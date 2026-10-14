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

CREATE TABLE SalaryAudit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Department VALUES
(1, 'IT', 'Delhi'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Pune');

INSERT INTO Project VALUES
(101, 'AI Platform', 1, 500000),
(102, 'Recruitment System', 2, 150000),
(103, 'Financial Analytics', 3, 400000);

INSERT INTO Employee VALUES
(1, 'Rahul', 90000, 1, 101),
(2, 'Amit', 70000, 1, 101),
(3, 'Priya', 65000, 1, 101),
(4, 'Neha', 60000, 2, 102),
(5, 'Rohit', 50000, 2, 102),
(6, 'Anjali', 85000, 3, 103),
(7, 'Vikas', 55000, 3, 103);


-- 1. STORED PROCEDURE FOR TRANSFERRING EMPLOYEE

DELIMITER $$

CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE v_emp_count INT;
    DECLARE v_dept_count INT;
    DECLARE v_old_dept INT;

    SELECT COUNT(*) INTO v_emp_count
    FROM Employee
    WHERE emp_id = p_emp_id;

    IF v_emp_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist';
    END IF;

    SELECT COUNT(*) INTO v_dept_count
    FROM Department
    WHERE dept_id = p_new_dept_id;

    IF v_dept_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department does not exist';
    END IF;

    SELECT dept_id INTO v_old_dept
    FROM Employee
    WHERE emp_id = p_emp_id;

    IF v_old_dept = p_new_dept_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee already belongs to this department';
    END IF;

    UPDATE Employee
    SET dept_id = p_new_dept_id
    WHERE emp_id = p_emp_id;
END$$

DELIMITER ;


-- TEST STORED PROCEDURE

CALL transfer_employee(2, 2);

SELECT emp_id, emp_name, dept_id
FROM Employee
WHERE emp_id = 2;


-- 2. SALARY VALIDATION TRIGGER

DELIMITER $$

CREATE TRIGGER validate_salary_insert
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER validate_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END$$

DELIMITER ;


-- TEST SALARY VALIDATION

UPDATE Employee
SET salary = 0
WHERE emp_id = 2;


-- 3. SALARY AUDIT LOGGING TRIGGER

DELIMITER $$

CREATE TRIGGER salary_audit
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO SalaryAudit
        (emp_id, old_salary, new_salary)
        VALUES
        (OLD.emp_id, OLD.salary, NEW.salary);
    END IF;
END$$

DELIMITER ;


-- TEST SALARY AUDIT

UPDATE Employee
SET salary = 75000
WHERE emp_id = 2;

SELECT emp_id, old_salary, new_salary, changed_at
FROM SalaryAudit
WHERE emp_id = 2;


-- 4. TEST EDGE CASES

-- Invalid Employee

CALL transfer_employee(999, 2);


-- Invalid Department

CALL transfer_employee(2, 999);


-- Employee Already in Department

CALL transfer_employee(2, 2);


-- Invalid Salary

UPDATE Employee
SET salary = -5000
WHERE emp_id = 2;


-- Valid Salary Update

UPDATE Employee
SET salary = 80000
WHERE emp_id = 2;

SELECT *
FROM SalaryAudit
WHERE emp_id = 2;