<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AttendanceManagement.aspx.cs" Inherits="AttendanceManagement" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Attendance Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style>
        .attendance-card {
            transition: transform 0.2s;
        }
        .attendance-card:hover {
            transform: translateY(-2px);
        }
        .status-pending { border-left: 4px solid #ffc107; }
        .status-approved { border-left: 4px solid #28a745; }
        .status-rejected { border-left: 4px solid #dc3545; }
        .work-submission {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
        }
    </style>
</head>
<body style="background-color: #f5f7fb;">
    <form id="form1" runat="server" class="container-fluid">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        
        <!-- Header -->
        <div class="row bg-info text-white p-3 mb-4">
            <div class="col">
                <h2><i class="fas fa-clock me-2"></i>Attendance Management</h2>
                <p class="mb-0">Review and approve employee attendance and work submissions</p>
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
                    <div class="card-header bg-primary text-white">
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
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-tasks me-2"></i>Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <asp:Button ID="btnViewPerformance" runat="server" Text="View Performance" CssClass="btn btn-info w-100 mb-2" OnClick="btnViewPerformance_Click" />
                        <asp:Button ID="btnSetGoals" runat="server" Text="Set Goals" CssClass="btn btn-success w-100 mb-2" OnClick="btnSetGoals_Click" />
                        <asp:Button ID="btnExportAttendance" runat="server" Text="Export Report" CssClass="btn btn-warning w-100" OnClick="btnExportAttendance_Click" />
                    </div>
                </div>

                <!-- Statistics -->
                <div class="card shadow-sm mt-4">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i>This Month</h5>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-6">
                                <h4 class="text-primary"><asp:Literal ID="litDaysPresent" runat="server" /></h4>
                                <small class="text-muted">Days Present</small>
                            </div>
                            <div class="col-6">
                                <h4 class="text-success"><asp:Literal ID="litAttendanceRate" runat="server" /></h4>
                                <small class="text-muted">Attendance Rate</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-9">
                <!-- Filters -->
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="form-label">Date Range</label>
                                <asp:DropDownList ID="ddlDateRange" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlDateRange_SelectedIndexChanged">
                                    <asp:ListItem Text="This Week" Value="week" />
                                    <asp:ListItem Text="This Month" Value="month" Selected="True" />
                                    <asp:ListItem Text="Last 3 Months" Value="quarter" />
                                    <asp:ListItem Text="Custom Range" Value="custom" />
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Status</label>
                                <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                                    <asp:ListItem Text="All" Value="" />
                                    <asp:ListItem Text="Pending" Value="Pending" />
                                    <asp:ListItem Text="Approved" Value="Approved" />
                                    <asp:ListItem Text="Rejected" Value="Rejected" />
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">From Date</label>
                                <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control" TextMode="Date" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">To Date</label>
                                <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control" TextMode="Date" />
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col">
                                <asp:Button ID="btnApplyFilter" runat="server" Text="Apply Filter" CssClass="btn btn-primary" OnClick="btnApplyFilter_Click" />
                                <asp:Button ID="btnClearFilter" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnClearFilter_Click" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Attendance List -->
                <div class="card shadow-sm">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-list me-2"></i>Attendance Records</h5>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvAttendance" runat="server" CssClass="table table-striped table-hover" 
                            AutoGenerateColumns="false" OnRowCommand="gvAttendance_RowCommand" 
                            EmptyDataText="No attendance records found.">
                            <Columns>
                                <asp:BoundField DataField="AttendanceDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                                <asp:BoundField DataField="TimeIn" HeaderText="Time In" />
                                <asp:BoundField DataField="TimeOut" HeaderText="Time Out" />
                                <asp:BoundField DataField="TotalHours" HeaderText="Hours" />
                                <asp:TemplateField HeaderText="Work Submitted">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkViewWork" runat="server" CssClass="btn btn-sm btn-outline-info" 
                                            CommandName="ViewWork" CommandArgument='<%# Eval("AttendanceId") %>'>
                                            <i class="fas fa-eye"></i> View
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge <%# GetStatusBadgeClass(Eval("Status").ToString()) %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <div class="btn-group btn-group-sm">
                                            <asp:LinkButton ID="lnkApprove" runat="server" CssClass="btn btn-outline-success" 
                                                CommandName="Approve" CommandArgument='<%# Eval("AttendanceId") %>'
                                                Visible='<%# Eval("Status").ToString() == "Pending" %>'>
                                                <i class="fas fa-check"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="lnkReject" runat="server" CssClass="btn btn-outline-danger" 
                                                CommandName="Reject" CommandArgument='<%# Eval("AttendanceId") %>'
                                                Visible='<%# Eval("Status").ToString() == "Pending" %>'>
                                                <i class="fas fa-times"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="lnkAddFeedback" runat="server" CssClass="btn btn-outline-warning" 
                                                CommandName="AddFeedback" CommandArgument='<%# Eval("AttendanceId") %>'>
                                                <i class="fas fa-comment"></i>
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

        <!-- Work Submission Modal -->
        <div class="modal fade" id="workModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Work Submission Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <asp:Panel ID="pnlWorkDetails" runat="server">
                            <div class="work-submission">
                                <h6>Tasks Completed:</h6>
                                <asp:Literal ID="litTasksCompleted" runat="server" />
                            </div>
                            <div class="work-submission">
                                <h6>Challenges Faced:</h6>
                                <asp:Literal ID="litChallenges" runat="server" />
                            </div>
                            <div class="work-submission">
                                <h6>Next Day Plans:</h6>
                                <asp:Literal ID="litNextDayPlans" runat="server" />
                            </div>
                            <div class="work-submission">
                                <h6>Additional Notes:</h6>
                                <asp:Literal ID="litAdditionalNotes" runat="server" />
                            </div>
                        </asp:Panel>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Feedback Modal -->
        <div class="modal fade" id="feedbackModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Add Feedback</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Feedback Type</label>
                            <asp:DropDownList ID="ddlFeedbackType" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Positive" Value="Positive" />
                                <asp:ListItem Text="Constructive" Value="Constructive" />
                                <asp:ListItem Text="Improvement" Value="Improvement" />
                                <asp:ListItem Text="General" Value="General" />
                            </asp:DropDownList>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Feedback Message</label>
                            <asp:TextBox ID="txtFeedbackMessage" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Enter your feedback..." />
                        </div>
                        <asp:HiddenField ID="hdnAttendanceId" runat="server" />
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnSaveFeedback" runat="server" Text="Save Feedback" CssClass="btn btn-primary" OnClick="btnSaveFeedback_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showWorkModal() {
            var modal = new bootstrap.Modal(document.getElementById('workModal'));
            modal.show();
        }

        function showFeedbackModal() {
            var modal = new bootstrap.Modal(document.getElementById('feedbackModal'));
            modal.show();
        }
    </script>
</body>
</html> 