CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2),
    dept_id INT,
    manager_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (manager_id) REFERENCES Employee(emp_id)
);

INSERT INTO Department VALUES
(1, 'IT', 'Delhi'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Pune');

INSERT INTO Employee VALUES
(1, 'Rahul', 90000, 1, NULL),
(2, 'Amit', 70000, 1, 1),
(3, 'Priya', 65000, 1, 1),
(4, 'Neha', 60000, 2, NULL),
(5, 'Rohit', 50000, 2, 4),
(6, 'Anjali', 85000, 3, NULL),
(7, 'Vikas', 55000, 3, 6);

-- Department Salary Summary View
CREATE VIEW DepartmentSalarySummary AS
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS Employee_Count,
    AVG(e.salary) AS Average_Salary,
    SUM(e.salary) AS Total_Salary
FROM Department d
LEFT JOIN Employee e
ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

SELECT *
FROM DepartmentSalarySummary;

-- Employee Hierarchy View
CREATE VIEW EmployeeHierarchy AS
SELECT
    e.emp_id,
    e.emp_name AS Employee,
    e.salary,
    m.emp_name AS Manager
FROM Employee e
LEFT JOIN Employee m
ON e.manager_id = m.emp_id;

SELECT *
FROM EmployeeHierarchy;

-- Test Updatability of Employee Hierarchy View
UPDATE EmployeeHierarchy
SET salary = salary + 1000
WHERE emp_id = 2;

SELECT *
FROM EmployeeHierarchy
WHERE emp_id = 2;

-- Test Updatability of Salary Summary View
UPDATE DepartmentSalarySummary
SET Average_Salary = Average_Salary + 1000
WHERE dept_id = 1;

-- Recursive CTE for Reporting Chains
WITH RECURSIVE ReportingChain AS (
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS Level,
        CAST(emp_name AS CHAR(200)) AS Reporting_Chain
    FROM Employee
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        rc.Level + 1,
        CONCAT(rc.Reporting_Chain, ' -> ', e.emp_name)
    FROM Employee e
    INNER JOIN ReportingChain rc
    ON e.manager_id = rc.emp_id
)
SELECT
    emp_id,
    emp_name,
    manager_id,
    Level,
    Reporting_Chain
FROM ReportingChain
ORDER BY Reporting_Chain;