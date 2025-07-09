<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditEmployee.aspx.cs" Inherits="EditEmployee" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Edit Employee</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server" class="container mt-5 mb-5">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div class="row justify-content-center">
            <div class="col-md-8">
                <h2 class="mb-4">Edit Employee</h2>
                <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                    <div class="alert" id="alertBox" runat="server">
                        <asp:Literal ID="litMessage" runat="server" />
                    </div>
                </asp:Panel>
                <div class="card p-4 shadow-sm">
                    <asp:HiddenField ID="hdnEmployeeId" runat="server" />
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Username <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Password (leave blank to keep current)</label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">First Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Last Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Email <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" required="required"></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Phone Number <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Department <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-select" required="required"></asp:DropDownList>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Job Title <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtJobTitle" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Hire Date <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtHireDate" runat="server" CssClass="form-control" TextMode="Date" required="required"></asp:TextBox>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Birth Date <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtBirthDate" runat="server" CssClass="form-control" TextMode="Date" required="required"></asp:TextBox>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Salary <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtSalary" runat="server" CssClass="form-control" TextMode="Number" step="0.01" required="required"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Status <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" required="required">
                                <asp:ListItem Text="Active" Value="Active" />
                                <asp:ListItem Text="On Leave" Value="On Leave" />
                                <asp:ListItem Text="Inactive" Value="Inactive" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Address <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">City <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">State/Province <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtState" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Postal Code <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtPostalCode" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Gender <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-select" required="required">
                                <asp:ListItem Text="Male" Value="Male" />
                                <asp:ListItem Text="Female" Value="Female" />
                                <asp:ListItem Text="Other" Value="Other" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Emergency Contact Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtEmergencyContact" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Emergency Contact Phone <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtEmergencyPhone" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                        </div>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <a href="Default.aspx" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i> Back to Dashboard</a>
                        <asp:Button ID="btnSave" runat="server" Text="Update Employee" CssClass="btn btn-primary px-4" OnClick="btnSave_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html> 