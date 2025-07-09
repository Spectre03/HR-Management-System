using System;
using System.Configuration;
using System.Data.SqlClient;

namespace WebSite3
{
    public partial class AddDepartment : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlMessage.Visible = false;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            pnlMessage.Visible = true;
            try
            {
                if (string.IsNullOrWhiteSpace(txtDepartmentName.Text))
                {
                    alertMsg.InnerHtml = "<div class='alert alert-danger'>Department name is required.</div>";
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"INSERT INTO Departments (DepartmentName, Description, Location, HeadOfDepartment, Budget, VacancyCount, IsActive, CreatedDate)
                                     VALUES (@DepartmentName, @Description, @Location, @HeadOfDepartment, @Budget, @VacancyCount, 1, GETDATE())";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@DepartmentName", txtDepartmentName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@Location", txtLocation.Text.Trim());
                        cmd.Parameters.AddWithValue("@HeadOfDepartment", txtHeadOfDepartment.Text.Trim());
                        cmd.Parameters.AddWithValue("@Budget", string.IsNullOrEmpty(txtBudget.Text) ? (object)DBNull.Value : Convert.ToDecimal(txtBudget.Text));
                        cmd.Parameters.AddWithValue("@VacancyCount", string.IsNullOrEmpty(txtVacancyCount.Text) ? 0 : Convert.ToInt32(txtVacancyCount.Text));
                        cmd.ExecuteNonQuery();
                    }
                }
                alertMsg.InnerHtml = "<div class='alert alert-success'>Department added successfully! Redirecting...</div>";
                Response.AddHeader("REFRESH", "1.5;URL=Departments.aspx");
            }
            catch (Exception ex)
            {
                alertMsg.InnerHtml = string.Format("<div class='alert alert-danger'>Error: {0}</div>", ex.Message);
            }
        }
    }
} 