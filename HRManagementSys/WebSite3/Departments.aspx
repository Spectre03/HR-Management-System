<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Departments.aspx.cs" Inherits="WebSite3.Departments" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Department Management - HR System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style type="text/css">
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #34495e;
            --accent-color: #3498db;
            --success-color: #27ae60;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --text-color: #2c3e50;
            --light-bg: #f8f9fa;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--light-bg);
        }
        
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #283e51 0%, #485563 50%, #36d1c4 100%);
            color: #fff;
            padding: 20px;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        
        .sidebar .nav-link {
            color: #fff;
            padding: 12px 18px;
            margin: 5px 0;
            border-radius: 8px;
            transition: all 0.3s;
            border: 1px solid transparent;
            display: flex;
            align-items: center;
            font-size: 1.08rem;
        }
        
        .sidebar .nav-link.active, .sidebar .nav-link:hover {
            background-color: #36d1c4;
            color: #fff;
            border-color: #36d1c4;
            box-shadow: 0 2px 10px rgba(54, 209, 196, 0.2);
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
        
        .logout-link {
            margin-top: auto;
            border-top: 1px solid #36d1c4;
            padding-top: 10px;
        }
        
        .main-content {
            padding: 30px;
        }
        
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 25px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }
        
        .department-card {
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
            box-shadow: 0 4px 24px 0 rgba(54,209,196,0.10), 0 0 16px 2px rgba(54,209,196,0.12);
            transition: box-shadow 0.3s, transform 0.3s;
        }
        
        .department-card::after {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            pointer-events: none;
            border-radius: 15px;
            box-shadow: 0 0 32px 8px rgba(54,209,196,0.10), 0 0 64px 16px rgba(54,209,196,0.08);
            opacity: 0.6;
            z-index: 0;
            animation: glowPulseDept 2.5s infinite alternate;
        }
        
        .department-card .card-body, .department-card h5, .department-card p {
            position: relative;
            z-index: 1;
        }
        
        .department-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-color), var(--success-color));
        }
        
        .department-stats {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(0, 0, 0, 0.1);
        }
        
        .stat-item {
            text-align: center;
            flex: 1;
        }
        
        .stat-item h3 {
            font-size: 1.8rem;
            margin: 0;
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .stat-item p {
            margin: 5px 0 0 0;
            color: #6c757d;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--accent-color), #2980b9);
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9, var(--accent-color));
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.4);
        }
        
        .btn-success {
            background: linear-gradient(135deg, var(--success-color), #229954);
            border: none;
            border-radius: 8px;
        }
        
        .btn-warning {
            background: linear-gradient(135deg, var(--warning-color), #e67e22);
            border: none;
            border-radius: 8px;
        }
        
        .btn-danger {
            background: linear-gradient(135deg, var(--danger-color), #c0392b);
            border: none;
            border-radius: 8px;
        }
        
        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }
        
        .modal-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 15px 15px 0 0;
            border-bottom: none;
        }
        
        .modal-body {
            padding: 30px;
        }
        
        .form-control, .form-select {
            border-radius: 8px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
        }
        
        .alert-success {
            background: linear-gradient(135deg, var(--success-color), #229954);
            color: white;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, var(--danger-color), #c0392b);
            color: white;
        }
        
        .search-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }
        
        .stats-overview {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .stats-overview h3 {
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 24px 0 rgba(54,209,196,0.15), 0 0 16px 2px rgba(54,209,196,0.18);
            position: relative;
            overflow: hidden;
            transition: box-shadow 0.3s, transform 0.3s;
        }
        
        .stat-card::after {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            pointer-events: none;
            border-radius: 10px;
            box-shadow: 0 0 32px 8px rgba(54,209,196,0.18), 0 0 64px 16px rgba(54,209,196,0.10);
            opacity: 0.7;
            z-index: 0;
            animation: glowPulseDept 2.5s infinite alternate;
        }
        
        @keyframes glowPulseDept {
            0% { box-shadow: 0 0 32px 8px rgba(54,209,196,0.18), 0 0 64px 16px rgba(54,209,196,0.10); }
            100% { box-shadow: 0 0 48px 16px rgba(54,209,196,0.28), 0 0 96px 32px rgba(54,209,196,0.18); }
        }
        
        .stat-card h4, .stat-card p {
            position: relative;
            z-index: 1;
        }
        
        .action-buttons .btn {
            margin: 2px;
            border-radius: 6px;
            font-size: 0.85rem;
            padding: 6px 12px;
        }
        
        .department-name {
            font-weight: 600;
            color: var(--primary-color);
            font-size: 1.1rem;
        }
        
        .department-description {
            color: #6c757d;
            font-size: 0.9rem;
            line-height: 1.5;
        }
        
        .vacancy-badge {
            background: linear-gradient(135deg, var(--warning-color), #e67e22);
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .budget-info {
            background: rgba(52, 152, 219, 0.1);
            border-radius: 8px;
            padding: 10px;
            margin-top: 10px;
            border-left: 4px solid var(--accent-color);
        }
        
        .budget-info small {
            color: var(--accent-color);
            font-weight: 500;
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
                    <div class="sidebar-logo text-center mb-4">
                        <img src="https://ui-avatars.com/api/?name=HR+M" alt="HRM Logo" style="width:48px;height:48px;border-radius:50%;margin-bottom:10px;" />
                        <div style="color:#fff;font-size:1.3rem;font-weight:600;">HR Manager</div>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item"><a class="nav-link" href="Default.aspx"><i class="fas fa-home"></i> Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link active" href="Departments.aspx"><i class="fas fa-building"></i> Departments</a></li>
                        <li class="nav-item"><a class="nav-link" href="Reports.aspx"><i class="fas fa-chart-bar"></i> Reports</a></li>
                        <li class="nav-item"><a class="nav-link" href="PerformanceEvaluation.aspx"><i class="fas fa-chart-line"></i> Performance</a></li>
                        <li class="nav-item"><a class="nav-link" href="Settings.aspx"><i class="fas fa-cog"></i> Settings</a></li>
                    </ul>
                    <div class="logout-link mt-auto pt-3 border-top">
                        <asp:LinkButton ID="btnLogout" runat="server" CssClass="nav-link text-danger" OnClick="btnLogout_Click"><i class="fas fa-sign-out-alt"></i> Logout</asp:LinkButton>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-md-10 main-content">
                    <!-- Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2 class="mb-1"><i class="fas fa-building me-2 text-primary"></i>Department Management</h2>
                            <p class="text-muted mb-0">Manage organizational departments and their resources</p>
                        </div>
                        <asp:LinkButton ID="btnAddDepartment" runat="server" CssClass="btn btn-primary" PostBackUrl="AddDepartment.aspx">
                            <i class="fas fa-plus me-2"></i>Add New Department
                        </asp:LinkButton>
                    </div>

                    <!-- Statistics Overview -->
                    <div class="stats-overview">
                        <h3><i class="fas fa-chart-pie me-2"></i>Department Overview</h3>
                        <div class="stats-grid">
                            <div class="stat-card">
                                <h4><asp:Label ID="lblTotalDepartments" runat="server" Text="0"></asp:Label></h4>
                                <p>Total Departments</p>
                            </div>
                            <div class="stat-card">
                                <h4><asp:Label ID="lblTotalEmployees" runat="server" Text="0"></asp:Label></h4>
                                <p>Total Employees</p>
                            </div>
                            <div class="stat-card">
                                <h4><asp:Label ID="lblActiveDepartments" runat="server" Text="0"></asp:Label></h4>
                                <p>Active Departments</p>
                            </div>
                            <div class="stat-card">
                                <h4><asp:Label ID="lblTotalVacancies" runat="server" Text="0"></asp:Label></h4>
                                <p>Total Vacancies</p>
                            </div>
                        </div>
                    </div>

                    <!-- Search and Filter Section -->
                    <asp:UpdatePanel ID="upDepartments" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="search-section">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="form-label"><i class="fas fa-search me-1"></i>Search</label>
                                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search departments..." />
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label"><i class="fas fa-filter me-1"></i>Department</label>
                                        <asp:DropDownList ID="ddlFilterDepartment" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="All Departments" Value="" />
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label"><i class="fas fa-sort me-1"></i>Status</label>
                                        <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="All Statuses" Value="" />
                                            <asp:ListItem Text="Active" Value="Active" />
                                            <asp:ListItem Text="Inactive" Value="Inactive" />
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">&nbsp;</label>
                                        <div class="d-grid">
                                            <asp:Button ID="btnFilter" runat="server" Text="Search" 
                                                CssClass="btn btn-primary" OnClick="btnFilter_Click" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Department Cards -->
                            <div class="row">
                                <asp:Repeater ID="rptDepartments" runat="server" OnItemCommand="rptDepartments_ItemCommand">
                                    <ItemTemplate>
                                        <div class="col-md-6 col-lg-4 mb-4">
                                            <div class="card department-card">
                                                <div class="card-body">
                                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                                        <h5 class="card-title department-name mb-0"><%# DataBinder.Eval(Container.DataItem, "DepartmentName") %></h5>
                                                        <span class="vacancy-badge"><%# DataBinder.Eval(Container.DataItem, "VacancyCount") %> Vacancies</span>
                                                    </div>
                                                    <p class="card-text department-description"><%# DataBinder.Eval(Container.DataItem, "Description") %></p>
                                                    
                                                    <div class="mb-3">
                                                        <small class="text-muted"><i class="fas fa-map-marker-alt me-1"></i><%# DataBinder.Eval(Container.DataItem, "Location") %></small>
                                                    </div>
                                                    
                                                    <div class="mb-3">
                                                        <small class="text-muted"><i class="fas fa-user-tie me-1"></i>Head: <%# DataBinder.Eval(Container.DataItem, "HeadOfDepartment") %></small>
                                                    </div>
                                                    
                                                    <div class="budget-info" runat="server" visible='<%# !string.IsNullOrEmpty(DataBinder.Eval(Container.DataItem, "Budget").ToString()) %>'>
                                                        <small><i class="fas fa-dollar-sign me-1"></i>Budget: $<%# string.Format("{0:N2}", DataBinder.Eval(Container.DataItem, "Budget")) %></small>
                                                    </div>
                                                    
                                                    <div class="department-stats">
                                                        <div class="stat-item">
                                                            <h3><%# DataBinder.Eval(Container.DataItem, "EmployeeCount") %></h3>
                                                            <p>Employees</p>
                                                        </div>
                                                        <div class="stat-item">
                                                            <h3><%# DataBinder.Eval(Container.DataItem, "ActiveCount") %></h3>
                                                            <p>Active</p>
                                                        </div>
                                                        <div class="stat-item">
                                                            <h3><%# DataBinder.Eval(Container.DataItem, "VacancyCount") %></h3>
                                                            <p>Vacancies</p>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="mt-3">
                                                        <small class="text-muted">
                                                            <i class="fas fa-chart-line me-1"></i>
                                                            Utilization: <%# GetEmployeeUtilizationPercentage(DataBinder.Eval(Container.DataItem, "EmployeeCount"), DataBinder.Eval(Container.DataItem, "VacancyCount")) %>%
                                                        </small>
                                                    </div>
                                                    
                                                    <div class="action-buttons mt-3">
                                                        <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-primary" 
                                                            CommandName="EditDepartment" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "DepartmentId") %>' UseSubmitBehavior="false">
                                                            <i class="fas fa-edit"></i> Edit
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="btnViewEmployees" runat="server" CssClass="btn btn-info"
                                                            CommandName="ViewEmployees" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "DepartmentId") %>' UseSubmitBehavior="false">
                                                            <i class="fas fa-users"></i> Employees
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="btnManageEmployees" runat="server" CssClass="btn btn-warning"
                                                            CommandName="ManageEmployees" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "DepartmentId") %>' UseSubmitBehavior="false">
                                                            <i class="fas fa-user-cog"></i> Manage
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-danger"
                                                            CommandName="DeleteDepartment" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "DepartmentId") %>'
                                                            OnClientClick="return confirm('Are you sure you want to delete this department? This action cannot be undone.');" UseSubmitBehavior="false">
                                                            <i class="fas fa-trash"></i>
                                                        </asp:LinkButton>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>

                            <!-- Add/Edit Department Modal -->
                            <div class="modal fade" id="addDepartmentModal" tabindex="-1" aria-labelledby="addDepartmentModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="addDepartmentModalLabel">
                                                <i class="fas fa-building me-2"></i><span id="modalTitle">Add New Department</span>
                                            </h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <asp:HiddenField ID="hdnDepartmentId" runat="server" />
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Department Name <span class="text-danger">*</span></label>
                                                        <asp:TextBox ID="txtDepartmentName" runat="server" CssClass="form-control" required></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Location</label>
                                                        <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control" placeholder="e.g., Floor 3, Building A"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Description</label>
                                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" 
                                                    TextMode="MultiLine" Rows="3" placeholder="Describe the department's role and responsibilities..."></asp:TextBox>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Head of Department</label>
                                                        <asp:TextBox ID="txtHeadOfDepartment" runat="server" CssClass="form-control" placeholder="Department Manager Name"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Vacancy Count</label>
                                                        <asp:TextBox ID="txtVacancyCount" runat="server" CssClass="form-control" 
                                                            TextMode="Number" min="0" placeholder="0"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Annual Budget</label>
                                                        <div class="input-group">
                                                            <span class="input-group-text">$</span>
                                                            <asp:TextBox ID="txtBudget" runat="server" CssClass="form-control" 
                                                                TextMode="Number" step="0.01" placeholder="0.00"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Budget Status</label>
                                                        <div class="form-control-plaintext">
                                                            <span id="budgetStatus" class="badge bg-info">Not Set</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                            <asp:Button ID="btnSave" runat="server" Text="Save Department" CssClass="btn btn-primary" 
                                                OnClick="btnSave_Click" />
                                            <asp:Button ID="btnUpdate" runat="server" Text="Update Department" CssClass="btn btn-success" 
                                                OnClick="btnUpdate_Click" Visible="false" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnFilter" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>

        <!-- View Employees Modal -->
        <div class="modal fade" id="viewEmployeesModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-users me-2"></i>Department Employees</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:GridView ID="gvDepartmentEmployees" runat="server" CssClass="table table-hover table-striped" 
                            AutoGenerateColumns="False" EmptyDataText="No employees found in this department.">
                            <Columns>
                                <asp:BoundField DataField="EmployeeId" HeaderText="ID" />
                                <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                                <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                                <asp:BoundField DataField="Email" HeaderText="Email" />
                                <asp:BoundField DataField="JobTitle" HeaderText="Position" />
                                <asp:BoundField DataField="HireDate" HeaderText="Hire Date" 
                                    DataFormatString="{0:MM/dd/yyyy}" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge <%# (DataBinder.Eval(Container.DataItem, "Status").ToString() == "Active" ? "bg-success" : "bg-danger") %>'>
                                            <%# DataBinder.Eval(Container.DataItem, "Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Manage Employees Modal -->
        <div class="modal fade" id="manageEmployeesModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-user-cog me-2"></i>Manage Department Employees</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:HiddenField ID="hdnManageDepartmentId" runat="server" />
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h6><i class="fas fa-users me-2"></i>Current Employees</h6>
                                <asp:GridView ID="gvManageEmployees" runat="server" CssClass="table table-sm table-hover" 
                                    AutoGenerateColumns="False" EmptyDataText="No employees in this department."
                                    OnRowCommand="gvManageEmployees_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="EmployeeId" HeaderText="ID" />
                                        <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                                        <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                                        <asp:BoundField DataField="JobTitle" HeaderText="Position" />
                                        <asp:TemplateField HeaderText="Actions">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnReassign" runat="server" CssClass="btn btn-sm btn-warning"
                                                    CommandName="ReassignEmployee" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "EmployeeId") %>'>
                                                    <i class="fas fa-exchange-alt"></i> Reassign
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn btn-sm btn-danger"
                                                    CommandName="RemoveEmployee" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "EmployeeId") %>'
                                                    OnClientClick="return confirm('Are you sure you want to remove this employee from the department?');">
                                                    <i class="fas fa-user-minus"></i>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-plus me-2"></i>Add Employee to Department</h6>
                                <div class="mb-3">
                                    <label class="form-label">Select Employee</label>
                                    <asp:DropDownList ID="ddlAvailableEmployees" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="-- Select Employee --" Value="" />
                                    </asp:DropDownList>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Job Title</label>
                                    <asp:TextBox ID="txtJobTitle" runat="server" CssClass="form-control" placeholder="Enter job title"></asp:TextBox>
                                </div>
                                <asp:Button ID="btnAddEmployeeToDept" runat="server" Text="Add Employee" 
                                    CssClass="btn btn-success" OnClick="btnAddEmployeeToDept_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Reassign Employee Modal -->
        <div class="modal fade" id="reassignEmployeeModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-exchange-alt me-2"></i>Reassign Employee</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:HiddenField ID="hdnReassignEmployeeId" runat="server" />
                        <div class="mb-3">
                            <label class="form-label">Employee</label>
                            <asp:Label ID="lblReassignEmployeeName" runat="server" CssClass="form-control-plaintext"></asp:Label>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">New Department <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlReassignDepartment" runat="server" CssClass="form-select">
                                <asp:ListItem Text="-- Select Department --" Value="" />
                            </asp:DropDownList>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">New Job Title</label>
                            <asp:TextBox ID="txtReassignJobTitle" runat="server" CssClass="form-control" placeholder="Enter new job title"></asp:TextBox>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnConfirmReassign" runat="server" Text="Confirm Reassignment" 
                            CssClass="btn btn-primary" OnClick="btnConfirmReassign_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Alert Modal -->
        <div class="modal fade" id="alertModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-bell me-2"></i>Notification</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:Label ID="lblMessage" runat="server"></asp:Label>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">OK</button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showAlert(message, isSuccess) {
            var alertModal = new bootstrap.Modal(document.getElementById('alertModal'));
            var messageLabel = document.getElementById('<%= lblMessage.ClientID %>');
            messageLabel.textContent = message;
            messageLabel.className = isSuccess ? 'alert alert-success' : 'alert alert-danger';
            alertModal.show();
        }
        
        function updateModalTitle(isEdit) {
            var titleElement = document.getElementById('modalTitle');
            titleElement.textContent = isEdit ? 'Edit Department' : 'Add New Department';
        }
    </script>
</body>
</html>