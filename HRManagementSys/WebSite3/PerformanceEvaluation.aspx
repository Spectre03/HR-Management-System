<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PerformanceEvaluation.aspx.cs" Inherits="PerformanceEvaluation" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Performance Evaluation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style>
        .rating-stars {
            font-size: 1.5rem;
            color: #ffc107;
            cursor: pointer;
        }
        .rating-stars:hover {
            color: #ffdb4d;
        }
        .performance-card {
            transition: transform 0.2s;
        }
        .performance-card:hover {
            transform: translateY(-2px);
        }
        .goal-status {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        /* Performance sidebar theme */
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #283e51 0%, #485563 50%, #36d1c4 100%);
            color: #fff;
            padding-top: 20px;
            position: sticky;
            top: 0;
            box-shadow: 2px 0 8px rgba(0,0,0,0.05);
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
        .logout-link {
            margin-top: auto;
            border-top: 1px solid #36d1c4;
            padding-top: 10px;
        }
    </style>
</head>
<body style="background-color: #f5f7fb;">
    <form id="form1" runat="server">
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-2 sidebar">
                <div class="sidebar-logo text-center mb-4">
                    <img src="https://ui-avatars.com/api/?name=HR+M" alt="HRM Logo" style="width:48px;height:48px;border-radius:50%;margin-bottom:10px;" />
                    <div style="color:#fff;font-size:1.3rem;font-weight:600;">HR Manager</div>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item"><a class="nav-link" href="Default.aspx"><i class="fas fa-home"></i> Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="Departments.aspx"><i class="fas fa-building"></i> Departments</a></li>
                    <li class="nav-item"><a class="nav-link" href="Reports.aspx"><i class="fas fa-chart-bar"></i> Reports</a></li>
                    <li class="nav-item"><a class="nav-link active" href="PerformanceEvaluation.aspx"><i class="fas fa-chart-line"></i> Performance</a></li>
                    <li class="nav-item"><a class="nav-link" href="Settings.aspx"><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
                <div class="logout-link mt-auto pt-3 border-top">
                    <asp:LinkButton ID="btnLogout" runat="server" CssClass="nav-link text-danger" OnClick="btnLogout_Click"><i class="fas fa-sign-out-alt"></i> Logout</asp:LinkButton>
                </div>
            </div>
            <div class="col-md-10 main-content">
                <div class="row bg-primary text-white p-3 mb-4">
                    <div class="col">
                        <h2><i class="fas fa-chart-line me-2"></i>Performance Evaluation & Goals Management</h2>
                        <p class="mb-0">Evaluate employee performance, set goals, and provide feedback</p>
                    </div>
                    <div class="col-auto">
                        <a href="Default.aspx" class="btn btn-light"><i class="fas fa-arrow-left me-1"></i>Back to Dashboard</a>
                    </div>
                </div>

                <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-info alert-dismissible fade show" role="alert">
                    <asp:Literal ID="litMessage" runat="server" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </asp:Panel>

                <div class="row">
                    <div class="col-md-3">
                        <div class="card shadow-sm mb-4">
                            <div class="card-header bg-info text-white">
                                <h5 class="mb-0"><i class="fas fa-users me-2"></i>Select Employee</h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label">Employee</label>
                                    <asp:DropDownList ID="ddlEmployees" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlEmployees_SelectedIndexChanged">
                                        <asp:ListItem Text="Select Employee" Value="" />
                                    </asp:DropDownList>
                                </div>
                                
                                <asp:Panel ID="pnlEmployeeInfo" runat="server" Visible="false">
                                    <div class="border rounded p-3 bg-light">
                                        <h6 class="text-primary">Employee Information</h6>
                                        <p class="mb-1"><strong>Name:</strong> <asp:Literal ID="litEmployeeName" runat="server" /></p>
                                        <p class="mb-1"><strong>Department:</strong> <asp:Literal ID="litDepartment" runat="server" /></p>
                                        <p class="mb-1"><strong>Position:</strong> <asp:Literal ID="litPosition" runat="server" /></p>
                                        <p class="mb-0"><strong>Hire Date:</strong> <asp:Literal ID="litHireDate" runat="server" /></p>
                                    </div>
                                </asp:Panel>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-success text-white">
                                <h5 class="mb-0"><i class="fas fa-tasks me-2"></i>Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <asp:Button ID="btnNewEvaluation" runat="server" Text="New Performance Review" CssClass="btn btn-primary w-100 mb-2" OnClick="btnNewEvaluation_Click" />
                                <asp:Button ID="btnSetGoals" runat="server" Text="Set New Goals" CssClass="btn btn-success w-100 mb-2" OnClick="btnSetGoals_Click" />
                                <asp:Button ID="btnViewAttendance" runat="server" Text="View Attendance" CssClass="btn btn-info w-100 mb-2" OnClick="btnViewAttendance_Click" />
                                <asp:Button ID="btnWorkFeedback" runat="server" Text="Work Feedback" CssClass="btn btn-warning w-100" OnClick="btnWorkFeedback_Click" />
                            </div>
                        </div>
                    </div>

                    <div class="col-md-9">
                        <asp:Panel ID="pnlEvaluationForm" runat="server" Visible="false">
                            <div class="card shadow-sm mb-4">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0"><i class="fas fa-edit me-2"></i>Performance Evaluation</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Review Period Start</label>
                                                <asp:TextBox ID="txtReviewStart" runat="server" CssClass="form-control" TextMode="Date" />
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Review Period End</label>
                                                <asp:TextBox ID="txtReviewEnd" runat="server" CssClass="form-control" TextMode="Date" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Technical Skills (1-5)</label>
                                                <asp:DropDownList ID="ddlTechnicalSkills" runat="server" CssClass="form-select">
                                                    <asp:ListItem Text="1 - Poor" Value="1" />
                                                    <asp:ListItem Text="2 - Below Average" Value="2" />
                                                    <asp:ListItem Text="3 - Average" Value="3" Selected="True" />
                                                    <asp:ListItem Text="4 - Above Average" Value="4" />
                                                    <asp:ListItem Text="5 - Excellent" Value="5" />
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Communication Skills (1-5)</label>
                                                <asp:DropDownList ID="ddlCommunicationSkills" runat="server" CssClass="form-select">
                                                    <asp:ListItem Text="1 - Poor" Value="1" />
                                                    <asp:ListItem Text="2 - Below Average" Value="2" />
                                                    <asp:ListItem Text="3 - Average" Value="3" Selected="True" />
                                                    <asp:ListItem Text="4 - Above Average" Value="4" />
                                                    <asp:ListItem Text="5 - Excellent" Value="5" />
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Teamwork Skills (1-5)</label>
                                                <asp:DropDownList ID="ddlTeamworkSkills" runat="server" CssClass="form-select">
                                                    <asp:ListItem Text="1 - Poor" Value="1" />
                                                    <asp:ListItem Text="2 - Below Average" Value="2" />
                                                    <asp:ListItem Text="3 - Average" Value="3" Selected="True" />
                                                    <asp:ListItem Text="4 - Above Average" Value="4" />
                                                    <asp:ListItem Text="5 - Excellent" Value="5" />
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Leadership Skills (1-5)</label>
                                                <asp:DropDownList ID="ddlLeadershipSkills" runat="server" CssClass="form-select">
                                                    <asp:ListItem Text="1 - Poor" Value="1" />
                                                    <asp:ListItem Text="2 - Below Average" Value="2" />
                                                    <asp:ListItem Text="3 - Average" Value="3" Selected="True" />
                                                    <asp:ListItem Text="4 - Above Average" Value="4" />
                                                    <asp:ListItem Text="5 - Excellent" Value="5" />
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Overall Performance Rating (1-5)</label>
                                        <asp:DropDownList ID="ddlOverallRating" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="1 - Poor" Value="1" />
                                            <asp:ListItem Text="2 - Below Average" Value="2" />
                                            <asp:ListItem Text="3 - Average" Value="3" Selected="True" />
                                            <asp:ListItem Text="4 - Above Average" Value="4" />
                                            <asp:ListItem Text="5 - Excellent" Value="5" />
                                        </asp:DropDownList>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Strengths</label>
                                        <asp:TextBox ID="txtStrengths" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="List employee strengths..." />
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Areas for Improvement</label>
                                        <asp:TextBox ID="txtImprovements" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="List areas for improvement..." />
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Recommendations</label>
                                        <asp:TextBox ID="txtRecommendations" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Provide recommendations for growth..." />
                                    </div>

                                    <div class="d-flex gap-2">
                                        <asp:Button ID="btnSaveEvaluation" runat="server" Text="Save Evaluation" CssClass="btn btn-primary" OnClick="btnSaveEvaluation_Click" />
                                        <asp:Button ID="btnCancelEvaluation" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancelEvaluation_Click" />
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="pnlPerformanceHistory" runat="server" Visible="false">
                            <div class="card shadow-sm mb-4">
                                <div class="card-header bg-info text-white">
                                    <h5 class="mb-0"><i class="fas fa-history me-2"></i>Performance History</h5>
                                </div>
                                <div class="card-body">
                                    <asp:GridView ID="gvPerformanceHistory" runat="server" CssClass="table table-striped table-hover" 
                                        AutoGenerateColumns="false" OnRowCommand="gvPerformanceHistory_RowCommand">
                                        <Columns>
                                            <asp:BoundField DataField="ReviewDate" HeaderText="Review Date" DataFormatString="{0:MMM dd, yyyy}" />
                                            <asp:BoundField DataField="PerformanceRating" HeaderText="Overall Rating" />
                                            <asp:BoundField DataField="TechnicalSkills" HeaderText="Technical" />
                                            <asp:BoundField DataField="CommunicationSkills" HeaderText="Communication" />
                                            <asp:BoundField DataField="TeamworkSkills" HeaderText="Teamwork" />
                                            <asp:BoundField DataField="LeadershipSkills" HeaderText="Leadership" />
                                            <asp:BoundField DataField="Status" HeaderText="Status" />
                                            <asp:TemplateField HeaderText="Actions">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lnkViewDetails" runat="server" CssClass="btn btn-sm btn-outline-primary" 
                                                        CommandName="ViewDetails" CommandArgument='<%# Eval("PerformanceId") %>'>
                                                        <i class="fas fa-eye"></i> View
                                                    </asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const ratingContainers = document.querySelectorAll('.rating-stars');
            
            ratingContainers.forEach(container => {
                const stars = container.querySelectorAll('i');
                const hiddenField = container.parentElement.querySelector('input[type="hidden"]');
                
                stars.forEach(star => {
                    star.addEventListener('click', function() {
                        const rating = this.getAttribute('data-rating');
                        updateStars(stars, rating);
                        if (hiddenField) {
                            hiddenField.value = rating;
                        }
                    });
                });
                
                const defaultRating = hiddenField ? hiddenField.value : 3;
                updateStars(stars, defaultRating);
            });
        });
        
        function updateStars(stars, rating) {
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.remove('far');
                    star.classList.add('fas');
                } else {
                    star.classList.remove('fas');
                    star.classList.add('far');
                }
            });
        }
    </script>
</body>
</html> 