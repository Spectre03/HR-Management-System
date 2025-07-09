using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

public partial class UpdatePasswordHashes : System.Web.UI.Page
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Check if user is admin
            if (Session["UserRole"] == null || !Session["UserRole"].ToString().Equals("Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }
    }

    protected void btnTestHash_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrWhiteSpace(txtTestPassword.Text))
        {
            lblTestResult.Text = "Please enter a test password.";
            return;
        }

        string testPassword = txtTestPassword.Text;
        string hexHash = HashPassword(testPassword);
        
        lblTestResult.Text = $"Test password '{testPassword}' hashes to: {hexHash}";
    }

    protected void btnUpdateHashes_Click(object sender, EventArgs e)
    {
        try
        {
            int updatedCount = 0;
            
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                
                // Get all employees with password hashes
                string selectQuery = "SELECT EmployeeId, Username, PasswordHash FROM Employees WHERE PasswordHash IS NOT NULL";
                
                using (SqlCommand selectCmd = new SqlCommand(selectQuery, con))
                {
                    using (SqlDataReader reader = selectCmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int employeeId = reader.GetInt32("EmployeeId");
                            string username = reader.GetString("Username");
                            string currentHash = reader.GetString("PasswordHash");
                            
                            // Check if this is a Base64 hash (contains = at the end or is longer than 64 chars)
                            if (currentHash.Contains("=") || currentHash.Length > 64)
                            {
                                // This is likely a Base64 hash, we need to update it
                                // For now, we'll set a default password "password123" for all employees
                                string newHash = HashPassword("password123");
                                
                                // Update the hash
                                using (SqlConnection updateCon = new SqlConnection(connectionString))
                                {
                                    updateCon.Open();
                                    string updateQuery = "UPDATE Employees SET PasswordHash = @PasswordHash WHERE EmployeeId = @EmployeeId";
                                    using (SqlCommand updateCmd = new SqlCommand(updateQuery, updateCon))
                                    {
                                        updateCmd.Parameters.AddWithValue("@PasswordHash", newHash);
                                        updateCmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                                        updateCmd.ExecuteNonQuery();
                                        updatedCount++;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            ShowMessage($"Successfully updated {updatedCount} employee password(s). All updated employees now have password: 'password123'", true);
        }
        catch (Exception ex)
        {
            ShowMessage($"Error updating password hashes: {ex.Message}", false);
        }
    }

    private void ShowMessage(string message, bool isSuccess)
    {
        pnlMessage.Visible = true;
        litMessage.Text = message;
        pnlMessage.CssClass = isSuccess ? "alert alert-success" : "alert alert-danger";
    }

    private static string HashPassword(string password)
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