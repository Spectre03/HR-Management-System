using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Text;
using System.Web.UI;

public partial class EmployeeAttendance : System.Web.UI.UserControl
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;
    private int employeeId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null) return;
        employeeId = Convert.ToInt32(Session["UserId"]);
        if (!IsPostBack)
        {
            InitializeDropdowns();
            LoadAttendanceData();
            LoadAttendanceStats();
            // Set default date to today
            txtWorkDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        }
    }

    private void InitializeDropdowns()
    {
        ddlAttendanceMonth.Items.Clear();
        for (int i = 0; i < 12; i++)
        {
            DateTime month = DateTime.Now.AddMonths(-i);
            string text = month.ToString("MMMM yyyy");
            string value = month.ToString("yyyy-MM");
            ddlAttendanceMonth.Items.Add(new ListItem(text, value));
        }
        ddlAttendanceMonth.SelectedIndex = 0;
    }

    private void LoadAttendanceData()
    {
        string selectedMonth = ddlAttendanceMonth.SelectedValue;
        DateTime date;
        if (string.IsNullOrEmpty(selectedMonth) || !DateTime.TryParse(selectedMonth + "-01", out date))
        {
            date = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
        }
        DateTime startDate = new DateTime(date.Year, date.Month, 1);
        DateTime endDate = startDate.AddMonths(1).AddDays(-1);
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = @"SELECT AttendanceId, AttendanceDate, TimeIn, TimeOut, WorkHours, Status, Notes, WorkQuality, 
                           TasksCompleted, Challenges, TomorrowPlan, ManagerComments 
                           FROM Attendance WHERE EmployeeId = @EmployeeId AND AttendanceDate BETWEEN @StartDate AND @EndDate 
                           ORDER BY AttendanceDate DESC";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                cmd.Parameters.AddWithValue("@StartDate", startDate);
                cmd.Parameters.AddWithValue("@EndDate", endDate);
                con.Open();
                DataTable dt = new DataTable();
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }
                gvAttendance.DataSource = dt;
                gvAttendance.DataBind();
                lblNoAttendance.Visible = (dt.Rows.Count == 0);
            }
        }
    }

    private void LoadAttendanceStats()
    {
        if (Session["UserId"] == null) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);
        
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            // Get current month stats
            DateTime startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            DateTime endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);
            
            // Calculate total working days in the month (excluding weekends)
            int totalWorkingDays = 0;
            for (DateTime date = startOfMonth; date <= endOfMonth; date = date.AddDays(1))
            {
                if (date.DayOfWeek != DayOfWeek.Saturday && date.DayOfWeek != DayOfWeek.Sunday)
                {
                    totalWorkingDays++;
                }
            }
            
            string query = @"SELECT 
                COUNT(CASE WHEN Status = 'Present' THEN 1 END) as PresentDays,
                COUNT(CASE WHEN Status = 'Absent' THEN 1 END) as AbsentDays,
                COUNT(CASE WHEN Status = 'Late' THEN 1 END) as LateDays,
                COUNT(*) as RecordedDays
                FROM Attendance 
                WHERE EmployeeId = @EmployeeId AND AttendanceDate BETWEEN @StartDate AND @EndDate";
            
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
                        int presentDays = Convert.ToInt32(reader["PresentDays"]);
                        int absentDays = Convert.ToInt32(reader["AbsentDays"]);
                        int lateDays = Convert.ToInt32(reader["LateDays"]);
                        int recordedDays = Convert.ToInt32(reader["RecordedDays"]);
                        
                        litPresentDays.Text = presentDays.ToString();
                        litAbsentDays.Text = absentDays.ToString();
                        litLateDays.Text = lateDays.ToString();
                        
                        // Calculate attendance rate based on total working days
                        double attendanceRate = totalWorkingDays > 0 ? (double)presentDays / totalWorkingDays * 100 : 0;
                        litAttendanceRate.Text = attendanceRate.ToString("F1") + "%";
                    }
                }
            }
        }
    }

    protected void ddlAttendanceMonth_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadAttendanceData();
    }

    protected string GetAttendanceStatusBadgeClass(string status)
    {
        switch (status.ToLower())
        {
            case "present": return "bg-success";
            case "late": return "bg-warning";
            case "half day": return "bg-info";
            case "absent": return "bg-danger";
            default: return "bg-secondary";
        }
    }

    protected void btnSubmitWork_Click(object sender, EventArgs e)
    {
        if (Session["UserId"] == null) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);
        
        // Clear previous error messages
        lblErrorMessage.Visible = false;
        
        // Declare workHours at method level so it's accessible in catch block
        decimal workHours = 0;
        
        // Validate required fields
        if (string.IsNullOrEmpty(txtWorkDate.Text))
        {
            lblErrorMessage.Text = "Work date is required.";
            lblErrorMessage.CssClass = "alert alert-danger";
            lblErrorMessage.Visible = true;
            return;
        }
        
        if (string.IsNullOrEmpty(txtTimeIn.Text))
        {
            lblErrorMessage.Text = "Time In is required.";
            lblErrorMessage.CssClass = "alert alert-danger";
            lblErrorMessage.Visible = true;
            return;
        }
        
        if (string.IsNullOrEmpty(txtTimeOut.Text))
        {
            lblErrorMessage.Text = "Time Out is required.";
            lblErrorMessage.CssClass = "alert alert-danger";
            lblErrorMessage.Visible = true;
            return;
        }
        
        if (string.IsNullOrEmpty(txtTasksCompleted.Text))
        {
            lblErrorMessage.Text = "Tasks completed is required.";
            lblErrorMessage.CssClass = "alert alert-danger";
            lblErrorMessage.Visible = true;
            return;
        }
        
        try
        {
            // Simple time validation - no complex parsing
            string timeInString = txtTimeIn.Text.Trim();
            string timeOutString = txtTimeOut.Text.Trim();
            
            // Basic validation
            if (string.IsNullOrEmpty(timeInString) || string.IsNullOrEmpty(timeOutString))
            {
                throw new FormatException("Time In and Time Out are required");
            }
            
            // Just check if it looks like a time format (HH:mm)
            if (!timeInString.Contains(":") || !timeOutString.Contains(":"))
            {
                throw new FormatException("Invalid time format - use HH:mm format");
            }
            
            DateTime workDate;
            if (!DateTime.TryParse(txtWorkDate.Text, out workDate))
            {
                throw new FormatException("Invalid work date format");
            }
            
            // Check if it's today's date only
            if (workDate.Date != DateTime.Now.Date)
            {
                throw new FormatException("Attendance can only be submitted for today's date");
            }
            
            try
            {
                // Extract hours and minutes from strings
                string[] timeInParts = timeInString.Split(':');
                string[] timeOutParts = timeOutString.Split(':');
                
                if (timeInParts.Length != 2 || timeOutParts.Length != 2)
                {
                    throw new FormatException("Invalid time format");
                }
                
                int timeInHours = Convert.ToInt32(timeInParts[0]);
                int timeInMinutes = Convert.ToInt32(timeInParts[1]);
                int timeOutHours = Convert.ToInt32(timeOutParts[0]);
                int timeOutMinutes = Convert.ToInt32(timeOutParts[1]);
                
                // Calculate total minutes
                int timeInTotalMinutes = (timeInHours * 60) + timeInMinutes;
                int timeOutTotalMinutes = (timeOutHours * 60) + timeOutMinutes;
                
                // Calculate work hours
                workHours = (decimal)(timeOutTotalMinutes - timeInTotalMinutes) / 60;
                
                // Handle negative hours (overnight work)
                if (workHours < 0)
                {
                    workHours += 24;
                }
            }
            catch (Exception ex)
            {
                throw new FormatException(string.Format("Error calculating work hours: {0}", ex.Message));
            }
            
            // Subtract break time if provided
            if (!string.IsNullOrEmpty(txtBreakTime.Text))
            {
                int breakMinutes = int.Parse(txtBreakTime.Text);
                workHours -= (decimal)breakMinutes / 60;
            }
            
            string tasksCompleted = txtTasksCompleted.Text.Trim();
            string challenges = txtChallenges.Text.Trim();
            string tomorrowPlan = txtTomorrowPlan.Text.Trim();
            
            // Determine status based on work hours
            string status = "Present";
            if (workHours < 6) status = "Late";
            if (workHours < 4) status = "Absent";
            
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Check if attendance already exists for this date
                string checkQuery = "SELECT COUNT(*) FROM Attendance WHERE EmployeeId = @EmployeeId AND AttendanceDate = @AttendanceDate";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    checkCmd.Parameters.AddWithValue("@AttendanceDate", workDate);
                    con.Open();
                    int existingCount = (int)checkCmd.ExecuteScalar();
                    
                    if (existingCount > 0)
                    {
                        // Update existing record
                        string updateQuery = @"UPDATE Attendance SET 
                            TimeIn = @TimeIn, TimeOut = @TimeOut, WorkHours = @WorkHours, Status = @Status, 
                            TasksCompleted = @TasksCompleted, Challenges = @Challenges, TomorrowPlan = @TomorrowPlan, 
                            Notes = 'Work submitted'
                            WHERE EmployeeId = @EmployeeId AND AttendanceDate = @AttendanceDate";
                        
                        using (SqlCommand updateCmd = new SqlCommand(updateQuery, con))
                        {
                            updateCmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                            updateCmd.Parameters.AddWithValue("@AttendanceDate", workDate);
                            updateCmd.Parameters.AddWithValue("@TimeIn", timeInString);
                            updateCmd.Parameters.AddWithValue("@TimeOut", timeOutString);
                            updateCmd.Parameters.AddWithValue("@WorkHours", workHours);
                            updateCmd.Parameters.AddWithValue("@Status", status);
                            updateCmd.Parameters.AddWithValue("@TasksCompleted", tasksCompleted);
                            updateCmd.Parameters.AddWithValue("@Challenges", challenges);
                            updateCmd.Parameters.AddWithValue("@TomorrowPlan", tomorrowPlan);
                            updateCmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        // Insert new record
                        string insertQuery = @"INSERT INTO Attendance (EmployeeId, AttendanceDate, TimeIn, TimeOut, WorkHours, Status, 
                            TasksCompleted, Challenges, TomorrowPlan, Notes, WorkQuality) 
                            VALUES (@EmployeeId, @AttendanceDate, @TimeIn, @TimeOut, @WorkHours, @Status, 
                            @TasksCompleted, @Challenges, @TomorrowPlan, 'Work submitted', 'Pending Review')";
                        
                        using (SqlCommand insertCmd = new SqlCommand(insertQuery, con))
                        {
                            insertCmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                            insertCmd.Parameters.AddWithValue("@AttendanceDate", workDate);
                            insertCmd.Parameters.AddWithValue("@TimeIn", timeInString);
                            insertCmd.Parameters.AddWithValue("@TimeOut", timeOutString);
                            insertCmd.Parameters.AddWithValue("@WorkHours", workHours);
                            insertCmd.Parameters.AddWithValue("@Status", status);
                            insertCmd.Parameters.AddWithValue("@TasksCompleted", tasksCompleted);
                            insertCmd.Parameters.AddWithValue("@Challenges", challenges);
                            insertCmd.Parameters.AddWithValue("@TomorrowPlan", tomorrowPlan);
                            insertCmd.ExecuteNonQuery();
                        }
                    }
                }
            }
            
            // Clear form
            txtWorkDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtTimeIn.Text = "";
            txtTimeOut.Text = "";
            txtWorkHours.Text = "";
            txtBreakTime.Text = "0";
            txtTasksCompleted.Text = "";
            txtChallenges.Text = "";
            txtTomorrowPlan.Text = "";
            
            // Clear any error messages
            lblErrorMessage.Visible = false;
            
            // Refresh data
            LoadAttendanceData();
            LoadAttendanceStats();
        }
        catch (Exception ex)
        {
            // Show user-friendly error message with debugging info
            lblErrorMessage.Text = "Error submitting attendance: " + ex.Message + 
                "<br/>Debug Info - TimeIn: '" + txtTimeIn.Text + "', TimeOut: '" + txtTimeOut.Text + "'" +
                "<br/>Work Date: '" + txtWorkDate.Text + "'" +
                "<br/>Work Hours: '" + workHours.ToString() + "'";
            lblErrorMessage.CssClass = "alert alert-danger";
            lblErrorMessage.Visible = true;
        }
    }

    protected void gvAttendance_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ViewWork")
        {
            int attendanceId = Convert.ToInt32(e.CommandArgument);
            LoadWorkReview(attendanceId);
        }
        else if (e.CommandName == "DeleteAttendance")
        {
            int attendanceId = Convert.ToInt32(e.CommandArgument);
            DeleteAttendance(attendanceId);
        }
    }

    private void LoadWorkReview(int attendanceId)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = @"SELECT AttendanceDate, TasksCompleted, Challenges, TomorrowPlan, WorkQuality, ManagerComments 
                           FROM Attendance WHERE AttendanceId = @AttendanceId";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@AttendanceId", attendanceId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        litReviewDate.Text = Convert.ToDateTime(reader["AttendanceDate"]).ToString("yyyy-MM-dd");
                        litReviewTasks.Text = reader["TasksCompleted"] != DBNull.Value && reader["TasksCompleted"] != null ? reader["TasksCompleted"].ToString() : "No tasks recorded";
                        litReviewChallenges.Text = reader["Challenges"] != DBNull.Value && reader["Challenges"] != null ? reader["Challenges"].ToString() : "No challenges recorded";
                        litReviewTomorrowPlan.Text = reader["TomorrowPlan"] != DBNull.Value && reader["TomorrowPlan"] != null ? reader["TomorrowPlan"].ToString() : "No plan recorded";
                        
                        string workQuality = reader["WorkQuality"] != DBNull.Value && reader["WorkQuality"] != null ? reader["WorkQuality"].ToString() : "";
                        ddlWorkQuality.SelectedValue = workQuality;
                        
                        txtManagerComments.Text = reader["ManagerComments"] != DBNull.Value && reader["ManagerComments"] != null ? reader["ManagerComments"].ToString() : "";
                        
                        pnlWorkReview.Visible = true;
                    }
                }
            }
        }
    }

    protected void btnCloseReview_Click(object sender, EventArgs e)
    {
        pnlWorkReview.Visible = false;
    }

    protected void btnSaveReview_Click(object sender, EventArgs e)
    {
        pnlWorkReview.Visible = false;
    }

    protected void btnExportAttendance_Click(object sender, EventArgs e)
    {
        // Simple CSV export for demonstration
        Response.Clear();
        Response.Buffer = true;
        Response.AddHeader("content-disposition", "attachment;filename=Attendance.csv");
        Response.Charset = "";
        Response.ContentType = "application/text";
        StringBuilder sb = new StringBuilder();
        // Add header
        sb.AppendLine("Date,Time In,Time Out,Status,Notes");
        foreach (GridViewRow row in gvAttendance.Rows)
        {
            for (int i = 1; i < row.Cells.Count; i++) // skip AttendanceId if present
            {
                sb.Append(row.Cells[i].Text.Replace(",", " ") + ",");
            }
            sb.Length--; // Remove last comma
            sb.AppendLine();
        }
        Response.Output.Write(sb.ToString());
        Response.Flush();
        Response.End();
    }

    public string GetStatusBadgeClass(string status)
    {
        switch (status.ToLower())
        {
            case "present": return "bg-success";
            case "absent": return "bg-danger";
            case "late": return "bg-warning";
            default: return "bg-secondary";
        }
    }

    public string GetQualityBadgeClass(string quality)
    {
        switch (quality.ToLower())
        {
            case "excellent": return "bg-success";
            case "good": return "bg-info";
            case "average": return "bg-warning";
            case "below average": return "bg-orange";
            case "poor": return "bg-danger";
            case "pending review": return "bg-secondary";
            default: return "bg-secondary";
        }
    }

    private void DeleteAttendance(int attendanceId)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "DELETE FROM Attendance WHERE AttendanceId = @AttendanceId AND EmployeeId = @EmployeeId";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@AttendanceId", attendanceId);
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
        LoadAttendanceData();
        LoadAttendanceStats();
    }
} 