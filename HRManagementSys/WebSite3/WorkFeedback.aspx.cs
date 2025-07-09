using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class WorkFeedback : System.Web.UI.Page
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string employeeId = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(employeeId))
            {
                LoadEmployeeInfo(employeeId);
                LoadWorkSubmissions(employeeId);
                LoadFeedbackStats(employeeId);
                SetDefaultDateRange();
            }
            else
            {
                ShowMessage("No employee selected.", false);
            }
        }
    }

    private void LoadEmployeeInfo(string employeeId)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT e.FirstName, e.LastName, e.Department, e.JobTitle, e.HireDate 
                                FROM Employees e 
                                WHERE e.EmployeeId = @EmployeeId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            litEmployeeName.Text = string.Format("{0} {1}", reader["FirstName"], reader["LastName"]);
                            litDepartment.Text = reader["Department"].ToString();
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

    private void LoadWorkSubmissions(string employeeId)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT AttendanceId, AttendanceDate, WorkHours, Status, 
                                TasksCompleted, Challenges, TomorrowPlan, ManagerComments
                                FROM Attendance 
                                WHERE EmployeeId = @EmployeeId 
                                ORDER BY AttendanceDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    gvWorkSubmissions.DataSource = dt;
                    gvWorkSubmissions.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading work submissions: " + ex.Message, false);
        }
    }

    private void LoadFeedbackStats(string employeeId)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT COUNT(*) as TotalFeedback,
                                SUM(CASE WHEN FeedbackType = 'Positive' THEN 1 ELSE 0 END) as PositiveFeedback
                                FROM AttendanceFeedback 
                                WHERE AttendanceId IN (SELECT AttendanceId FROM Attendance WHERE EmployeeId = @EmployeeId)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            litTotalFeedback.Text = reader["TotalFeedback"].ToString();
                            litPositiveFeedback.Text = reader["PositiveFeedback"].ToString();
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading feedback stats: " + ex.Message, false);
        }
    }

    private void SetDefaultDateRange()
    {
        DateTime now = DateTime.Now;
        txtFromDate.Text = new DateTime(now.Year, now.Month, 1).ToString("yyyy-MM-dd");
        txtToDate.Text = now.ToString("yyyy-MM-dd");
    }

    protected void ddlDateRange_SelectedIndexChanged(object sender, EventArgs e)
    {
        DateTime now = DateTime.Now;
        DateTime fromDate = now;
        DateTime toDate = now;

        switch (ddlDateRange.SelectedValue)
        {
            case "week":
                fromDate = now.AddDays(-(int)now.DayOfWeek);
                break;
            case "month":
                fromDate = new DateTime(now.Year, now.Month, 1);
                break;
            case "quarter":
                fromDate = now.AddMonths(-3);
                break;
            case "all":
                fromDate = DateTime.MinValue;
                break;
        }

        txtFromDate.Text = fromDate.ToString("yyyy-MM-dd");
        txtToDate.Text = toDate.ToString("yyyy-MM-dd");
    }

    protected void ddlFeedbackType_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadWorkSubmissions(Request.QueryString["id"]);
    }

    protected void btnApplyFilter_Click(object sender, EventArgs e)
    {
        LoadWorkSubmissions(Request.QueryString["id"]);
    }

    protected void btnClearFilter_Click(object sender, EventArgs e)
    {
        ddlDateRange.SelectedValue = "month";
        ddlFeedbackType.SelectedValue = "";
        SetDefaultDateRange();
        LoadWorkSubmissions(Request.QueryString["id"]);
    }

    protected void btnAddFeedback_Click(object sender, EventArgs e)
    {
        // This will be handled by the modal
    }

    protected void gvWorkSubmissions_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string attendanceId = e.CommandArgument.ToString();

        if (e.CommandName == "ViewWork")
        {
            LoadWorkDetails(attendanceId);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "showWorkModal", "showWorkModal();", true);
        }
        else if (e.CommandName == "ViewFeedback")
        {
            LoadFeedbackDetails(attendanceId);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "showViewFeedbackModal", "showViewFeedbackModal();", true);
        }
        else if (e.CommandName == "AddFeedback")
        {
            hdnAttendanceId.Value = attendanceId;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "showFeedbackModal", "showFeedbackModal();", true);
        }
    }

    private void LoadWorkDetails(string attendanceId)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT TasksCompleted, Challenges, TomorrowPlan, ManagerComments 
                                FROM Attendance 
                                WHERE AttendanceId = @AttendanceId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AttendanceId", attendanceId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            litTasksCompleted.Text = reader["TasksCompleted"] != DBNull.Value && reader["TasksCompleted"] != null ? reader["TasksCompleted"].ToString() : "No tasks recorded";
                            litChallenges.Text = reader["Challenges"] != DBNull.Value && reader["Challenges"] != null ? reader["Challenges"].ToString() : "No challenges recorded";
                            litNextDayPlans.Text = reader["TomorrowPlan"] != DBNull.Value && reader["TomorrowPlan"] != null ? reader["TomorrowPlan"].ToString() : "No plans recorded";
                            litAdditionalNotes.Text = reader["ManagerComments"] != DBNull.Value && reader["ManagerComments"] != null ? reader["ManagerComments"].ToString() : "No additional notes";
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading work details: " + ex.Message, false);
        }
    }

    private void LoadFeedbackDetails(string attendanceId)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT FeedbackType, FeedbackMessage, GivenBy, GivenDate 
                                FROM AttendanceFeedback 
                                WHERE AttendanceId = @AttendanceId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AttendanceId", attendanceId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            litFeedbackType.Text = reader["FeedbackType"].ToString();
                            litFeedbackMessage.Text = reader["FeedbackMessage"].ToString();
                            litGivenBy.Text = reader["GivenBy"].ToString();
                            litGivenDate.Text = Convert.ToDateTime(reader["GivenDate"]).ToString("MMM dd, yyyy HH:mm");
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading feedback details: " + ex.Message, false);
        }
    }

    protected void btnSaveFeedback_Click(object sender, EventArgs e)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(txtFeedbackMessage.Text))
            {
                ShowMessage("Please enter a feedback message.", false);
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO AttendanceFeedback (AttendanceId, FeedbackType, FeedbackMessage, GivenBy, GivenDate) 
                                VALUES (@AttendanceId, @FeedbackType, @FeedbackMessage, @GivenBy, @GivenDate)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AttendanceId", hdnAttendanceId.Value);
                    cmd.Parameters.AddWithValue("@FeedbackType", ddlNewFeedbackType.SelectedValue);
                    cmd.Parameters.AddWithValue("@FeedbackMessage", txtFeedbackMessage.Text.Trim());
                    cmd.Parameters.AddWithValue("@GivenBy", Session["UserName"] ?? "Admin");
                    cmd.Parameters.AddWithValue("@GivenDate", DateTime.Now);

                    con.Open();
                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        ShowMessage("Feedback saved successfully!", true);
                        txtFeedbackMessage.Text = "";
                        LoadWorkSubmissions(Request.QueryString["id"]);
                        LoadFeedbackStats(Request.QueryString["id"]);
                    }
                    else
                    {
                        ShowMessage("Failed to save feedback.", false);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error saving feedback: " + ex.Message, false);
        }
    }

    protected void btnViewPerformance_Click(object sender, EventArgs e)
    {
        Response.Redirect(string.Format("PerformanceEvaluation.aspx?id={0}", Request.QueryString["id"]));
    }

    protected void btnSetGoals_Click(object sender, EventArgs e)
    {
        Response.Redirect(string.Format("EmployeeGoals.aspx?id={0}", Request.QueryString["id"]));
    }

    protected void btnViewAttendance_Click(object sender, EventArgs e)
    {
        Response.Redirect(string.Format("AttendanceManagement.aspx?id={0}", Request.QueryString["id"]));
    }

    public string GetStatusBadgeClass(string status)
    {
        switch ((status != null ? status.ToLower() : ""))
        {
            case "present":
                return "bg-success";
            case "absent":
                return "bg-danger";
            case "late":
                return "bg-warning";
            case "half-day":
                return "bg-info";
            default:
                return "bg-secondary";
        }
    }

    public bool HasFeedback(object attendanceId)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM AttendanceFeedback WHERE AttendanceId = @AttendanceId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AttendanceId", attendanceId);
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
            }
        }
        catch
        {
            return false;
        }
    }

    private void ShowMessage(string message, bool isSuccess)
    {
        pnlMessage.Visible = true;
        litMessage.Text = message;
        pnlMessage.CssClass = isSuccess ? "alert alert-success alert-dismissible fade show" : "alert alert-danger alert-dismissible fade show";
    }
} 