using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebSite3
{
    public partial class TestDepartments : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Load overview statistics
                    string totalDeptQuery = "SELECT COUNT(*) FROM Departments WHERE IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(totalDeptQuery, conn))
                    {
                        lblTotalDepts.Text = cmd.ExecuteScalar().ToString();
                    }

                    string totalEmpQuery = "SELECT COUNT(*) FROM Employees WHERE Status = 'Active'";
                    using (SqlCommand cmd = new SqlCommand(totalEmpQuery, conn))
                    {
                        lblTotalEmps.Text = cmd.ExecuteScalar().ToString();
                    }

                    string activeDeptQuery = "SELECT COUNT(*) FROM Departments WHERE IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(activeDeptQuery, conn))
                    {
                        lblActiveDepts.Text = cmd.ExecuteScalar().ToString();
                    }

                    string vacancyQuery = "SELECT ISNULL(SUM(ISNULL(VacancyCount, 0)), 0) FROM Departments WHERE IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(vacancyQuery, conn))
                    {
                        lblTotalVacancies.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Load department details
                    string deptQuery = @"
                        SELECT 
                            d.DepartmentId,
                            d.DepartmentName,
                            d.Description,
                            d.Location,
                            d.HeadOfDepartment,
                            d.Budget,
                            ISNULL(d.VacancyCount, 0) as VacancyCount,
                            d.IsActive,
                            ISNULL(emp.EmployeeCount, 0) as EmployeeCount,
                            ISNULL(active.ActiveCount, 0) as ActiveCount
                        FROM Departments d
                        LEFT JOIN (
                            SELECT DepartmentId, COUNT(*) as EmployeeCount
                            FROM Employees
                            WHERE DepartmentId IS NOT NULL
                            GROUP BY DepartmentId
                        ) emp ON d.DepartmentId = emp.DepartmentId
                        LEFT JOIN (
                            SELECT DepartmentId, COUNT(*) as ActiveCount
                            FROM Employees
                            WHERE DepartmentId IS NOT NULL AND Status = 'Active'
                            GROUP BY DepartmentId
                        ) active ON d.DepartmentId = active.DepartmentId
                        WHERE d.IsActive = 1
                        ORDER BY d.DepartmentName";

                    using (SqlCommand cmd = new SqlCommand(deptQuery, conn))
                    {
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            gvDepartments.DataSource = dt;
                            gvDepartments.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("Error: " + ex.Message);
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadData();
        }
    }
} 