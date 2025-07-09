# HR Management System (ASP.NET)

A modern, feature-rich HR management web application built with ASP.NET Web Forms and SQL Server. Includes employee management, goal tracking, attendance, performance evaluation, notifications, and an integrated AI chatbot for admin support.

## Features
- Employee profile and goal management
- Attendance and leave tracking
- Performance evaluation and reporting
- Department and role management
- Notification system (Email/SMS)
- Modern, glowing UI with responsive design
- Admin settings panel with avatar upload
- AI-powered chatbot (OpenAI integration)
- Secure authentication and password policies
- Audit logs and support section

## Prerequisites
- Windows OS
- Visual Studio 2015 or later
- .NET Framework 4.5+
- SQL Server (Express or higher)

## Getting Started

### 1. Clone the Repository
```
git clone <your-repo-url>
```

### 2. Open in Visual Studio
- Open the `.sln` file in Visual Studio.

### 3. Restore NuGet Packages
- Right-click the solution > Restore NuGet Packages.

### 4. Database Setup
- Use the provided `HRDatabase.sql` file to create the database and tables.
- Open SQL Server Management Studio (SSMS).
- Run the script:
  - Right-click Databases > New Database > Name: `HRManagement`
  - Open `HRDatabase.sql` and execute it on the new database.
- Update your `Web.config` connection string if needed:
  ```xml
  <connectionStrings>
    <add name="HRConnectionString" connectionString="Data Source=.;Initial Catalog=HRManagement;Integrated Security=True" providerName="System.Data.SqlClient" />
  </connectionStrings>
  ```

### 5. Run the Project
- Press F5 or click Start in Visual Studio.
- Login as Admin (default credentials in the database script).

## AI Chatbot Setup
- Get an OpenAI API key from https://platform.openai.com/
- Add your API key to the appropriate backend config or code section.
- The chatbot is available in the admin panel as a floating widget.

## Customization
- Update company info, logo, and settings in the Settings panel.
- Modify notification templates as needed.
- Add/modify employees, departments, and goals via the UI.

## Troubleshooting
- If you see SQL or C# errors, ensure your database schema matches the provided script.
- For C# 6+ syntax errors, use string.Format and classic null checks.
- For chatbot issues, check your API key and network access.

## License
MIT or your chosen license. 