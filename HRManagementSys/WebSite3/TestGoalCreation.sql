-- Test Goal Creation Functionality
-- Run this script to test if the EmployeeGoals table is working correctly

USE HRmanagementDB;
GO

PRINT '=== TESTING GOAL CREATION ===';

-- Test 1: Check if EmployeeGoals table has all required columns
PRINT 'Test 1: Checking EmployeeGoals table structure...';
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'EmployeeGoals'
ORDER BY ORDINAL_POSITION;
GO

-- Test 2: Check if there are any employees to create goals for
PRINT '';
PRINT 'Test 2: Checking available employees...';
SELECT EmployeeId, FirstName + ' ' + LastName AS FullName, Status
FROM Employees
WHERE Status = 'Active';
GO

-- Test 3: Try to insert a test goal
PRINT '';
PRINT 'Test 3: Inserting a test goal...';
DECLARE @TestEmployeeId INT;
SELECT TOP 1 @TestEmployeeId = EmployeeId FROM Employees WHERE Status = 'Active';

IF @TestEmployeeId IS NOT NULL
BEGIN
    INSERT INTO EmployeeGoals (
        EmployeeId, GoalTitle, Category, TargetDate, Priority, 
        GoalDescription, SuccessCriteria, Status, ProgressPercentage, CreatedBy
    ) VALUES (
        @TestEmployeeId,
        'Test Goal - Complete Project Alpha',
        'Project Completion',
        DATEADD(MONTH, 2, GETDATE()),
        'High',
        'This is a test goal to verify the system is working correctly.',
        'Project Alpha is completed and delivered on time.',
        'Active',
        0,
        'Test System'
    );
    
    PRINT 'Test goal inserted successfully!';
    
    -- Show the inserted goal
    SELECT 
        g.GoalId,
        g.GoalTitle,
        g.Category,
        g.TargetDate,
        g.Priority,
        g.Status,
        g.ProgressPercentage,
        e.FirstName + ' ' + e.LastName AS EmployeeName
    FROM EmployeeGoals g
    INNER JOIN Employees e ON g.EmployeeId = e.EmployeeId
    WHERE g.CreatedBy = 'Test System';
    
    -- Clean up test data
    DELETE FROM EmployeeGoals WHERE CreatedBy = 'Test System';
    PRINT 'Test goal cleaned up.';
END
ELSE
BEGIN
    PRINT 'No active employees found to test with.';
END
GO

PRINT '';
PRINT '=== TESTING ATTENDANCE TABLE ===';

-- Test 4: Check if Attendance table has TotalHours column
PRINT 'Test 4: Checking Attendance table for TotalHours column...';
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Attendance' AND COLUMN_NAME = 'TotalHours';
GO

-- Test 5: Check attendance records
PRINT '';
PRINT 'Test 5: Checking attendance records...';
SELECT TOP 5 
    AttendanceId,
    EmployeeId,
    AttendanceDate,
    TimeIn,
    TimeOut,
    TotalHours,
    Status
FROM Attendance
ORDER BY AttendanceDate DESC;
GO

PRINT '';
PRINT 'All tests completed!';
PRINT 'If you see the table structures and test data above, the system is working correctly.'; 