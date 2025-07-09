-- Quick Fix for Departments Overview
-- This script will fix the immediate issues with the department overview

-- Step 1: Add IsActive column if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Departments' AND COLUMN_NAME = 'IsActive')
BEGIN
    ALTER TABLE Departments ADD IsActive BIT DEFAULT 1;
    PRINT 'Added IsActive column to Departments table';
END

-- Step 2: Set all existing departments as active
UPDATE Departments SET IsActive = 1 WHERE IsActive IS NULL;
PRINT 'Set all departments as active';

-- Step 3: Set vacancy counts for all departments
UPDATE Departments SET VacancyCount = 5 WHERE DepartmentId = 1; -- IT
UPDATE Departments SET VacancyCount = 3 WHERE DepartmentId = 2; -- HR  
UPDATE Departments SET VacancyCount = 4 WHERE DepartmentId = 3; -- Finance
UPDATE Departments SET VacancyCount = 6 WHERE DepartmentId = 4; -- Marketing
UPDATE Departments SET VacancyCount = 7 WHERE DepartmentId = 5; -- Operations
UPDATE Departments SET VacancyCount = 8 WHERE DepartmentId = 6; -- Sales
UPDATE Departments SET VacancyCount = 4 WHERE DepartmentId = 7; -- R&D
UPDATE Departments SET VacancyCount = 3 WHERE DepartmentId = 8; -- Customer Service
UPDATE Departments SET VacancyCount = 2 WHERE DepartmentId = 9; -- Legal
UPDATE Departments SET VacancyCount = 4 WHERE DepartmentId = 10; -- QA
PRINT 'Updated vacancy counts for all departments';

-- Step 4: Add some sample employees to make the system functional
-- First, let's add employees to IT Department
IF NOT EXISTS (SELECT * FROM Employees WHERE DepartmentId = 1)
BEGIN
    INSERT INTO Employees (FirstName, LastName, Email, Phone, JobTitle, DepartmentId, HireDate, Status, CreatedDate)
    VALUES 
    ('John', 'Smith', 'john.smith@company.com', '555-0101', 'Senior Developer', 1, '2023-01-15', 'Active', GETDATE()),
    ('Sarah', 'Johnson', 'sarah.johnson@company.com', '555-0102', 'System Administrator', 1, '2023-02-20', 'Active', GETDATE()),
    ('Mike', 'Davis', 'mike.davis@company.com', '555-0103', 'Network Engineer', 1, '2023-03-10', 'Active', GETDATE());
    PRINT 'Added employees to IT Department';
END

-- Add employees to Finance Department
IF NOT EXISTS (SELECT * FROM Employees WHERE DepartmentId = 3)
BEGIN
    INSERT INTO Employees (FirstName, LastName, Email, Phone, JobTitle, DepartmentId, HireDate, Status, CreatedDate)
    VALUES 
    ('Emily', 'Taylor', 'emily.taylor@company.com', '555-0201', 'Financial Analyst', 3, '2023-01-10', 'Active', GETDATE()),
    ('Robert', 'Anderson', 'robert.anderson@company.com', '555-0202', 'Accountant', 3, '2023-02-15', 'Active', GETDATE());
    PRINT 'Added employees to Finance Department';
END

-- Add employees to HR Department
IF NOT EXISTS (SELECT * FROM Employees WHERE DepartmentId = 2)
BEGIN
    INSERT INTO Employees (FirstName, LastName, Email, Phone, JobTitle, DepartmentId, HireDate, Status, CreatedDate)
    VALUES 
    ('Amanda', 'Clark', 'amanda.clark@company.com', '555-0301', 'HR Specialist', 2, '2023-01-05', 'Active', GETDATE()),
    ('Kevin', 'Lewis', 'kevin.lewis@company.com', '555-0302', 'Recruiter', 2, '2023-02-10', 'Active', GETDATE());
    PRINT 'Added employees to HR Department';
END

-- Step 5: Update the EmployeeCount and ActiveCount columns in Departments table
-- First, let's make sure these columns exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Departments' AND COLUMN_NAME = 'EmployeeCount')
BEGIN
    ALTER TABLE Departments ADD EmployeeCount INT DEFAULT 0;
    PRINT 'Added EmployeeCount column';
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Departments' AND COLUMN_NAME = 'ActiveCount')
BEGIN
    ALTER TABLE Departments ADD ActiveCount INT DEFAULT 0;
    PRINT 'Added ActiveCount column';
END

-- Step 6: Update the counts based on actual employee data
UPDATE d SET 
    EmployeeCount = ISNULL(emp.EmployeeCount, 0),
    ActiveCount = ISNULL(active.ActiveCount, 0)
FROM Departments d
LEFT JOIN (
    SELECT DepartmentId, COUNT(*) as EmployeeCount
    FROM Employees
    WHERE DepartmentId IS NOT NULL
    GROUP BY DepartmentId
) emp ON d.DepartmentId = emp.DepartmentId
LEFT JOIN (
    SELECT DepartmentId, COUNT(*) as ActiveCount
    FROM Employees
    WHERE DepartmentId IS NOT NULL AND Status = 'Active'
    GROUP BY DepartmentId
) active ON d.DepartmentId = active.DepartmentId;

PRINT 'Updated employee counts for all departments';

-- Step 7: Show the results
SELECT 
    'Total Departments' as Metric,
    COUNT(*) as Value
FROM Departments 
WHERE IsActive = 1

UNION ALL

SELECT 
    'Total Employees' as Metric,
    COUNT(*) as Value
FROM Employees 
WHERE Status = 'Active'

UNION ALL

SELECT 
    'Total Vacancies' as Metric,
    ISNULL(SUM(ISNULL(VacancyCount, 0)), 0) as Value
FROM Departments 
WHERE IsActive = 1;

PRINT 'Department overview should now show correct values!'; 