using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;

public partial class EditEmployee : System.Web.UI.Page
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;

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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            PopulateDepartments();
            string idStr = Request.QueryString["id"];
            if (string.IsNullOrEmpty(idStr) || !int.TryParse(idStr, out int employeeId))
            {
                ShowMessage("Invalid or missing Employee ID.", false);
                DisableForm();
                return;
            }
            hdnEmployeeId.Value = employeeId.ToString();
            LoadEmployee(employeeId);
        }
    }

    private void PopulateDepartments()
    {
        ddlDepartment.Items.Clear();
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "SELECT DepartmentId, DepartmentName FROM Departments ORDER BY DepartmentName";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                ddlDepartment.DataSource = reader;
                ddlDepartment.DataTextField = "DepartmentName";
                ddlDepartment.DataValueField = "DepartmentId";
                ddlDepartment.DataBind();
            }
        }
        ddlDepartment.Items.Insert(0, new ListItem("Select Department", ""));
    }

    private void LoadEmployee(int employeeId)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "SELECT * FROM Employees WHERE EmployeeId = @EmployeeId";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        txtUsername.Text = reader["Username"].ToString();
                        // Password not shown for security
                        txtFirstName.Text = reader["FirstName"].ToString();
                        txtLastName.Text = reader["LastName"].ToString();
                        txtEmail.Text = reader["Email"].ToString();
                        txtPhone.Text = reader["Phone"].ToString();
                        ddlDepartment.SelectedValue = reader["DepartmentId"].ToString();
                        txtJobTitle.Text = reader["JobTitle"].ToString();
                        txtHireDate.Text = Convert.ToDateTime(reader["HireDate"]).ToString("yyyy-MM-dd");
                        txtBirthDate.Text = reader["BirthDate"] != DBNull.Value ? Convert.ToDateTime(reader["BirthDate"]).ToString("yyyy-MM-dd") : "";
                        txtSalary.Text = reader["Salary"].ToString();
                        ddlStatus.SelectedValue = reader["Status"].ToString();
                        txtAddress.Text = reader["Address"].ToString();
                        txtCity.Text = reader["City"].ToString();
                        txtState.Text = reader["State"].ToString();
                        txtPostalCode.Text = reader["ZipCode"].ToString();
                        ddlGender.SelectedValue = reader["Gender"].ToString();
                        txtEmergencyContact.Text = reader["EmergencyContactName"].ToString();
                        txtEmergencyPhone.Text = reader["EmergencyContactPhone"].ToString();
                    }
                    else
                    {
                        ShowMessage("Employee not found.", false);
                        DisableForm();
                    }
                }
            }
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        pnlMessage.Visible = false;
        litMessage.Text = "";
        try
        {
            if (string.IsNullOrEmpty(hdnEmployeeId.Value) || !int.TryParse(hdnEmployeeId.Value, out int employeeId))
            {
                ShowMessage("Invalid Employee ID.", false);
                return;
            }
            // Validate
            if (string.IsNullOrWhiteSpace(txtUsername.Text) ||
                string.IsNullOrWhiteSpace(txtFirstName.Text) ||
                string.IsNullOrWhiteSpace(txtLastName.Text) ||
                string.IsNullOrWhiteSpace(txtEmail.Text) ||
                string.IsNullOrWhiteSpace(txtPhone.Text) ||
                string.IsNullOrWhiteSpace(ddlDepartment.SelectedValue) ||
                string.IsNullOrWhiteSpace(txtJobTitle.Text) ||
                string.IsNullOrWhiteSpace(txtHireDate.Text) ||
                string.IsNullOrWhiteSpace(txtBirthDate.Text) ||
                string.IsNullOrWhiteSpace(txtSalary.Text) ||
                string.IsNullOrWhiteSpace(ddlStatus.SelectedValue) ||
                string.IsNullOrWhiteSpace(txtAddress.Text) ||
                string.IsNullOrWhiteSpace(txtCity.Text) ||
                string.IsNullOrWhiteSpace(txtState.Text) ||
                string.IsNullOrWhiteSpace(txtPostalCode.Text) ||
                string.IsNullOrWhiteSpace(ddlGender.SelectedValue) ||
                string.IsNullOrWhiteSpace(txtEmergencyContact.Text) ||
                string.IsNullOrWhiteSpace(txtEmergencyPhone.Text))
            {
                ShowMessage("Please fill in all required fields.", false);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = System.Data.CommandType.Text;
                    string updateSql = @"UPDATE Employees SET
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
                        EmergencyContactPhone = @EmergencyPhone";
                    // Only update password if provided
                    if (!string.IsNullOrWhiteSpace(txtPassword.Text))
                    {
                        updateSql += ", PasswordHash = @PasswordHash";
                    }
                    updateSql += " WHERE EmployeeId = @EmployeeId";
                    cmd.CommandText = updateSql;

                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim() ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@DepartmentId", int.Parse(ddlDepartment.SelectedValue));
                    cmd.Parameters.AddWithValue("@JobTitle", txtJobTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@HireDate", DateTime.Parse(txtHireDate.Text));
                    cmd.Parameters.AddWithValue("@BirthDate", !string.IsNullOrWhiteSpace(txtBirthDate.Text) ? DateTime.Parse(txtBirthDate.Text) : (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@Salary", !string.IsNullOrWhiteSpace(txtSalary.Text) ? decimal.Parse(txtSalary.Text) : (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@City", txtCity.Text.Trim());
                    cmd.Parameters.AddWithValue("@State", txtState.Text.Trim());
                    cmd.Parameters.AddWithValue("@ZipCode", txtPostalCode.Text.Trim());
                    cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
                    cmd.Parameters.AddWithValue("@EmergencyContact", txtEmergencyContact.Text.Trim());
                    cmd.Parameters.AddWithValue("@EmergencyPhone", txtEmergencyPhone.Text.Trim());
                    if (!string.IsNullOrWhiteSpace(txtPassword.Text))
                    {
                        cmd.Parameters.AddWithValue("@PasswordHash", HashPassword(txtPassword.Text));
                    }

                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        ShowMessage("Employee updated successfully! <a href='Default.aspx' class='alert-link'>Go to Dashboard</a>", true);
                    }
                    else
                    {
                        ShowMessage("Failed to update employee.", false);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            string errorMsg = "An error occurred: " + ex.Message;
            if (ex.InnerException != null)
                errorMsg += "<br/>Inner: " + ex.InnerException.Message;
            errorMsg += "<br/>Stack: " + ex.StackTrace;
            ShowMessage(errorMsg, false);
        }
    }

    private void ShowMessage(string message, bool isSuccess)
    {
        pnlMessage.Visible = true;
        litMessage.Text = message;
        alertBox.Attributes["class"] = isSuccess ? "alert alert-success" : "alert alert-danger";
    }

    private void DisableForm()
    {
        txtUsername.Enabled = false;
        txtPassword.Enabled = false;
        txtFirstName.Enabled = false;
        txtLastName.Enabled = false;
        txtEmail.Enabled = false;
        txtPhone.Enabled = false;
        ddlDepartment.Enabled = false;
        txtJobTitle.Enabled = false;
        txtHireDate.Enabled = false;
        txtBirthDate.Enabled = false;
        txtSalary.Enabled = false;
        ddlStatus.Enabled = false;
        txtAddress.Enabled = false;
        txtCity.Enabled = false;
        txtState.Enabled = false;
        txtPostalCode.Enabled = false;
        ddlGender.Enabled = false;
        txtEmergencyContact.Enabled = false;
        txtEmergencyPhone.Enabled = false;
        btnSave.Enabled = false;
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