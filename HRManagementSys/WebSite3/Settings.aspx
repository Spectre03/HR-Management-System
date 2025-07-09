<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Settings.aspx.cs" Inherits="Settings" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Settings - HR Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --success-color: #4bb543;
            --warning-color: #fca311;
            --danger-color: #ef233c;
            --light-color: #f8f9fa;
            --dark-color: #212529;
            --accent-color: #36d1c4;
            --glow: 0 0 32px 8px rgba(67,97,238,0.18), 0 0 64px 16px rgba(67,97,238,0.10);
        }
        body {
            background: linear-gradient(135deg, #f5f7fb 0%, #e0e7ff 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #283e51 0%, #485563 50%, var(--accent-color) 100%);
            color: #fff;
            padding: 24px 0 0 0;
            box-shadow: 2px 0 16px 0 rgba(67,97,238,0.10);
            border-top-right-radius: 24px;
            border-bottom-right-radius: 24px;
            position: sticky;
            top: 0;
        }
        .sidebar-logo {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 30px;
        }
        .sidebar-logo img {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            margin-right: 10px;
            box-shadow: 0 0 16px 4px #fff3;
        }
        .sidebar-logo span, .sidebar-logo div {
            color: #fff;
            font-size: 1.3rem;
            font-weight: 700;
            letter-spacing: 1px;
            text-shadow: 0 2px 8px #0002;
        }
        .sidebar .nav-section-label {
            color: #adb5bd;
            font-size: 0.95rem;
            margin-left: 18px;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.92);
            padding: 12px 24px;
            margin: 6px 12px;
            border-radius: 8px;
            font-size: 1.08rem;
            font-weight: 500;
            transition: all 0.25s;
            box-shadow: none;
            display: flex;
            align-items: center;
            gap: 10px;
            position: relative;
        }
        .sidebar .nav-link.active, .sidebar .nav-link:hover {
            background: linear-gradient(90deg, var(--accent-color) 0%, #36d1c4 100%);
            color: #fff;
            box-shadow: 0 2px 12px 0 #36d1c455;
        }
        .sidebar .nav-link i {
            margin-right: 12px;
            width: 22px;
            text-align: center;
            font-size: 1.2rem;
        }
        .sidebar .logout-link {
            margin-top: auto;
            border-top: 1px solid #36d1c4;
            padding-top: 16px;
        }
        .sidebar .logout-link .nav-link {
            color: var(--danger-color);
            font-weight: 600;
        }
        .sidebar .logout-link .nav-link:hover {
            background: rgba(239,35,60,0.12);
            color: #fff;
        }
        .main-content {
            padding: 40px 32px 32px 32px;
            background: linear-gradient(135deg, #f5f7fb 60%, #e0e7ff 100%);
            min-height: 100vh;
        }
        .settings-card {
            border: none;
            border-radius: 18px;
            box-shadow: 0 4px 32px 0 rgba(67,97,238,0.15), 0 0 32px 8px rgba(67,97,238,0.18);
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, #fff 80%, #e0e7ff 100%);
            margin-bottom: 36px;
            animation: glowPulse 2.5s infinite alternate;
            border-left: 8px solid var(--accent-color);
        }
        .settings-card::after {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            pointer-events: none;
            border-radius: 18px;
            box-shadow: var(--glow);
            opacity: 0.7;
            z-index: 0;
        }
        @keyframes glowPulse {
            0% { box-shadow: var(--glow); }
            100% { box-shadow: 0 0 48px 16px rgba(67,97,238,0.28), 0 0 96px 32px rgba(67,97,238,0.18); }
        }
        .settings-card .card-body, .settings-card h5, .settings-card p {
            position: relative;
            z-index: 1;
        }
        .settings-section {
            display: none;
        }
        .settings-section.active {
            display: block;
        }
        .form-label {
            font-weight: 600;
            color: var(--primary-color);
        }
        .form-control, .form-select {
            border-radius: 8px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s;
            font-size: 1.05rem;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.2rem rgba(54,209,196,0.15);
        }
        .btn-primary {
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
            border: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 1.12rem;
            box-shadow: 0 2px 8px 0 rgba(67,97,238,0.10);
            padding: 12px 36px;
            letter-spacing: 0.5px;
        }
        .btn-primary:hover {
            background: linear-gradient(90deg, var(--accent-color), var(--primary-color));
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67,97,238,0.18);
        }
        .btn-secondary {
            border-radius: 10px;
            font-weight: 500;
        }
        .avatar-preview {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            object-fit: cover;
            box-shadow: 0 0 12px 2px #4361ee44;
            margin-bottom: 8px;
        }
        .section-header {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--secondary-color);
            margin-bottom: 18px;
            letter-spacing: 1px;
            text-shadow: 0 2px 8px #3f37c933;
        }
        .divider {
            border-top: 2px solid #e9ecef;
            margin: 24px 0 32px 0;
        }
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            font-size: 1.05rem;
        }
        .alert-success {
            background: linear-gradient(135deg, var(--success-color), #229954);
            color: white;
        }
        .alert-danger {
            background: linear-gradient(135deg, var(--danger-color), #c0392b);
            color: white;
        }
        .custom-switch {
            position: relative;
            display: inline-block;
            width: 56px;
            height: 32px;
            vertical-align: middle;
        }
        .custom-switch .slider {
            position: absolute;
            cursor: pointer;
            top: 0; left: 0; right: 0; bottom: 0;
            background: #222;
            border-radius: 32px;
            box-shadow: 0 0 8px #0ff3, 0 0 2px #0ff3 inset;
            transition: background 0.3s, box-shadow 0.3s;
        }
        .custom-switch input[type="checkbox"]:checked + .slider {
            background: #0ff3;
            box-shadow: 0 0 16px #0ff3, 0 0 4px #0ff3 inset;
        }
        .custom-switch .slider:before {
            content: "";
            position: absolute;
            left: 4px;
            top: 4px;
            width: 24px;
            height: 24px;
            background: #fff;
            border-radius: 50%;
            transition: transform 0.3s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .custom-switch input[type="checkbox"]:checked + .slider:before {
            transform: translateX(24px);
        }
        .custom-switch input[type="checkbox"] {
            opacity: 0;
            width: 0;
            height: 0;
        }
        .custom-switch-label {
            margin-left: 12px;
            font-weight: 500;
            color: #0ff3;
            text-shadow: 0 0 4px #0ff3;
        }
        @media (max-width: 991px) {
            .main-content { padding: 24px 8px; }
            .sidebar { border-radius: 0; }
        }
        @media (max-width: 767px) {
            .sidebar { min-height: auto; padding: 10px 0; }
            .main-content { padding: 12px 2px; }
            .settings-card { margin-bottom: 18px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2 sidebar d-flex flex-column position-sticky" style="top:0; min-height:100vh;">
                    <div class="sidebar-logo text-center mb-4">
                        <img src="https://ui-avatars.com/api/?name=HR+M" alt="HRM Logo" style="width:56px;height:56px;border-radius:50%;margin-bottom:10px;box-shadow:0 0 16px 4px #fff3;" />
                        <div style="color:#fff;font-size:1.4rem;font-weight:700;letter-spacing:1px;text-shadow:0 2px 8px #0002;">HR Manager</div>
                    </div>
                    <ul class="nav flex-column mb-auto">
                        <li class="nav-item"><a class="nav-link" href="Default.aspx"><i class="fas fa-home"></i> Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="Departments.aspx"><i class="fas fa-building"></i> Departments</a></li>
                        <li class="nav-item"><a class="nav-link" href="Reports.aspx"><i class="fas fa-chart-bar"></i> Reports</a></li>
                        <li class="nav-item"><a class="nav-link" href="PerformanceEvaluation.aspx"><i class="fas fa-chart-line"></i> Performance</a></li>
                        <li class="nav-item"><a class="nav-link active" href="Settings.aspx"><i class="fas fa-cog"></i> Settings</a></li>
                    </ul>
                    <div class="logout-link mt-auto pt-3 border-top">
                        <asp:LinkButton ID="btnLogout" runat="server" CssClass="nav-link text-danger fw-bold" OnClick="btnLogout_Click"><i class="fas fa-sign-out-alt"></i> Logout</asp:LinkButton>
                    </div>
                </div>
                <!-- Main Content -->
                <div class="col-md-10 main-content">
                    <h2 class="mb-4"><i class="fas fa-cog text-primary me-2"></i>Settings</h2>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="list-group mb-4" id="settingsMenu">
                                <a href="#" class="list-group-item list-group-item-action active" data-section="profile"><i class="fas fa-user-circle me-2"></i>Profile</a>
                                <a href="#" class="list-group-item list-group-item-action" data-section="system"><i class="fas fa-building me-2"></i>System</a>
                                <a href="#" class="list-group-item list-group-item-action" data-section="notifications"><i class="fas fa-bell me-2"></i>Notifications</a>
                                <a href="#" class="list-group-item list-group-item-action" data-section="security"><i class="fas fa-shield-alt me-2"></i>Security</a>
                                <a href="#" class="list-group-item list-group-item-action" data-section="integrations"><i class="fas fa-plug me-2"></i>Integrations</a>
                                <a href="#" class="list-group-item list-group-item-action" data-section="audit"><i class="fas fa-clipboard-list me-2"></i>Audit & Logs</a>
                                <a href="#" class="list-group-item list-group-item-action" data-section="support"><i class="fas fa-life-ring me-2"></i>Support</a>
                            </div>
                        </div>
                        <div class="col-md-9">
                            <!-- Profile Section -->
                            <div class="settings-card settings-section active" id="section-profile">
                                <div class="card-body">
                                    <asp:Label ID="lblProfileMessage" runat="server" Visible="false" CssClass="w-100" />
                                    <div class="section-header"><i class="fas fa-user-circle me-2"></i>Profile Settings</div>
                                    <div class="row mb-3 align-items-center">
                                        <div class="col-md-2 text-center">
                                            <img id="avatarPreview" src="https://ui-avatars.com/api/?name=Admin" class="avatar-preview" alt="Avatar Preview" />
                                        </div>
                                        <div class="col-md-10">
                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Admin Name</label>
                                                    <asp:TextBox ID="txtAdminName" runat="server" CssClass="form-control" placeholder="Admin Name" />
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Email</label>
                                                    <asp:TextBox ID="txtAdminEmail" runat="server" CssClass="form-control" placeholder="Admin Email" />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">New Password</label>
                                                    <asp:TextBox ID="txtAdminPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="New Password" />
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Avatar</label>
                                                    <asp:FileUpload ID="fuAvatar" runat="server" CssClass="form-control" onchange="previewAvatar(this)" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-end mt-2">
                                        <asp:Button ID="btnSaveProfile" runat="server" Text="Save" CssClass="btn btn-primary me-2 px-4" OnClick="btnSaveProfile_Click" />
                                        <button type="button" class="btn btn-secondary" onclick="resetProfileForm()">Cancel</button>
                                    </div>
                                </div>
                            </div>
                            <!-- System Section -->
                            <div class="settings-card settings-section" id="section-system">
                                <div class="card-body">
                                    <asp:Label ID="lblSystemMessage" runat="server" Visible="false" CssClass="w-100" />
                                    <h5 class="card-title mb-3"><i class="fas fa-building me-2"></i>System Settings</h5>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label">Company Name</label>
                                            <asp:TextBox ID="txtCompanyName" runat="server" CssClass="form-control" placeholder="Company Name" />
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">Company Logo</label>
                                            <asp:FileUpload ID="fuCompanyLogo" runat="server" CssClass="form-control" />
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label">Working Hours</label>
                                            <asp:TextBox ID="txtWorkingHours" runat="server" CssClass="form-control" placeholder="e.g. 9:00 AM - 6:00 PM" />
            </div>
                <div class="col-md-6">
                                            <label class="form-label">Holidays</label>
                                            <asp:TextBox ID="txtHolidays" runat="server" CssClass="form-control" placeholder="e.g. Saturday, Sunday" />
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-end">
                                        <asp:Button ID="btnSaveSystem" runat="server" Text="Save" CssClass="btn btn-primary me-2" OnClick="btnSaveSystem_Click" />
                                        <button type="button" class="btn btn-secondary" onclick="resetSystemForm()">Cancel</button>
                                    </div>
                                </div>
                            </div>
                            <!-- Notifications Section -->
                            <div class="settings-card settings-section" id="section-notifications">
                                <div class="card-body">
                                    <asp:Label ID="lblNotificationsMessage" runat="server" Visible="false" CssClass="w-100" />
                                    <div class="section-header"><i class="fas fa-bell me-2"></i>Notification Settings</div>
                                    <div class="row mb-3 align-items-center">
                                        <div class="col-md-6 mb-2">
                                            <label class="custom-switch">
                                                <input type="checkbox" id="nativeEmailToggle" />
                                                <span class="slider"></span>
                                            </label>
                                            <span class="custom-switch-label" for="nativeEmailToggle" style="color:#4361ee;">Enable Email Notifications</span>
                                            <asp:CheckBox ID="chkEmailNotifications" runat="server" CssClass="d-none" />
                                        </div>
                                        <div class="col-md-6 mb-2">
                                            <label class="custom-switch">
                                                <input type="checkbox" id="nativeSmsToggle" />
                                                <span class="slider"></span>
                                            </label>
                                            <span class="custom-switch-label" for="nativeSmsToggle" style="color:#4bb543;">Enable SMS Notifications</span>
                                            <asp:CheckBox ID="chkSmsNotifications" runat="server" CssClass="d-none" />
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Notification Email Template</label>
                                        <asp:TextBox ID="txtNotificationTemplate" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Enter email template..." />
                                    </div>
                                    <div class="d-flex justify-content-end mt-2">
                                        <asp:Button ID="btnSaveNotifications" runat="server" Text="Save" CssClass="btn btn-primary me-2 px-4" OnClick="btnSaveNotifications_Click" />
                                        <button type="button" class="btn btn-secondary" onclick="resetNotificationsForm()">Cancel</button>
                                    </div>
                                </div>
                            </div>
                            <!-- Security Section -->
                            <div class="settings-card settings-section" id="section-security">
                                <div class="card-body">
                                    <asp:Label ID="lblSecurityMessage" runat="server" Visible="false" CssClass="w-100" />
                                    <h5 class="card-title mb-3"><i class="fas fa-shield-alt me-2"></i>Security Settings</h5>
                                    <div class="mb-3">
                                        <label class="form-label">Password Policy</label>
                                        <asp:TextBox ID="txtPasswordPolicy" runat="server" CssClass="form-control" placeholder="e.g. Min 8 chars, 1 uppercase, 1 number" />
                                    </div>
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <asp:CheckBox ID="chkEnable2FA" runat="server" CssClass="form-check-input" />
                                            <label class="form-check-label ms-2">Enable Two-Factor Authentication</label>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Session Timeout (minutes)</label>
                                        <asp:TextBox ID="txtSessionTimeout" runat="server" CssClass="form-control" TextMode="Number" min="1" placeholder="30" />
                                    </div>
                                    <div class="d-flex justify-content-end">
                                        <asp:Button ID="btnSaveSecurity" runat="server" Text="Save" CssClass="btn btn-primary me-2" OnClick="btnSaveSecurity_Click" />
                                        <button type="button" class="btn btn-secondary" onclick="resetSecurityForm()">Cancel</button>
                                    </div>
                                </div>
                            </div>
                            <!-- Integrations Section -->
                            <div class="settings-card settings-section" id="section-integrations">
                                <div class="card-body">
                                    <asp:Label ID="lblIntegrationsMessage" runat="server" Visible="false" CssClass="w-100" />
                                    <h5 class="card-title mb-3"><i class="fas fa-plug me-2"></i>Integrations</h5>
                                    <div class="mb-3">
                                        <label class="form-label">Payroll Provider</label>
                                        <asp:TextBox ID="txtPayrollProvider" runat="server" CssClass="form-control" placeholder="e.g. ADP, Paychex" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Email Service</label>
                                        <asp:TextBox ID="txtEmailService" runat="server" CssClass="form-control" placeholder="e.g. SendGrid, SMTP" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Calendar Integration</label>
                                        <asp:TextBox ID="txtCalendarIntegration" runat="server" CssClass="form-control" placeholder="e.g. Google Calendar" />
                                    </div>
                                    <div class="d-flex justify-content-end">
                                        <asp:Button ID="btnSaveIntegrations" runat="server" Text="Save" CssClass="btn btn-primary me-2" OnClick="btnSaveIntegrations_Click" />
                                        <button type="button" class="btn btn-secondary" onclick="resetIntegrationsForm()">Cancel</button>
                                    </div>
                                </div>
                            </div>
                            <!-- Audit & Logs Section -->
                            <div class="settings-card settings-section" id="section-audit">
                        <div class="card-body">
                                    <h5 class="card-title mb-3"><i class="fas fa-clipboard-list me-2"></i>Audit & Logs</h5>
                            <div class="mb-3">
                                        <label class="form-label">Recent Admin Actions</label>
                                        <asp:GridView ID="gvAuditLogs" runat="server" CssClass="table table-sm table-hover" AutoGenerateColumns="False">
                                            <Columns>
                                                <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:MM/dd/yyyy HH:mm}" />
                                                <asp:BoundField DataField="Action" HeaderText="Action" />
                                                <asp:BoundField DataField="Details" HeaderText="Details" />
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                            <!-- Support Section -->
                            <div class="settings-card settings-section" id="section-support">
                                <div class="card-body">
                                    <asp:Label ID="lblSupportMessage" runat="server" Visible="false" CssClass="w-100" />
                                    <h5 class="card-title mb-3"><i class="fas fa-life-ring me-2"></i>Support</h5>
                                    <div class="mb-3">
                                        <label class="form-label">Contact Email</label>
                                        <asp:TextBox ID="txtSupportEmail" runat="server" CssClass="form-control" placeholder="support@company.com" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Help Center Link</label>
                                        <asp:TextBox ID="txtHelpCenter" runat="server" CssClass="form-control" placeholder="https://help.company.com" />
                            </div>
                            <div class="mb-3">
                                        <label class="form-label">Message to Users</label>
                                        <asp:TextBox ID="txtSupportMessage" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Enter a message for users..." />
                                    </div>
                                    <div class="d-flex justify-content-end">
                                        <asp:Button ID="btnSaveSupport" runat="server" Text="Save" CssClass="btn btn-primary me-2" OnClick="btnSaveSupport_Click" />
                                        <button type="button" class="btn btn-secondary" onclick="resetSupportForm()">Cancel</button>
                                    </div>
                                </div>
                            </div>
                            <!-- Toast for feedback -->
                            <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
                                <div id="toast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                                    <div class="toast-header">
                                        <strong class="me-auto" id="toastTitle"></strong>
                                        <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                                    </div>
                                    <div class="toast-body" id="toastMessage"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script type="text/javascript">
            // Sidebar section switching
            $(document).ready(function () {
                $('#settingsMenu .list-group-item').click(function (e) {
                    e.preventDefault();
                    $('#settingsMenu .list-group-item').removeClass('active');
                    $(this).addClass('active');
                    var section = $(this).data('section');
                    $('.settings-section').removeClass('active');
                    $('#section-' + section).addClass('active');
                });
            });
            // Toast feedback
            function showToast(title, message, isSuccess) {
                var toast = document.getElementById('toast');
                var toastTitle = document.getElementById('toastTitle');
                var toastMessage = document.getElementById('toastMessage');
                toastTitle.textContent = title;
                toastMessage.textContent = message;
                toast.classList.remove('bg-danger', 'bg-success', 'text-white');
                if (isSuccess) {
                    toast.classList.add('bg-success', 'text-white');
                } else {
                    toast.classList.add('bg-danger', 'text-white');
                }
                var bsToast = new bootstrap.Toast(toast);
                bsToast.show();
            }
            // Reset forms (placeholders for future logic)
            function resetProfileForm() { $("#section-profile input").val(""); }
            function resetSystemForm() { $("#section-system input").val(""); }
            function resetNotificationsForm() { $("#section-notifications input, #section-notifications textarea").val(""); }
            function resetSecurityForm() { $("#section-security input").val(""); }
            function resetIntegrationsForm() { $("#section-integrations input").val(""); }
            function resetSupportForm() { $("#section-support input, #section-support textarea").val(""); }
            function previewAvatar(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        document.getElementById('avatarPreview').src = e.target.result;
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }
        </script>
        <script>
function syncNativeWithAsp() {
    // Email
    var aspEmail = document.getElementById('<%= chkEmailNotifications.ClientID %>');
    var nativeEmail = document.getElementById('nativeEmailToggle');
    if (aspEmail && nativeEmail) {
        nativeEmail.checked = aspEmail.checked;
        nativeEmail.addEventListener('change', function() {
            aspEmail.checked = nativeEmail.checked;
            if (typeof __doPostBack === 'function') {
                __doPostBack(aspEmail.name, '');
            }
        });
    }
    // SMS
    var aspSms = document.getElementById('<%= chkSmsNotifications.ClientID %>');
    var nativeSms = document.getElementById('nativeSmsToggle');
    if (aspSms && nativeSms) {
        nativeSms.checked = aspSms.checked;
        nativeSms.addEventListener('change', function() {
            aspSms.checked = nativeSms.checked;
            if (typeof __doPostBack === 'function') {
                __doPostBack(aspSms.name, '');
            }
        });
    }
}
document.addEventListener('DOMContentLoaded', syncNativeWithAsp);
if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(syncNativeWithAsp);
}
</script>
    </form>
</body>
</html>