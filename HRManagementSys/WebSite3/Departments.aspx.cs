using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebSite3
{
public partial class Departments : System.Web.UI.Page
{
        private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            {
                LoadDepartmentOverview();
                LoadDepartments();
                LoadFilterOptions();
            }
        }

        private void LoadDepartmentOverview()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if IsActive column exists
                    bool hasIsActiveColumn = false;
                    string checkColumnQuery = @"
                        SELECT COUNT(*) 
                        FROM INFORMATION_SCHEMA.COLUMNS 
                        WHERE TABLE_NAME = 'Departments' AND COLUMN_NAME = 'IsActive'";
                    
                    using (SqlCommand cmd = new SqlCommand(checkColumnQuery, conn))
                    {
                        hasIsActiveColumn = (int)cmd.ExecuteScalar() > 0;
                    }

                    // Total Departments (active only if IsActive column exists, otherwise all)
                    string totalDeptQuery = hasIsActiveColumn 
                        ? "SELECT COUNT(*) FROM Departments WHERE IsActive = 1"
                        : "SELECT COUNT(*) FROM Departments";
                    using (SqlCommand cmd = new SqlCommand(totalDeptQuery, conn))
                    {
                        lblTotalDepartments.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Total Employees (active only)
                    string totalEmpQuery = "SELECT COUNT(*) FROM Employees WHERE Status = 'Active'";
                    using (SqlCommand cmd = new SqlCommand(totalEmpQuery, conn))
                    {
                        lblTotalEmployees.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Active Departments (same as total if IsActive column doesn't exist)
                    string activeDeptQuery = hasIsActiveColumn 
                        ? "SELECT COUNT(*) FROM Departments WHERE IsActive = 1"
                        : "SELECT COUNT(*) FROM Departments";
                    using (SqlCommand cmd = new SqlCommand(activeDeptQuery, conn))
                    {
                        lblActiveDepartments.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Total Vacancies (sum of all department vacancies)
                    string vacancyQuery = hasIsActiveColumn
                        ? "SELECT ISNULL(SUM(ISNULL(VacancyCount, 0)), 0) FROM Departments WHERE IsActive = 1"
                        : "SELECT ISNULL(SUM(ISNULL(VacancyCount, 0)), 0) FROM Departments";
                    using (SqlCommand cmd = new SqlCommand(vacancyQuery, conn))
                    {
                        lblTotalVacancies.Text = cmd.ExecuteScalar().ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading department overview: " + ex.Message, false);
            }
        }

        private void LoadDepartments()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Check if IsActive column exists
                    bool hasIsActiveColumn = false;
                    string checkColumnQuery = @"
                        SELECT COUNT(*) 
                        FROM INFORMATION_SCHEMA.COLUMNS 
                        WHERE TABLE_NAME = 'Departments' AND COLUMN_NAME = 'IsActive'";
                    
                    using (SqlCommand cmd = new SqlCommand(checkColumnQuery, conn))
                    {
                        hasIsActiveColumn = (int)cmd.ExecuteScalar() > 0;
                    }
                    
                    string query = @"
                        SELECT 
                            d.DepartmentId,
                            d.DepartmentName,
                            d.Description,
                            d.Location,
                            d.HeadOfDepartment,
                            d.Budget,
                            ISNULL(d.VacancyCount, 0) as VacancyCount,
                            " + (hasIsActiveColumn ? "d.IsActive" : "1 as IsActive") + @",
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
                        " + (hasIsActiveColumn ? "WHERE d.IsActive = 1" : "") + @"
                        ORDER BY d.DepartmentName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                DataTable dt = new DataTable();
                            da.Fill(dt);
                            rptDepartments.DataSource = dt;
                            rptDepartments.DataBind();
                        }
                    }
                        }
                    }
                    catch (Exception ex)
            {
                ShowAlert("Error loading departments: " + ex.Message, false);
            }
        }

        private void LoadFilterOptions()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Check if IsActive column exists
                    bool hasIsActiveColumn = false;
                    string checkColumnQuery = @"
                        SELECT COUNT(*) 
                        FROM INFORMATION_SCHEMA.COLUMNS 
                        WHERE TABLE_NAME = 'Departments' AND COLUMN_NAME = 'IsActive'";
                    
                    using (SqlCommand cmd = new SqlCommand(checkColumnQuery, conn))
                    {
                        hasIsActiveColumn = (int)cmd.ExecuteScalar() > 0;
                    }
                    
                    string query = hasIsActiveColumn 
                        ? "SELECT DepartmentName FROM Departments WHERE IsActive = 1 ORDER BY DepartmentName"
                        : "SELECT DepartmentName FROM Departments ORDER BY DepartmentName";
                        
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlFilterDepartment.Items.Clear();
                            ddlFilterDepartment.Items.Add(new ListItem("All Departments", ""));
                            while (reader.Read())
                            {
                                ddlFilterDepartment.Items.Add(new ListItem(reader["DepartmentName"].ToString(), reader["DepartmentName"].ToString()));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading filter options: " + ex.Message, false);
            }
    }

    protected void btnAddDepartment_Click(object sender, EventArgs e)
    {
            ClearForm();
            hdnDepartmentId.Value = "";
            txtDepartmentName.Text = "";
            txtLocation.Text = "";
            txtDescription.Text = "";
            txtHeadOfDepartment.Text = "";
            txtVacancyCount.Text = "0";
            txtBudget.Text = "";
            
            btnSave.Visible = true;
            btnUpdate.Visible = false;
            
            ScriptManager.RegisterStartupScript(this, GetType(), "showModal", 
                "updateModalTitle(false); var modal = new bootstrap.Modal(document.getElementById('addDepartmentModal')); modal.show();", true);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtDepartmentName.Text))
                {
                    ShowAlert("Department name is required.", false);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                    conn.Open();
                    string query = @"
                        INSERT INTO Departments (DepartmentName, Description, Location, HeadOfDepartment, Budget, VacancyCount, IsActive, CreatedDate)
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

                ShowAlert("Department added successfully!", true);
                LoadDepartmentOverview();
                LoadDepartments();
                LoadFilterOptions();
                
                ScriptManager.RegisterStartupScript(this, GetType(), "hideModal", 
                    "var modal = bootstrap.Modal.getInstance(document.getElementById('addDepartmentModal')); modal.hide();", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error adding department: " + ex.Message, false);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtDepartmentName.Text))
                {
                    ShowAlert("Department name is required.", false);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                    conn.Open();
                    string query = @"
                        UPDATE Departments 
                    SET DepartmentName = @DepartmentName,
                        Description = @Description,
                        Location = @Location,
                        HeadOfDepartment = @HeadOfDepartment,
                        Budget = @Budget,
                        VacancyCount = @VacancyCount,
                            ModifiedDate = GETDATE()
                    WHERE DepartmentId = @DepartmentId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@DepartmentId", Convert.ToInt32(hdnDepartmentId.Value));
                        cmd.Parameters.AddWithValue("@DepartmentName", txtDepartmentName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@Location", txtLocation.Text.Trim());
                        cmd.Parameters.AddWithValue("@HeadOfDepartment", txtHeadOfDepartment.Text.Trim());
                        cmd.Parameters.AddWithValue("@Budget", string.IsNullOrEmpty(txtBudget.Text) ? (object)DBNull.Value : Convert.ToDecimal(txtBudget.Text));
                        cmd.Parameters.AddWithValue("@VacancyCount", string.IsNullOrEmpty(txtVacancyCount.Text) ? 0 : Convert.ToInt32(txtVacancyCount.Text));

                        cmd.ExecuteNonQuery();
                    }
                }

                ShowAlert("Department updated successfully!", true);
                LoadDepartmentOverview();
                LoadDepartments();
                
                ScriptManager.RegisterStartupScript(this, GetType(), "hideModal", 
                    "var modal = bootstrap.Modal.getInstance(document.getElementById('addDepartmentModal')); modal.hide();", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating department: " + ex.Message, false);
            }
        }

        protected void rptDepartments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int departmentId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "EditDepartment":
                    LoadDepartmentForEdit(departmentId);
                    break;
                case "ViewEmployees":
                    LoadDepartmentEmployees(departmentId);
                    break;
                case "ManageEmployees":
                    LoadManageEmployees(departmentId);
                    break;
                case "DeleteDepartment":
                    DeleteDepartment(departmentId);
                    break;
            }
        }

        private void LoadDepartmentForEdit(int departmentId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                string query = "SELECT * FROM Departments WHERE DepartmentId = @DepartmentId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                hdnDepartmentId.Value = departmentId.ToString();
                                txtDepartmentName.Text = reader["DepartmentName"].ToString();
                                txtDescription.Text = reader["Description"].ToString();
                                txtLocation.Text = reader["Location"].ToString();
                                txtHeadOfDepartment.Text = reader["HeadOfDepartment"].ToString();
                                txtVacancyCount.Text = reader["VacancyCount"].ToString();
                                txtBudget.Text = reader["Budget"] != DBNull.Value ? reader["Budget"].ToString() : "";

                                btnSave.Visible = false;
                                btnUpdate.Visible = true;

                                ScriptManager.RegisterStartupScript(this, GetType(), "showEditModal", 
                                    "updateModalTitle(true); var modal = new bootstrap.Modal(document.getElementById('addDepartmentModal')); modal.show();", true);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading department for edit: " + ex.Message, false);
            }
        }

        private void LoadDepartmentEmployees(int departmentId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT EmployeeId, FirstName, LastName, Email, JobTitle, HireDate, Status
                        FROM Employees 
                        WHERE DepartmentId = @DepartmentId
                        ORDER BY FirstName, LastName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            gvDepartmentEmployees.DataSource = dt;
                            gvDepartmentEmployees.DataBind();
                        }
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "showEmployeesModal", 
                    "var modal = new bootstrap.Modal(document.getElementById('viewEmployeesModal')); modal.show();", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading department employees: " + ex.Message, false);
            }
        }

        private void LoadManageEmployees(int departmentId)
        {
            try
            {
                hdnManageDepartmentId.Value = departmentId.ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Load current department employees
                    string deptEmployeesQuery = @"
                        SELECT EmployeeId, FirstName, LastName, JobTitle
                        FROM Employees 
                        WHERE DepartmentId = @DepartmentId
                        ORDER BY FirstName, LastName";

                    using (SqlCommand cmd = new SqlCommand(deptEmployeesQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            gvManageEmployees.DataSource = dt;
                            gvManageEmployees.DataBind();
                        }
                    }

                    // Load available employees (all active employees)
                    string availableEmployeesQuery = @"
                        SELECT EmployeeId, FirstName + ' ' + LastName as FullName
                        FROM Employees 
                        WHERE Status = 'Active'
                        ORDER BY FirstName, LastName";

                    using (SqlCommand cmd = new SqlCommand(availableEmployeesQuery, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlAvailableEmployees.Items.Clear();
                            ddlAvailableEmployees.Items.Add(new ListItem("-- Select Employee --", ""));
                            while (reader.Read())
                            {
                                ddlAvailableEmployees.Items.Add(new ListItem(reader["FullName"].ToString(), reader["EmployeeId"].ToString()));
                            }
                        }
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "showManageModal", 
                    "var modal = new bootstrap.Modal(document.getElementById('manageEmployeesModal')); modal.show();", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading employee management: " + ex.Message, false);
            }
        }

        protected void gvManageEmployees_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int employeeId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "ReassignEmployee":
                    LoadReassignEmployee(employeeId);
                    break;
                case "RemoveEmployee":
                    RemoveEmployeeFromDepartment(employeeId);
                    break;
            }
        }

        private void LoadReassignEmployee(int employeeId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Get employee details
                    string employeeQuery = "SELECT FirstName, LastName, JobTitle FROM Employees WHERE EmployeeId = @EmployeeId";
                    using (SqlCommand cmd = new SqlCommand(employeeQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                hdnReassignEmployeeId.Value = employeeId.ToString();
                                lblReassignEmployeeName.Text = reader["FirstName"].ToString() + " " + reader["LastName"].ToString();
                                txtReassignJobTitle.Text = reader["JobTitle"].ToString();
                            }
                        }
                    }

                    // Load available departments
                    string departmentsQuery = @"
                        SELECT DepartmentId, DepartmentName 
                        FROM Departments 
                        WHERE IsActive = 1 
                        ORDER BY DepartmentName";

                    using (SqlCommand cmd = new SqlCommand(departmentsQuery, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlReassignDepartment.Items.Clear();
                            ddlReassignDepartment.Items.Add(new ListItem("-- Select Department --", ""));
                            while (reader.Read())
                            {
                                ddlReassignDepartment.Items.Add(new ListItem(reader["DepartmentName"].ToString(), reader["DepartmentId"].ToString()));
                            }
                        }
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "showReassignModal", 
                    "var modal = new bootstrap.Modal(document.getElementById('reassignEmployeeModal')); modal.show();", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading reassignment: " + ex.Message, false);
            }
        }

        protected void btnConfirmReassign_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(ddlReassignDepartment.SelectedValue))
                {
                    ShowAlert("Please select a department.", false);
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        UPDATE Employees 
                        SET DepartmentId = @DepartmentId, 
                            JobTitle = @JobTitle,
                            ModifiedDate = GETDATE()
                        WHERE EmployeeId = @EmployeeId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmployeeId", Convert.ToInt32(hdnReassignEmployeeId.Value));
                        cmd.Parameters.AddWithValue("@DepartmentId", Convert.ToInt32(ddlReassignDepartment.SelectedValue));
                        cmd.Parameters.AddWithValue("@JobTitle", txtReassignJobTitle.Text.Trim());

                        cmd.ExecuteNonQuery();
                    }
                }

                ShowAlert("Employee reassigned successfully!", true);
                LoadDepartmentOverview();
                LoadDepartments();

                // Refresh the manage employees modal
                LoadManageEmployees(Convert.ToInt32(hdnManageDepartmentId.Value));

                ScriptManager.RegisterStartupScript(this, GetType(), "hideReassignModal", 
                    "var modal = bootstrap.Modal.getInstance(document.getElementById('reassignEmployeeModal')); modal.hide();", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error reassigning employee: " + ex.Message, false);
            }
        }

        private void RemoveEmployeeFromDepartment(int employeeId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        UPDATE Employees 
                        SET DepartmentId = NULL, 
                            JobTitle = NULL,
                            ModifiedDate = GETDATE()
                        WHERE EmployeeId = @EmployeeId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowAlert("Employee removed from department successfully!", true);
                LoadDepartmentOverview();
                LoadDepartments();

                // Refresh the manage employees modal
                LoadManageEmployees(Convert.ToInt32(hdnManageDepartmentId.Value));
                    }
                    catch (Exception ex)
            {
                ShowAlert("Error removing employee: " + ex.Message, false);
            }
        }

        protected void btnAddEmployeeToDept_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(ddlAvailableEmployees.SelectedValue))
                {
                    ShowAlert("Please select an employee.", false);
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtJobTitle.Text))
                {
                    ShowAlert("Job title is required.", false);
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        UPDATE Employees 
                        SET DepartmentId = @DepartmentId, 
                            JobTitle = @JobTitle,
                            ModifiedDate = GETDATE()
                        WHERE EmployeeId = @EmployeeId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmployeeId", Convert.ToInt32(ddlAvailableEmployees.SelectedValue));
                        cmd.Parameters.AddWithValue("@DepartmentId", Convert.ToInt32(hdnManageDepartmentId.Value));
                        cmd.Parameters.AddWithValue("@JobTitle", txtJobTitle.Text.Trim());

                        cmd.ExecuteNonQuery();
                    }
                }

                ShowAlert("Employee added to department successfully!", true);
                LoadDepartmentOverview();
                LoadDepartments();

                // Refresh the manage employees modal
                LoadManageEmployees(Convert.ToInt32(hdnManageDepartmentId.Value));

                // Clear the form
                ddlAvailableEmployees.SelectedIndex = 0;
                txtJobTitle.Text = "";
            }
            catch (Exception ex)
            {
                ShowAlert("Error adding employee to department: " + ex.Message, false);
            }
        }

        private void DeleteDepartment(int departmentId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if department has employees
                    string checkQuery = "SELECT COUNT(*) FROM Employees WHERE DepartmentId = @DepartmentId";
                    using (SqlCommand cmd = new SqlCommand(checkQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                        int employeeCount = (int)cmd.ExecuteScalar();

                        if (employeeCount > 0)
                        {
                            ShowAlert("Cannot delete department. It has " + employeeCount + " employee(s) assigned. Please reassign or remove employees first.", false);
                            return;
                        }
                    }

                    // Soft delete the department
                    string deleteQuery = "UPDATE Departments SET IsActive = 0, ModifiedDate = GETDATE() WHERE DepartmentId = @DepartmentId";
                    using (SqlCommand cmd = new SqlCommand(deleteQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowAlert("Department deleted successfully!", true);
                LoadDepartmentOverview();
                LoadDepartments();
                LoadFilterOptions();
            }
            catch (Exception ex)
            {
                ShowAlert("Error deleting department: " + ex.Message, false);
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Check if IsActive column exists
                    bool hasIsActiveColumn = false;
                    string checkColumnQuery = @"
                        SELECT COUNT(*) 
                        FROM INFORMATION_SCHEMA.COLUMNS 
                        WHERE TABLE_NAME = 'Departments' AND COLUMN_NAME = 'IsActive'";
                    
                    using (SqlCommand cmd = new SqlCommand(checkColumnQuery, conn))
                    {
                        hasIsActiveColumn = (int)cmd.ExecuteScalar() > 0;
                    }
                    
                    string query = @"
                        SELECT 
                            d.DepartmentId,
                            d.DepartmentName,
                            d.Description,
                            d.Location,
                            d.HeadOfDepartment,
                            d.Budget,
                            ISNULL(d.VacancyCount, 0) as VacancyCount,
                            " + (hasIsActiveColumn ? "d.IsActive" : "1 as IsActive") + @",
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
                        " + (hasIsActiveColumn ? "WHERE d.IsActive = 1" : "WHERE 1=1") + @"";

                    List<SqlParameter> parameters = new List<SqlParameter>();

                    if (!string.IsNullOrEmpty(txtSearch.Text))
                    {
                        query += " AND (d.DepartmentName LIKE @Search OR d.Description LIKE @Search OR d.Location LIKE @Search)";
                        parameters.Add(new SqlParameter("@Search", "%" + txtSearch.Text + "%"));
                    }

                    if (!string.IsNullOrEmpty(ddlFilterDepartment.SelectedValue))
                    {
                        query += " AND d.DepartmentName = @Department";
                        parameters.Add(new SqlParameter("@Department", ddlFilterDepartment.SelectedValue));
                    }

                    if (!string.IsNullOrEmpty(ddlFilterStatus.SelectedValue) && hasIsActiveColumn)
                    {
                        query += " AND d.IsActive = @Status";
                        parameters.Add(new SqlParameter("@Status", ddlFilterStatus.SelectedValue == "Active" ? 1 : 0));
                    }

                    query += " ORDER BY d.DepartmentName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                        foreach (SqlParameter param in parameters)
                        {
                            cmd.Parameters.Add(param);
                        }

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            rptDepartments.DataSource = dt;
                            rptDepartments.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error filtering departments: " + ex.Message, false);
            }
        }

        private void ClearForm()
        {
            txtDepartmentName.Text = "";
            txtLocation.Text = "";
            txtDescription.Text = "";
            txtHeadOfDepartment.Text = "";
            txtVacancyCount.Text = "0";
            txtBudget.Text = "";
        }

        private void ShowAlert(string message, bool isSuccess)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showAlert", 
                string.Format("showAlert('{0}', {1});", message.Replace("'", "\\'"), isSuccess.ToString().ToLower()), true);
        }

        protected string GetEmployeeUtilizationPercentage(object employeeCount, object vacancyCount)
        {
            try
            {
                int employees = Convert.ToInt32(employeeCount);
                int vacancies = Convert.ToInt32(vacancyCount);
                int totalPositions = employees + vacancies;
                
                if (totalPositions == 0) return "0";
                
                double percentage = (double)employees / totalPositions * 100;
                return Math.Round(percentage, 1).ToString();
            }
            catch
            {
                return "0";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}