using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class EmployeeDocuments : System.Web.UI.UserControl
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDocuments();
        }
    }
    private void LoadDocuments()
    {
        if (Session["UserId"] == null) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "SELECT DocumentId, DocumentName, UploadDate, FilePath FROM Documents WHERE EmployeeId = @EmployeeId ORDER BY UploadDate DESC";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                con.Open();
                DataTable dt = new DataTable();
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }
                gvDocuments.DataSource = dt;
                gvDocuments.DataBind();
                lblNoDocuments.Visible = (dt.Rows.Count == 0);
            }
        }
    }
    protected void btnUploadDocument_Click(object sender, EventArgs e)
    {
        if (Session["UserId"] == null || !fuDocument.HasFile) return;
        int employeeId = Convert.ToInt32(Session["UserId"]);
        string fileName = Path.GetFileName(fuDocument.FileName);
        string savePath = Server.MapPath("~/EmployeeDocuments/") + fileName;
        fuDocument.SaveAs(savePath);
        string filePath = "~/EmployeeDocuments/" + fileName;
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "INSERT INTO Documents (EmployeeId, DocumentName, UploadDate, FilePath) VALUES (@EmployeeId, @DocumentName, GETDATE(), @FilePath)";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                cmd.Parameters.AddWithValue("@DocumentName", txtDocumentName.Text.Trim());
                cmd.Parameters.AddWithValue("@FilePath", filePath);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
        txtDocumentName.Text = string.Empty;
        LoadDocuments();
    }
    protected void gvDocuments_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteDoc")
        {
            int documentId = Convert.ToInt32(e.CommandArgument);
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT FilePath FROM Documents WHERE DocumentId = @DocumentId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@DocumentId", documentId);
                    con.Open();
                    string filePath = cmd.ExecuteScalar() as string;
                    if (!string.IsNullOrEmpty(filePath))
                    {
                        string fullPath = Server.MapPath(filePath);
                        if (File.Exists(fullPath)) File.Delete(fullPath);
                    }
                }
                query = "DELETE FROM Documents WHERE DocumentId = @DocumentId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@DocumentId", documentId);
                    cmd.ExecuteNonQuery();
                }
            }
            LoadDocuments();
        }
    }
} 