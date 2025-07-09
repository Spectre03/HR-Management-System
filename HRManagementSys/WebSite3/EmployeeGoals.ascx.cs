using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class EmployeeGoals : System.Web.UI.UserControl
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadGoals();
            LoadGoalStats();
        }
    }

    private void LoadGoals()
    {
        if (Session["UserId"] == null) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);
        
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = @"SELECT g.GoalId, g.GoalTitle, g.GoalDescription, g.TargetDate, g.Status, 
                           g.ProgressPercentage, g.AssignedDate, 
                           CASE 
                               WHEN ISNUMERIC(g.AssignedBy) = 1 
                               THEN (SELECT e.FirstName + ' ' + e.LastName FROM Employees e WHERE e.EmployeeId = CAST(g.AssignedBy AS INT))
                               ELSE g.AssignedBy
                           END AS AssignedBy
                           FROM EmployeeGoals g
                           WHERE g.EmployeeId = @EmployeeId
                           ORDER BY g.TargetDate ASC";
            
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                con.Open();
                DataTable dt = new DataTable();
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }
                rptGoals.DataSource = dt;
                rptGoals.DataBind();
                lblNoGoals.Visible = (dt.Rows.Count == 0);
            }
        }
    }

    private void LoadGoalStats()
    {
        if (Session["UserId"] == null) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);
        
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = @"SELECT 
                COUNT(*) as TotalGoals,
                COUNT(CASE WHEN Status = 'Completed' THEN 1 END) as CompletedGoals,
                COUNT(CASE WHEN Status = 'In Progress' THEN 1 END) as InProgressGoals
                FROM EmployeeGoals 
                WHERE EmployeeId = @EmployeeId";
            
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        int totalGoals = Convert.ToInt32(reader["TotalGoals"]);
                        int completedGoals = Convert.ToInt32(reader["CompletedGoals"]);
                        int inProgressGoals = Convert.ToInt32(reader["InProgressGoals"]);
                        
                        litTotalGoals.Text = totalGoals.ToString();
                        litCompletedGoals.Text = completedGoals.ToString();
                        litInProgressGoals.Text = inProgressGoals.ToString();
                        
                        double completionRate = totalGoals > 0 ? (double)completedGoals / totalGoals * 100 : 0;
                        litCompletionRate.Text = completionRate.ToString("F1") + "%";
                    }
                }
            }
        }
    }

    protected void rptGoals_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int goalId = Convert.ToInt32(e.CommandArgument);
        
        if (e.CommandName == "UpdateProgress")
        {
            LoadGoalForProgressUpdate(goalId);
        }
        else if (e.CommandName == "MarkComplete")
        {
            MarkGoalComplete(goalId);
        }
    }

    private void LoadGoalForProgressUpdate(int goalId)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "SELECT GoalTitle, ProgressPercentage FROM EmployeeGoals WHERE GoalId = @GoalId";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@GoalId", goalId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        litGoalTitle.Text = reader["GoalTitle"].ToString();
                        txtProgressPercentage.Text = reader["ProgressPercentage"].ToString();
                        ViewState["CurrentGoalId"] = goalId;
                        pnlProgressModal.Visible = true;
                    }
                }
            }
        }
    }

    private void MarkGoalComplete(int goalId)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "UPDATE EmployeeGoals SET Status = 'Completed', ProgressPercentage = 100, CompletedDate = GETDATE() WHERE GoalId = @GoalId";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@GoalId", goalId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
        LoadGoals();
        LoadGoalStats();
    }

    protected void btnSaveProgress_Click(object sender, EventArgs e)
    {
        if (ViewState["CurrentGoalId"] == null) return;
        
        int goalId = Convert.ToInt32(ViewState["CurrentGoalId"]);
        int progressPercentage = Convert.ToInt32(txtProgressPercentage.Text);
        string comments = txtProgressComments.Text.Trim();
        
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = @"UPDATE EmployeeGoals 
                           SET ProgressPercentage = @ProgressPercentage, 
                               Status = CASE WHEN @ProgressPercentage = 100 THEN 'Completed' ELSE 'In Progress' END,
                               LastUpdated = GETDATE()
                           WHERE GoalId = @GoalId";
            
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@GoalId", goalId);
                cmd.Parameters.AddWithValue("@ProgressPercentage", progressPercentage);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
        
        pnlProgressModal.Visible = false;
        txtProgressPercentage.Text = "";
        txtProgressComments.Text = "";
        ViewState["CurrentGoalId"] = null;
        
        LoadGoals();
        LoadGoalStats();
    }

    protected void btnCancelProgress_Click(object sender, EventArgs e)
    {
        pnlProgressModal.Visible = false;
        txtProgressPercentage.Text = "";
        txtProgressComments.Text = "";
        ViewState["CurrentGoalId"] = null;
    }

    public string GetStatusBadgeClass(string status)
    {
        switch (status.ToLower())
        {
            case "completed": return "bg-success";
            case "in progress": return "bg-warning";
            case "not started": return "bg-secondary";
            case "overdue": return "bg-danger";
            default: return "bg-secondary";
        }
    }
} 