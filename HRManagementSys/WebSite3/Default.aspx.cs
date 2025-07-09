using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;        
using System.Web.UI.HtmlControls;   
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Linq;
using System.Collections.Generic;

public partial class _Default : System.Web.UI.Page
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;
    private EmployeeService employeeService;

    private void ShowMessage(string message, bool isSuccess)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "ShowMessage", 
            string.Format("showToast('{0}', '{1}', {2});", isSuccess ? "Success" : "Error", message, isSuccess.ToString().ToLower()), true);
    }

    // Employee class definition
    public class Employees
    {
        public int EmployeeId { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public int DepartmentId { get; set; }
        public string JobTitle { get; set; }
        public DateTime HireDate { get; set; }
        public DateTime? BirthDate { get; set; }
        public decimal? Salary { get; set; }
        public string Status { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
        public string Gender { get; set; }
        public string EmergencyContact { get; set; }
        public string EmergencyPhone { get; set; }
    }

    // EmployeeService class
    private class EmployeeService
    {
        private string connectionString;

        public EmployeeService(string connectionString)
        {
            this.connectionString = connectionString;
        }

        public bool AddEmployee(Employees employee)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = conn;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = @"INSERT INTO Employees (
                            Username, PasswordHash, FirstName, LastName, Email, Phone, 
                            DepartmentId, JobTitle, HireDate, BirthDate, Salary, Status,
                            Address, City, State, ZipCode, Gender, EmergencyContactName, 
                            EmergencyContactPhone
                        ) VALUES (
                            @Username, @PasswordHash, @FirstName, @LastName, @Email, @Phone,
                            @DepartmentId, @JobTitle, @HireDate, @BirthDate, @Salary, @Status,
                            @Address, @City, @State, @ZipCode, @Gender, @EmergencyContact,
                            @EmergencyPhone
                        ); SELECT SCOPE_IDENTITY();";

                        cmd.Parameters.AddWithValue("@Username", employee.Username);
                        cmd.Parameters.AddWithValue("@PasswordHash", HashPassword(employee.Password));
                        cmd.Parameters.AddWithValue("@FirstName", employee.FirstName);
                        cmd.Parameters.AddWithValue("@LastName", employee.LastName);
                        cmd.Parameters.AddWithValue("@Email", employee.Email);
                        cmd.Parameters.AddWithValue("@Phone", employee.Phone ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@DepartmentId", employee.DepartmentId);
                        cmd.Parameters.AddWithValue("@JobTitle", employee.JobTitle);
                        cmd.Parameters.AddWithValue("@HireDate", employee.HireDate);
                        cmd.Parameters.AddWithValue("@BirthDate", employee.BirthDate ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@Salary", employee.Salary ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@Status", employee.Status);
                        cmd.Parameters.AddWithValue("@Address", employee.Address);
                        cmd.Parameters.AddWithValue("@City", employee.City);
                        cmd.Parameters.AddWithValue("@State", employee.State);
                        cmd.Parameters.AddWithValue("@ZipCode", employee.PostalCode);
                        cmd.Parameters.AddWithValue("@Gender", employee.Gender);
                        cmd.Parameters.AddWithValue("@EmergencyContact", employee.EmergencyContact);
                        cmd.Parameters.AddWithValue("@EmergencyPhone", employee.EmergencyPhone);

                        object result = cmd.ExecuteScalar();
                        int newEmployeeId = 0;
                        if (result != null && int.TryParse(result.ToString(), out newEmployeeId))
                        {
                            // Insert default leave balance
                            using (SqlCommand leaveCmd = new SqlCommand("INSERT INTO LeaveBalances (EmployeeId, AnnualLeave, SickLeave, OtherLeave, Year) VALUES (@EmployeeId, 20, 10, 5, @Year)", conn))
                            {
                                leaveCmd.Parameters.AddWithValue("@EmployeeId", newEmployeeId);
                                leaveCmd.Parameters.AddWithValue("@Year", DateTime.Now.Year);
                                leaveCmd.ExecuteNonQuery();
                            }
                            // Insert default performance record
                            using (SqlCommand perfCmd = new SqlCommand("INSERT INTO Performance (EmployeeId, ReviewDate, ReviewPeriodStart, ReviewPeriodEnd, ReviewerName, PerformanceRating, TechnicalSkills, CommunicationSkills, TeamworkSkills, LeadershipSkills, Status) VALUES (@EmployeeId, @ReviewDate, @ReviewPeriodStart, @ReviewPeriodEnd, @ReviewerName, @PerformanceRating, @TechnicalSkills, @CommunicationSkills, @TeamworkSkills, @LeadershipSkills, @Status)", conn))
                            {
                                DateTime today = DateTime.Now.Date;
                                perfCmd.Parameters.AddWithValue("@EmployeeId", newEmployeeId);
                                perfCmd.Parameters.AddWithValue("@ReviewDate", today);
                                perfCmd.Parameters.AddWithValue("@ReviewPeriodStart", today.AddMonths(-6));
                                perfCmd.Parameters.AddWithValue("@ReviewPeriodEnd", today);
                                perfCmd.Parameters.AddWithValue("@ReviewerName", "System");
                                perfCmd.Parameters.AddWithValue("@PerformanceRating", 3); // Default average
                                perfCmd.Parameters.AddWithValue("@TechnicalSkills", 3);
                                perfCmd.Parameters.AddWithValue("@CommunicationSkills", 3);
                                perfCmd.Parameters.AddWithValue("@TeamworkSkills", 3);
                                perfCmd.Parameters.AddWithValue("@LeadershipSkills", 3);
                                perfCmd.Parameters.AddWithValue("@Status", "Draft");
                                perfCmd.ExecuteNonQuery();
                            }
                            return true;
                        }
                        return false;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(string.Format("Error in AddEmployee: {0}", ex.Message));
                return false;
            }
        }

        public bool UpdateEmployee(Employees employee)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = conn;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = @"UPDATE Employees SET 
                            Username = @Username,
                            FirstName = @FirstName,
                            LastName = @LastName,
                            Email = @Email,
                            Phone = @Phone,
                            DepartmentId = @DepartmentId,
                            JobTitle = @JobTitle,
                            HireDate = @HireDate,
                            BirthDate = @BirthDate,
                            Salary = @Salary,
                            Status = @Status,
                            Address = @Address,
                            City = @City,
                            State = @State,
                            ZipCode = @ZipCode,
                            Gender = @Gender,
                            EmergencyContactName = @EmergencyContact,
                            EmergencyContactPhone = @EmergencyPhone
                            WHERE EmployeeId = @EmployeeId";

                        cmd.Parameters.AddWithValue("@EmployeeId", employee.EmployeeId);
                        cmd.Parameters.AddWithValue("@Username", employee.Username);
                        cmd.Parameters.AddWithValue("@FirstName", employee.FirstName);
                        cmd.Parameters.AddWithValue("@LastName", employee.LastName);
                        cmd.Parameters.AddWithValue("@Email", employee.Email);
                        cmd.Parameters.AddWithValue("@Phone", employee.Phone ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@DepartmentId", employee.DepartmentId);
                        cmd.Parameters.AddWithValue("@JobTitle", employee.JobTitle);
                        cmd.Parameters.AddWithValue("@HireDate", employee.HireDate);
                        cmd.Parameters.AddWithValue("@BirthDate", employee.BirthDate ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@Salary", employee.Salary ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@Status", employee.Status);
                        cmd.Parameters.AddWithValue("@Address", employee.Address);
                        cmd.Parameters.AddWithValue("@City", employee.City);
                        cmd.Parameters.AddWithValue("@State", employee.State);
                        cmd.Parameters.AddWithValue("@ZipCode", employee.PostalCode);
                        cmd.Parameters.AddWithValue("@Gender", employee.Gender);
                        cmd.Parameters.AddWithValue("@EmergencyContact", employee.EmergencyContact);
                        cmd.Parameters.AddWithValue("@EmergencyPhone", employee.EmergencyPhone);

                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(string.Format("Error in UpdateEmployee: {0}", ex.Message));
                return false;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
            }
            BindEmployeeStats();
            LoadEmployees();
            BindDepartments();
        }
    }

    private void BindDepartments()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT DepartmentId, DepartmentName FROM Departments ORDER BY DepartmentName";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    ddlFilterDepartment.DataSource = dt;
                    ddlFilterDepartment.DataTextField = "DepartmentName";
                    ddlFilterDepartment.DataValueField = "DepartmentId";
                    ddlFilterDepartment.DataBind();
                }
            }
            ddlFilterDepartment.Items.Insert(0, new ListItem("All Departments", ""));
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading departments: " + ex.Message, false);
        }
    }

    private void BindEmployeeStats()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT 
                                COUNT(*) as TotalEmployees,
                                SUM(CASE WHEN Status = 'Active' THEN 1 ELSE 0 END) as ActiveEmployees,
                                COUNT(CASE WHEN HireDate >= DATEADD(month, -1, GETDATE()) THEN 1 END) as NewThisMonth
                              FROM Employees";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTotalEmployees.Text = reader["TotalEmployees"].ToString();
                            lblActiveToday.Text = reader["ActiveEmployees"].ToString();
                            lblNewThisMonth.Text = reader["NewThisMonth"].ToString();
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

    private void LoadEmployees()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT e.EmployeeId, e.FirstName, e.LastName, e.Email, e.Phone, 
                                d.DepartmentName as Department, e.JobTitle, e.HireDate, e.Status 
                                FROM Employees e 
                                LEFT JOIN Departments d ON e.DepartmentId = d.DepartmentId 
                                ORDER BY e.FirstName, e.LastName";
                
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    gvEmployees.DataSource = dt;
                    gvEmployees.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading employees: " + ex.Message, false);
        }
    }

    private void BindEmployees()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT e.EmployeeId, e.FirstName, e.LastName, e.Email, e.Phone, 
                                d.DepartmentName as Department, e.JobTitle, e.HireDate, e.Status 
                                FROM Employees e 
                                LEFT JOIN Departments d ON e.DepartmentId = d.DepartmentId 
                                ORDER BY e.FirstName, e.LastName";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    gvEmployees.DataSource = dt;
                    gvEmployees.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading employees: " + ex.Message, false);
        }
    }

    private static string HashPassword(string password)
    {
        try
        {
            using (var sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine(string.Format("Error in HashPassword: {0}", ex.Message));
            throw;
        }
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {
        try
        {
            string search = txtSearch.Text.Trim();
            string department = ddlFilterDepartment.SelectedValue;
            string status = ddlFilterStatus.SelectedValue;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT e.EmployeeId, e.FirstName, e.LastName, e.Email, e.Phone, 
                                d.DepartmentName as Department, e.JobTitle, e.HireDate, e.Status 
                                FROM Employees e 
                                LEFT JOIN Departments d ON e.DepartmentId = d.DepartmentId 
                                WHERE 1=1";

                if (!string.IsNullOrEmpty(search))
                    query += " AND (e.FirstName LIKE @Search OR e.LastName LIKE @Search)";
                if (!string.IsNullOrEmpty(department))
                    query += " AND e.DepartmentId = @Department";
                if (!string.IsNullOrEmpty(status))
                    query += " AND e.Status = @Status";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrEmpty(search))
                        cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                    if (!string.IsNullOrEmpty(department))
                        cmd.Parameters.AddWithValue("@Department", department);
                    if (!string.IsNullOrEmpty(status))
                        cmd.Parameters.AddWithValue("@Status", status);

                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    gvEmployees.DataSource = dt;
                    gvEmployees.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error filtering employees: " + ex.Message, false);
        }
    }

    protected void gvEmployees_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Delete")
        {
            int employeeId = Convert.ToInt32(e.CommandArgument);
            DeleteEmployee(employeeId);
        }
    }

    protected void gvEmployees_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            int employeeId = Convert.ToInt32(gvEmployees.DataKeys[e.RowIndex].Value);
            DeleteEmployee(employeeId);
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine(string.Format("Error in gvEmployees_RowDeleting: {0}", ex.Message));
            System.Diagnostics.Debug.WriteLine(string.Format("Stack Trace: {0}", ex.StackTrace));
            ShowMessage("Error deleting employee: " + ex.Message, false);
        }
    }

    private void DeleteEmployee(int employeeId)
    {
        try
        {
            System.Diagnostics.Debug.WriteLine(string.Format("Starting delete operation for employee ID: {0}", employeeId));
            
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlTransaction transaction = con.BeginTransaction())
                {
                    try
                    {
                        // First, get employee details for logging
                        string employeeName = "";
                        using (SqlCommand checkCmd = new SqlCommand(
                            "SELECT FirstName, LastName FROM Employees WHERE EmployeeId = @EmployeeId", 
                            con, transaction))
                        {
                            checkCmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                            using (SqlDataReader reader = checkCmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    employeeName = string.Format("{0} {1}", reader["FirstName"], reader["LastName"]);
                                }
                            }
                        }

                        // Delete employee
                        using (SqlCommand cmd = new SqlCommand("DELETE FROM Employees WHERE EmployeeId = @EmployeeId", con, transaction))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                            int rowsAffected = cmd.ExecuteNonQuery();
                            
                            if (rowsAffected > 0)
                            {
                                transaction.Commit();
                                System.Diagnostics.Debug.WriteLine(string.Format("Successfully deleted employee: {0} (ID: {1})", employeeName, employeeId));
                                ShowMessage(string.Format("Employee {0} has been deleted successfully!", employeeName), true);
                                
                                // Refresh the data
                    BindEmployees();
                    BindEmployeeStats();
                            }
                            else
                            {
                                transaction.Rollback();
                                System.Diagnostics.Debug.WriteLine(string.Format("No employee found with ID: {0}", employeeId));
                                ShowMessage("Employee not found or already deleted.", false);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        System.Diagnostics.Debug.WriteLine(string.Format("Error during delete transaction: {0}", ex.Message));
                        throw;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine(string.Format("Error in DeleteEmployee: {0}", ex.Message));
            System.Diagnostics.Debug.WriteLine(string.Format("Stack Trace: {0}", ex.StackTrace));
            ShowMessage("Error deleting employee: " + ex.Message, false);
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        // Clear all session variables
        Session.Clear();
        Session.Abandon();

        // Clear authentication cookie if exists
        if (Request.Cookies["ASP.NET_SessionId"] != null)
        {
            Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddDays(-1);
        }

        // Redirect to login page
        Response.Redirect("Login.aspx");
    }
}