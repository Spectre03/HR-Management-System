using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AttendanceManagement : System.Web.UI.Page
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
            LoadAttendanceStatistics();
            SetDefaultDateRange();
            LoadAttendance();
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

    private void LoadAttendanceStatistics()
    {
        try
        {
            DateTime startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            DateTime endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT 
                                COUNT(*) as DaysPresent,
                                ROUND(CAST(COUNT(*) AS FLOAT) / CAST(DAY(GETDATE()) AS FLOAT) * 100, 1) as AttendanceRate
                                FROM Attendance 
                                WHERE EmployeeId = @EmployeeId 
                                AND AttendanceDate BETWEEN @StartDate AND @EndDate
                                AND Status = 'Approved'";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    cmd.Parameters.AddWithValue("@StartDate", startOfMonth);
                    cmd.Parameters.AddWithValue("@EndDate", endOfMonth);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            litDaysPresent.Text = reader["DaysPresent"].ToString();
                            litAttendanceRate.Text = reader["AttendanceRate"].ToString() + "%";
                        }
                        else
                        {
                            litDaysPresent.Text = "0";
                            litAttendanceRate.Text = "0%";
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading statistics: " + ex.Message, false);
        }
    }

    private void SetDefaultDateRange()
    {
        DateTime today = DateTime.Today;
        DateTime startOfMonth = new DateTime(today.Year, today.Month, 1);
        DateTime endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);

        txtFromDate.Text = startOfMonth.ToString("yyyy-MM-dd");
        txtToDate.Text = endOfMonth.ToString("yyyy-MM-dd");
    }

    private void LoadAttendance()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT AttendanceId, AttendanceDate, TimeIn, TimeOut, 
                                TotalHours, Status, TasksCompleted, Challenges, NextDayPlans, AdditionalNotes
                                FROM Attendance 
                                WHERE EmployeeId = @EmployeeId";

                if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
                {
                    query += " AND Status = @Status";
                }

                if (ddlDateRange.SelectedValue == "week")
                {
                    query += " AND AttendanceDate >= DATEADD(day, -7, GETDATE())";
                }
                else if (ddlDateRange.SelectedValue == "month")
                {
                    query += " AND AttendanceDate >= DATEADD(month, -1, GETDATE())";
                }
                else if (ddlDateRange.SelectedValue == "quarter")
                {
                    query += " AND AttendanceDate >= DATEADD(month, -3, GETDATE())";
                }
                else if (ddlDateRange.SelectedValue == "custom")
                {
                    if (!string.IsNullOrWhiteSpace(txtFromDate.Text) && !string.IsNullOrWhiteSpace(txtToDate.Text))
                    {
                        query += " AND AttendanceDate BETWEEN @FromDate AND @ToDate";
                    }
                }

                query += " ORDER BY AttendanceDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@Status", ddlStatusFilter.SelectedValue);
                    }
                    if (ddlDateRange.SelectedValue == "custom" && !string.IsNullOrWhiteSpace(txtFromDate.Text) && !string.IsNullOrWhiteSpace(txtToDate.Text))
                    {
                        cmd.Parameters.AddWithValue("@FromDate", DateTime.Parse(txtFromDate.Text));
                        cmd.Parameters.AddWithValue("@ToDate", DateTime.Parse(txtToDate.Text));
                    }

                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    gvAttendance.DataSource = dt;
                    gvAttendance.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading attendance: " + ex.Message, false);
        }
    }

    protected void ddlDateRange_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadAttendance();
    }

    protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadAttendance();
    }

    protected void btnApplyFilter_Click(object sender, EventArgs e)
    {
        LoadAttendance();
    }

    protected void btnClearFilter_Click(object sender, EventArgs e)
    {
        ddlDateRange.SelectedIndex = 1; // This Month
        ddlStatusFilter.SelectedIndex = 0; // All
        SetDefaultDateRange();
        LoadAttendance();
    }

    protected void btnViewPerformance_Click(object sender, EventArgs e)
    {
        Response.Redirect(string.Format("PerformanceEvaluation.aspx?id={0}", employeeId));
    }

    protected void btnSetGoals_Click(object sender, EventArgs e)
    {
        Response.Redirect(string.Format("EmployeeGoals.aspx?id={0}", employeeId));
    }

    protected void btnExportAttendance_Click(object sender, EventArgs e)
    {
        // TODO: Implement export functionality
        ShowMessage("Export functionality will be implemented soon.", false);
    }

    protected void gvAttendance_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int attendanceId = int.Parse(e.CommandArgument.ToString());

        if (e.CommandName == "ViewWork")
        {
            LoadWorkDetails(attendanceId);
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowWorkModal", "showWorkModal();", true);
        }
        else if (e.CommandName == "Approve")
        {
            UpdateAttendanceStatus(attendanceId, "Approved");
        }
        else if (e.CommandName == "Reject")
        {
            UpdateAttendanceStatus(attendanceId, "Rejected");
        }
        else if (e.CommandName == "AddFeedback")
        {
            hdnAttendanceId.Value = attendanceId.ToString();
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowFeedbackModal", "showFeedbackModal();", true);
        }
    }

    private void LoadWorkDetails(int attendanceId)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT TasksCompleted, Challenges, NextDayPlans, AdditionalNotes FROM Attendance WHERE AttendanceId = @AttendanceId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AttendanceId", attendanceId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            litTasksCompleted.Text = reader["TasksCompleted"] != DBNull.Value && reader["TasksCompleted"] != null ? reader["TasksCompleted"].ToString() : "No tasks completed recorded.";
                            litChallenges.Text = reader["Challenges"] != DBNull.Value && reader["Challenges"] != null ? reader["Challenges"].ToString() : "No challenges recorded.";
                            litNextDayPlans.Text = reader["NextDayPlans"] != DBNull.Value && reader["NextDayPlans"] != null ? reader["NextDayPlans"].ToString() : "No plans for next day recorded.";
                            litAdditionalNotes.Text = reader["AdditionalNotes"] != DBNull.Value && reader["AdditionalNotes"] != null ? reader["AdditionalNotes"].ToString() : "No additional notes.";
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

    private void UpdateAttendanceStatus(int attendanceId, string status)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("UPDATE Attendance SET Status = @Status, ReviewedBy = @ReviewedBy, ReviewedDate = @ReviewedDate WHERE AttendanceId = @AttendanceId", con))
                {
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@ReviewedBy", Session["UserName"] ?? "Admin");
                    cmd.Parameters.AddWithValue("@ReviewedDate", DateTime.Now);
                    cmd.Parameters.AddWithValue("@AttendanceId", attendanceId);
                    
                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        ShowMessage(string.Format("Attendance {0} successfully!", status.ToLower()), true);
                        LoadAttendance();
                        LoadAttendanceStatistics();
                    }
                    else
                    {
                        ShowMessage("Failed to update attendance status.", false);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error updating attendance status: " + ex.Message, false);
        }
    }

    protected void btnSaveFeedback_Click(object sender, EventArgs e)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(txtFeedbackMessage.Text))
            {
                ShowMessage("Please enter feedback message.", false);
                return;
            }

            int attendanceId = int.Parse(hdnAttendanceId.Value);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("INSERT INTO AttendanceFeedback (AttendanceId, FeedbackType, FeedbackMessage, GivenBy, GivenDate) VALUES (@AttendanceId, @FeedbackType, @FeedbackMessage, @GivenBy, @GivenDate)", con))
                {
                    cmd.Parameters.AddWithValue("@AttendanceId", attendanceId);
                    cmd.Parameters.AddWithValue("@FeedbackType", ddlFeedbackType.SelectedValue);
                    cmd.Parameters.AddWithValue("@FeedbackMessage", txtFeedbackMessage.Text.Trim());
                    cmd.Parameters.AddWithValue("@GivenBy", Session["UserName"] ?? "Admin");
                    cmd.Parameters.AddWithValue("@GivenDate", DateTime.Now);
                    
                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        ShowMessage("Feedback saved successfully!", true);
                        txtFeedbackMessage.Text = "";
                        ddlFeedbackType.SelectedIndex = 0;
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

    public string GetStatusBadgeClass(string status)
    {
        switch (status.ToLower())
        {
            case "approved": return "bg-success";
            case "pending": return "bg-warning";
            case "rejected": return "bg-danger";
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