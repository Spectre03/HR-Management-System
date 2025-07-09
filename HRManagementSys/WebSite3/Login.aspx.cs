using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

public partial class Login : System.Web.UI.Page
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] != null)
        {
            // Redirect based on role
            string role = Session["UserRole"] != null ? Session["UserRole"].ToString() : null;
            System.Diagnostics.Debug.WriteLine(string.Format("Page_Load - Current Role: {0}", role));
            
            if (role != null && role.Equals("Admin", StringComparison.OrdinalIgnoreCase))
                Response.Redirect("Default.aspx");
            else if (role != null && role.Equals("Employee", StringComparison.OrdinalIgnoreCase))
                Response.Redirect("EmployeeDashboard.aspx");
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        try
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            string role = ddlRole.SelectedValue;

            System.Diagnostics.Debug.WriteLine(string.Format("Login attempt - Username: {0}, Role: {1}", username, role));

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ShowError("Please enter both username and password.");
                return;
            }

            // Hash the input password
            string hashedPassword = HashPassword(password);

            string query = "";
            if (role.Equals("Admin", StringComparison.OrdinalIgnoreCase))
            {
                query = @"SELECT AdminId AS UserId, FullName 
                         FROM Admins 
                         WHERE LOWER(Username) = LOWER(@Username) 
                         AND PasswordHash = @Password";
            }
            else if (role.Equals("Employee", StringComparison.OrdinalIgnoreCase))
            {
                query = @"SELECT EmployeeId AS UserId, FirstName + ' ' + LastName AS FullName 
                         FROM Employees 
                         WHERE LOWER(Username) = LOWER(@Username) 
                         AND PasswordHash = @Password";
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                    
                    try
                    {
                        con.Open();
                        var reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            Session["UserId"] = reader["UserId"];
                            Session["UserName"] = reader["FullName"];
                            Session["UserRole"] = role;

                            System.Diagnostics.Debug.WriteLine(string.Format("Login successful - UserId: {0}, Role: {1}", reader["UserId"], role));

                            if (role.Equals("Admin", StringComparison.OrdinalIgnoreCase))
                            {
                                System.Diagnostics.Debug.WriteLine("Redirecting to Admin panel");
                                Response.Redirect("Default.aspx");
                            }
                            else if (role.Equals("Employee", StringComparison.OrdinalIgnoreCase))
                            {
                                System.Diagnostics.Debug.WriteLine("Redirecting to Employee panel");
                                Response.Redirect("EmployeeDashboard.aspx");
                            }
                        }
                        else
                        {
                            ShowError("Invalid username or password. Please try again.");
                        }
                    }
                    catch (SqlException ex)
                    {
                        ShowError("Database error occurred. Please try again later.");
                        System.Diagnostics.Debug.WriteLine(string.Format("SQL Error: {0}", ex.Message));
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowError("An unexpected error occurred. Please try again later.");
            System.Diagnostics.Debug.WriteLine(string.Format("General Error: {0}", ex.Message));
        }
    }

    private void ShowError(string message)
    {
        lblError.Text = message;
        lblError.CssClass = "alert alert-danger d-block";
    }

    private string HashPassword(string password)
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
}
