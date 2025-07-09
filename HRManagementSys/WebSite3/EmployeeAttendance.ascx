<%@ Control Language="C#" AutoEventWireup="true" CodeFile="EmployeeAttendance.ascx.cs" Inherits="EmployeeAttendance" %>
<asp:UpdatePanel ID="upAttendance" runat="server">
    <ContentTemplate>
        <!-- Enhanced Summary Cards with Gradients -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-success text-white mb-3" style="background: linear-gradient(135deg, #4bb543 0%, #36d1c4 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-calendar-check fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Present Days</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litPresentDays" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 85%"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-danger text-white mb-3" style="background: linear-gradient(135deg, #ef233c 0%, #ff6b6b 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-calendar-times fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Absent Days</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litAbsentDays" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 15%"></div>
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
                                <h6 class="mb-0">Late Days</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litLateDays" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 25%"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-primary text-white mb-3" style="background: linear-gradient(135deg, #4361ee 0%, #3f37c9 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-percentage fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Attendance Rate</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litAttendanceRate" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 92%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Daily Work Submission Section -->
        <div class="card mb-4 shadow border-0">
            <div class="card-header bg-gradient-info text-white" style="background: linear-gradient(90deg, #36d1c4 60%, #4361ee 100%);">
                <h5 class="mb-0"><i class="fas fa-tasks me-2"></i>Daily Work Submission</h5>
            </div>
            <div class="card-body">
                <asp:Label ID="lblErrorMessage" runat="server" CssClass="alert alert-danger d-none" />
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold"><i class="fas fa-calendar me-2"></i>Work Date <small class="text-muted">(Today Only)</small></label>
                        <asp:TextBox ID="txtWorkDate" runat="server" CssClass="form-control form-control-lg" TextMode="Date" ReadOnly="true" />
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold"><i class="fas fa-sign-in-alt me-2"></i>Time In</label>
                        <asp:TextBox ID="txtTimeIn" runat="server" CssClass="form-control form-control-lg" TextMode="Time" onchange="calculateWorkHours()" />
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold"><i class="fas fa-sign-out-alt me-2"></i>Time Out</label>
                        <asp:TextBox ID="txtTimeOut" runat="server" CssClass="form-control form-control-lg" TextMode="Time" onchange="calculateWorkHours()" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold"><i class="fas fa-hourglass-half me-2"></i>Work Hours <small class="text-muted">(Auto-calculated)</small></label>
                        <asp:TextBox ID="txtWorkHours" runat="server" CssClass="form-control form-control-lg" TextMode="Number" Min="1" Max="12" Step="0.5" ReadOnly="true" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold"><i class="fas fa-coffee me-2"></i>Break Time (minutes)</label>
                        <asp:TextBox ID="txtBreakTime" runat="server" CssClass="form-control form-control-lg" TextMode="Number" Min="0" Max="120" Value="0" onchange="calculateWorkHours()" />
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold"><i class="fas fa-check-circle me-2"></i>Tasks Completed</label>
                    <asp:TextBox ID="txtTasksCompleted" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="List the main tasks you completed today..." />
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold"><i class="fas fa-exclamation-triangle me-2"></i>Challenges Faced</label>
                    <asp:TextBox ID="txtChallenges" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="Any challenges or issues you encountered..." />
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold"><i class="fas fa-arrow-right me-2"></i>Tomorrow's Plan</label>
                    <asp:TextBox ID="txtTomorrowPlan" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="What do you plan to work on tomorrow?" />
                </div>
                <div class="text-end">
                    <asp:Button ID="btnSubmitWork" runat="server" Text="Submit Daily Work" CssClass="btn btn-primary btn-lg px-4" OnClick="btnSubmitWork_Click" />
                </div>
            </div>
        </div>

        <!-- Enhanced Attendance Records -->
        <div class="card shadow border-0">
            <div class="card-header bg-gradient-secondary text-white d-flex justify-content-between align-items-center" style="background: linear-gradient(90deg, #3f37c9 60%, #36d1c4 100%);">
                <h5 class="mb-0"><i class="fas fa-calendar-check me-2"></i>Attendance Records</h5>
                <div>
                    <asp:DropDownList ID="ddlAttendanceMonth" runat="server" CssClass="form-select d-inline-block w-auto me-2" AutoPostBack="true" OnSelectedIndexChanged="ddlAttendanceMonth_SelectedIndexChanged" />
                    <asp:Button ID="btnExportAttendance" runat="server" Text="Export" CssClass="btn btn-light btn-sm" OnClick="btnExportAttendance_Click" />
                </div>
            </div>
            <div class="card-body">
                <asp:GridView ID="gvAttendance" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-hover" OnRowCommand="gvAttendance_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="AttendanceDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                        <asp:BoundField DataField="TimeIn" HeaderText="Time In" DataFormatString="{0:HH:mm}" />
                        <asp:BoundField DataField="TimeOut" HeaderText="Time Out" DataFormatString="{0:HH:mm}" />
                        <asp:BoundField DataField="WorkHours" HeaderText="Work Hours" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class="badge badge-pill <%# GetStatusBadgeClass(Eval("Status").ToString()) %>"><%# Eval("Status") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Notes" HeaderText="Notes" />
                        <asp:TemplateField HeaderText="Work Quality">
                            <ItemTemplate>
                                <span class="badge badge-pill <%# GetQualityBadgeClass(Eval("WorkQuality").ToString()) %>"><%# Eval("WorkQuality") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:Button runat="server" CommandName="ViewWork" CommandArgument='<%# Eval("AttendanceId") %>' Text="View Work" CssClass="btn btn-info btn-sm me-1" />
                                <asp:Button runat="server" CommandName="DeleteAttendance" CommandArgument='<%# Eval("AttendanceId") %>' Text="Delete" CssClass="btn btn-danger btn-sm" 
                                    OnClientClick="return confirm('Are you sure you want to delete this attendance record?');" 
                                    Visible='<%# Convert.ToDateTime(Eval("AttendanceDate")).Date == DateTime.Now.Date %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:Label ID="lblNoAttendance" runat="server" CssClass="alert alert-info w-100 text-center my-3" Text="No attendance records found for this month." Visible="false" />
            </div>
        </div>

        <!-- Enhanced Work Review Modal -->
        <asp:Panel ID="pnlWorkReview" runat="server" CssClass="card mt-3 shadow border-0" Visible="false">
            <div class="card-header bg-gradient-warning text-white" style="background: linear-gradient(90deg, #fca311 60%, #4361ee 100%);">
                <h5 class="mb-0"><i class="fas fa-eye me-2"></i>Work Review - <asp:Literal ID="litReviewDate" runat="server" /></h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="card bg-light">
                            <div class="card-body">
                                <h6 class="text-primary"><i class="fas fa-check-circle me-2"></i>Tasks Completed:</h6>
                                <asp:Literal ID="litReviewTasks" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card bg-light">
                            <div class="card-body">
                                <h6 class="text-warning"><i class="fas fa-exclamation-triangle me-2"></i>Challenges:</h6>
                                <asp:Literal ID="litReviewChallenges" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="card bg-light">
                            <div class="card-body">
                                <h6 class="text-info"><i class="fas fa-arrow-right me-2"></i>Tomorrow's Plan:</h6>
                                <asp:Literal ID="litReviewTomorrowPlan" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card bg-light">
                            <div class="card-body">
                                <h6 class="text-success"><i class="fas fa-star me-2"></i>Work Quality Assessment:</h6>
                                <asp:DropDownList ID="ddlWorkQuality" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Select Quality" Value="" />
                                    <asp:ListItem Text="Excellent" Value="Excellent" />
                                    <asp:ListItem Text="Good" Value="Good" />
                                    <asp:ListItem Text="Average" Value="Average" />
                                    <asp:ListItem Text="Below Average" Value="Below Average" />
                                    <asp:ListItem Text="Poor" Value="Poor" />
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="mt-3">
                    <label class="form-label fw-bold"><i class="fas fa-comments me-2"></i>Manager Comments:</label>
                    <asp:TextBox ID="txtManagerComments" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                </div>
                <div class="text-end mt-3">
                    <asp:Button ID="btnCloseReview" runat="server" Text="Close" CssClass="btn btn-secondary me-2" OnClick="btnCloseReview_Click" />
                    <asp:Button ID="btnSaveReview" runat="server" Text="Save Review" CssClass="btn btn-success" OnClick="btnSaveReview_Click" />
                </div>
            </div>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>

<style>
.bg-gradient-success { background: linear-gradient(135deg, #4bb543 0%, #36d1c4 100%) !important; }
.bg-gradient-danger { background: linear-gradient(135deg, #ef233c 0%, #ff6b6b 100%) !important; }
.bg-gradient-warning { background: linear-gradient(135deg, #fca311 0%, #ffd93d 100%) !important; }
.bg-gradient-primary { background: linear-gradient(135deg, #4361ee 0%, #3f37c9 100%) !important; }
.bg-gradient-info { background: linear-gradient(90deg, #36d1c4 60%, #4361ee 100%) !important; }
.bg-gradient-secondary { background: linear-gradient(90deg, #3f37c9 60%, #36d1c4 100%) !important; }
.card { transition: transform 0.2s ease-in-out; }
.card:hover { transform: translateY(-2px); }
.form-control-lg { font-size: 1.1rem; }
</style>

<script type="text/javascript">
    function calculateWorkHours() {
        var timeIn = document.getElementById('<%= txtTimeIn.ClientID %>').value;
        var timeOut = document.getElementById('<%= txtTimeOut.ClientID %>').value;
        var breakTime = document.getElementById('<%= txtBreakTime.ClientID %>').value || 0;
        
        if (timeIn && timeOut) {
            var timeInDate = new Date('2000-01-01T' + timeIn);
            var timeOutDate = new Date('2000-01-01T' + timeOut);
            
            if (timeOutDate > timeInDate) {
                var diffMs = timeOutDate - timeInDate;
                var diffHours = diffMs / (1000 * 60 * 60);
                var breakHours = breakTime / 60;
                var workHours = Math.max(0, diffHours - breakHours);
                
                document.getElementById('<%= txtWorkHours.ClientID %>').value = workHours.toFixed(1);
            }
        }
    }
</script> 