<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Employee Management System</title>
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
        
        .sidebar .logout-link {
            margin-top: auto;
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 10px;
        }
        
        .sidebar .logout-link .nav-link {
            color: var(--danger-color);
        }
        
        .sidebar .logout-link .nav-link:hover {
            background-color: rgba(239,35,60,0.1);
        }
        
        .main-content {
            padding: 30px;
        }
        
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .card-header {
            background-color: white;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            font-weight: 600;
        }
        
        .stats-card {
            border-left: 4px solid var(--primary-color);
            box-shadow: 0 4px 24px 0 rgba(67,97,238,0.15), 0 0 16px 2px rgba(67,97,238,0.18);
            position: relative;
            overflow: hidden;
            background: #fff;
            transition: box-shadow 0.3s, transform 0.3s;
        }
        .stats-card::after {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            pointer-events: none;
            border-radius: 10px;
            box-shadow: 0 0 32px 8px rgba(67,97,238,0.18), 0 0 64px 16px rgba(67,97,238,0.10);
            opacity: 0.7;
            z-index: 0;
            animation: glowPulse 2.5s infinite alternate;
        }
        @keyframes glowPulse {
            0% { box-shadow: 0 0 32px 8px rgba(67,97,238,0.18), 0 0 64px 16px rgba(67,97,238,0.10); }
            100% { box-shadow: 0 0 48px 16px rgba(67,97,238,0.28), 0 0 96px 32px rgba(67,97,238,0.18); }
        }
        .stats-card .card-body, .stats-card h2, .stats-card p {
            position: relative;
            z-index: 1;
        }
        
        .stats-card h2 {
            font-size: 1.8rem;
            font-weight: 700;
            margin: 0;
        }
        
        .stats-card p {
            color: #6c757d;
            margin: 0;
        }
        
        .table th {
            border-top: none;
            font-weight: 600;
            color: #495057;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }
        
        .action-buttons .btn {
            padding: 4px 8px;
            font-size: 0.8rem;
        }

        #chatbotWidget {
            position: fixed;
            bottom: 16px;
            right: 32px;
            z-index: 1050;
        }
        #chatbotWindow {
            display: none;
            position: fixed;
            bottom: 40px;
            right: 32px;
            width: 400px;
            max-width: 95vw;
            background: linear-gradient(135deg,#f5f7fb 60%,#e0e7ff 100%);
            border-radius: 18px;
            box-shadow: 0 8px 32px #4361ee33;
            border: 1.5px solid #4361ee33;
            overflow: hidden;
            z-index: 1060;
            flex-direction: column;
        }
        #chatbotHeader {
            background: linear-gradient(90deg, #4361ee, #36d1c4);
            color: #fff;
            padding: 12px 16px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-top-left-radius: 18px;
            border-top-right-radius: 18px;
        }
        #chatbotHeader .btn {
            color: #fff;
            font-size: 1.1rem;
            background: none;
            border: none;
            outline: none;
            box-shadow: none;
        }
        #chatbotHistory {
            min-height: 220px;
            max-height: 420px;
            overflow-y: auto;
            padding: 18px 12px;
            background: transparent;
        }
        #chatbotInputArea {
            padding: 12px 10px 10px 10px;
            border-top: 1px solid #e0e7ff;
            background: #fff;
        }
        #chatbotInputArea .input-group {
            width: 100%;
        }
        #chatbotWidget .btn {
            width: 64px;
            height: 64px;
            font-size: 2rem;
            box-shadow: 0 4px 24px #4361ee55;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2 sidebar">
                    <div class="sidebar-logo text-center mb-4">
                        <img src="https://ui-avatars.com/api/?name=HR+M" alt="HRM Logo" style="width:48px;height:48px;border-radius:50%;margin-bottom:10px;" />
                        <div style="color:#fff;font-size:1.3rem;font-weight:600;">HR Manager</div>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item"><a class="nav-link active" href="Default.aspx"><i class="fas fa-home"></i> Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="Departments.aspx"><i class="fas fa-building"></i> Departments</a></li>
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
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Dashboard</h2>
                        <a href="AddEmployee.aspx" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Add New Employee
                        </a>
                    </div>

                    <!-- Stats Cards -->
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <div class="card stats-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <p class="mb-1">Total Employees</p>
                                            <h2><asp:Label ID="lblTotalEmployees" runat="server" Text="0"></asp:Label></h2>
                                        </div>
                                        <div class="bg-primary bg-opacity-10 p-3 rounded-circle">
                                            <i class="fas fa-users text-primary" style="font-size: 1.5rem;"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card stats-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <p class="mb-1">Active Today</p>
                                            <h2><asp:Label ID="lblActiveToday" runat="server" Text="0"></asp:Label></h2>
                                        </div>
                                        <div class="bg-success bg-opacity-10 p-3 rounded-circle">
                                            <i class="fas fa-user-check text-success" style="font-size: 1.5rem;"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card stats-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <p class="mb-1">New This Month</p>
                                            <h2><asp:Label ID="lblNewThisMonth" runat="server" Text="0"></asp:Label></h2>
                                        </div>
                                        <div class="bg-warning bg-opacity-10 p-3 rounded-circle">
                                            <i class="fas fa-user-plus text-warning" style="font-size: 1.5rem;"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--search/filter-->
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by name..." />
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlFilterDepartment" runat="server" CssClass="form-select">
                                <asp:ListItem Text="All Departments" Value="" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-select">
                                <asp:ListItem Text="All Statuses" Value="" />
                                <asp:ListItem Text="Active" Value="Active" />
                                <asp:ListItem Text="On Leave" Value="On Leave" />
                                <asp:ListItem Text="Inactive" Value="Inactive" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn btn-primary w-100" OnClick="btnFilter_Click" />
                        </div>
                    </div>
                    <!-- Employees Table -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Employee List</h5>
                            <div class="input-group" style="width: 300px;">
                                <input type="text" class="form-control" placeholder="Search employees..." />
                                <button class="btn btn-outline-secondary" type="button"><i class="fas fa-search"></i></button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" 
                                    CssClass="table table-hover" GridLines="None" OnRowCommand="gvEmployees_RowCommand"
                                    DataKeyNames="EmployeeId" OnRowDeleting="gvEmployees_RowDeleting">
                                    <Columns>
                                        <asp:BoundField DataField="EmployeeId" HeaderText="ID" />
                                        <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                                        <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                                        <asp:BoundField DataField="Email" HeaderText="Email" />
                                        <asp:BoundField DataField="Phone" HeaderText="Phone" />
                                        <asp:BoundField DataField="Department" HeaderText="Department" />
                                        <asp:BoundField DataField="JobTitle" HeaderText="Job Title" />
                                        <asp:BoundField DataField="HireDate" HeaderText="Hire Date" DataFormatString="{0:MM/dd/yyyy}" />
                                        <asp:BoundField DataField="Status" HeaderText="Status" />
                                        <asp:TemplateField HeaderText="Actions">
                                            <ItemTemplate>
                                                <div class="action-buttons">
                                                    <a href='EditEmployee.aspx?id=<%# Eval("EmployeeId") %>' class='btn btn-sm btn-primary me-2'>
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-sm btn-danger"
                                                        CommandName="Delete" CommandArgument='<%# Eval("EmployeeId") %>'
                                                        OnClientClick="return confirm('Are you sure you want to delete this employee?');">
                                                        <i class="fas fa-trash"></i>
                                                    </asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <div class="text-center py-4">
                                            <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                            <p class="mb-0">No employees found. Add your first employee to get started.</p>
                                        </div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alert Modal -->
        <div class="modal fade" id="alertModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Notification</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:Label ID="lblAlertMessage" runat="server" />
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">OK</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Message Alert -->
        <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
            <div id="toast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header">
                    <strong class="me-auto" id="toastTitle"></strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body" id="toastMessage"></div>
            </div>
        </div>

        <!-- Floating Chatbot Widget (Floating Window) -->
        <div id="chatbotWidget">
            <button class="btn btn-primary rounded-circle shadow-lg" id="openChatbotBtn">
                <i class="fas fa-robot"></i>
            </button>
        </div>
        <div id="chatbotWindow">
            <div id="chatbotHeader">
                <span><i class="fas fa-robot me-2"></i>AI Assistant</span>
                <div>
                    <button class="btn" id="minimizeChatbotBtn" title="Minimize"><i class="fas fa-minus"></i></button>
                    <button class="btn" id="closeChatbotBtn" title="Close"><i class="fas fa-times"></i></button>
                </div>
            </div>
            <div id="chatbotHistory"></div>
            <div id="chatbotInputArea">
                <div class="input-group">
                    <input type="text" id="chatbotInput" class="form-control" placeholder="Ask me anything..." autocomplete="off" />
                    <button class="btn btn-primary" id="sendChatbotBtn"><i class="fas fa-paper-plane"></i></button>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script type="text/javascript">
            function showToast(title, message, isSuccess) {
                var toast = document.getElementById('toast');
                var toastTitle = document.getElementById('toastTitle');
                var toastMessage = document.getElementById('toastMessage');
                
                toastTitle.textContent = title;
                toastMessage.textContent = message;
                
                if (isSuccess) {
                    toast.classList.add('bg-success', 'text-white');
                } else {
                    toast.classList.add('bg-danger', 'text-white');
                }
                
                var bsToast = new bootstrap.Toast(toast);
                bsToast.show();
            }

            // Only keep dashboard-related JS
            document.addEventListener('DOMContentLoaded', function() {
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            });
        </script>
        <script>
        $(function(){
            var $widget = $('#chatbotWidget');
            var $window = $('#chatbotWindow');
            var $history = $('#chatbotHistory');
            var $input = $('#chatbotInput');
            var $sendBtn = $('#sendChatbotBtn');
            var minimized = false;
            function appendMessage(sender, text) {
                var align = sender === 'You' ? 'end' : 'start';
                var bg = sender === 'You' ? 'bg-primary text-white' : 'bg-light';
                $history.append('<div class="d-flex justify-content-'+align+' mb-2"><div class="p-2 rounded '+bg+'" style="max-width:80%;min-width:60px;word-break:break-word;">'+text+'</div></div>');
                $history.scrollTop($history[0].scrollHeight);
            }
            $sendBtn.on('click', function(e){ e.preventDefault(); sendMessage(); });
            $input.on('keypress', function(e){ if(e.which===13){ e.preventDefault(); sendMessage(); }});
            function sendMessage(){
                var msg = $input.val().trim();
                if(!msg) return;
                appendMessage('You', msg);
                $input.val('');
                appendMessage('Bot', '<span class="text-muted"><i class="fas fa-spinner fa-spin"></i> Thinking...</span>');
                $.ajax({
                    url: 'ChatBotApi.aspx',
                    method: 'POST',
                    data: { message: msg },
                    success: function(resp){
                        $history.find('.text-muted').parent().parent().remove();
                        appendMessage('Bot', resp);
                    },
                    error: function(xhr){
                        $history.find('.text-muted').parent().parent().remove();
                        var err = xhr.responseText || 'Sorry, there was an error.';
                        appendMessage('Bot', '<span class="text-danger">'+err+'</span>');
                        showToast('Chatbot Error', err, false);
                    }
                });
            }
            $('#openChatbotBtn').on('click', function(e){
                e.preventDefault();
                $window.show();
                $input.focus();
                $widget.hide();
            });
            $('#closeChatbotBtn').on('click', function(){
                $window.hide();
                $widget.show();
            });
            $('#minimizeChatbotBtn').on('click', function(){
                if(!minimized){
                    $history.hide();
                    $('#chatbotInputArea').hide();
                    minimized = true;
                    $(this).find('i').removeClass('fa-minus').addClass('fa-window-maximize');
                } else {
                    $history.show();
                    $('#chatbotInputArea').show();
                    minimized = false;
                    $(this).find('i').removeClass('fa-window-maximize').addClass('fa-minus');
                    $input.focus();
                }
            });
        });
        </script>
    </form>
</body>
</html>