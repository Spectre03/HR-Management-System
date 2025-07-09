using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI.WebControls;

public partial class Settings : System.Web.UI.Page
{
    private string connectionString = ConfigurationManager.ConnectionStrings["HRConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadProfileSettings();
            LoadSystemSettings();
            LoadNotificationSettings();
            LoadSecuritySettings();
            LoadIntegrationSettings();
            LoadSupportSettings();
        }
    }

    // --- Profile ---
    private void LoadProfileSettings()
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "SELECT FullName, Email, AvatarPath FROM Admins WHERE AdminId=1";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        txtAdminName.Text = reader["FullName"].ToString();
                        txtAdminEmail.Text = reader["Email"].ToString();
                        string avatarPath = reader["AvatarPath"] == DBNull.Value ? "" : reader["AvatarPath"].ToString();
                        if (!string.IsNullOrEmpty(avatarPath))
                        {
                            Page.ClientScript.RegisterStartupScript(this.GetType(), "SetAvatarPreview", string.Format("document.addEventListener('DOMContentLoaded',function(){{document.getElementById('avatarPreview').src='{0}';}});", avatarPath), true);
                        }
                    }
                }
            }
        }
    }
    protected void btnSaveProfile_Click(object sender, EventArgs e)
    {
        try
        {
            string avatarPath = null;
            if (fuAvatar.HasFile)
            {
                avatarPath = "/uploads/" + Guid.NewGuid() + System.IO.Path.GetExtension(fuAvatar.FileName);
                fuAvatar.SaveAs(Server.MapPath(avatarPath));
            }
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "UPDATE Admins SET FullName=@FullName, Email=@Email";
                if (!string.IsNullOrEmpty(txtAdminPassword.Text))
                    query += ", PasswordHash=@PasswordHash";
                if (!string.IsNullOrEmpty(avatarPath))
                    query += ", AvatarPath=@AvatarPath";
                query += " WHERE AdminId=1";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FullName", txtAdminName.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtAdminEmail.Text.Trim());
                    if (!string.IsNullOrEmpty(txtAdminPassword.Text))
                        cmd.Parameters.AddWithValue("@PasswordHash", HashPassword(txtAdminPassword.Text.Trim()));
                    if (!string.IsNullOrEmpty(avatarPath))
                        cmd.Parameters.AddWithValue("@AvatarPath", avatarPath);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            lblProfileMessage.Text = "<div class='alert alert-success'>Profile updated successfully!</div>";
            lblProfileMessage.Visible = true;
        }
        catch (Exception ex)
        {
            lblProfileMessage.Text = string.Format("<div class='alert alert-danger'>Error updating profile: {0}</div>", ex.Message);
            lblProfileMessage.Visible = true;
        }
    }

    // --- System ---
    private void LoadSystemSettings()
    {
        txtCompanyName.Text = GetSetting("CompanyName");
        txtWorkingHours.Text = GetSetting("WorkingHours");
        txtHolidays.Text = GetSetting("Holidays");
        // Logo upload not loaded here
    }
    protected void btnSaveSystem_Click(object sender, EventArgs e)
    {
        try
        {
            SetSetting("CompanyName", txtCompanyName.Text.Trim());
            SetSetting("WorkingHours", txtWorkingHours.Text.Trim());
            SetSetting("Holidays", txtHolidays.Text.Trim());
            if (fuCompanyLogo.HasFile)
            {
                string filePath = "/uploads/" + Guid.NewGuid() + System.IO.Path.GetExtension(fuCompanyLogo.FileName);
                fuCompanyLogo.SaveAs(Server.MapPath(filePath));
                SetSetting("CompanyLogo", filePath);
            }
            lblSystemMessage.Text = "<div class='alert alert-success'>System settings updated!</div>";
            lblSystemMessage.Visible = true;
        }
        catch (Exception ex)
        {
            lblSystemMessage.Text = string.Format("<div class='alert alert-danger'>Error updating system settings: {0}</div>", ex.Message);
            lblSystemMessage.Visible = true;
        }
    }

    // --- Notifications ---
    private void LoadNotificationSettings()
    {
        chkEmailNotifications.Checked = GetSetting("EnableEmailNotifications") == "true";
        chkSmsNotifications.Checked = GetSetting("EnableSmsNotifications") == "true";
        txtNotificationTemplate.Text = GetSetting("NotificationTemplate");
    }
    protected void btnSaveNotifications_Click(object sender, EventArgs e)
    {
        try
        {
            SetSetting("EnableEmailNotifications", chkEmailNotifications.Checked ? "true" : "false");
            SetSetting("EnableSmsNotifications", chkSmsNotifications.Checked ? "true" : "false");
            SetSetting("NotificationTemplate", txtNotificationTemplate.Text.Trim());
            lblNotificationsMessage.Text = "<div class='alert alert-success'>Notification settings updated!</div>";
            lblNotificationsMessage.Visible = true;
        }
        catch (Exception ex)
        {
            lblNotificationsMessage.Text = string.Format("<div class='alert alert-danger'>Error updating notification settings: {0}</div>", ex.Message);
            lblNotificationsMessage.Visible = true;
        }
    }

    // --- Security ---
    private void LoadSecuritySettings()
    {
        txtPasswordPolicy.Text = GetSetting("PasswordPolicy");
        chkEnable2FA.Checked = GetSetting("Enable2FA") == "true";
        txtSessionTimeout.Text = GetSetting("SessionTimeout");
    }
    protected void btnSaveSecurity_Click(object sender, EventArgs e)
    {
        try
        {
            SetSetting("PasswordPolicy", txtPasswordPolicy.Text.Trim());
            SetSetting("Enable2FA", chkEnable2FA.Checked ? "true" : "false");
            SetSetting("SessionTimeout", txtSessionTimeout.Text.Trim());
            lblSecurityMessage.Text = "<div class='alert alert-success'>Security settings updated!</div>";
            lblSecurityMessage.Visible = true;
        }
        catch (Exception ex)
        {
            lblSecurityMessage.Text = string.Format("<div class='alert alert-danger'>Error updating security settings: {0}</div>", ex.Message);
            lblSecurityMessage.Visible = true;
        }
    }

    // --- Integrations ---
    private void LoadIntegrationSettings()
    {
        txtPayrollProvider.Text = GetSetting("PayrollProvider");
        txtEmailService.Text = GetSetting("EmailService");
        txtCalendarIntegration.Text = GetSetting("CalendarIntegration");
    }
    protected void btnSaveIntegrations_Click(object sender, EventArgs e)
    {
        try
        {
            SetSetting("PayrollProvider", txtPayrollProvider.Text.Trim());
            SetSetting("EmailService", txtEmailService.Text.Trim());
            SetSetting("CalendarIntegration", txtCalendarIntegration.Text.Trim());
            lblIntegrationsMessage.Text = "<div class='alert alert-success'>Integrations updated!</div>";
            lblIntegrationsMessage.Visible = true;
        }
        catch (Exception ex)
        {
            lblIntegrationsMessage.Text = string.Format("<div class='alert alert-danger'>Error updating integrations: {0}</div>", ex.Message);
            lblIntegrationsMessage.Visible = true;
        }
    }

    // --- Support ---
    private void LoadSupportSettings()
    {
        txtSupportEmail.Text = GetSetting("SupportEmail");
        txtHelpCenter.Text = GetSetting("HelpCenter");
        txtSupportMessage.Text = GetSetting("SupportMessage");
    }
    protected void btnSaveSupport_Click(object sender, EventArgs e)
    {
        try
        {
            SetSetting("SupportEmail", txtSupportEmail.Text.Trim());
            SetSetting("HelpCenter", txtHelpCenter.Text.Trim());
            SetSetting("SupportMessage", txtSupportMessage.Text.Trim());
            lblSupportMessage.Text = "<div class='alert alert-success'>Support settings updated!</div>";
            lblSupportMessage.Visible = true;
        }
        catch (Exception ex)
        {
            lblSupportMessage.Text = string.Format("<div class='alert alert-danger'>Error updating support settings: {0}</div>", ex.Message);
            lblSupportMessage.Visible = true;
        }
    }

    // --- Helper methods ---
    private string GetSetting(string key)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = "SELECT SettingValue FROM Settings WHERE SettingKey=@Key";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Key", key);
                con.Open();
                object val = cmd.ExecuteScalar();
                return val == null ? string.Empty : val.ToString();
            }
        }
    }
    private void SetSetting(string key, string value)
    {
        using (SqlConnection con = new SqlConnection(connectionString))
        {
            string query = @"IF EXISTS (SELECT 1 FROM Settings WHERE SettingKey=@Key)
                                UPDATE Settings SET SettingValue=@Value, ModifiedDate=GETDATE() WHERE SettingKey=@Key
                            ELSE
                                INSERT INTO Settings (SettingKey, SettingValue) VALUES (@Key, @Value)";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Key", key);
                cmd.Parameters.AddWithValue("@Value", value);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
    private string HashPassword(string password)
    {
        using (SHA256 sha = SHA256.Create())
        {
            byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
            StringBuilder sb = new StringBuilder();
            foreach (byte b in bytes)
                sb.Append(b.ToString("x2"));
            return sb.ToString();
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Redirect("Login.aspx");
    }
}