using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web;
using System.Text;
using System.IO;

namespace WebSite3
{
    public partial class Reports : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is authenticated and is an admin
                if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadDepartments();
                LoadMetrics();
                LoadReportData();
            }
        }

        private void LoadDepartments()
        {
            try
            {
                ddlDepartment.Items.Clear();
                ddlDepartment.Items.Add(new ListItem("All Departments", ""));
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT DepartmentId, DepartmentName FROM Departments ORDER BY DepartmentName";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                ddlDepartment.Items.Add(new ListItem(reader["DepartmentName"].ToString(), reader["DepartmentId"].ToString()));
                            }
                        }
                    }
                }
                ddlDepartment.Items.Add(new ListItem("Unassigned", "unassigned"));
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading departments: " + ex.Message, false);
            }
        }

        private void LoadMetrics()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            (SELECT COUNT(*) FROM Employees) as TotalEmployees,
                            (SELECT COUNT(*) FROM Departments) as TotalDepartments,
                            (SELECT COUNT(*) FROM Employees WHERE Status = 'Active') as ActiveEmployees,
                            (SELECT COUNT(*) FROM Employees WHERE Status = 'Inactive') as InactiveEmployees";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                lblTotalEmployees.Text = reader["TotalEmployees"].ToString();
                                lblAttendanceRate.Text = reader["TotalDepartments"].ToString();
                                lblLeaveRequests.Text = reader["ActiveEmployees"].ToString();
                                lblAvgPerformance.Text = reader["InactiveEmployees"].ToString();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading metrics: " + ex.Message, false);
            }
        }

        private void LoadReportData()
        {
            try
            {
                string departmentId = ddlDepartment.SelectedValue;
                string dateRange = ddlDateRange.SelectedValue;
                string reportType = ddlReportType.SelectedValue;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = GetReportQuery(reportType, departmentId, dateRange);
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(departmentId) && departmentId != "")
                            cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                        if (!string.IsNullOrEmpty(dateRange))
                            cmd.Parameters.AddWithValue("@DateRange", int.Parse(dateRange));

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);
                            gvReportData.DataSource = dt;
                            gvReportData.DataBind();

                            // Add summary row for Employee List
                            if (reportType == "leave" && dt.Rows.Count > 0)
                            {
                                int total = dt.Rows.Count;
                                GridViewRow footer = new GridViewRow(0, 0, DataControlRowType.Footer, DataControlRowState.Normal);
                                TableCell cell = new TableCell();
                                cell.ColumnSpan = dt.Columns.Count;
                                cell.Text = string.Format("<strong>Total Employees: {0}</strong>", total);
                                cell.HorizontalAlign = HorizontalAlign.Right;
                                footer.Cells.Add(cell);
                                if (gvReportData.FooterRow != null)
                                    gvReportData.FooterRow.Controls.Clear();
                                gvReportData.Controls[0].Controls.Add(footer);
                            }
                            // Show empty state
                            if (dt.Rows.Count == 0)
                            {
                                gvReportData.EmptyDataText = "<div class='alert alert-warning text-center mb-0'>No data found for the selected filters.</div>";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading report data: " + ex.Message, false);
            }
        }

        private string GetReportQuery(string reportType, string departmentId, string dateRange)
        {
            string baseQuery = "";
            string whereClause = "WHERE 1=1";

            // For Employee List, handle department filter robustly
            if (reportType == "leave")
            {
                if (!string.IsNullOrEmpty(departmentId))
                {
                    if (departmentId == "unassigned")
                        whereClause += " AND e.DepartmentId IS NULL";
                    else if (departmentId != "")
                        whereClause += " AND e.DepartmentId = @DepartmentId";
                    // If departmentId is empty, do not filter by department (show all)
                }
                if (!string.IsNullOrEmpty(dateRange))
                    whereClause += " AND e.HireDate >= DATEADD(day, -@DateRange, GETDATE())";
                baseQuery = @"
                        SELECT 
                            ISNULL(d.DepartmentName, 'Unassigned') as DepartmentName,
                            e.FirstName + ' ' + e.LastName as EmployeeName,
                            e.Email,
                            e.Phone,
                            e.JobTitle,
                            e.HireDate,
                            e.Status
                        FROM Employees e
                        LEFT JOIN Departments d ON d.DepartmentId = e.DepartmentId
                        " + whereClause + @"
                        ORDER BY d.DepartmentName, e.LastName, e.FirstName";
                return baseQuery;
            }

            // For other reports, keep previous logic
            if (!string.IsNullOrEmpty(departmentId) && departmentId != "unassigned")
                whereClause += " AND d.DepartmentId = @DepartmentId";
            if (!string.IsNullOrEmpty(dateRange))
                whereClause += " AND e.HireDate >= DATEADD(day, -@DateRange, GETDATE())";
            if (departmentId == "unassigned")
                whereClause += " AND e.DepartmentId IS NULL";

            switch (reportType)
            {
                case "attendance":
                    baseQuery = @"
                        SELECT 
                            d.DepartmentName,
                            COUNT(e.EmployeeId) as TotalEmployees,
                            SUM(CASE WHEN e.Status = 'Active' THEN 1 ELSE 0 END) as ActiveEmployees,
                            SUM(CASE WHEN e.Status = 'Inactive' THEN 1 ELSE 0 END) as InactiveEmployees,
                            CAST(AVG(CAST(e.Salary as decimal(10,2))) as decimal(10,2)) as AverageSalary
                        FROM Departments d
                        LEFT JOIN Employees e ON d.DepartmentId = e.DepartmentId
                        " + whereClause + @"
                        GROUP BY d.DepartmentName
                        ORDER BY d.DepartmentName";
                    break;
                case "performance":
                    baseQuery = @"
                        SELECT 
                            d.DepartmentName,
                            COUNT(e.EmployeeId) as EmployeeCount,
                            CAST(AVG(CAST(e.Salary as decimal(10,2))) as decimal(10,2)) as AverageSalary,
                            MIN(e.HireDate) as OldestEmployee,
                            MAX(e.HireDate) as NewestEmployee
                        FROM Departments d
                        LEFT JOIN Employees e ON d.DepartmentId = e.DepartmentId
                        " + whereClause + @"
                        GROUP BY d.DepartmentName
                        ORDER BY d.DepartmentName";
                    break;
                case "department":
                    baseQuery = @"
                        SELECT 
                            d.DepartmentName,
                            d.Description,
                            d.Location,
                            d.HeadOfDepartment,
                            COUNT(e.EmployeeId) as EmployeeCount,
                            d.VacancyCount,
                            CAST(d.Budget as decimal(10,2)) as Budget
                        FROM Departments d
                        LEFT JOIN Employees e ON d.DepartmentId = e.DepartmentId
                        " + whereClause + @"
                        GROUP BY d.DepartmentName, d.Description, d.Location, d.HeadOfDepartment, d.VacancyCount, d.Budget";
                    break;
            }
            return baseQuery;
        }

        protected void ddlDateRange_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadReportData();
        }

        protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadReportData();
        }

        protected void ddlReportType_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadReportData();
        }

        protected void ddlViewType_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Toggle between chart and table view
            bool showCharts = ddlViewType.SelectedValue == "chart";
            // You can implement the view switching logic here
        }

        protected void btnExportPDF_Click(object sender, EventArgs e)
        {
            try
            {
                // Create HTML content
                StringBuilder sb = new StringBuilder();
                sb.Append("<html><head>");
                sb.Append("<style>");
                sb.Append("table { border-collapse: collapse; width: 100%; }");
                sb.Append("th, td { border: 1px solid black; padding: 8px; text-align: left; }");
                sb.Append("th { background-color: #f2f2f2; }");
                sb.Append("</style>");
                sb.Append("</head><body>");
                
                // Add title and report details
                sb.Append("<h2 style='text-align: center;'>HR Analytics Report</h2>");
                sb.Append(string.Format("<p><strong>Report Type:</strong> {0}</p>", ddlReportType.SelectedItem.Text));
                sb.Append(string.Format("<p><strong>Department:</strong> {0}</p>", ddlDepartment.SelectedItem.Text));
                sb.Append(string.Format("<p><strong>Date Range:</strong> {0}</p>", ddlDateRange.SelectedItem.Text));
                
                // Add table
                sb.Append("<table>");
                
                // Add headers
                sb.Append("<tr>");
                foreach (DataControlField column in gvReportData.Columns)
                {
                    sb.Append(string.Format("<th>{0}</th>", column.HeaderText));
                }
                sb.Append("</tr>");
                
                // Add data rows
                foreach (GridViewRow row in gvReportData.Rows)
                {
                    sb.Append("<tr>");
                    foreach (TableCell cell in row.Cells)
                    {
                        sb.Append(string.Format("<td>{0}</td>", cell.Text));
                    }
                    sb.Append("</tr>");
                }
                
                sb.Append("</table>");
                sb.Append("</body></html>");

                // Set response headers
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=HRReport.html");
                Response.Charset = "";
                Response.ContentType = "application/html";
                Response.Output.Write(sb.ToString());
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                ShowMessage("Error generating report: " + ex.Message, false);
            }
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            try
            {
                // Create CSV content
                StringBuilder sb = new StringBuilder();
                
                // Add headers
                for (int i = 0; i < gvReportData.Columns.Count; i++)
                {
                    sb.Append(gvReportData.Columns[i].HeaderText);
                    if (i < gvReportData.Columns.Count - 1)
                        sb.Append(",");
                }
                sb.AppendLine();
                
                // Add data rows
                foreach (GridViewRow row in gvReportData.Rows)
                {
                    for (int i = 0; i < row.Cells.Count; i++)
                    {
                        // Escape commas and quotes in cell values
                        string cellValue = row.Cells[i].Text.Replace("\"", "\"\"");
                        if (cellValue.Contains(",") || cellValue.Contains("\""))
                            cellValue = string.Format("\"{0}\"", cellValue);
                        sb.Append(cellValue);
                        if (i < row.Cells.Count - 1)
                            sb.Append(",");
                    }
                    sb.AppendLine();
                }

                // Set response headers
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=HRReport.csv");
                Response.Charset = "";
                Response.ContentType = "text/csv";
                Response.Output.Write(sb.ToString());
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                ShowMessage("Error generating report: " + ex.Message, false);
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            string script = string.Format("alert('{0}');", message);
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowMessage", script, true);
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddYears(-1);
            Response.Redirect("Login.aspx");
        }
    }
}