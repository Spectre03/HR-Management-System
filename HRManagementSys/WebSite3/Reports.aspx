<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Reports.aspx.cs" Inherits="WebSite3.Reports" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HR Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style type="text/css">
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #232526 0%, #414345 50%, #36d1c4 100%);
            color: #fff;
            padding-top: 20px;
            position: sticky;
            top: 0;
            box-shadow: 2px 0 8px rgba(0,0,0,0.05);
        }
        .sidebar .nav-section {
            margin-top: 30px;
        }
        .sidebar .nav-link {
            color: #fff;
            text-decoration: none;
            padding: 12px 18px;
            display: flex;
            align-items: center;
            border-radius: 6px;
            font-size: 1.08rem;
            margin-bottom: 6px;
            transition: background 0.2s;
        }
        .sidebar .nav-link.active, .sidebar .nav-link:hover {
            background-color: #36d1c4;
            color: #fff;
        }
        .sidebar .nav-link i {
            margin-right: 12px;
            font-size: 1.2rem;
        }
        .sidebar .sidebar-logo {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 30px;
        }
        .sidebar .sidebar-logo img {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            margin-right: 10px;
        }
        .sidebar .sidebar-logo span {
            color: #fff;
            font-size: 1.3rem;
            font-weight: 600;
            letter-spacing: 1px;
        }
        .sidebar .nav-divider {
            border-top: 1px solid #36d1c4;
            margin: 18px 0 10px 0;
        }
        .sidebar .nav-section-label {
            color: #adb5bd;
            font-size: 0.95rem;
            margin-left: 10px;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .main-content {
            padding: 20px;
        }
        .metric-card {
            background-color: #f8f9fa;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .metric-value {
            font-size: 24px;
            font-weight: bold;
            color: #0d6efd;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2 sidebar">
                    <div class="sidebar-logo">
                        <img src="https://ui-avatars.com/api/?name=HR+M" alt="HRM Logo" />
                        <span>HR Manager</span>
                    </div>
                    <div class="nav-section">
                        <asp:HyperLink ID="lnkDashboard" runat="server" CssClass="nav-link" NavigateUrl="~/Default.aspx"><i class="bi bi-house-door"></i> Dashboard</asp:HyperLink>
                        <asp:HyperLink ID="lnkEmployees" runat="server" CssClass="nav-link" NavigateUrl="~/Employees.aspx"><i class="bi bi-people"></i> Employees</asp:HyperLink>
                        <asp:HyperLink ID="lnkDepartments" runat="server" CssClass="nav-link" NavigateUrl="~/Departments.aspx"><i class="bi bi-diagram-3"></i> Departments</asp:HyperLink>
                        <asp:HyperLink ID="lnkReports" runat="server" CssClass="nav-link active" NavigateUrl="~/Reports.aspx"><i class="bi bi-bar-chart"></i> Reports</asp:HyperLink>
                        <asp:HyperLink ID="lnkPerformance" runat="server" CssClass="nav-link" NavigateUrl="~/PerformanceEvaluation.aspx"><i class="bi bi-graph-up"></i> Performance</asp:HyperLink>
                        <asp:HyperLink ID="lnkSettings" runat="server" CssClass="nav-link" NavigateUrl="~/Settings.aspx"><i class="bi bi-gear"></i> Settings</asp:HyperLink>
                    </div>
                    <div class="nav-divider"></div>
                    <div class="nav-section-label">Account</div>
                    <asp:LinkButton ID="lnkLogout" runat="server" CssClass="nav-link" OnClick="btnLogout_Click"><i class="bi bi-box-arrow-right"></i> Logout</asp:LinkButton>
                </div>

                <!-- Main Content -->
                <div class="col-md-10 main-content">
                    <h2 class="mb-2">HR Analytics Dashboard</h2>
                    <p class="text-muted mb-4">View, filter, and export key HR data including employees, departments, and performance. Use the filters below to customize your report.</p>

                    <!-- Metrics Section -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="metric-card">
                                <h5>Total Employees</h5>
                                <div class="metric-value">
                                    <asp:Label ID="lblTotalEmployees" runat="server" Text="0"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="metric-card">
                                <h5>Total Departments</h5>
                                <div class="metric-value">
                                    <asp:Label ID="lblAttendanceRate" runat="server" Text="0"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="metric-card">
                                <h5>Active Employees</h5>
                                <div class="metric-value">
                                    <asp:Label ID="lblLeaveRequests" runat="server" Text="0"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="metric-card">
                                <h5>Inactive Employees</h5>
                                <div class="metric-value">
                                    <asp:Label ID="lblAvgPerformance" runat="server" Text="0"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Filters Section -->
                    <div class="card mb-4 shadow-sm border-0">
                        <div class="card-body">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-3">
                                    <label class="form-label">Report Type</label>
                                    <asp:DropDownList ID="ddlReportType" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlReportType_SelectedIndexChanged">
                                        <asp:ListItem Text="Department Overview" Value="attendance" />
                                        <asp:ListItem Text="Employee List" Value="leave" />
                                        <asp:ListItem Text="Department Performance" Value="performance" />
                                        <asp:ListItem Text="Department Details" Value="department" />
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Department</label>
                                    <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged">
                                        <asp:ListItem Text="All Departments" Value="" />
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Date Range</label>
                                    <asp:DropDownList ID="ddlDateRange" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlDateRange_SelectedIndexChanged">
                                        <asp:ListItem Text="Last 7 Days" Value="7" />
                                        <asp:ListItem Text="Last 30 Days" Value="30" />
                                        <asp:ListItem Text="Last 90 Days" Value="90" />
                                        <asp:ListItem Text="Last Year" Value="365" />
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">View Type</label>
                                    <asp:DropDownList ID="ddlViewType" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlViewType_SelectedIndexChanged" style="display:none;">
                                        <asp:ListItem Text="Table" Value="table" />
                                        <asp:ListItem Text="Chart" Value="chart" />
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Export Buttons -->
                    <div class="mb-4 d-flex align-items-center">
                        <asp:LinkButton ID="btnExportPDF" runat="server" CssClass="btn btn-outline-primary me-2" OnClick="btnExportPDF_Click" ToolTip="Export report as PDF (HTML)">
                            <i class="bi bi-file-earmark-pdf"></i> Export to PDF
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnExportExcel" runat="server" CssClass="btn btn-outline-success me-2" OnClick="btnExportExcel_Click" ToolTip="Export report as CSV">
                            <i class="bi bi-file-earmark-excel"></i> Export to Excel
                        </asp:LinkButton>
                        <span id="spinner" style="display:none;"><span class="spinner-border spinner-border-sm text-primary"></span> Loading...</span>
                    </div>

                    <!-- Report Data -->
                    <div class="card shadow-sm border-0">
                        <div class="card-body">
                            <asp:GridView ID="gvReportData" runat="server" CssClass="table table-striped table-hover table-responsive" AutoGenerateColumns="true" ShowFooter="true" EmptyDataText="<div class='alert alert-warning text-center mb-0'>No data found for the selected filters.</div>">
                            </asp:GridView>
                            <div id="chartContainer" style="display:none; margin-top:30px;">
                                <canvas id="reportChart" height="120"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script>
        // Show spinner on report reload
        document.addEventListener('DOMContentLoaded', function() {
            var form = document.getElementById('form1');
            if (form) {
                form.addEventListener('submit', function() {
                    document.getElementById('spinner').style.display = '';
                });
            }
        });

        // Chart view toggle logic
        function toggleChartView(showChart) {
            var chartContainer = document.getElementById('chartContainer');
            var grid = document.getElementById('<%= gvReportData.ClientID %>');
            if (showChart) {
                chartContainer.style.display = '';
                grid.style.display = 'none';
                renderReportChart();
            } else {
                chartContainer.style.display = 'none';
                grid.style.display = '';
            }
        }

        // Render a bar chart for Employee List report
        function renderReportChart() {
            var chartCanvas = document.getElementById('reportChart');
            if (!chartCanvas) return;
            // Get data from the table
            var grid = document.getElementById('<%= gvReportData.ClientID %>');
            var rows = grid.querySelectorAll('tbody tr');
            var deptCounts = {};
            rows.forEach(function(row) {
                var dept = row.cells[0]?.innerText || 'Unassigned';
                deptCounts[dept] = (deptCounts[dept] || 0) + 1;
            });
            var labels = Object.keys(deptCounts);
            var data = Object.values(deptCounts);
            // Destroy previous chart if exists
            if (window.reportChartInstance) window.reportChartInstance.destroy();
            window.reportChartInstance = new Chart(chartCanvas, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Employee Count',
                        data: data,
                        backgroundColor: '#0d6efd',
                    }]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { display: false } },
                    scales: { y: { beginAtZero: true, precision:0 } }
                }
            });
        }

        // Listen for view type change
        document.addEventListener('DOMContentLoaded', function() {
            var ddlViewType = document.getElementById('<%= ddlViewType.ClientID %>');
            if (ddlViewType) {
                ddlViewType.addEventListener('change', function() {
                    toggleChartView(ddlViewType.value === 'chart');
                });
                // On page load, set correct view
                toggleChartView(ddlViewType.value === 'chart');
            }
        });
    </script>
</body>
</html>