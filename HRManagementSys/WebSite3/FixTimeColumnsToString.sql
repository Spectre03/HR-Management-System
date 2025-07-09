-- Fix TimeIn and TimeOut columns to use NVARCHAR instead of TIME
-- This will eliminate all SQL Server time conversion issues

-- First, check current column types
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Attendance' 
AND COLUMN_NAME IN ('TimeIn', 'TimeOut');

-- Add new columns as NVARCHAR
ALTER TABLE Attendance ADD TimeInNew NVARCHAR(10) NULL;
ALTER TABLE Attendance ADD TimeOutNew NVARCHAR(10) NULL;

-- Copy existing data (if any) to new columns
UPDATE Attendance 
SET TimeInNew = CAST(TimeIn AS NVARCHAR(10)),
    TimeOutNew = CAST(TimeOut AS NVARCHAR(10))
WHERE TimeIn IS NOT NULL AND TimeOut IS NOT NULL;

-- Drop old columns
ALTER TABLE Attendance DROP COLUMN TimeIn;
ALTER TABLE Attendance DROP COLUMN TimeOut;

-- Rename new columns to original names
EXEC sp_rename 'Attendance.TimeInNew', 'TimeIn', 'COLUMN';
EXEC sp_rename 'Attendance.TimeOutNew', 'TimeOut', 'COLUMN';

-- Verify the changes
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Attendance' 
AND COLUMN_NAME IN ('TimeIn', 'TimeOut');

PRINT 'TimeIn and TimeOut columns converted to NVARCHAR successfully!';
PRINT 'No more SQL Server time conversion issues!'; 