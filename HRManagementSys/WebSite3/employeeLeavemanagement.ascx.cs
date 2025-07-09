using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class employeeLeavemanagement : System.Web.UI.UserControl
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadLeaveBalances();
            LoadLeaveRequests();
            LoadLeaveTypes();
        }
    }
    private void LoadLeaveBalances()
    {
        if (Session["UserId"] == null) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "SELECT AnnualLeave, SickLeave, OtherLeave FROM LeaveBalances WHERE EmployeeId = @EmployeeId";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        litAnnualLeave.Text = reader["AnnualLeave"].ToString();
                        litSickLeave.Text = reader["SickLeave"].ToString();
                        litOtherLeave.Text = reader["OtherLeave"].ToString();
                    }
                }
            }
        }
    }
    private void LoadLeaveRequests()
    {
        if (Session["UserId"] == null) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = @"SELECT lr.LeaveRequestId, lt.LeaveTypeName AS LeaveType, lr.StartDate, lr.EndDate, lr.Status, lr.Reason FROM LeaveRequests lr LEFT JOIN LeaveTypes lt ON lr.LeaveTypeId = lt.LeaveTypeId WHERE lr.EmployeeId = @EmployeeId ORDER BY lr.StartDate DESC";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                con.Open();
                DataTable dt = new DataTable();
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }
                gvLeaveRequests.DataSource = dt;
                gvLeaveRequests.DataBind();
                lblNoLeaveRequests.Visible = (dt.Rows.Count == 0);
            }
        }
    }
    private void LoadLeaveTypes()
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "SELECT LeaveTypeId, LeaveTypeName FROM LeaveTypes ORDER BY LeaveTypeName";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                ddlLeaveType.DataSource = cmd.ExecuteReader();
                ddlLeaveType.DataTextField = "LeaveTypeName";
                ddlLeaveType.DataValueField = "LeaveTypeId";
                ddlLeaveType.DataBind();
            }
        }
        ddlLeaveType.Items.Insert(0, new ListItem("Select Leave Type", ""));
    }
    protected void btnRequestLeave_Click(object sender, EventArgs e)
    {
        pnlLeaveForm.Visible = true;
    }
    protected void btnCancelLeave_Click(object sender, EventArgs e)
    {
        pnlLeaveForm.Visible = false;
        // Clear form fields
        ddlLeaveType.SelectedIndex = 0;
        txtStartDate.Text = "";
        txtEndDate.Text = "";
        txtReason.Text = "";
    }
    protected void btnSubmitLeave_Click(object sender, EventArgs e)
    {
        if (Session["UserId"] == null) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);
        if (string.IsNullOrEmpty(ddlLeaveType.SelectedValue)) return;
        int leaveTypeId = Convert.ToInt32(ddlLeaveType.SelectedValue);
        DateTime startDate = DateTime.Parse(txtStartDate.Text);
        DateTime endDate = DateTime.Parse(txtEndDate.Text);
        string reason = txtReason.Text.Trim();
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "INSERT INTO LeaveRequests (EmployeeId, LeaveTypeId, StartDate, EndDate, Status, Reason, RequestDate) VALUES (@EmployeeId, @LeaveTypeId, @StartDate, @EndDate, 'Pending', @Reason, GETDATE())";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                cmd.Parameters.AddWithValue("@LeaveTypeId", leaveTypeId);
                cmd.Parameters.AddWithValue("@StartDate", startDate);
                cmd.Parameters.AddWithValue("@EndDate", endDate);
                cmd.Parameters.AddWithValue("@Reason", reason);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
        // Clear form fields and hide form
        ddlLeaveType.SelectedIndex = 0;
        txtStartDate.Text = "";
        txtEndDate.Text = "";
        txtReason.Text = "";
        pnlLeaveForm.Visible = false;
        LoadLeaveRequests();
    }
    public string GetLeaveStatusBadgeClass(string status)
    {
        switch (status.ToLower())
        {
            case "approved": return "bg-success";
            case "pending": return "bg-warning";
            case "rejected": return "bg-danger";
            default: return "bg-secondary";
        }
    }

    protected void gvLeaveRequests_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            int leaveRequestId = Convert.ToInt32(e.CommandArgument);
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "UPDATE LeaveRequests SET Status = 'Cancelled' WHERE LeaveRequestId = @LeaveRequestId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LeaveRequestId", leaveRequestId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            LoadLeaveRequests();
        }
    }
} 