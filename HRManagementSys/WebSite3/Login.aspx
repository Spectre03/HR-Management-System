<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            background: linear-gradient(135deg, #4361ee 0%, #3f37c9 100%);
            min-height: 100vh;
        }
        .login-container {
            max-width: 400px;
            margin: 80px auto;
            padding: 36px 32px 28px 32px;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(67,97,238,0.18);
            animation: fadeIn 0.6s;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(40px);}
            to { opacity: 1; transform: translateY(0);}
        }
        .login-header {
            background: linear-gradient(90deg, #4361ee 70%, #3f37c9 100%);
            color: #fff;
            border-radius: 10px;
            padding: 18px 0 10px 0;
            margin-bottom: 32px;
            box-shadow: 0 2px 8px rgba(67,97,238,0.10);
        }
        .login-header .fa-user-shield {
            font-size: 2.5rem;
            margin-bottom: 8px;
            color: #fff;
        }
        .login-container .form-label {
            font-weight: 500;
        }
        .login-container .btn-primary {
            background: #4361ee;
            border: none;
            font-weight: 600;
            letter-spacing: 1px;
        }
        .login-container .btn-primary:hover {
            background: #3f37c9;
        }
        .login-footer {
            margin-top: 18px;
            text-align: center;
            color: #888;
            font-size: 0.95rem;
        }
    </style>
</head>
<body>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="login-header text-center">
                <i class="fa-solid fa-user-shield"></i>
                <h3 style="margin-bottom: 0;">HR Management Login</h3>
                <div style="font-size: 1rem; font-weight: 400;">Sign in to continue</div>
            </div>
            <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-none" EnableViewState="false"></asp:Label>
            <div class="mb-3">
                <label for="ddlRole" class="form-label">Login as</label>
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select">
                    <asp:ListItem Text="Admin" Value="Admin" />
                    <asp:ListItem Text="Employee" Value="Employee" />
                </asp:DropDownList>
            </div>
            <div class="mb-3">
                <label for="txtUsername" class="form-label">Username</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" required="true"></asp:TextBox>
            </div>
            <div class="mb-3">
                <label for="txtPassword" class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" required="true"></asp:TextBox>
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary w-100" OnClick="btnLogin_Click" />
            <div class="login-footer">
                &copy; <%= DateTime.Now.Year %> HR Management System
            </div>
        </div>
    </form>
</body>
</html>