<%@ Control Language="C#" AutoEventWireup="true" CodeFile="EmployeeGoals.ascx.cs" Inherits="EmployeeGoals" %>
<asp:UpdatePanel ID="upGoals" runat="server">
    <ContentTemplate>
        <!-- Enhanced Summary Cards with Gradients -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-primary text-white mb-3" style="background: linear-gradient(135deg, #4361ee 0%, #3f37c9 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-bullseye fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Total Goals</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litTotalGoals" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 100%"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-success text-white mb-3" style="background: linear-gradient(135deg, #4bb543 0%, #36d1c4 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-check-circle fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Completed</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litCompletedGoals" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 75%"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-warning text-white mb-3" style="background: linear-gradient(135deg, #fca311 0%, #ffd93d 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-clock fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">In Progress</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litInProgressGoals" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 60%"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-info text-white mb-3" style="background: linear-gradient(135deg, #36d1c4 0%, #4361ee 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-percentage fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Completion Rate</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litCompletionRate" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 85%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Goals List -->
        <div class="card shadow border-0">
            <div class="card-header bg-gradient-secondary text-white" style="background: linear-gradient(90deg, #3f37c9 60%, #36d1c4 100%);">
                <h5 class="mb-0"><i class="fas fa-bullseye me-2"></i>My Goals</h5>
            </div>
            <div class="card-body">
                <asp:Repeater ID="rptGoals" runat="server" OnItemCommand="rptGoals_ItemCommand">
                    <ItemTemplate>
                        <div class="goal-item border rounded p-4 mb-3 shadow-sm" style="background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <div class="d-flex align-items-center mb-2">
                                        <i class="fas fa-target text-primary me-2"></i>
                                        <h6 class="mb-0 fw-bold text-primary"><%# Eval("GoalTitle") %></h6>
                                    </div>
                                    <p class="text-muted mb-3"><%# Eval("GoalDescription") %></p>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <div class="d-flex align-items-center">
                                                <i class="fas fa-calendar text-warning me-2"></i>
                                                <small class="text-muted">
                                                    Due: <%# Convert.ToDateTime(Eval("TargetDate")).ToString("MMM dd, yyyy") %>
                                                </small>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="d-flex align-items-center">
                                                <i class="fas fa-user text-info me-2"></i>
                                                <small class="text-muted">
                                                    Assigned by: <%# Eval("AssignedBy") %>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mb-2">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <small class="text-muted fw-bold">Progress</small>
                                            <small class="text-primary fw-bold"><%# Eval("ProgressPercentage") %>%</small>
                                        </div>
                                        <div class="progress" style="height: 10px; border-radius: 5px;">
                                            <div class="progress-bar bg-gradient-success" role="progressbar" 
                                                 style="width: <%# Eval("ProgressPercentage") %>%; background: linear-gradient(90deg, #4bb543 0%, #36d1c4 100%);" 
                                                 aria-valuenow="<%# Eval("ProgressPercentage") %>" 
                                                 aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 text-end">
                                    <span class="badge badge-pill <%# GetStatusBadgeClass(Eval("Status").ToString()) %> mb-3 fs-6">
                                        <i class="fas fa-circle me-1"></i><%# Eval("Status") %>
                                    </span>
                                    <div class="d-grid gap-2">
                                        <asp:Button runat="server" CommandName="UpdateProgress" 
                                                    CommandArgument='<%# Eval("GoalId") %>' 
                                                    Text="Update Progress" CssClass="btn btn-primary btn-sm" />
                                        <asp:Button runat="server" CommandName="MarkComplete" 
                                                    CommandArgument='<%# Eval("GoalId") %>' 
                                                    Text="Mark Complete" CssClass="btn btn-success btn-sm"
                                                    Visible='<%# Eval("Status").ToString() != "Completed" %>' />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoGoals" runat="server" CssClass="alert alert-info w-100 text-center my-3" 
                          Text="No goals assigned yet." Visible="false" />
            </div>
        </div>

        <!-- Enhanced Progress Update Modal -->
        <asp:Panel ID="pnlProgressModal" runat="server" CssClass="card mt-3 shadow border-0" Visible="false">
            <div class="card-header bg-gradient-warning text-white" style="background: linear-gradient(90deg, #fca311 60%, #4361ee 100%);">
                <h5 class="mb-0"><i class="fas fa-edit me-2"></i>Update Goal Progress</h5>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label class="form-label fw-bold text-primary"><i class="fas fa-target me-2"></i>Goal: <asp:Literal ID="litGoalTitle" runat="server" /></label>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold"><i class="fas fa-percentage me-2"></i>Progress Percentage</label>
                    <asp:TextBox ID="txtProgressPercentage" runat="server" CssClass="form-control form-control-lg" 
                                TextMode="Number" Min="0" Max="100" />
                    <div class="form-text">Enter a value between 0 and 100</div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold"><i class="fas fa-comments me-2"></i>Comments</label>
                    <asp:TextBox ID="txtProgressComments" runat="server" CssClass="form-control" 
                                TextMode="MultiLine" Rows="3" placeholder="Add your progress comments here..." />
                </div>
                <div class="text-end">
                    <asp:Button ID="btnCancelProgress" runat="server" Text="Cancel" 
                                CssClass="btn btn-secondary me-2" OnClick="btnCancelProgress_Click" />
                    <asp:Button ID="btnSaveProgress" runat="server" Text="Save Progress" 
                                CssClass="btn btn-primary" OnClick="btnSaveProgress_Click" />
                </div>
            </div>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>

<style>
.bg-gradient-primary { background: linear-gradient(135deg, #4361ee 0%, #3f37c9 100%) !important; }
.bg-gradient-success { background: linear-gradient(135deg, #4bb543 0%, #36d1c4 100%) !important; }
.bg-gradient-warning { background: linear-gradient(135deg, #fca311 0%, #ffd93d 100%) !important; }
.bg-gradient-info { background: linear-gradient(135deg, #36d1c4 0%, #4361ee 100%) !important; }
.bg-gradient-secondary { background: linear-gradient(90deg, #3f37c9 60%, #36d1c4 100%) !important; }
.card { transition: transform 0.2s ease-in-out; }
.card:hover { transform: translateY(-2px); }
.goal-item { transition: all 0.3s ease; }
.goal-item:hover { transform: translateY(-1px); box-shadow: 0 4px 15px rgba(0,0,0,0.1) !important; }
.progress-bar { transition: width 0.6s ease; }
.badge { font-size: 0.875rem; padding: 0.5rem 1rem; }
.form-control-lg { font-size: 1.1rem; }
</style> 