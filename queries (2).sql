-- =========================================================
-- CREATE DEPARTMENT TABLE
-- =========================================================

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);


-- =========================================================
-- CREATE PROJECT TABLE
-- =========================================================

CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    dept_id INT,
    budget DECIMAL(12,2),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);


-- =========================================================
-- CREATE EMPLOYEE TABLE
-- =========================================================

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2),
    dept_id INT,
    project_id INT,
    manager_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id),
    FOREIGN KEY (manager_id) REFERENCES Employee(emp_id)
);


-- =========================================================
-- INSERT DEPARTMENT DATA
-- =========================================================

INSERT INTO Department VALUES
(1, 'IT', 'Delhi'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Pune'),
(4, 'Marketing', 'Bangalore'),
(5, 'Operations', 'Chennai');


-- =========================================================
-- INSERT PROJECT DATA
-- =========================================================

INSERT INTO Project VALUES
(101, 'AI Platform', 1, 500000),
(102, 'Cloud Migration', 1, 350000),
(103, 'Recruitment System', 2, 150000),
(104, 'Financial Analytics', 3, 400000),
(105, 'Digital Marketing', 4, 250000),
(106, 'Supply Chain', 5, 300000),
(107, 'Cyber Security', 1, 450000),
(108, 'Customer Portal', 4, 220000);


-- =========================================================
-- INSERT EMPLOYEE DATA
-- =========================================================

INSERT INTO Employee VALUES
(1, 'Rahul', 90000, 1, 101, NULL),
(2, 'Amit', 70000, 1, 101, 1),
(3, 'Priya', 65000, 1, 102, 1),
(4, 'Rohan', 62000, 1, 102, 1),
(5, 'Kunal', 58000, 1, 107, 1),
(6, 'Arjun', 76000, 1, 107, 1),

(7, 'Neha', 60000, 2, 103, NULL),
(8, 'Rohit', 50000, 2, 103, 7),
(9, 'Ananya', 54000, 2, 103, 7),
(10, 'Pooja', 68000, 2, 103, 7),
(11, 'Vivek', 47000, 2, 103, 7),

(12, 'Anjali', 85000, 3, 104, NULL),
(13, 'Vikas', 55000, 3, 104, 12),
(14, 'Meera', 72000, 3, 104, 12),
(15, 'Suresh', 61000, 3, 104, 12),
(16, 'Nitin', 49000, 3, 104, 12),

(17, 'Sneha', 75000, 4, 105, NULL),
(18, 'Karan', 52000, 4, 105, 17),
(19, 'Isha', 58000, 4, 105, 17),
(20, 'Manish', 66000, 4, 108, 17),
(21, 'Tanya', 48000, 4, 108, 17),
(22, 'Simran', 57000, 4, 108, 17),

(23, 'Arvind', 80000, 5, 106, NULL),
(24, 'Pankaj', 54000, 5, 106, 23),
(25, 'Divya', 62000, 5, 106, 23),
(26, 'Mohit', 51000, 5, 106, 23),
(27, 'Nisha', 59000, 5, 106, 23),

(28, 'Deepak', 73000, 1, 107, 1),
(29, 'Riya', 64000, 2, 103, 7),
(30, 'Varun', 69000, 3, 104, 12);


-- =========================================================
-- INNER JOIN
-- =========================================================

SELECT
    e.emp_id,
    e.emp_name,
    e.salary,
    d.dept_name
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id;


-- =========================================================
--  LEFT JOIN
-- =========================================================

SELECT
    d.dept_id,
    d.dept_name,
    e.emp_name,
    e.salary
FROM Department d
LEFT JOIN Employee e
    ON d.dept_id = e.dept_id;


-- =========================================================
-- SELF JOIN
-- =========================================================

SELECT
    e.emp_name AS Employee,
    m.emp_name AS Manager
FROM Employee e
LEFT JOIN Employee m
    ON e.manager_id = m.emp_id;


-- =========================================================
-- THREE-WAY JOIN
-- =========================================================

SELECT
    e.emp_name,
    d.dept_name,
    p.project_name,
    p.budget
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id
INNER JOIN Project p
    ON e.project_id = p.project_id;


-- =========================================================
-- CORRELATED SUBQUERY
-- =========================================================

SELECT
    e.emp_id,
    e.emp_name,
    e.salary,
    e.dept_id
FROM Employee e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e.dept_id
);


-- =========================================================
-- EXISTS
-- =========================================================

SELECT
    d.dept_id,
    d.dept_name
FROM Department d
WHERE EXISTS (
    SELECT 1
    FROM Employee e
    WHERE e.dept_id = d.dept_id
);


-- =========================================================
-- SIMULATED INTERSECT USING EXISTS
-- =========================================================

SELECT
    e.emp_id,
    e.emp_name
FROM Employee e
WHERE e.salary > 60000
AND EXISTS (
    SELECT 1
    FROM Project p
    WHERE p.project_id = e.project_id
    AND p.budget > 300000
);


-- =========================================================
--  SIMULATED INTERSECT USING INNER JOIN
-- =========================================================

SELECT
    e.emp_id,
    e.emp_name
FROM Employee e
INNER JOIN Project p
    ON e.project_id = p.project_id
WHERE e.salary > 60000
AND p.budget > 300000;


-- =========================================================
-- SIMULATED EXCEPT USING NOT EXISTS
-- =========================================================

SELECT
    e.emp_id,
    e.emp_name
FROM Employee e
WHERE NOT EXISTS (
    SELECT 1
    FROM Department d
    WHERE d.dept_id = e.dept_id
    AND d.dept_name = 'IT'
);
--  SIMULATED EXCEPT USING LEFT JOIN
SELECT
    e.emp_id,
    e.emp_name
FROM Employee e
LEFT JOIN Department d
    ON e.dept_id = d.dept_id
WHERE d.dept_name <> 'IT';
--  EXPLAIN - INNER JOIN
EXPLAIN
SELECT
    e.emp_name,
    d.dept_name
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id;
--  EXPLAIN - LEFT JOIN
EXPLAIN
SELECT
    d.dept_name,
    e.emp_name
FROM Department d
LEFT JOIN Employee e
    ON d.dept_id = e.dept_id;
-- EXPLAIN - CORRELATED SUBQUERY
EXPLAIN
SELECT
    e.emp_name,
    e.salary
FROM Employee e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e.dept_id
);
--  EXPLAIN - EXISTS
EXPLAIN
SELECT
    d.dept_name
FROM Department d
WHERE EXISTS (
    SELECT 1
    FROM Employee e
    WHERE e.dept_id = d.dept_id
);
-- EXPLAIN - THREE-WAY JOIN
EXPLAIN
SELECT
    e.emp_name,
    d.dept_name,
    p.project_name
FROM Employee e
INNER JOIN Department d
    ON e.dept_id = d.dept_id
INNER JOIN Project p
    ON e.project_id = p.project_id;