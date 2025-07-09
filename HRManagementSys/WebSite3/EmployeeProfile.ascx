<%@ Control Language="C#" AutoEventWireup="true" CodeFile="EmployeeProfile.ascx.cs" Inherits="EmployeeProfile" %>
<asp:UpdatePanel ID="upProfile" runat="server">
    <ContentTemplate>
        <!-- Enhanced Profile Header Card -->
        <div class="card mb-4 shadow-lg border-0" style="background: linear-gradient(135deg, #6e8efb 0%, #a777e3 100%); color: #fff;">
            <div class="card-body p-4">
                <div class="row align-items-center">
                    <div class="col-md-3 text-center">
                        <div class="position-relative d-inline-block">
                            <asp:Image ID="imgProfilePicture" runat="server" CssClass="rounded-circle border border-4 border-white shadow-lg" Width="150" Height="150" Style="object-fit: cover;" />
                            <div class="position-absolute bottom-0 end-0">
                                <asp:FileUpload ID="fuProfilePicture" runat="server" CssClass="form-control" Style="width:120px; font-size: 0.8rem;" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-9">
                        <div class="row">
                            <div class="col-md-8">
                                <h2 class="fw-bold mb-2"><asp:Literal ID="litProfileName" runat="server" /></h2>
                                <div class="row mb-2">
                                    <div class="col-md-6">
                                        <div class="d-flex align-items-center mb-1">
                                            <i class="fas fa-envelope me-2 text-warning"></i>
                                            <span><asp:Literal ID="litProfileEmail" runat="server" /></span>
                                        </div>
                                        <div class="d-flex align-items-center mb-1">
                                            <i class="fas fa-phone me-2 text-info"></i>
                                            <span><asp:Literal ID="litProfilePhone" runat="server" /></span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="d-flex align-items-center mb-1">
                                            <i class="fas fa-building me-2 text-success"></i>
                                            <span><asp:Literal ID="litProfileDepartment" runat="server" /></span>
                                        </div>
                                        <div class="d-flex align-items-center mb-1">
                                            <i class="fas fa-briefcase me-2 text-primary"></i>
                                            <span><asp:Literal ID="litProfilePosition" runat="server" /></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-md-12">
                                        <div class="d-flex align-items-center mb-1">
                                            <i class="fas fa-map-marker-alt me-2 text-danger"></i>
                                            <span><asp:Literal ID="litProfileAddress" runat="server" />, <asp:Literal ID="litProfileCity" runat="server" />, <asp:Literal ID="litProfileState" runat="server" /> <asp:Literal ID="litProfileZip" runat="server" /></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <div class="d-flex align-items-center mb-1">
                                            <i class="fas fa-venus-mars me-2 text-pink"></i>
                                            <span><asp:Literal ID="litProfileGender" runat="server" /></span>
                                        </div>
                                        <div class="d-flex align-items-center mb-1">
                                            <i class="fas fa-calendar-alt me-2 text-warning"></i>
                                            <span>Hire Date: <asp:Literal ID="litProfileHireDate" runat="server" /></span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="d-flex align-items-center mb-1">
                                            <i class="fas fa-user-shield me-2 text-info"></i>
                                            <span>Emergency: <asp:Literal ID="litProfileEmergencyContact" runat="server" /> (<asp:Literal ID="litProfileEmergencyPhone" runat="server" />)</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <a href="#" class="btn btn-light btn-sm me-2" id="emailLink">
                                        <i class="fab fa-google me-1"></i> Email
                                    </a>
                                    <a href="#" class="btn btn-light btn-sm me-2" id="phoneLink">
                                        <i class="fab fa-whatsapp me-1"></i> WhatsApp
                                    </a>
                                    <a href="#" class="btn btn-light btn-sm" id="linkedinLink">
                                        <i class="fab fa-linkedin me-1"></i> LinkedIn
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-4 text-end">
                                <asp:Button ID="btnEditProfile" runat="server" Text="Edit Profile" CssClass="btn btn-light text-primary fw-bold px-4 py-2" OnClick="btnEditProfile_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-success text-white mb-3" style="background: linear-gradient(135deg, #4bb543 0%, #36d1c4 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-calendar-check fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Total Leaves</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litProfileTotalLeaves" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 75%"></div>
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
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litProfileAttendanceRate" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 92%"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-warning text-white mb-3" style="background: linear-gradient(135deg, #fca311 0%, #ffd93d 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-star fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Performance</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litProfilePerformance" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 85%"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-info text-white mb-3" style="background: linear-gradient(135deg, #36d1c4 0%, #4361ee 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-file-alt fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Documents</h6>
                                <h3 class="mb-0 fw-bold"><asp:Literal ID="litProfileDocuments" runat="server" /></h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 60%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Profile Edit Form -->
        <asp:Panel ID="pnlEditProfile" runat="server" Visible="false" CssClass="card mb-4 shadow border-0">
            <div class="card-header bg-gradient-secondary text-white" style="background: linear-gradient(90deg, #3f37c9 60%, #36d1c4 100%);">
                <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i>Edit Profile Information</h5>
            </div>
            <div class="card-body bg-light">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold"><i class="fas fa-user me-2"></i>First Name</label>
                            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control form-control-lg" placeholder="First Name" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold"><i class="fas fa-user me-2"></i>Last Name</label>
                            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control form-control-lg" placeholder="Last Name" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold"><i class="fas fa-envelope me-2"></i>Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-lg" placeholder="Email" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold"><i class="fas fa-phone me-2"></i>Phone</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control form-control-lg" placeholder="Phone" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold"><i class="fas fa-building me-2"></i>Department</label>
                            <asp:TextBox ID="txtDepartment" runat="server" CssClass="form-control form-control-lg" placeholder="Department" />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold"><i class="fas fa-briefcase me-2"></i>Job Title</label>
                            <asp:TextBox ID="txtJobTitle" runat="server" CssClass="form-control form-control-lg" placeholder="Job Title" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold"><i class="fas fa-venus-mars me-2"></i>Gender</label>
                            <asp:TextBox ID="txtGender" runat="server" CssClass="form-control form-control-lg" placeholder="Gender" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold"><i class="fas fa-calendar me-2"></i>Hire Date</label>
                            <asp:TextBox ID="txtHireDate" runat="server" CssClass="form-control form-control-lg" placeholder="Hire Date" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold"><i class="fas fa-user-shield me-2"></i>Emergency Contact</label>
                            <asp:TextBox ID="txtEmergencyContact" runat="server" CssClass="form-control form-control-lg" placeholder="Emergency Contact" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold"><i class="fas fa-phone me-2"></i>Emergency Phone</label>
                            <asp:TextBox ID="txtEmergencyPhone" runat="server" CssClass="form-control form-control-lg" placeholder="Emergency Phone" />
                        </div>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-12">
                        <h6 class="fw-bold mb-3"><i class="fas fa-map-marker-alt me-2"></i>Address Information</h6>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Address</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control form-control-lg" placeholder="Address" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">City</label>
                            <asp:TextBox ID="txtCity" runat="server" CssClass="form-control form-control-lg" placeholder="City" />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">State</label>
                            <asp:TextBox ID="txtState" runat="server" CssClass="form-control form-control-lg" placeholder="State" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Zip Code</label>
                            <asp:TextBox ID="txtZip" runat="server" CssClass="form-control form-control-lg" placeholder="Zip Code" />
                        </div>
                    </div>
                </div>
                <div class="text-end">
                    <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="btn btn-success btn-lg px-4 me-2" OnClick="btnSaveProfile_Click" />
                    <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" CssClass="btn btn-secondary btn-lg px-4" OnClick="btnCancelEdit_Click" />
                </div>
            </div>
        </asp:Panel>
        <asp:Label ID="lblProfileToast" runat="server" CssClass="d-none" />
    </ContentTemplate>
</asp:UpdatePanel>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<style>
.bg-gradient-success { background: linear-gradient(135deg, #4bb543 0%, #36d1c4 100%) !important; }
.bg-gradient-primary { background: linear-gradient(135deg, #4361ee 0%, #3f37c9 100%) !important; }
.bg-gradient-warning { background: linear-gradient(135deg, #fca311 0%, #ffd93d 100%) !important; }
.bg-gradient-info { background: linear-gradient(135deg, #36d1c4 0%, #4361ee 100%) !important; }
.bg-gradient-secondary { background: linear-gradient(90deg, #3f37c9 60%, #36d1c4 100%) !important; }
.card { transition: transform 0.2s ease-in-out; }
.card:hover { transform: translateY(-2px); }
.form-control-lg { font-size: 1.1rem; }
.text-pink { color: #e91e63 !important; }
</style>

<script>
    function showProfileToast(msg, type) {
        toastr.options = { 
            "positionClass": "toast-bottom-right", 
            "timeOut": "3000",
            "progressBar": true,
            "closeButton": true
        };
        toastr[type](msg);
    }
</script> 