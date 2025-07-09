<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UpdatePasswordHashes.aspx.cs" Inherits="UpdatePasswordHashes" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Update Password Hashes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body style="background-color: #f5f7fb;">
    <form id="form1" runat="server" class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-warning text-dark">
                        <h4>Update Password Hashes</h4>
                    </div>
                    <div class="card-body">
                        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert" role="alert">
                            <asp:Literal ID="litMessage" runat="server" />
                        </asp:Panel>
                        
                        <p class="text-muted">
                            This utility will update existing employee password hashes from Base64 format to hexadecimal format 
                            to match the login system. This is needed because there was a mismatch in hashing methods.
                        </p>
                        
                        <div class="mb-3">
                            <label class="form-label">Test Password (to verify hashing works):</label>
                            <asp:TextBox ID="txtTestPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter a test password"></asp:TextBox>
                        </div>
                        
                        <div class="mb-3">
                            <asp:Button ID="btnTestHash" runat="server" Text="Test Hash" CssClass="btn btn-info" OnClick="btnTestHash_Click" />
                        </div>
                        
                        <div class="mb-3">
                            <asp:Label ID="lblTestResult" runat="server" CssClass="form-text"></asp:Label>
                        </div>
                        
                        <hr />
                        
                        <div class="mb-3">
                            <asp:Button ID="btnUpdateHashes" runat="server" Text="Update All Password Hashes" CssClass="btn btn-warning" OnClick="btnUpdateHashes_Click" />
                        </div>
                        
                        <div class="mt-3">
                            <a href="Default.aspx" class="btn btn-secondary">Back to Dashboard</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html> 