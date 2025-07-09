<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test.aspx.cs" Inherits="Test" %>
<%@ Register Src="~/EmployeeProfile.ascx" TagName="EmployeeProfile" TagPrefix="uc" %>
<%@ Register Src="~/EmployeePerformance.ascx" TagName="EmployeePerformance" TagPrefix="uc" %>
<%@ Register Src="~/employeeLeavemanagement.ascx" TagName="EmployeeLeaveManagement" TagPrefix="uc" %>
<%@ Register Src="~/EmployeeDocuments.ascx" TagName="EmployeeDocuments" TagPrefix="uc" %>
<%@ Register Src="~/EmployeeAttendance.ascx" TagName="EmployeeAttendance" TagPrefix="uc" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Test Page - User Controls</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div class="container mt-4">
            <h1>User Control Test Page</h1>
            <p>This page tests all user controls to ensure they compile and work properly.</p>
            
            <div class="row">
                <div class="col-12 mb-4">
                    <h3>Employee Profile Control</h3>
                    <uc:EmployeeProfile ID="EmployeeProfile" runat="server" />
                </div>
                
                <div class="col-12 mb-4">
                    <h3>Employee Attendance Control</h3>
                    <uc:EmployeeAttendance ID="EmployeeAttendance" runat="server" />
                </div>
                
                <div class="col-12 mb-4">
                    <h3>Employee Leave Management Control</h3>
                    <uc:EmployeeLeaveManagement ID="EmployeeLeaveManagement" runat="server" />
                </div>
                
                <div class="col-12 mb-4">
                    <h3>Employee Performance Control</h3>
                    <uc:EmployeePerformance ID="EmployeePerformance" runat="server" />
                </div>
                
                <div class="col-12 mb-4">
                    <h3>Employee Documents Control</h3>
                    <uc:EmployeeDocuments ID="EmployeeDocuments" runat="server" />
                </div>
            </div>
        </div>
    </form>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 