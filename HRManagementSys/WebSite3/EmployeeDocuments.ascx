<%@ Control Language="C#" AutoEventWireup="true" CodeFile="EmployeeDocuments.ascx.cs" Inherits="EmployeeDocuments" %>
<asp:UpdatePanel ID="upDocuments" runat="server">
    <ContentTemplate>
        <!-- Enhanced Document Upload Section -->
        <div class="card shadow border-0 mb-4">
            <div class="card-header bg-gradient-primary text-white" style="background: linear-gradient(90deg, #4361ee 60%, #3f37c9 100%);">
                <h5 class="mb-0"><i class="fas fa-cloud-upload-alt me-2"></i>Upload Documents</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-8">
                        <div class="upload-area p-4 border-2 border-dashed border-primary rounded text-center mb-3" style="background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);">
                            <i class="fas fa-file-upload fa-3x text-primary mb-3"></i>
                            <h6 class="text-primary mb-2">Drag & Drop files here or click to browse</h6>
                            <p class="text-muted mb-3">Supported formats: PDF, DOC, DOCX, XLS, XLSX, JPG, PNG</p>
                            <asp:FileUpload ID="fuDocument" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="upload-form">
                            <div class="mb-3">
                                <label class="form-label fw-bold"><i class="fas fa-tag me-2"></i>Document Name</label>
                                <asp:TextBox ID="txtDocumentName" runat="server" CssClass="form-control form-control-lg" placeholder="Enter document name..." />
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold"><i class="fas fa-folder me-2"></i>Category</label>
                                <select class="form-select form-select-lg">
                                    <option>Personal Documents</option>
                                    <option>Employment Documents</option>
                                    <option>Performance Reviews</option>
                                    <option>Certificates</option>
                                    <option>Other</option>
                                </select>
                            </div>
                            <asp:Button ID="btnUploadDocument" runat="server" Text="Upload Document" CssClass="btn btn-primary btn-lg w-100" OnClick="btnUploadDocument_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Document Statistics -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-success text-white mb-3" style="background: linear-gradient(135deg, #4bb543 0%, #36d1c4 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-file-alt fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Total Documents</h6>
                                <h3 class="mb-0 fw-bold">12</h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 100%"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-info text-white mb-3" style="background: linear-gradient(135deg, #36d1c4 0%, #4361ee 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-file-pdf fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">PDF Files</h6>
                                <h3 class="mb-0 fw-bold">5</h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 42%"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-warning text-white mb-3" style="background: linear-gradient(135deg, #fca311 0%, #ffd93d 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-file-word fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Word Files</h6>
                                <h3 class="mb-0 fw-bold">4</h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 33%"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow border-0 bg-gradient-secondary text-white mb-3" style="background: linear-gradient(135deg, #3f37c9 0%, #36d1c4 100%);">
                    <div class="card-body text-center">
                        <div class="d-flex align-items-center justify-content-center mb-2">
                            <i class="fas fa-file-image fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-0">Images</h6>
                                <h3 class="mb-0 fw-bold">3</h3>
                            </div>
                        </div>
                        <div class="progress bg-white bg-opacity-25" style="height: 6px;">
                            <div class="progress-bar bg-white" style="width: 25%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Document Grid View -->
        <div class="card shadow border-0">
            <div class="card-header bg-gradient-secondary text-white d-flex justify-content-between align-items-center" style="background: linear-gradient(90deg, #3f37c9 60%, #36d1c4 100%);">
                <h5 class="mb-0"><i class="fas fa-folder-open me-2"></i>My Documents</h5>
                <div>
                    <button class="btn btn-light btn-sm me-2" onclick="toggleView()">
                        <i class="fas fa-th-large"></i> Grid
                    </button>
                    <button class="btn btn-light btn-sm">
                        <i class="fas fa-list"></i> List
                    </button>
                </div>
            </div>
            <div class="card-body">
                <!-- Grid View -->
                <div class="row" id="documentGrid">
                    <div class="col-md-3 mb-3">
                        <div class="document-card card h-100 shadow-sm border-0">
                            <div class="card-body text-center">
                                <i class="fas fa-file-pdf fa-3x text-danger mb-3"></i>
                                <h6 class="card-title">Resume.pdf</h6>
                                <p class="text-muted small">Uploaded: Dec 15, 2024</p>
                                <div class="btn-group w-100">
                                    <button class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-download"></i> Download
                                    </button>
                                    <button class="btn btn-outline-danger btn-sm">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="document-card card h-100 shadow-sm border-0">
                            <div class="card-body text-center">
                                <i class="fas fa-file-word fa-3x text-primary mb-3"></i>
                                <h6 class="card-title">Performance Review.docx</h6>
                                <p class="text-muted small">Uploaded: Dec 10, 2024</p>
                                <div class="btn-group w-100">
                                    <button class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-download"></i> Download
                                    </button>
                                    <button class="btn btn-outline-danger btn-sm">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="document-card card h-100 shadow-sm border-0">
                            <div class="card-body text-center">
                                <i class="fas fa-file-image fa-3x text-success mb-3"></i>
                                <h6 class="card-title">Certificate.jpg</h6>
                                <p class="text-muted small">Uploaded: Dec 05, 2024</p>
                                <div class="btn-group w-100">
                                    <button class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-download"></i> Download
                                    </button>
                                    <button class="btn btn-outline-danger btn-sm">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="document-card card h-100 shadow-sm border-0">
                            <div class="card-body text-center">
                                <i class="fas fa-file-excel fa-3x text-success mb-3"></i>
                                <h6 class="card-title">Timesheet.xlsx</h6>
                                <p class="text-muted small">Uploaded: Dec 01, 2024</p>
                                <div class="btn-group w-100">
                                    <button class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-download"></i> Download
                                    </button>
                                    <button class="btn btn-outline-danger btn-sm">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- List View (Hidden by default) -->
                <div id="documentList" style="display: none;">
                    <asp:GridView ID="gvDocuments" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-hover" OnRowCommand="gvDocuments_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="DocumentName" HeaderText="Document Name" />
                            <asp:BoundField DataField="UploadDate" HeaderText="Upload Date" DataFormatString="{0:MMM dd, yyyy}" />
                            <asp:TemplateField HeaderText="Download">
                                <ItemTemplate>
                                    <asp:HyperLink runat="server" NavigateUrl='<%# Eval("FilePath") %>' Text="Download" Target="_blank" CssClass="btn btn-primary btn-sm" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Delete">
                                <ItemTemplate>
                                    <asp:Button runat="server" CommandName="DeleteDoc" CommandArgument='<%# Eval("DocumentId") %>' Text="Delete" CssClass="btn btn-danger btn-sm" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                
                <asp:Label ID="lblNoDocuments" runat="server" CssClass="alert alert-info w-100 text-center my-3" Text="No documents uploaded yet." Visible="false" />
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>

