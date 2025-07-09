<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WorkFeedback.aspx.cs" Inherits="WorkFeedback" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Work Feedback Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style>
        .feedback-card {
            transition: transform 0.2s;
        }
        .feedback-card:hover {
            transform: translateY(-2px);
        }
        .feedback-positive { border-left: 4px solid #28a745; }
        .feedback-constructive { border-left: 4px solid #ffc107; }
        .feedback-improvement { border-left: 4px solid #dc3545; }
        .feedback-general { border-left: 4px solid #17a2b8; }
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
        <div class="row bg-warning text-dark p-3 mb-4">
            <div class="col">
                <h2><i class="fas fa-comments me-2"></i>Work Feedback Management</h2>
                <p class="mb-0">Provide feedback on employee work submissions and performance</p>
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
                        <asp:Button ID="btnViewAttendance" runat="server" Text="View Attendance" CssClass="btn btn-warning w-100" OnClick="btnViewAttendance_Click" />
                    </div>
                </div>

                <!-- Statistics -->
                <div class="card shadow-sm mt-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Feedback Stats</h5>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-6">
                                <h4 class="text-primary"><asp:Literal ID="litTotalFeedback" runat="server" /></h4>
                                <small class="text-muted">Total Feedback</small>
                            </div>
                            <div class="col-6">
                                <h4 class="text-success"><asp:Literal ID="litPositiveFeedback" runat="server" /></h4>
                                <small class="text-muted">Positive</small>
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
                                    <asp:ListItem Text="All Time" Value="all" />
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Feedback Type</label>
                                <asp:DropDownList ID="ddlFeedbackType" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlFeedbackType_SelectedIndexChanged">
                                    <asp:ListItem Text="All Types" Value="" />
                                    <asp:ListItem Text="Positive" Value="Positive" />
                                    <asp:ListItem Text="Constructive" Value="Constructive" />
                                    <asp:ListItem Text="Improvement" Value="Improvement" />
                                    <asp:ListItem Text="General" Value="General" />
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

                <!-- Work Submissions and Feedback -->
                <div class="card shadow-sm">
                    <div class="card-header bg-light d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-list me-2"></i>Work Submissions & Feedback</h5>
                        <asp:Button ID="btnAddFeedback" runat="server" Text="Add New Feedback" CssClass="btn btn-success" OnClick="btnAddFeedback_Click" />
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gvWorkSubmissions" runat="server" CssClass="table table-striped table-hover" 
                            AutoGenerateColumns="false" OnRowCommand="gvWorkSubmissions_RowCommand" 
                            EmptyDataText="No work submissions found for this employee.">
                            <Columns>
                                <asp:BoundField DataField="AttendanceDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                                <asp:TemplateField HeaderText="Work Details">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkViewWork" runat="server" CssClass="btn btn-sm btn-outline-info" 
                                            CommandName="ViewWork" CommandArgument='<%# Eval("AttendanceId") %>'>
                                            <i class="fas fa-eye"></i> View Work
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="WorkHours" HeaderText="Hours" DataFormatString="{0:F1}" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge <%# GetStatusBadgeClass(Eval("Status").ToString()) %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Feedback">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkViewFeedback" runat="server" CssClass="btn btn-sm btn-outline-warning" 
                                            CommandName="ViewFeedback" CommandArgument='<%# Eval("AttendanceId") %>'
                                            Visible='<%# HasFeedback(Eval("AttendanceId")) %>'>
                                            <i class="fas fa-comment"></i> View
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lnkAddFeedback" runat="server" CssClass="btn btn-sm btn-outline-success" 
                                            CommandName="AddFeedback" CommandArgument='<%# Eval("AttendanceId") %>'
                                            Visible='<%# !HasFeedback(Eval("AttendanceId")) %>'>
                                            <i class="fas fa-plus"></i> Add
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>

        <!-- Work Details Modal -->
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

        <!-- Add Feedback Modal -->
        <div class="modal fade" id="feedbackModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Add Work Feedback</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Feedback Type <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlNewFeedbackType" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Positive" Value="Positive" />
                                <asp:ListItem Text="Constructive" Value="Constructive" />
                                <asp:ListItem Text="Improvement" Value="Improvement" />
                                <asp:ListItem Text="General" Value="General" />
                            </asp:DropDownList>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Feedback Message <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtFeedbackMessage" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Enter your feedback on the work submission..." />
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

        <!-- View Feedback Modal -->
        <div class="modal fade" id="viewFeedbackModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Work Feedback</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <asp:Panel ID="pnlFeedbackDetails" runat="server">
                            <div class="mb-3">
                                <strong>Feedback Type:</strong>
                                <asp:Literal ID="litFeedbackType" runat="server" />
                            </div>
                            <div class="mb-3">
                                <strong>Feedback Message:</strong>
                                <asp:Literal ID="litFeedbackMessage" runat="server" />
                            </div>
                            <div class="mb-3">
                                <strong>Given By:</strong>
                                <asp:Literal ID="litGivenBy" runat="server" />
                            </div>
                            <div class="mb-3">
                                <strong>Date:</strong>
                                <asp:Literal ID="litGivenDate" runat="server" />
                            </div>
                        </asp:Panel>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
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

        function showViewFeedbackModal() {
            var modal = new bootstrap.Modal(document.getElementById('viewFeedbackModal'));
            modal.show();
        }
    </script>
</body>
</html> 