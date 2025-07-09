using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class EmployeeGoals : System.Web.UI.Page
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;
    private int employeeId;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is authenticated and is an admin
        if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
        {
            Response.Redirect("Login.aspx");
            return;
        }

        string idStr = Request.QueryString["id"];
        if (string.IsNullOrEmpty(idStr) || !int.TryParse(idStr, out employeeId))
        {
            ShowMessage("Invalid employee ID.", false);
            return;
        }

        if (!IsPostBack)
        {
            LoadEmployeeInfo();
            LoadGoals();
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
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
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
                        else
                        {
                            ShowMessage("Employee not found.", false);
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

    private void LoadGoals()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT GoalId, GoalTitle, Category, TargetDate, Priority, Status, 
                                ProgressPercentage, GoalDescription, SuccessCriteria, Resources 
                                FROM EmployeeGoals 
                                WHERE EmployeeId = @EmployeeId";

                if (!string.IsNullOrEmpty(ddlFilterStatus.SelectedValue))
                {
                    query += " AND Status = @Status";
                }

                query += " ORDER BY TargetDate ASC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    if (!string.IsNullOrEmpty(ddlFilterStatus.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@Status", ddlFilterStatus.SelectedValue);
                    }

                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    gvGoals.DataSource = dt;
                    gvGoals.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading goals: " + ex.Message, false);
        }
    }

    protected void btnAddGoal_Click(object sender, EventArgs e)
    {
        pnlGoalForm.Visible = true;
        ClearGoalForm();
        txtTargetDate.Text = DateTime.Now.AddMonths(3).ToString("yyyy-MM-dd");
    }

    protected void btnSaveGoal_Click(object sender, EventArgs e)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(txtGoalTitle.Text) ||
                string.IsNullOrWhiteSpace(txtGoalDescription.Text) ||
                string.IsNullOrWhiteSpace(txtSuccessCriteria.Text) ||
                string.IsNullOrWhiteSpace(txtTargetDate.Text))
            {
                ShowMessage("Please fill in all required fields.", false);
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = @"INSERT INTO EmployeeGoals (
                        EmployeeId, GoalTitle, Category, TargetDate, Priority, GoalDescription, 
                        SuccessCriteria, Resources, Status, ProgressPercentage, CreatedDate
                    ) VALUES (
                        @EmployeeId, @GoalTitle, @Category, @TargetDate, @Priority, @GoalDescription,
                        @SuccessCriteria, @Resources, @Status, @ProgressPercentage, @CreatedDate
                    )";

                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    cmd.Parameters.AddWithValue("@GoalTitle", txtGoalTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@Category", ddlGoalCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@TargetDate", DateTime.Parse(txtTargetDate.Text));
                    cmd.Parameters.AddWithValue("@Priority", ddlPriority.SelectedValue);
                    cmd.Parameters.AddWithValue("@GoalDescription", txtGoalDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@SuccessCriteria", txtSuccessCriteria.Text.Trim());
                    cmd.Parameters.AddWithValue("@Resources", txtResources.Text.Trim());
                    cmd.Parameters.AddWithValue("@Status", "Active");
                    cmd.Parameters.AddWithValue("@ProgressPercentage", 0);
                    cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);

                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        ShowMessage("Goal added successfully!", true);
                        btnCancelGoal_Click(sender, e);
                        LoadGoals();
                    }
                    else
                    {
                        ShowMessage("Failed to add goal.", false);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error saving goal: " + ex.Message, false);
        }
    }

    protected void btnCancelGoal_Click(object sender, EventArgs e)
    {
        pnlGoalForm.Visible = false;
        ClearGoalForm();
    }

    private void ClearGoalForm()
    {
        txtGoalTitle.Text = "";
        txtGoalDescription.Text = "";
        txtSuccessCriteria.Text = "";
        txtResources.Text = "";
        ddlGoalCategory.SelectedIndex = 0;
        ddlPriority.SelectedIndex = 1; // Medium
    }

    protected void btnViewPerformance_Click(object sender, EventArgs e)
    {
        Response.Redirect(string.Format("PerformanceEvaluation.aspx?id={0}", employeeId));
    }

    protected void btnExportGoals_Click(object sender, EventArgs e)
    {
        // TODO: Implement export functionality
        ShowMessage("Export functionality will be implemented soon.", false);
    }

    protected void ddlFilterStatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadGoals();
    }

    protected void gvGoals_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "UpdateProgress")
        {
            string goalId = e.CommandArgument.ToString();
            Response.Redirect(string.Format("GoalProgress.aspx?id={0}", goalId));
        }
        else if (e.CommandName == "ViewDetails")
        {
            string goalId = e.CommandArgument.ToString();
            Response.Redirect(string.Format("GoalDetails.aspx?id={0}", goalId));
        }
        else if (e.CommandName == "DeleteGoal")
        {
            string goalId = e.CommandArgument.ToString();
            DeleteGoal(int.Parse(goalId));
        }
    }

    private void DeleteGoal(int goalId)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("DELETE FROM EmployeeGoals WHERE GoalId = @GoalId AND EmployeeId = @EmployeeId", con))
                {
                    cmd.Parameters.AddWithValue("@GoalId", goalId);
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        ShowMessage("Goal deleted successfully!", true);
                        LoadGoals();
                    }
                    else
                    {
                        ShowMessage("Failed to delete goal.", false);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error deleting goal: " + ex.Message, false);
        }
    }

    public string GetPriorityBadgeClass(string priority)
    {
        switch (priority.ToLower())
        {
            case "critical": return "bg-danger";
            case "high": return "bg-warning";
            case "medium": return "bg-info";
            case "low": return "bg-success";
            default: return "bg-secondary";
        }
    }

    public string GetStatusBadgeClass(string status)
    {
        switch (status.ToLower())
        {
            case "completed": return "bg-success";
            case "active": return "bg-primary";
            case "overdue": return "bg-danger";
            case "on hold": return "bg-warning";
            default: return "bg-secondary";
        }
    }

    private void ShowMessage(string message, bool isSuccess)
    {
        pnlMessage.Visible = true;
        litMessage.Text = message;
        pnlMessage.CssClass = isSuccess ? "alert alert-success alert-dismissible fade show" : "alert alert-danger alert-dismissible fade show";
    }
} 