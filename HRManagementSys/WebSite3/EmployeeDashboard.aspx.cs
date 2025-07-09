using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class EmployeeDashboard : System.Web.UI.Page
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null || Session["UserRole"] == null || !Session["UserRole"].ToString().Equals("Employee", StringComparison.OrdinalIgnoreCase))
        {
            Response.Redirect("Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadDashboardData();
        }
    }

    private void LoadDashboardData()
    {
        if (Session["UserId"] == null) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
            // Load employee basic info
            string query = "SELECT FirstName, LastName, JobTitle FROM Employees WHERE EmployeeId = @EmployeeId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                        litEmployeeName.Text = reader["FirstName"] + " " + reader["LastName"];
                        litUserDropdown.Text = reader["FirstName"] + " " + reader["LastName"];
                        litJobTitle.Text = reader["JobTitle"].ToString();
                    }
                }
            }

            // Load current date
            litCurrentDate.Text = DateTime.Now.ToString("MMMM dd, yyyy");
                            
            // Load attendance rate
            query = "SELECT COUNT(*) as TotalDays, SUM(CASE WHEN Status = 'Present' THEN 1 ELSE 0 END) as PresentDays FROM Attendance WHERE EmployeeId = @EmployeeId AND AttendanceDate >= DATEADD(month, -1, GETDATE())";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                        int totalDays = reader["TotalDays"] != DBNull.Value ? Convert.ToInt32(reader["TotalDays"]) : 0;
                        int presentDays = reader["PresentDays"] != DBNull.Value ? Convert.ToInt32(reader["PresentDays"]) : 0;
                        double attendanceRate = totalDays > 0 ? Math.Round((double)presentDays / totalDays * 100, 1) : 0;
                        litAttendanceRate.Text = attendanceRate + "%";
                    }
                    else
                    {
                        litAttendanceRate.Text = "0%";
            }
                }
            }

            // Load leave balance
            query = "SELECT AnnualLeave FROM LeaveBalances WHERE EmployeeId = @EmployeeId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                        litLeaveBalance.Text = reader["AnnualLeave"] != DBNull.Value ? reader["AnnualLeave"].ToString() : "0";
                    }
                    else
                    {
                        litLeaveBalance.Text = "0";
                    }
                }
                }
                
            // Load performance rating
            query = "SELECT TOP 1 PerformanceRating FROM Performance WHERE EmployeeId = @EmployeeId ORDER BY ReviewDate DESC";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                        litPerformanceRating.Text = reader["PerformanceRating"] != DBNull.Value ? reader["PerformanceRating"].ToString() + "/5" : "N/A";
                    }
                    else
                    {
                        litPerformanceRating.Text = "N/A";
                }
                }
            }
                                    }
                                }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Redirect("Login.aspx");
    }
}

