<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestDepartments.aspx.cs" Inherits="WebSite3.TestDepartments" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Test Departments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container mt-4">
            <h2>Department Test Page</h2>
            
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card bg-primary text-white">
                        <div class="card-body">
                            <h5>Total Departments</h5>
                            <h3><asp:Label ID="lblTotalDepts" runat="server" Text="0"></asp:Label></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card bg-success text-white">
                        <div class="card-body">
                            <h5>Total Employees</h5>
                            <h3><asp:Label ID="lblTotalEmps" runat="server" Text="0"></asp:Label></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card bg-info text-white">
                        <div class="card-body">
                            <h5>Active Departments</h5>
                            <h3><asp:Label ID="lblActiveDepts" runat="server" Text="0"></asp:Label></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card bg-warning text-white">
                        <div class="card-body">
                            <h5>Total Vacancies</h5>
                            <h3><asp:Label ID="lblTotalVacancies" runat="server" Text="0"></asp:Label></h3>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-12">
                    <h4>Department List</h4>
                    <asp:GridView ID="gvDepartments" runat="server" CssClass="table table-striped" 
                        AutoGenerateColumns="False">
                        <Columns>
                            <asp:BoundField DataField="DepartmentId" HeaderText="ID" />
                            <asp:BoundField DataField="DepartmentName" HeaderText="Name" />
                            <asp:BoundField DataField="EmployeeCount" HeaderText="Employees" />
                            <asp:BoundField DataField="ActiveCount" HeaderText="Active" />
                            <asp:BoundField DataField="VacancyCount" HeaderText="Vacancies" />
                            <asp:BoundField DataField="Budget" HeaderText="Budget" DataFormatString="{0:C}" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            
            <asp:Button ID="btnRefresh" runat="server" Text="Refresh Data" CssClass="btn btn-primary" OnClick="btnRefresh_Click" />
        </div>
    </form>
</body>
</html> 