<style>
.bg-gradient-primary { background: linear-gradient(90deg, #4361ee 60%, #3f37c9 100%) !important; }
.bg-gradient-success { background: linear-gradient(135deg, #4bb543 0%, #36d1c4 100%) !important; }
.bg-gradient-info { background: linear-gradient(135deg, #36d1c4 0%, #4361ee 100%) !important; }
.bg-gradient-warning { background: linear-gradient(135deg, #fca311 0%, #ffd93d 100%) !important; }
.bg-gradient-secondary { background: linear-gradient(90deg, #3f37c9 60%, #36d1c4 100%) !important; }
.card { transition: transform 0.2s ease-in-out; }
.card:hover { transform: translateY(-2px); }
.document-card { transition: all 0.3s ease; }
.document-card:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important; }
.upload-area { transition: all 0.3s ease; }
.upload-area:hover { border-color: #4361ee !important; background: linear-gradient(135deg, #f0f8ff 0%, #e6f3ff 100%) !important; }
.border-dashed { border-style: dashed !important; }
.form-control-lg, .form-select-lg { font-size: 1.1rem; }
.btn-group .btn { border-radius: 0; }
.btn-group .btn:first-child { border-top-left-radius: 0.375rem; border-bottom-left-radius: 0.375rem; }
.btn-group .btn:last-child { border-top-right-radius: 0.375rem; border-bottom-right-radius: 0.375rem; }
</style>

<script>
function toggleView() {
    var grid = document.getElementById('documentGrid');
    var list = document.getElementById('documentList');
    
    if (grid.style.display === 'none') {
        grid.style.display = 'flex';
        list.style.display = 'none';
    } else {
        grid.style.display = 'none';
        list.style.display = 'block';
    }
}
</script> 