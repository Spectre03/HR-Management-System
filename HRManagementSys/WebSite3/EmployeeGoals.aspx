<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmployeeGoals.aspx.cs" Inherits="EmployeeGoals" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Employee Goals Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style>
        .goal-card {
            transition: transform 0.2s;
        }
        .goal-card:hover {
            transform: translateY(-2px);
        }
        .progress {
            height: 20px;
        }
        .priority-high { border-left: 4px solid #dc3545; }
        .priority-medium { border-left: 4px solid #ffc107; }
        .priority-low { border-left: 4px solid #28a745; }
        .priority-critical { border-left: 4px solid #6f42c1; }
    </style>
</head>
<body style="background-color: #f5f7fb;">
    <form id="form1" runat="server" class="container-fluid">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        
        <!-- Header -->
        <div class="row bg-success text-white p-3 mb-4">
            <div class="col">
                <h2><i class="fas fa-bullseye me-2"></i>Employee Goals Management</h2>
                <p class="mb-0">Set, track, and manage employee goals and objectives</p>
            </div>
            <div class="col-auto">
                <a href="PerformanceEvaluation.aspx" class="btn btn-light"><i class="fas fa-arrow-left me-1"></i>Back to Performance</a>
            </div>
        </div>

        <!-- Message Panel -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-info alert-dismissible fade show" role="alert">
            <asp:Literal ID="litMessage" runat="server" />
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </asp:Panel>

        <div class="row">
            <!-- Employee Info -->
            <div class="col-md-3">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-user me-2"></i>Employee Information</h5>
                    </div>
                    <div class="card-body">
                        <asp:Panel ID="pnlEmployeeInfo" runat="server" Visible="false">
                            <div class="text-center mb-3">
                                <i class="fas fa-user-circle fa-3x text-primary"></i>
                            </div>
                            <h6 class="text-primary text-center"><asp:Literal ID="litEmployeeName" runat="server" /></h6>
                            <p class="mb-1"><strong>Department:</strong> <asp:Literal ID="litDepartment" runat="server" /></p>
                            <p class="mb-1"><strong>Position:</strong> <asp:Literal ID="litPosition" runat="server" /></p>
                            <p class="mb-0"><strong>Hire Date:</strong> <asp:Literal ID="litHireDate" runat="server" /></p>
                        </asp:Panel>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-tasks me-2"></i>Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <asp:Button ID="btnAddGoal" runat="server" Text="Add New Goal" CssClass="btn btn-success w-100 mb-2" OnClick="btnAddGoal_Click" />
                        <asp:Button ID="btnViewPerformance" runat="server" Text="View Performance" CssClass="btn btn-info w-100 mb-2" OnClick="btnViewPerformance_Click" />
                        <asp:Button ID="btnExportGoals" runat="server" Text="Export Goals" CssClass="btn btn-warning w-100" OnClick="btnExportGoals_Click" />
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-9">
                <!-- Add/Edit Goal Form -->
                <asp:Panel ID="pnlGoalForm" runat="server" Visible="false">
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0"><i class="fas fa-plus me-2"></i>Add New Goal</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Goal Title <span class="text-danger">*</span></label>
                                        <asp:TextBox ID="txtGoalTitle" runat="server" CssClass="form-control" placeholder="Enter goal title..." />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Goal Category <span class="text-danger">*</span></label>
                                        <asp:DropDownList ID="ddlGoalCategory" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="Performance" Value="Performance" />
                                            <asp:ListItem Text="Skills Development" Value="Skills Development" />
                                            <asp:ListItem Text="Project Completion" Value="Project Completion" />
                                            <asp:ListItem Text="Leadership" Value="Leadership" />
                                            <asp:ListItem Text="Training" Value="Training" />
                                            <asp:ListItem Text="Other" Value="Other" />
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Target Date <span class="text-danger">*</span></label>
                                        <asp:TextBox ID="txtTargetDate" runat="server" CssClass="form-control" TextMode="Date" />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Priority <span class="text-danger">*</span></label>
                                        <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="Low" Value="Low" />
                                            <asp:ListItem Text="Medium" Value="Medium" Selected="True" />
                                            <asp:ListItem Text="High" Value="High" />
                                            <asp:ListItem Text="Critical" Value="Critical" />
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Goal Description <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtGoalDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Describe the goal in detail..." />
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Success Criteria <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtSuccessCriteria" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Define how success will be measured..." />
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Resources Needed</label>
                                <asp:TextBox ID="txtResources" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="List any resources or support needed..." />
                            </div>

                            <div class="d-flex gap-2">
                                <asp:Button ID="btnSaveGoal" runat="server" Text="Save Goal" CssClass="btn btn-success" OnClick="btnSaveGoal_Click" />
                                <asp:Button ID="btnCancelGoal" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancelGoal_Click" />
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <!-- Goals List -->
                <div class="card shadow-sm">
                    <div class="card-header bg-warning text-dark d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-list me-2"></i>Employee Goals</h5>
                        <div>
                            <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-select form-select-sm d-inline-block w-auto" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterStatus_SelectedIndexChanged">
                                <asp:ListItem Text="All Goals" Value="" />
                                <asp:ListItem Text="Active" Value="Active" />
                                <asp:ListItem Text="Completed" Value="Completed" />
                                <asp:ListItem Text="Overdue" Value="Overdue" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvGoals" runat="server" CssClass="table table-striped table-hover" 
                            AutoGenerateColumns="false" OnRowCommand="gvGoals_RowCommand" 
                            EmptyDataText="No goals found for this employee.">
                            <Columns>
                                <asp:TemplateField HeaderText="Goal">
                                    <ItemTemplate>
                                        <div class="fw-bold"><%# Eval("GoalTitle") %></div>
                                        <small class="text-muted"><%# Eval("Category") %></small>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="TargetDate" HeaderText="Target Date" DataFormatString="{0:MMM dd, yyyy}" />
                                <asp:TemplateField HeaderText="Priority">
                                    <ItemTemplate>
                                        <span class='badge <%# GetPriorityBadgeClass(Eval("Priority").ToString()) %>'>
                                            <%# Eval("Priority") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge <%# GetStatusBadgeClass(Eval("Status").ToString()) %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Progress">
                                    <ItemTemplate>
                                        <div class="progress">
                                            <div class="progress-bar" role="progressbar" 
                                                 style="width: <%# Eval("ProgressPercentage") %>%;" 
                                                 aria-valuenow="<%# Eval("ProgressPercentage") %>" 
                                                 aria-valuemin="0" aria-valuemax="100">
                                                <%# Eval("ProgressPercentage") %>%
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <div class="btn-group btn-group-sm">
                                            <asp:LinkButton ID="lnkUpdateProgress" runat="server" CssClass="btn btn-outline-primary" 
                                                CommandName="UpdateProgress" CommandArgument='<%# Eval("GoalId") %>'>
                                                <i class="fas fa-edit"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="lnkViewDetails" runat="server" CssClass="btn btn-outline-info" 
                                                CommandName="ViewDetails" CommandArgument='<%# Eval("GoalId") %>'>
                                                <i class="fas fa-eye"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="lnkDeleteGoal" runat="server" CssClass="btn btn-outline-danger" 
                                                CommandName="DeleteGoal" CommandArgument='<%# Eval("GoalId") %>'
                                                OnClientClick="return confirm('Are you sure you want to delete this goal?');">
                                                <i class="fas fa-trash"></i>
                                            </asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 