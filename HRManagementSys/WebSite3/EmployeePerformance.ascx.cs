using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Data;
using System.Web.Script.Serialization;

public partial class EmployeePerformance : System.Web.UI.UserControl
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPerformance();
        }
    }
    private void LoadPerformance()
    {
        if (Session["UserId"] == null) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);
        DataTable dt = new DataTable();
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = @"SELECT PerformanceId, ReviewDate, PerformanceRating, TechnicalSkills, CommunicationSkills, TeamworkSkills, LeadershipSkills, Comments, GoalsForNextPeriod, EmployeeComments FROM Performance WHERE EmployeeId = @EmployeeId ORDER BY ReviewDate DESC";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                con.Open();
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }
            }
        }
        // Bind to history table
        gvPerformanceHistory.DataSource = dt;
        gvPerformanceHistory.DataBind();
        // Summary badges: average rating and review count
        double avgRating = 0;
        int reviewCount = dt.Rows.Count;
        if (reviewCount > 0)
        {
            int sum = 0;
            foreach (DataRow row in dt.Rows)
            {
                sum += row["PerformanceRating"] != DBNull.Value ? Convert.ToInt32(row["PerformanceRating"]) : 0;
            }
            avgRating = (double)sum / reviewCount;
        }
        // Set summary badge values (for JS to pick up)
        litAvgRating.Text = avgRating > 0 ? avgRating.ToString("F2") : "--";
        litReviewCount.Text = reviewCount.ToString();
        // Latest review for top card and radar
        if (dt.Rows.Count > 0)
        {
            DataRow latest = dt.Rows[0];
            int rating = latest["PerformanceRating"] != DBNull.Value ? Convert.ToInt32(latest["PerformanceRating"]) : 0;
            // Use Unicode stars for best compatibility
            string filledStar = "&#9733;"; // ★
            string emptyStar = "&#9734;"; // ☆
            stars.InnerHtml = new string(' ', 0); // clear
            for (int i = 0; i < rating; i++) stars.InnerHtml += filledStar;
            for (int i = rating; i < 5; i++) stars.InnerHtml += emptyStar;
            litPerformanceRating.Text = rating.ToString();
            litPerformanceReview.Text = latest["Comments"].ToString();
            litPerformanceGoals.Text = latest["GoalsForNextPeriod"].ToString();
            txtSelfReview.Text = latest["EmployeeComments"].ToString();
            ViewState["PerformanceId"] = latest["PerformanceId"];
            lblNoPerformance.Visible = false;
            // Radar chart data (latest skills)
            int tech = latest["TechnicalSkills"] != DBNull.Value ? Convert.ToInt32(latest["TechnicalSkills"]) : 0;
            int comm = latest["CommunicationSkills"] != DBNull.Value ? Convert.ToInt32(latest["CommunicationSkills"]) : 0;
            int team = latest["TeamworkSkills"] != DBNull.Value ? Convert.ToInt32(latest["TeamworkSkills"]) : 0;
            int lead = latest["LeadershipSkills"] != DBNull.Value ? Convert.ToInt32(latest["LeadershipSkills"]) : 0;
            perfRadarData.Value = new JavaScriptSerializer().Serialize(new int[] { tech, comm, team, lead });
        }
        else
        {
            stars.InnerHtml = "&#9734;&#9734;&#9734;&#9734;&#9734;";
            litPerformanceRating.Text = "N/A";
            litPerformanceReview.Text = "";
            litPerformanceGoals.Text = "";
            txtSelfReview.Text = "";
            lblNoPerformance.Visible = true;
            perfRadarData.Value = new JavaScriptSerializer().Serialize(new int[] { 0, 0, 0, 0 });
        }
        // Trend chart data (all reviews)
        var dates = new System.Collections.Generic.List<string>();
        var ratings = new System.Collections.Generic.List<int>();
        foreach (DataRow row in dt.Rows)
        {
            dates.Add(Convert.ToDateTime(row["ReviewDate"]).ToString("MMM yyyy"));
            ratings.Add(row["PerformanceRating"] != DBNull.Value ? Convert.ToInt32(row["PerformanceRating"]) : 0);
        }
        if (dates.Count == 0) { dates.Add("-"); ratings.Add(0); }
        var trendObj = new { dates = dates, ratings = ratings };
        perfTrendData.Value = new JavaScriptSerializer().Serialize(trendObj);
    }
    protected void btnSubmitSelfReview_Click(object sender, EventArgs e)
    {
        if (Session["UserId"] == null || ViewState["PerformanceId"] == null) return;
        int performanceId = Convert.ToInt32(ViewState["PerformanceId"]);
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "UPDATE Performance SET EmployeeComments = @EmployeeComments WHERE PerformanceId = @PerformanceId";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@EmployeeComments", txtSelfReview.Text.Trim());
                cmd.Parameters.AddWithValue("@PerformanceId", performanceId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
        LoadPerformance();
    }
} 