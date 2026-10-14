# DBMS-LAB-FILE

A collection of Database Management Systems (DBMS) laboratory experiments implemented using MySQL as part of academic coursework.

## About the Repository

This repository contains SQL scripts, queries, and practical implementations covering database design, relational schemas, data manipulation, integrity constraints, advanced SQL queries, database programming, normalization, transactions, and query optimization.

## Experiments

### Experiment 1: ER Diagram Design
Design an ER diagram for an Indian e-commerce platform, covering Customer, Product, Order, OrderItem, Seller, Category, Payment, Delivery, and Address. Include keys, composite and multivalued attributes, weak entities, product specialization, and participation constraints.

### Experiment 2: Relational Schema and Integrity Constraints
Convert the ER diagram into a relational schema and implement MySQL `CREATE TABLE` statements with primary keys, foreign keys, `NOT NULL`, `UNIQUE`, `ON DELETE CASCADE`, and `SET NULL` constraints. Insert sample data and demonstrate referential integrity violations.

### Experiment 3: SQL Queries on Employee–Department–Project Schema
Create an Employee–Department–Project schema with at least 30 employees, 5 departments, and 8 projects. Demonstrate selection, projection, aggregate functions, `GROUP BY`, `HAVING`, `CASE`, and `ORDER BY`.

### Experiment 4: Joins, Subqueries, and Execution Plans
Implement `INNER JOIN`, `LEFT JOIN`, self-joins, three-way joins, correlated subqueries, `EXISTS`, simulated `INTERSECT` and `EXCEPT` operations, and compare execution plans using `EXPLAIN`.

### Experiment 5: Views and Recursive CTEs
Create views for department salary summaries and employee hierarchies. Test view updatability and implement a recursive CTE to display reporting chains.

### Experiment 6: Stored Procedures and Triggers
Create a stored procedure `transfer_employee(emp_id, new_dept_id)` with validation and error handling. Implement salary-validation and audit-logging triggers and test edge cases.

### Experiment 7: Database Normalization
Analyze functional dependencies in a denormalized Sales table and normalize it from UNF to 3NF and BCNF. Verify lossless joins and dependency preservation using SQL queries.

### Experiment 8: Transactions and Concurrency Control
Implement banking-style transactions using `BEGIN`, `COMMIT`, `ROLLBACK`, and `SAVEPOINT`. Simulate partial failures, demonstrate isolation levels, and examine concurrency anomalies using two sessions.

### Experiment 9: Indexing and Performance Benchmarking
Create a Railway Booking table containing at least 5,000 records. Benchmark queries before and after creating single-column and composite indexes, and compare execution plans using `EXPLAIN`.

### Experiment 10: Query Optimization
Generate a dataset containing at least 10,000 rows. Analyze five slow queries using `EXPLAIN`, optimize them through indexing and query rewriting, and compare execution times before and after optimization.

## Technologies Used

- **MySQL** — Relational database management system
- **SQL** — Database definition, manipulation, querying, and optimization

## How to Use

1. Clone or download this repository.
2. Install MySQL Server and a MySQL client.
3. Open the SQL script for the required experiment.
4. Execute the script in your MySQL environment.
5. Review the query results and verify the expected behavior.

## Learning Objectives

- Design ER diagrams and relational database schemas.
- Implement database constraints and referential integrity.
- Write basic and advanced SQL queries.
- Use views, stored procedures, triggers, and recursive CTEs.
- Apply database normalization and transaction management.
- Analyze indexes, execution plans, and query performance.

## Author

**Protistha Chowdhury**

B.Tech — Computer Science and Engineering (AI & ML)

GitHub: [Protistha](https://github.com/Protistha)

---

*This repository is maintained for academic learning and DBMS laboratory practice.*
