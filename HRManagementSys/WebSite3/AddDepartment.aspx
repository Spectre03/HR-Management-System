<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddDepartment.aspx.cs" Inherits="WebSite3.AddDepartment" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Add Department - HR System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card shadow-lg">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0"><i class="fas fa-plus me-2"></i>Add New Department</h4>
                        </div>
                        <div class="card-body">
                            <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                                <div id="alertMsg" runat="server"></div>
                            </asp:Panel>
                            <div class="mb-3">
                                <label class="form-label">Department Name <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtDepartmentName" runat="server" CssClass="form-control" required></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Location</label>
                                    <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Head of Department</label>
                                    <asp:TextBox ID="txtHeadOfDepartment" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Vacancy Count</label>
                                    <asp:TextBox ID="txtVacancyCount" runat="server" CssClass="form-control" TextMode="Number" min="0" placeholder="0"></asp:TextBox>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Annual Budget</label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <asp:TextBox ID="txtBudget" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="0.00"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-end">
                                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary me-2" OnClick="btnSave_Click" />
                                <a href="Departments.aspx" class="btn btn-secondary">Cancel</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 