CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    dept_id INT,
    budget DECIMAL(12,2),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2),
    dept_id INT,
    project_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

INSERT INTO Department VALUES
(1, 'IT', 'Delhi'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Pune'),
(4, 'Marketing', 'Bangalore'),
(5, 'Operations', 'Chennai');

INSERT INTO Project VALUES
(101, 'AI Platform', 1, 500000),
(102, 'Cloud Migration', 1, 350000),
(103, 'Recruitment System', 2, 150000),
(104, 'Financial Analytics', 3, 400000),
(105, 'Digital Marketing', 4, 250000),
(106, 'Supply Chain', 5, 300000),
(107, 'Cyber Security', 1, 450000),
(108, 'Customer Portal', 4, 220000);

INSERT INTO Employee VALUES
(1, 'Rahul', 90000, 1, 101),
(2, 'Amit', 70000, 1, 101),
(3, 'Priya', 65000, 1, 102),
(4, 'Rohan', 62000, 1, 102),
(5, 'Kunal', 58000, 1, 107),
(6, 'Arjun', 76000, 1, 107),
(7, 'Neha', 60000, 2, 103),
(8, 'Rohit', 50000, 2, 103),
(9, 'Ananya', 54000, 2, 103),
(10, 'Pooja', 68000, 2, 103),
(11, 'Vivek', 47000, 2, 103),
(12, 'Anjali', 85000, 3, 104),
(13, 'Vikas', 55000, 3, 104),
(14, 'Meera', 72000, 3, 104),
(15, 'Suresh', 61000, 3, 104),
(16, 'Nitin', 49000, 3, 104),
(17, 'Sneha', 75000, 4, 105),
(18, 'Karan', 52000, 4, 105),
(19, 'Isha', 58000, 4, 105),
(20, 'Manish', 66000, 4, 108),
(21, 'Tanya', 48000, 4, 108),
(22, 'Simran', 57000, 4, 108),
(23, 'Arvind', 80000, 5, 106),
(24, 'Pankaj', 54000, 5, 106),
(25, 'Divya', 62000, 5, 106),
(26, 'Mohit', 51000, 5, 106),
(27, 'Nisha', 59000, 5, 106),
(28, 'Deepak', 73000, 1, 107),
(29, 'Riya', 64000, 2, 103),
(30, 'Varun', 69000, 3, 104);
-- Selection
SELECT emp_id, emp_name, salary
FROM Employee
WHERE salary > 60000;
-- Projection
SELECT emp_name, dept_id
FROM Employee;
-- Aggregate Functions
SELECT COUNT(*) AS Total_Employees,

       AVG(salary) AS Average_Salary,

       MAX(salary) AS Maximum_Salary,

       MIN(salary) AS Minimum_Salary

FROM Employee;
-- Group By
SELECT dept_id,

       COUNT(*) AS Employee_Count,

       AVG(salary) AS Average_Salary

FROM Employee
GROUP BY dept_id;
-- Having
SELECT dept_id, COUNT(*) AS Employee_Count
FROM Employee
GROUP BY dept_id
HAVING COUNT(*) > 5;
-- CASE Expressions
SELECT emp_name, salary,

       CASE

           WHEN salary >= 75000 THEN 'High'

           WHEN salary >= 60000 THEN 'Medium'

           ELSE 'Low'

       END AS Salary_Level

FROM Employee;
-- Order By
SELECT emp_id, emp_name, salary
FROM Employee
ORDER BY salary DESC;