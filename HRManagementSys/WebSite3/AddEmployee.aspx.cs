using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;

public partial class AddEmployee : System.Web.UI.Page
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
            txtHireDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtBirthDate.Text = DateTime.Now.AddYears(-25).ToString("yyyy-MM-dd");
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        pnlMessage.Visible = false;
        litMessage.Text = "";
        try
        {
            // Validate
            if (string.IsNullOrWhiteSpace(txtUsername.Text) ||
                string.IsNullOrWhiteSpace(txtPassword.Text) ||
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

            var employee = new Employees
            {
                Username = txtUsername.Text.Trim(),
                Password = txtPassword.Text,
                FirstName = txtFirstName.Text.Trim(),
                LastName = txtLastName.Text.Trim(),
                Email = txtEmail.Text.Trim(),
                Phone = txtPhone.Text.Trim(),
                DepartmentId = int.Parse(ddlDepartment.SelectedValue),
                JobTitle = txtJobTitle.Text.Trim(),
                HireDate = DateTime.Parse(txtHireDate.Text),
                BirthDate = !string.IsNullOrWhiteSpace(txtBirthDate.Text) ? DateTime.Parse(txtBirthDate.Text) : (DateTime?)null,
                Salary = !string.IsNullOrWhiteSpace(txtSalary.Text) ? decimal.Parse(txtSalary.Text) : (decimal?)null,
                Status = ddlStatus.SelectedValue,
                Address = txtAddress.Text.Trim(),
                City = txtCity.Text.Trim(),
                State = txtState.Text.Trim(),
                PostalCode = txtPostalCode.Text.Trim(),
                Gender = ddlGender.SelectedValue,
                EmergencyContact = txtEmergencyContact.Text.Trim(),
                EmergencyPhone = txtEmergencyPhone.Text.Trim()
            };

            string deptName = "";
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlCommand cmdDept = new SqlCommand("SELECT DepartmentName FROM Departments WHERE DepartmentId = @DepartmentId", con))
                {
                    cmdDept.Parameters.AddWithValue("@DepartmentId", employee.DepartmentId);
                    object result = cmdDept.ExecuteScalar();
                    if (result != null)
                        deptName = result.ToString();
                    else
                        deptName = "";
                }
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = System.Data.CommandType.Text;
                    cmd.CommandText = @"INSERT INTO Employees (
                        Username, PasswordHash, FirstName, LastName, Email, Phone, 
                        DepartmentId, Department, JobTitle, HireDate, BirthDate, Salary, Status,
                        Address, City, State, ZipCode, Gender, EmergencyContactName, 
                        EmergencyContactPhone
                    ) VALUES (
                        @Username, @PasswordHash, @FirstName, @LastName, @Email, @Phone,
                        @DepartmentId, @Department, @JobTitle, @HireDate, @BirthDate, @Salary, @Status,
                        @Address, @City, @State, @ZipCode, @Gender, @EmergencyContact,
                        @EmergencyPhone
                    );";

                    cmd.Parameters.AddWithValue("@Username", employee.Username);
                    cmd.Parameters.AddWithValue("@PasswordHash", HashPassword(employee.Password));
                    cmd.Parameters.AddWithValue("@FirstName", employee.FirstName);
                    cmd.Parameters.AddWithValue("@LastName", employee.LastName);
                    cmd.Parameters.AddWithValue("@Email", employee.Email);
                    cmd.Parameters.AddWithValue("@Phone", employee.Phone ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@DepartmentId", employee.DepartmentId);
                    cmd.Parameters.AddWithValue("@Department", deptName);
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

                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        ShowMessage("Employee added successfully! <a href='Default.aspx' class='alert-link'>Go to Dashboard</a>", true);
                        ClearForm();
                    }
                    else
                    {
                        ShowMessage("Failed to add employee.", false);
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

    private void ClearForm()
    {
        txtUsername.Text = "";
        txtPassword.Text = "";
        txtFirstName.Text = "";
        txtLastName.Text = "";
        txtEmail.Text = "";
        txtPhone.Text = "";
        ddlDepartment.SelectedIndex = 0;
        txtJobTitle.Text = "";
        txtHireDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        txtBirthDate.Text = DateTime.Now.AddYears(-25).ToString("yyyy-MM-dd");
        txtSalary.Text = "";
        ddlStatus.SelectedIndex = 0;
        txtAddress.Text = "";
        txtCity.Text = "";
        txtState.Text = "";
        txtPostalCode.Text = "";
        ddlGender.SelectedIndex = 0;
        txtEmergencyContact.Text = "";
        txtEmergencyPhone.Text = "";
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