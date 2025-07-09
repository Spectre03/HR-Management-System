using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PerformanceEvaluation : System.Web.UI.Page
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is authenticated and is an admin
        if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
        {
            Response.Redirect("Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadEmployees();
            SetDefaultDates();
        }
    }

    private void LoadEmployees()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT EmployeeId, FirstName + ' ' + LastName AS FullName, 
                                d.DepartmentName, JobTitle, HireDate 
                                FROM Employees e 
                                LEFT JOIN Departments d ON e.DepartmentId = d.DepartmentId 
                                WHERE e.Status = 'Active' 
                                ORDER BY FirstName, LastName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlEmployees.DataSource = reader;
                    ddlEmployees.DataTextField = "FullName";
                    ddlEmployees.DataValueField = "EmployeeId";
                    ddlEmployees.DataBind();
                }
            }
            ddlEmployees.Items.Insert(0, new ListItem("Select Employee", ""));
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading employees: " + ex.Message, false);
        }
    }

    private void SetDefaultDates()
    {
        DateTime today = DateTime.Today;
        txtReviewStart.Text = today.AddMonths(-6).ToString("yyyy-MM-dd");
        txtReviewEnd.Text = today.ToString("yyyy-MM-dd");
    }

    protected void ddlEmployees_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(ddlEmployees.SelectedValue))
        {
            LoadEmployeeInfo();
            LoadPerformanceHistory();
        }
        else
        {
            pnlEmployeeInfo.Visible = false;
            pnlPerformanceHistory.Visible = false;
        }
    }

    private void LoadEmployeeInfo()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT FirstName, LastName, d.DepartmentName, JobTitle, HireDate 
                                FROM Employees e 
                                LEFT JOIN Departments d ON e.DepartmentId = d.DepartmentId 
                                WHERE e.EmployeeId = @EmployeeId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", ddlEmployees.SelectedValue);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            litEmployeeName.Text = string.Format("{0} {1}", reader["FirstName"], reader["LastName"]);
                            litDepartment.Text = reader["DepartmentName"].ToString();
                            litPosition.Text = reader["JobTitle"].ToString();
                            litHireDate.Text = Convert.ToDateTime(reader["HireDate"]).ToString("MMM dd, yyyy");
                            pnlEmployeeInfo.Visible = true;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading employee info: " + ex.Message, false);
        }
    }

    private void LoadPerformanceHistory()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT PerformanceId, ReviewDate, PerformanceRating, TechnicalSkills, 
                                CommunicationSkills, TeamworkSkills, LeadershipSkills, Status 
                                FROM Performance 
                                WHERE EmployeeId = @EmployeeId 
                                ORDER BY ReviewDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", ddlEmployees.SelectedValue);
                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    gvPerformanceHistory.DataSource = dt;
                    gvPerformanceHistory.DataBind();
                }
            }
            pnlPerformanceHistory.Visible = true;
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading performance history: " + ex.Message, false);
        }
    }

    protected void btnNewEvaluation_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(ddlEmployees.SelectedValue))
        {
            ShowMessage("Please select an employee first.", false);
            return;
        }

        pnlEvaluationForm.Visible = true;
        pnlPerformanceHistory.Visible = false;
        SetDefaultDates();
    }

    protected void btnSetGoals_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(ddlEmployees.SelectedValue))
        {
            ShowMessage("Please select an employee first.", false);
            return;
        }

        Response.Redirect(string.Format("EmployeeGoals.aspx?id={0}", ddlEmployees.SelectedValue));
    }

    protected void btnViewAttendance_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(ddlEmployees.SelectedValue))
        {
            ShowMessage("Please select an employee first.", false);
            return;
        }

        Response.Redirect(string.Format("AttendanceManagement.aspx?id={0}", ddlEmployees.SelectedValue));
    }

    protected void btnWorkFeedback_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(ddlEmployees.SelectedValue))
        {
            ShowMessage("Please select an employee first.", false);
            return;
        }

        Response.Redirect(string.Format("WorkFeedback.aspx?id={0}", ddlEmployees.SelectedValue));
    }

    protected void btnSaveEvaluation_Click(object sender, EventArgs e)
    {
        try
        {
            if (string.IsNullOrEmpty(ddlEmployees.SelectedValue))
            {
                ShowMessage("Please select an employee.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtReviewStart.Text) || string.IsNullOrWhiteSpace(txtReviewEnd.Text))
            {
                ShowMessage("Please enter review period dates.", false);
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = @"INSERT INTO Performance (
                        EmployeeId, ReviewDate, ReviewPeriodStart, ReviewPeriodEnd, 
                        ReviewerName, PerformanceRating, TechnicalSkills, CommunicationSkills, 
                        TeamworkSkills, LeadershipSkills, Strengths, AreasForImprovement, 
                        Recommendations, Status
                    ) VALUES (
                        @EmployeeId, @ReviewDate, @ReviewPeriodStart, @ReviewPeriodEnd,
                        @ReviewerName, @PerformanceRating, @TechnicalSkills, @CommunicationSkills,
                        @TeamworkSkills, @LeadershipSkills, @Strengths, @AreasForImprovement,
                        @Recommendations, @Status
                    )";

                    cmd.Parameters.AddWithValue("@EmployeeId", int.Parse(ddlEmployees.SelectedValue));
                    cmd.Parameters.AddWithValue("@ReviewDate", DateTime.Now);
                    cmd.Parameters.AddWithValue("@ReviewPeriodStart", DateTime.Parse(txtReviewStart.Text));
                    cmd.Parameters.AddWithValue("@ReviewPeriodEnd", DateTime.Parse(txtReviewEnd.Text));
                    cmd.Parameters.AddWithValue("@ReviewerName", Session["UserName"] ?? "Admin");
                    cmd.Parameters.AddWithValue("@PerformanceRating", int.Parse(ddlOverallRating.SelectedValue));
                    cmd.Parameters.AddWithValue("@TechnicalSkills", int.Parse(ddlTechnicalSkills.SelectedValue));
                    cmd.Parameters.AddWithValue("@CommunicationSkills", int.Parse(ddlCommunicationSkills.SelectedValue));
                    cmd.Parameters.AddWithValue("@TeamworkSkills", int.Parse(ddlTeamworkSkills.SelectedValue));
                    cmd.Parameters.AddWithValue("@LeadershipSkills", int.Parse(ddlLeadershipSkills.SelectedValue));
                    cmd.Parameters.AddWithValue("@Strengths", txtStrengths.Text.Trim());
                    cmd.Parameters.AddWithValue("@AreasForImprovement", txtImprovements.Text.Trim());
                    cmd.Parameters.AddWithValue("@Recommendations", txtRecommendations.Text.Trim());
                    cmd.Parameters.AddWithValue("@Status", "Completed");

                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        ShowMessage("Performance evaluation saved successfully!", true);
                        btnCancelEvaluation_Click(sender, e);
                        LoadPerformanceHistory();
                    }
                    else
                    {
                        ShowMessage("Failed to save performance evaluation.", false);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error saving evaluation: " + ex.Message, false);
        }
    }

    protected void btnCancelEvaluation_Click(object sender, EventArgs e)
    {
        pnlEvaluationForm.Visible = false;
        pnlPerformanceHistory.Visible = true;
        ClearEvaluationForm();
    }

    private void ClearEvaluationForm()
    {
        txtStrengths.Text = "";
        txtImprovements.Text = "";
        txtRecommendations.Text = "";
        ddlTechnicalSkills.SelectedIndex = 2; // Average
        ddlCommunicationSkills.SelectedIndex = 2;
        ddlTeamworkSkills.SelectedIndex = 2;
        ddlLeadershipSkills.SelectedIndex = 2;
        ddlOverallRating.SelectedIndex = 2;
        SetDefaultDates();
    }

    protected void gvPerformanceHistory_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ViewDetails")
        {
            string performanceId = e.CommandArgument.ToString();
            Response.Redirect(string.Format("PerformanceDetails.aspx?id={0}", performanceId));
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddYears(-1);
        Response.Redirect("Login.aspx");
    }

    private void ShowMessage(string message, bool isSuccess)
    {
        pnlMessage.Visible = true;
        litMessage.Text = message;
        pnlMessage.CssClass = isSuccess ? "alert alert-success alert-dismissible fade show" : "alert alert-danger alert-dismissible fade show";
    }
} 