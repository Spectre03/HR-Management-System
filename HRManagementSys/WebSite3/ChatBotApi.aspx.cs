using System;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.Script.Serialization;
using System.Threading.Tasks;
using System.Collections.Generic;

public partial class ChatBotApi : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        HandleRequestAsync().GetAwaiter().GetResult();
    }

    private async Task HandleRequestAsync()
    {
        Response.Clear();
        Response.ContentType = "text/plain";
        try
        {
            if (Request.HttpMethod != "POST")
            {
                Response.StatusCode = 405;
                Response.Write("Method Not Allowed");
                return;
            }
            string userMessage = Request.Form["message"];
            if (string.IsNullOrWhiteSpace(userMessage))
            {
                Response.StatusCode = 400;
                Response.Write("No message provided.");
                return;
            }
            
            // Use local HR Manager assistant instead of external API
            string aiResponse = GetHRManagerResponse(userMessage);
            Response.Write(aiResponse);
        }
        catch (Exception ex)
        {
            Response.StatusCode = 500;
            Response.Write("Error: " + ex.Message);
            System.Diagnostics.Debug.WriteLine("ChatBotApi Exception: " + ex.Message);
        }
        Response.End();
    }

    private string GetHRManagerResponse(string userMessage)
    {
        string message = userMessage.ToLower().Trim();
        
        // HR Manager-specific responses
        if (message.Contains("hello") || message.Contains("hi") || message.Contains("hey"))
        {
            return "Hello! I'm your HR Management Assistant. How can I help you manage your workforce today? I can assist with:\n- Employee management and oversight\n- Leave request approvals\n- Performance evaluations\n- Attendance monitoring\n- Department management\n- Reports and analytics";
        }
        
        if (message.Contains("employee") || message.Contains("staff") || message.Contains("team"))
        {
            return "Employee Management:\n\n- Add Employee: Go to Employee Management -> Add Employee\n- Edit Employee: Use the edit button in employee list\n- View Employee: Check employee profiles and statistics\n- Employee List: View all employees with search and filter\n- Employee Status: Monitor active, inactive, and terminated employees\n- Department Assignment: Assign employees to departments\n\nYou can also track employee performance, attendance, and leave history.";
        }
        
        if (message.Contains("leave") || message.Contains("approval") || message.Contains("time off"))
        {
            return "Leave Request Management:\n\n- Pending Requests: Check leave requests awaiting approval\n- Approve/Deny: Review employee leave requests with reasons\n- Leave Balance: Monitor employee leave balances\n- Leave History: View past leave requests and approvals\n- Leave Policies: Set and manage leave policies\n- Emergency Leave: Handle urgent leave requests\n\nBest Practice: Review requests within 24-48 hours and provide clear feedback.";
        }
        
        if (message.Contains("attendance") || message.Contains("time tracking") || message.Contains("work hours"))
        {
            return "Attendance Management:\n\n- Daily Monitoring: Check employee daily work submissions\n- Time Tracking: Review time in/out and work hours\n- Attendance Reports: Generate attendance reports by department/employee\n- Late Arrivals: Monitor and address late arrivals\n- Absenteeism: Track patterns and address issues\n- Work Quality: Review employee task completion and challenges\n- Overtime: Monitor and approve overtime hours\n\nUse attendance data for performance reviews and policy enforcement.";
        }
        
        if (message.Contains("performance") || message.Contains("review") || message.Contains("evaluation"))
        {
            return "Performance Management:\n\n- Conduct Reviews: Schedule and conduct employee performance reviews\n- Set Goals: Assign and track employee goals\n- Skill Assessment: Evaluate technical, communication, teamwork, leadership skills\n- Performance History: Review past performance data\n- Improvement Plans: Create development plans for underperforming employees\n- Recognition: Acknowledge high performers\n- Performance Reports: Generate performance analytics\n\nConduct quarterly reviews and annual appraisals for comprehensive evaluation.";
        }
        
        if (message.Contains("department") || message.Contains("team") || message.Contains("division"))
        {
            return "Department Management:\n\n- Create Departments: Add new departments and divisions\n- Assign Managers: Designate department heads\n- Employee Assignment: Move employees between departments\n- Department Reports: Generate department-specific reports\n- Department Performance: Track department metrics and KPIs\n- Budget Management: Monitor department budgets and resources\n- Department Policies: Set department-specific policies\n\nMaintain clear organizational structure and reporting lines.";
        }
        
        if (message.Contains("report") || message.Contains("analytics") || message.Contains("data"))
        {
            return "Reports and Analytics:\n\n- Employee Reports: Generate employee lists, profiles, and statistics\n- Attendance Reports: Monthly/quarterly attendance summaries\n- Performance Reports: Team and individual performance analytics\n- Leave Reports: Leave balance and usage reports\n- Department Reports: Department-wise employee and performance data\n- Custom Reports: Create custom reports based on specific criteria\n- Export Data: Export reports to Excel/PDF for presentations\n\nUse reports for strategic decision-making and compliance requirements.";
        }
        
        if (message.Contains("help") || message.Contains("support") || message.Contains("assist"))
        {
            return "I'm here to help you manage your HR operations! Here are the main areas I can assist with:\n\nEmployee Management - Add, edit, and oversee employees\nLeave Management - Approve and manage leave requests\nAttendance Monitoring - Track work hours and productivity\nPerformance Management - Conduct reviews and evaluations\nDepartment Management - Organize teams and structure\nReports & Analytics - Generate insights and reports\n\nJust ask about any of these topics for detailed guidance!";
        }
        
        if (message.Contains("thank") || message.Contains("thanks"))
        {
            return "You're welcome! I'm here to support your HR management responsibilities. Feel free to ask about employee management, performance reviews, leave approvals, or any other HR administrative tasks. Have a productive day!";
        }
        
        if (message.Contains("bye") || message.Contains("goodbye") || message.Contains("see you"))
        {
            return "Goodbye! Don't hesitate to reach out if you need assistance with any HR management tasks. Good luck with your workforce management!";
        }
        
        // Default response for unrecognized queries
        return "I understand you're asking about '" + userMessage + "'. As an HR Management Assistant, I can help you with:\n\n- Employee management and oversight\n- Leave request approvals and management\n- Performance evaluations and goal setting\n- Attendance monitoring and reporting\n- Department organization and management\n- HR policy development and compliance\n\nCould you please rephrase your question in terms of HR management tasks? Or type 'help' to see what I can assist with.";
    }
} 