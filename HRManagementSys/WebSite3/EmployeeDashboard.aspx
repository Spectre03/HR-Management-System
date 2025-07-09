<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmployeeDashboard.aspx.cs" Inherits="EmployeeDashboard" %>
<%@ Register Src="~/EmployeeProfile.ascx" TagName="EmployeeProfile" TagPrefix="uc" %>
<%@ Register Src="~/EmployeePerformance.ascx" TagName="EmployeePerformance" TagPrefix="uc" %>
<%@ Register Src="~/employeeLeavemanagement.ascx" TagName="EmployeeLeaveManagement" TagPrefix="uc" %>
<%@ Register Src="~/EmployeeDocuments.ascx" TagName="EmployeeDocuments" TagPrefix="uc" %>
<%@ Register Src="~/EmployeeAttendance.ascx" TagName="EmployeeAttendance" TagPrefix="uc" %>
<%@ Register Src="~/EmployeeGoals.ascx" TagName="EmployeeGoals" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Employee Dashboard - HR Management System</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
        }
        
        body {
            background-color: #f5f7fb;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 20px 0;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 10px 20px;
            margin: 5px 10px;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: rgba(255,255,255,0.1);
            color: white;
        }
        
        .sidebar .nav-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        .main-content {
            padding: 30px;
        }
        
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            margin-bottom: 20px;
        }
        
        .card-header {
            background-color: white;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            font-weight: 600;
        }
        
        .stat-card {
            border-radius: 10px;
            padding: 20px;
            color: white;
            height: 100%;
            transition: all 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        
        .stat-card i {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        
        .stat-card .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
        }
        
        .stat-card .stat-label {
            font-size: 0.9rem;
            opacity: 0.8;
        }
        
        .bg-gradient-primary {
            background: linear-gradient(45deg, var(--primary-color), #6e8efb);
        }
        
        .bg-gradient-success {
            background: linear-gradient(45deg, var(--success-color), #63d471);
        }
        
        .bg-gradient-warning {
            background: linear-gradient(45deg, var(--warning-color), #ffce51);
        }
        
        .bg-gradient-info {
            background: linear-gradient(45deg, #0396ff, #abdcff);
        }
        
        .table th {
            border-top: none;
            font-weight: 600;
            color: #495057;
        }
        
        .nav-tabs .nav-item .nav-link {
            color: #495057;
            font-weight: 500;
        }
        
        .nav-tabs .nav-item .nav-link.active {
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .profile-image {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid white;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
        
        .document-card {
            transition: all 0.2s;
        }
        
        .document-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.1);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }
        
        .badge-primary {
            background-color: var(--primary-color);
        }
        
        .progress {
            height: 10px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-3 col-lg-2 px-0 sidebar">
                    <div class="d-flex flex-column align-items-center align-items-sm-start py-4 text-white min-vh-100">
                        <div class="text-center mb-4 px-3">
                            <h4 class="fw-bold">HR Management</h4>
                            <span class="badge bg-light text-primary">Employee Portal</span>
                        </div>
                        <ul class="nav nav-pills flex-column mb-sm-auto mb-0 align-items-center align-items-sm-start w-100" id="menu">
                            <li class="nav-item w-100">
                                <a href="#dashboard" class="nav-link active" data-bs-toggle="tab">
                                    <i class="fas fa-tachometer-alt"></i> Dashboard
                                </a>
                            </li>
                            <li class="nav-item w-100">
                                <a href="#profile" class="nav-link" data-bs-toggle="tab">
                                    <i class="fas fa-user"></i> My Profile
                                </a>
                            </li>
                            <li class="nav-item w-100">
                                <a href="#leave" class="nav-link" data-bs-toggle="tab">
                                    <i class="fas fa-calendar-alt"></i> Leave Management
                                </a>
                            </li>
                            <li class="nav-item w-100">
                                <a href="#attendance" class="nav-link" data-bs-toggle="tab">
                                    <i class="fas fa-clock"></i> Attendance
                                </a>
                            </li>
                            <li class="nav-item w-100">
                                <a href="#performance" class="nav-link" data-bs-toggle="tab">
                                    <i class="fas fa-chart-line"></i> Performance
                                </a>
                            </li>
                            <li class="nav-item w-100">
                                <a href="#documents" class="nav-link" data-bs-toggle="tab">
                                    <i class="fas fa-file-alt"></i> Documents
                                </a>
                            </li>
                            <li class="nav-item w-100">
                                <a href="#goals" class="nav-link" data-bs-toggle="tab">
                                    <i class="fas fa-bullseye"></i> Goals
                                </a>
                            </li>
                            <li class="nav-item w-100 mt-5">
                                <asp:LinkButton ID="btnLogout" runat="server" CssClass="nav-link text-danger" OnClick="btnLogout_Click">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </asp:LinkButton>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-md-9 col-lg-10 main-content">
                    <!-- Top Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="h4 mb-0">
                            Welcome, <asp:Literal ID="litEmployeeName" runat="server"></asp:Literal>!
                        </h2>
                        <div class="d-flex align-items-center">
                            <span class="me-3">
                                <i class="far fa-calendar-alt me-1"></i>
                                <asp:Literal ID="litCurrentDate" runat="server"></asp:Literal>
                            </span>
                            <div class="dropdown">
                                <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle" id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
                                    <img src="https://via.placeholder.com/40" alt="User" width="32" height="32" class="rounded-circle me-2" />
                                    <span class="d-none d-sm-inline fw-semibold"><asp:Literal ID="litUserDropdown" runat="server"></asp:Literal></span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end text-small shadow" aria-labelledby="dropdownUser1">
                                    <li><a class="dropdown-item" href="#profile" data-bs-toggle="tab">Profile</a></li>
                                    <li><hr class="dropdown-divider" /></li>
                                    <li><asp:LinkButton ID="btnLogoutDropdown" runat="server" CssClass="dropdown-item" OnClick="btnLogout_Click">Logout</asp:LinkButton></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <asp:Panel ID="pnlAlerts" runat="server" Visible="false">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </asp:Panel>
                    
                    <!-- Add this just before the tab-content div -->
                    <ul class="nav nav-tabs d-none" id="employeeTabNav" role="tablist">
                        <li class="nav-item"><a class="nav-link active" id="dashboard-tab" data-bs-toggle="tab" href="#dashboard" role="tab">Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" id="profile-tab" data-bs-toggle="tab" href="#profile" role="tab">My Profile</a></li>
                        <li class="nav-item"><a class="nav-link" id="leave-tab" data-bs-toggle="tab" href="#leave" role="tab">Leave Management</a></li>
                        <li class="nav-item"><a class="nav-link" id="attendance-tab" data-bs-toggle="tab" href="#attendance" role="tab">Attendance</a></li>
                        <li class="nav-item"><a class="nav-link" id="performance-tab" data-bs-toggle="tab" href="#performance" role="tab">Performance</a></li>
                        <li class="nav-item"><a class="nav-link" id="documents-tab" data-bs-toggle="tab" href="#documents" role="tab">Documents</a></li>
                        <li class="nav-item"><a class="nav-link" id="goals-tab" data-bs-toggle="tab" href="#goals" role="tab">Goals</a></li>
                    </ul>
                    
                    <!-- Tab Content -->
                    <div class="tab-content" id="dashboardTabContent">
                        <div class="tab-pane fade show active" id="dashboard" role="tabpanel">
                            <!-- Stats -->
                            <div class="row mb-4">
                                <div class="col-md-3">
                                    <div class="stat-card bg-gradient-primary">
                                        <i class="fas fa-briefcase"></i>
                                        <div class="stat-value"><asp:Literal ID="litJobTitle" runat="server"></asp:Literal></div>
                                        <div class="stat-label">Position</div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card bg-gradient-success">
                                        <i class="fas fa-calendar-check"></i>
                                        <div class="stat-value"><asp:Literal ID="litAttendanceRate" runat="server"></asp:Literal></div>
                                        <div class="stat-label">Attendance Rate</div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card bg-gradient-warning">
                                        <i class="fas fa-hourglass-half"></i>
                                        <div class="stat-value"><asp:Literal ID="litLeaveBalance" runat="server"></asp:Literal></div>
                                        <div class="stat-label">Leave Balance</div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card bg-gradient-info">
                                        <i class="fas fa-star"></i>
                                        <div class="stat-value"><asp:Literal ID="litPerformanceRating" runat="server"></asp:Literal></div>
                                        <div class="stat-label">Performance Rating</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Quick Actions -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <i class="fas fa-bolt me-2"></i> Quick Actions
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-3 mb-3">
                                            <a href="#leave" data-bs-toggle="tab" class="btn btn-outline-primary w-100 py-3">
                                                <i class="fas fa-calendar-plus mb-2 d-block fs-4"></i>
                                                Request Leave
                                            </a>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <a href="#attendance" data-bs-toggle="tab" class="btn btn-outline-success w-100 py-3">
                                                <i class="fas fa-clock mb-2 d-block fs-4"></i>
                                                View Attendance
                                            </a>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <a href="#documents" data-bs-toggle="tab" class="btn btn-outline-warning w-100 py-3">
                                                <i class="fas fa-upload mb-2 d-block fs-4"></i>
                                                Upload Document
                                            </a>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <a href="#profile" data-bs-toggle="tab" class="btn btn-outline-info w-100 py-3">
                                                <i class="fas fa-user-edit mb-2 d-block fs-4"></i>
                                                Update Profile
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Recent Activity -->
                            <div class="card">
                                <div class="card-header">
                                    <i class="fas fa-history me-2"></i> Recent Activity
                                </div>
                                <div class="card-body">
                                    <asp:Repeater ID="rptRecentActivity" runat="server">
                                        <HeaderTemplate>
                                            <div class="list-group">
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <div class="list-group-item list-group-item-action">
                                                <div class="d-flex w-100 justify-content-between">
                                                    <h6 class="mb-1"><%# Eval("ActivityTitle") %></h6>
                                                    <small><%# Eval("ActivityDate", "{0:MMM dd, yyyy}") %></small>
                                                </div>
                                                <p class="mb-1"><%# Eval("ActivityDescription") %></p>
                                                <small class="text-muted"><%# Eval("ActivityType") %></small>
                                            </div>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </div>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                    <asp:Panel ID="pnlNoActivity" runat="server" CssClass="text-center py-4" Visible="false">
                                        <i class="fas fa-info-circle text-muted mb-2 fs-3"></i>
                                        <p class="text-muted">No recent activity to display.</p>
                                    </asp:Panel>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="profile" role="tabpanel">
                            <uc:EmployeeProfile ID="EmployeeProfile" runat="server" />
                        </div>

                        <div class="tab-pane fade" id="attendance" role="tabpanel">
                            <uc:EmployeeAttendance ID="EmployeeAttendance" runat="server" />
                        </div>

                        <div class="tab-pane fade" id="leave" role="tabpanel">
                            <uc:EmployeeLeaveManagement ID="EmployeeLeaveManagement" runat="server" />
                        </div>

                        <div class="tab-pane fade" id="performance" role="tabpanel">
                            <uc:EmployeePerformance ID="EmployeePerformance" runat="server" />
                                </div>

                        <div class="tab-pane fade" id="documents" role="tabpanel">
                            <uc:EmployeeDocuments ID="EmployeeDocuments" runat="server" />
                        </div>

                        <div class="tab-pane fade" id="goals" role="tabpanel">
                            <uc:EmployeeGoals ID="EmployeeGoals" runat="server" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            // Initialize tooltips
            document.addEventListener('DOMContentLoaded', function () {
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl)
                });

                // Auto-hide alerts after 5 seconds
                setTimeout(function () {
                    $('.alert').alert('close');
                }, 5000);
            });

            $(document).ready(function () {
                // Enable tab switching for sidebar and quick actions
                $('a[data-bs-toggle="tab"]').on('click', function (e) {
                    e.preventDefault();
                    var target = $(this).attr('href');
                    $('.tab-pane').removeClass('show active');
                    $(target).addClass('show active');
                    // Remove active from all nav links, add to current
                    $('.nav-link').removeClass('active');
                    $(this).addClass('active');
                });
                // If a tab is targeted by URL hash, activate it
                var hash = window.location.hash;
                if (hash && $(hash).length) {
                    $('.tab-pane').removeClass('show active');
                    $(hash).addClass('show active');
                    $('.nav-link').removeClass('active');
                    $("a[href='" + hash + "']").addClass('active');
                }
            });
        </script>
    </form>
</body>
</html>

