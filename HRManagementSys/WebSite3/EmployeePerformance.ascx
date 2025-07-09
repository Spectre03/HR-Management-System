<%@ Control Language="C#" AutoEventWireup="true" CodeFile="EmployeePerformance.ascx.cs" Inherits="EmployeePerformance" %>
<asp:UpdatePanel ID="upPerformance" runat="server">
    <ContentTemplate>
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card shadow border-0 bg-gradient-primary text-white mb-3" style="background: linear-gradient(90deg, #4361ee 60%, #36d1c4 100%);">
                    <div class="card-body">
                        <h5 class="card-title mb-2"><i class="fas fa-star me-2"></i>Performance Summary</h5>
                        <div class="d-flex align-items-center mb-2">
                            <span class="badge bg-success fs-5 me-2">
                                <asp:Literal ID="litAvgRating" runat="server" Text="--" />
                            </span>
                            <span>Average Rating</span>
                        </div>
                        <div class="d-flex align-items-center">
                            <span class="badge bg-info fs-6 me-2">
                                <asp:Literal ID="litReviewCount" runat="server" Text="--" />
                            </span>
                            <span>Total Reviews</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card shadow border-0 bg-light mb-3">
                    <div class="card-body">
                        <h5 class="card-title mb-2 text-primary"><i class="fas fa-trophy me-2"></i>Latest Rating</h5>
                        <div class="d-flex align-items-center mb-2">
                            <span id="stars" runat="server" class="fs-4 text-warning"></span>
                            <asp:Literal ID="litPerformanceRating" runat="server" /> <span class="text-muted">/ 5</span>
                        </div>
                        <div class="mb-1"><strong>Comments:</strong> <asp:Literal ID="litPerformanceReview" runat="server" /></div>
                        <div><strong>Goals for Next Period:</strong> <asp:Literal ID="litPerformanceGoals" runat="server" /></div>
                    </div>
                </div>
            </div>
        </div>
        <asp:Label ID="lblNoPerformance" runat="server" CssClass="alert alert-info w-100 text-center my-3" Text="No performance reviews found." Visible="false" />
        <div class="card mb-4 shadow border-0">
            <div class="card-header bg-gradient-info text-white" style="background: linear-gradient(90deg, #36d1c4 60%, #4361ee 100%);">
                <i class="fas fa-history me-2"></i>Performance History
            </div>
            <div class="card-body">
                <asp:GridView ID="gvPerformanceHistory" runat="server" CssClass="table table-striped table-hover" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="ReviewDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                        <asp:BoundField DataField="PerformanceRating" HeaderText="Rating" />
                        <asp:BoundField DataField="TechnicalSkills" HeaderText="Technical" />
                        <asp:BoundField DataField="CommunicationSkills" HeaderText="Communication" />
                        <asp:BoundField DataField="TeamworkSkills" HeaderText="Teamwork" />
                        <asp:BoundField DataField="LeadershipSkills" HeaderText="Leadership" />
                        <asp:BoundField DataField="Comments" HeaderText="Comments" />
                    </Columns>
                </asp:GridView>
                <input type="hidden" id="perfRadarData" runat="server" />
                <input type="hidden" id="perfTrendData" runat="server" />
            </div>
        </div>
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card mb-4 shadow border-0">
                    <div class="card-header bg-gradient-success text-white" style="background: linear-gradient(90deg, #4bb543 60%, #36d1c4 100%);">
                        <i class="fas fa-chart-radar me-2"></i>Skill Radar Chart
                    </div>
                    <div class="card-body">
                        <canvas id="performanceRadarChart" width="400" height="200"></canvas>
                        <div class="mt-3" id="skillBars"></div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card mb-4 shadow border-0">
                    <div class="card-header bg-gradient-warning text-white" style="background: linear-gradient(90deg, #fca311 60%, #4361ee 100%);">
                        <i class="fas fa-chart-line me-2"></i>Performance Trend
                    </div>
                    <div class="card-body">
                        <canvas id="performanceTrendChart" width="400" height="200"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <div class="card mb-4 shadow border-0">
            <div class="card-header bg-gradient-secondary text-white" style="background: linear-gradient(90deg, #3f37c9 60%, #36d1c4 100%);">
                <i class="fas fa-user-edit me-2"></i>Self-Review
            </div>
            <div class="card-body">
                <asp:TextBox ID="txtSelfReview" runat="server" CssClass="form-control mb-2" TextMode="MultiLine" Rows="3" placeholder="Add your self-review or comments..." />
                <asp:Button ID="btnSubmitSelfReview" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="btnSubmitSelfReview_Click" />
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/chart.js/dist/Chart.min.css" />
<script src="https://cdn.jsdelivr.net/npm/chart.js/dist/chart.min.js"></script>
<style>
.bg-gradient-primary { background: linear-gradient(90deg, #4361ee 60%, #36d1c4 100%) !important; }
.bg-gradient-info { background: linear-gradient(90deg, #36d1c4 60%, #4361ee 100%) !important; }
.bg-gradient-success { background: linear-gradient(90deg, #4bb543 60%, #36d1c4 100%) !important; }
.bg-gradient-warning { background: linear-gradient(90deg, #fca311 60%, #4361ee 100%) !important; }
.bg-gradient-secondary { background: linear-gradient(90deg, #3f37c9 60%, #36d1c4 100%) !important; }
#skillBars .progress { height: 18px; margin-bottom: 8px; }
#skillBars .progress-bar { font-weight: 600; font-size: 1rem; }
</style>
<script>
function renderPerformanceCharts() {
    var radarData = document.getElementById('perfRadarData').value;
    var trendData = document.getElementById('perfTrendData').value;
    // Radar chart
    if (radarData) {
        var radar = JSON.parse(radarData);
        new Chart(document.getElementById('performanceRadarChart').getContext('2d'), {
            type: 'radar',
            data: {
                labels: ['Technical', 'Communication', 'Teamwork', 'Leadership'],
                datasets: [{
                    label: 'Latest Skills',
                    data: radar,
                    backgroundColor: 'rgba(67,97,238,0.2)',
                    borderColor: '#4361ee',
                    pointBackgroundColor: '#4361ee',
                }]
            },
            options: {scale: {ticks: {min: 0, max: 5, stepSize: 1}}, animation: {duration: 1200}}
        });
        // Skill bars
        var barColors = ['#4361ee', '#36d1c4', '#4bb543', '#fca311'];
        var barLabels = ['Technical', 'Communication', 'Teamwork', 'Leadership'];
        var barsHtml = '';
        for (var i = 0; i < radar.length; i++) {
            var val = radar[i];
            var color = barColors[i];
            barsHtml += '<div class="mb-1"><span class="fw-bold">' + barLabels[i] + '</span>' +
                '<div class="progress"><div class="progress-bar" style="width:' + (val*20) + '%;background:' + color + ';">' + val + '/5</div></div></div>';
        }
        document.getElementById('skillBars').innerHTML = barsHtml;
    }
    // Trend chart
    if (trendData) {
        var trend = JSON.parse(trendData);
        new Chart(document.getElementById('performanceTrendChart').getContext('2d'), {
            type: 'line',
            data: {
                labels: trend.dates,
                datasets: [{
                    label: 'Overall Rating',
                    data: trend.ratings,
                    fill: false,
                    borderColor: '#4bb543',
                    backgroundColor: '#4bb543',
                    tension: 0.2,
                    pointRadius: 5,
                    pointBackgroundColor: trend.ratings.map(function(r){ return r >= 4 ? '#4bb543' : (r >= 3 ? '#fca311' : '#ef233c'); })
                }]
            },
            options: {scales: {y: {min: 0, max: 5, stepSize: 1}}, animation: {duration: 1200}}
        });
    }
}
document.addEventListener('DOMContentLoaded', renderPerformanceCharts);
</script>
<!-- Optionally, add a table for past reviews and a self-review/comment box here --> 