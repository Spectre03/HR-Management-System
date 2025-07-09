using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

public partial class EmployeeProfile : System.Web.UI.UserControl
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            pnlEditProfile.Visible = false;
            LoadProfile();
        }
    }
    private void LoadProfile()
    {
        if (Session["UserId"] == null) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = @"SELECT FirstName, LastName, Email, Phone, Department, JobTitle, ProfilePicture, Address, City, State, ZipCode, Gender, HireDate, EmergencyContactName, EmergencyContactPhone FROM Employees WHERE EmployeeId = @EmployeeId";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        litProfileName.Text = reader["FirstName"] + " " + reader["LastName"];
                        litProfileEmail.Text = reader["Email"].ToString();
                        litProfilePhone.Text = reader["Phone"].ToString();
                        litProfileDepartment.Text = reader["Department"].ToString();
                        litProfilePosition.Text = reader["JobTitle"].ToString();
                        imgProfilePicture.ImageUrl = string.IsNullOrEmpty(reader["ProfilePicture"].ToString()) ? "https://via.placeholder.com/100" : reader["ProfilePicture"].ToString();
                        litProfileAddress.Text = reader["Address"].ToString();
                        litProfileCity.Text = reader["City"].ToString();
                        litProfileState.Text = reader["State"].ToString();
                        litProfileZip.Text = reader["ZipCode"].ToString();
                        litProfileGender.Text = reader["Gender"].ToString();
                        litProfileHireDate.Text = reader["HireDate"] != DBNull.Value ? Convert.ToDateTime(reader["HireDate"]).ToString("yyyy-MM-dd") : "";
                        litProfileEmergencyContact.Text = reader["EmergencyContactName"].ToString();
                        litProfileEmergencyPhone.Text = reader["EmergencyContactPhone"].ToString();
                        // Fill edit fields
                        txtFirstName.Text = reader["FirstName"].ToString();
                        txtLastName.Text = reader["LastName"].ToString();
                        txtEmail.Text = reader["Email"].ToString();
                        txtPhone.Text = reader["Phone"].ToString();
                        txtDepartment.Text = reader["Department"].ToString();
                        txtJobTitle.Text = reader["JobTitle"].ToString();
                        txtAddress.Text = reader["Address"].ToString();
                        txtCity.Text = reader["City"].ToString();
                        txtState.Text = reader["State"].ToString();
                        txtZip.Text = reader["ZipCode"].ToString();
                        txtGender.Text = reader["Gender"].ToString();
                        txtHireDate.Text = reader["HireDate"] != DBNull.Value ? Convert.ToDateTime(reader["HireDate"]).ToString("yyyy-MM-dd") : "";
                        txtEmergencyContact.Text = reader["EmergencyContactName"].ToString();
                        txtEmergencyPhone.Text = reader["EmergencyContactPhone"].ToString();
                    }
                }
            }
        }
    }
    protected void btnEditProfile_Click(object sender, EventArgs e)
    {
        pnlEditProfile.Visible = true;
    }
    protected void btnCancelEdit_Click(object sender, EventArgs e)
    {
        pnlEditProfile.Visible = false;
    }
    protected void btnSaveProfile_Click(object sender, EventArgs e)
    {
        if (Session["UserId"] == null) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);
        string profilePicPath = null;
        if (fuProfilePicture.HasFile)
        {
            string ext = Path.GetExtension(fuProfilePicture.FileName);
            string fileName = string.Format("profile_{0}{1}", employeeId, ext);
            string savePath = Server.MapPath("~/ProfilePictures/") + fileName;
            fuProfilePicture.SaveAs(savePath);
            profilePicPath = "~/ProfilePictures/" + fileName;
        }
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = @"UPDATE Employees SET FirstName=@FirstName, LastName=@LastName, Email=@Email, PhoneNumber=@PhoneNumber, Department=@Department, JobTitle=@JobTitle, Address=@Address, City=@City, State=@State, ZipCode=@ZipCode, Gender=@Gender, HireDate=@HireDate, EmergencyContactName=@EmergencyContactName, EmergencyContactPhone=@EmergencyContactPhone";
            if (profilePicPath != null)
                query += ", ProfilePicture=@ProfilePicture";
            query += " WHERE EmployeeId=@EmployeeId";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@PhoneNumber", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@Department", txtDepartment.Text.Trim());
                cmd.Parameters.AddWithValue("@JobTitle", txtJobTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                cmd.Parameters.AddWithValue("@City", txtCity.Text.Trim());
                cmd.Parameters.AddWithValue("@State", txtState.Text.Trim());
                cmd.Parameters.AddWithValue("@ZipCode", txtZip.Text.Trim());
                cmd.Parameters.AddWithValue("@Gender", txtGender.Text.Trim());
                DateTime hireDate;
                if (DateTime.TryParse(txtHireDate.Text.Trim(), out hireDate))
                    cmd.Parameters.AddWithValue("@HireDate", hireDate);
                else
                    cmd.Parameters.AddWithValue("@HireDate", DBNull.Value);
                cmd.Parameters.AddWithValue("@EmergencyContactName", txtEmergencyContact.Text.Trim());
                cmd.Parameters.AddWithValue("@EmergencyContactPhone", txtEmergencyPhone.Text.Trim());
                if (profilePicPath != null)
                    cmd.Parameters.AddWithValue("@ProfilePicture", profilePicPath);
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
        pnlEditProfile.Visible = false;
        LoadProfile();
    }
} 