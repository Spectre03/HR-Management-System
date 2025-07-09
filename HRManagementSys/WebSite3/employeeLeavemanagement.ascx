<%@ Control Language="C#" AutoEventWireup="true" CodeFile="employeeLeavemanagement.ascx.cs" Inherits="employeeLeavemanagement" %>
<asp:UpdatePanel ID="upLeave" runat="server">
    <ContentTemplate>
        <!-- Enhanced Leave Summary Cards with Gradients -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card shadow border-0 bg-gradient-success text-white mb-3" style="background: linear-gradient(135deg, #4bb543 0%, #36d1c4 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-3">
                            <i class="fas fa-umbrella-beach fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Annual Leave</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litAnnualLeave" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 8px;">
                            <div class="progress-bar bg-white" style="width: 75%"></div>
                        </div>
                        <small class="mt-2 d-block">15 days remaining</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow border-0 bg-gradient-warning text-white mb-3" style="background: linear-gradient(135deg, #fca311 0%, #ffd93d 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-3">
                            <i class="fas fa-procedures fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Sick Leave</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litSickLeave" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 8px;">
                            <div class="progress-bar bg-white" style="width: 60%"></div>
                        </div>
                        <small class="mt-2 d-block">8 days remaining</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow border-0 bg-gradient-info text-white mb-3" style="background: linear-gradient(135deg, #36d1c4 0%, #4361ee 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-3">
                            <i class="fas fa-calendar-plus fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Other Leave</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litOtherLeave" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 8px;">
                            <div class="progress-bar bg-white" style="width: 40%"></div>
                        </div>
                        <small class="mt-2 d-block">5 days remaining</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Leave Request Button -->
        <div class="mb-4">
            <asp:Button ID="btnRequestLeave" runat="server" Text="Request Leave" CssClass="btn btn-primary btn-lg px-4" OnClick="btnRequestLeave_Click" />
        </div>

        <!-- Enhanced Leave Requests Table -->
        <div class="card shadow border-0 mb-4">
            <div class="card-header bg-gradient-primary text-white" style="background: linear-gradient(90deg, #4361ee 60%, #3f37c9 100%);">
                <h5 class="mb-0"><i class="fas fa-list me-2"></i>Leave Requests</h5>
            </div>
            <div class="card-body">
                <asp:GridView ID="gvLeaveRequests" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-hover" OnRowCommand="gvLeaveRequests_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="LeaveType" HeaderText="Type" />
                        <asp:BoundField DataField="StartDate" HeaderText="Start Date" DataFormatString="{0:MMM dd, yyyy}" />
                        <asp:BoundField DataField="EndDate" HeaderText="End Date" DataFormatString="{0:MMM dd, yyyy}" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class="badge badge-pill <%# GetLeaveStatusBadgeClass(Eval("Status").ToString()) %>">
                                    <i class="fas fa-circle me-1"></i><%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Reason" HeaderText="Reason" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:Button runat="server" CommandName="Cancel" CommandArgument='<%# Eval("LeaveRequestId") %>' 
                                            Text="Cancel" CssClass="btn btn-danger btn-sm" 
                                            Visible='<%# Eval("Status").ToString() == "Pending" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:Label ID="lblNoLeaveRequests" runat="server" CssClass="alert alert-info w-100 text-center my-3" Text="No leave requests found." Visible="false" />
            </div>
        </div>

        <!-- Enhanced Leave Timeline -->
        <div class="card shadow border-0 mb-4">
            <div class="card-header bg-gradient-secondary text-white" style="background: linear-gradient(90deg, #3f37c9 60%, #36d1c4 100%);">
                <h5 class="mb-0"><i class="fas fa-history me-2"></i>Leave Timeline</h5>
            </div>
            <div class="card-body">
                <div class="timeline-container">
                    <div class="timeline-item">
                        <div class="timeline-marker bg-success"></div>
                        <div class="timeline-content">
                            <h6 class="text-success">Annual Leave Approved</h6>
                            <p class="text-muted mb-1">Dec 15-20, 2024</p>
                            <small class="text-muted">Christmas vacation</small>
                        </div>
                    </div>
                    <div class="timeline-item">
                        <div class="timeline-marker bg-warning"></div>
                        <div class="timeline-content">
                            <h6 class="text-warning">Sick Leave Taken</h6>
                            <p class="text-muted mb-1">Nov 10, 2024</p>
                            <small class="text-muted">Medical appointment</small>
                        </div>
                    </div>
                    <div class="timeline-item">
                        <div class="timeline-marker bg-info"></div>
                        <div class="timeline-content">
                            <h6 class="text-info">Other Leave Requested</h6>
                            <p class="text-muted mb-1">Oct 25, 2024</p>
                            <small class="text-muted">Personal emergency</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Leave Request Form -->
        <asp:Panel ID="pnlLeaveForm" runat="server" CssClass="card mt-3 shadow border-0" Visible="false">
            <div class="card-header bg-gradient-warning text-white" style="background: linear-gradient(90deg, #fca311 60%, #4361ee 100%);">
                <h5 class="mb-0"><i class="fas fa-plus-circle me-2"></i>Request Leave</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold"><i class="fas fa-tag me-2"></i>Leave Type</label>
                        <asp:DropDownList ID="ddlLeaveType" runat="server" CssClass="form-select form-select-lg" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold"><i class="fas fa-calendar-day me-2"></i>Start Date</label>
                        <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control form-control-lg" TextMode="Date" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold"><i class="fas fa-calendar-check me-2"></i>End Date</label>
                        <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control form-control-lg" TextMode="Date" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold"><i class="fas fa-comment me-2"></i>Reason</label>
                        <asp:TextBox ID="txtReason" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Please provide a detailed reason for your leave request..." />
                    </div>
                </div>
                <div class="text-end">
                    <asp:Button ID="btnCancelLeave" runat="server" Text="Cancel" CssClass="btn btn-secondary me-2" OnClick="btnCancelLeave_Click" />
                    <asp:Button ID="btnSubmitLeave" runat="server" Text="Submit Request" CssClass="btn btn-success btn-lg px-4" OnClick="btnSubmitLeave_Click" />
                </div>
            </div>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>

<style>
.bg-gradient-success { background: linear-gradient(135deg, #4bb543 0%, #36d1c4 100%) !important; }
.bg-gradient-warning { background: linear-gradient(135deg, #fca311 0%, #ffd93d 100%) !important; }
.bg-gradient-info { background: linear-gradient(135deg, #36d1c4 0%, #4361ee 100%) !important; }
.bg-gradient-primary { background: linear-gradient(90deg, #4361ee 60%, #3f37c9 100%) !important; }
.bg-gradient-secondary { background: linear-gradient(90deg, #3f37c9 60%, #36d1c4 100%) !important; }
.card { transition: transform 0.2s ease-in-out; }
.card:hover { transform: translateY(-2px); }
.badge { font-size: 0.875rem; padding: 0.5rem 1rem; }
.form-control-lg, .form-select-lg { font-size: 1.1rem; }

/* Timeline Styles */
.timeline-container {
    position: relative;
    padding-left: 30px;
}

.timeline-container::before {
    content: '';
    position: absolute;
    left: 15px;
    top: 0;
    bottom: 0;
    width: 2px;
    background: linear-gradient(to bottom, #4361ee, #36d1c4);
}

.timeline-item {
    position: relative;
    margin-bottom: 30px;
    padding-left: 20px;
}

.timeline-marker {
    position: absolute;
    left: -22px;
    top: 5px;
    width: 12px;
    height: 12px;
    border-radius: 50%;
    border: 3px solid #fff;
    box-shadow: 0 0 0 3px #dee2e6;
}

.timeline-content {
    background: #f8f9fa;
    padding: 15px;
    border-radius: 8px;
    border-left: 4px solid #4361ee;
}

.timeline-content h6 {
    margin-bottom: 5px;
    font-weight: 600;
}

.timeline-content p {
    margin-bottom: 5px;
}

.timeline-content small {
    font-size: 0.875rem;
}
</style> 