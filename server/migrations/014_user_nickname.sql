-- Add nickname and employee_id fields to users table
ALTER TABLE users ADD COLUMN nickname VARCHAR(50) NULL AFTER name;
ALTER TABLE users ADD COLUMN employee_id INT NULL;
ALTER TABLE users ADD COLUMN password VARCHAR(255) NULL;
