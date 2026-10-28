CREATE TABLE BankAccount (
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(50) NOT NULL,
    balance DECIMAL(12,2) NOT NULL CHECK (balance >= 0)
);

INSERT INTO BankAccount VALUES
(1,'Aarav',10000),(2,'Diya',7000),(3,'Kabir',5000);

-- Transaction with COMMIT
START TRANSACTION;
UPDATE BankAccount SET balance = balance - 1000 WHERE account_id = 1;
UPDATE BankAccount SET balance = balance + 1000 WHERE account_id = 2;
COMMIT;
SELECT * FROM BankAccount;

-- SAVEPOINT and partial rollback
START TRANSACTION;
UPDATE BankAccount SET balance = balance - 500 WHERE account_id = 1;
SAVEPOINT after_debit;
UPDATE BankAccount SET balance = balance + 500 WHERE account_id = 3;
ROLLBACK TO SAVEPOINT after_debit;
-- Cancel the remaining transaction to simulate a failed transfer.
ROLLBACK;
SELECT * FROM BankAccount;

-- Full rollback after an invalid business operation
START TRANSACTION;
UPDATE BankAccount SET balance = balance - 2000 WHERE account_id = 2;
UPDATE BankAccount SET balance = balance + 2000 WHERE account_id = 99;
ROLLBACK;
SELECT * FROM BankAccount;

-- Set isolation level before starting a transaction
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT balance FROM BankAccount WHERE account_id = 1;
COMMIT;

-- Run the following concurrency tests using two separate SQL sessions:
-- Session A:
-- SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- START TRANSACTION;
-- SELECT balance FROM BankAccount WHERE account_id = 1;
-- Session B:
-- START TRANSACTION;
-- UPDATE BankAccount SET balance = balance + 500 WHERE account_id = 1;
-- COMMIT;
-- Session A: repeat SELECT; compare with REPEATABLE READ isolation.
-- A non-repeatable read may occur under READ COMMITTED, while
-- REPEATABLE READ keeps a consistent snapshot for ordinary consistent reads.
START TRANSACTION;
UPDATE BankAccount SET balance = balance - 300 WHERE account_id = 1;
SAVEPOINT transfer_step;
UPDATE BankAccount SET balance = balance + 300 WHERE account_id = 2;
ROLLBACK TO SAVEPOINT transfer_step;
ROLLBACK;
SELECT * FROM BankAccount;
-- Execute in Session A and Session B as described in SOURCE CODE.
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT balance FROM BankAccount WHERE account_id = 1;
COMMIT;

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT balance FROM BankAccount WHERE account_id = 1;
COMMIT;
