-- Fix GoalProgress Table Structure
-- Run this script to ensure the GoalProgress table has all required columns

USE HRmanagementDB;
GO

-- Drop the existing table if it exists (this will remove any data)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'GoalProgress')
BEGIN
    DROP TABLE GoalProgress;
    PRINT 'Dropped existing GoalProgress table';
END
GO

-- Create GoalProgress table for tracking goal updates
CREATE TABLE GoalProgress (
    ProgressId INT IDENTITY(1,1) PRIMARY KEY,
    GoalId INT NOT NULL FOREIGN KEY REFERENCES EmployeeGoals(GoalId),
    ProgressPercentage INT NOT NULL,
    ProgressNotes NVARCHAR(MAX) NULL,
    UpdatedBy NVARCHAR(100) NOT NULL,
    UpdatedDate DATETIME DEFAULT GETDATE()
);
GO

-- Create indexes for better performance
CREATE INDEX IX_GoalProgress_GoalId ON GoalProgress(GoalId);
GO

-- Verify the table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'GoalProgress'
ORDER BY ORDINAL_POSITION;
GO

PRINT 'GoalProgress table created successfully with all required columns!'; 