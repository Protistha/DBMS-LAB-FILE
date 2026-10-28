CREATE TABLE Sales_UNF (
    order_id INT,
    order_date DATE,
    customer_id INT,
    customer_name VARCHAR(50),
    customer_city VARCHAR(50),
    product_id INT,
    product_name VARCHAR(50),
    unit_price DECIMAL(10,2),
    quantity INT,
    PRIMARY KEY (order_id, product_id)
);

INSERT INTO Sales_UNF VALUES
(101,'2026-01-10',1,'Aarav','Delhi',501,'Keyboard',800,2),
(101,'2026-01-10',1,'Aarav','Delhi',502,'Mouse',400,1),
(102,'2026-01-11',2,'Diya','Lucknow',501,'Keyboard',800,1),
(103,'2026-01-12',3,'Kabir','Kanpur',503,'Monitor',7000,1);

-- Functional dependencies:
-- order_id -> order_date, customer_id
-- customer_id -> customer_name, customer_city
-- product_id -> product_name, unit_price
-- (order_id, product_id) -> quantity

-- 1NF: each cell contains one atomic value; Sales_UNF is already atomic.
-- 2NF/3NF decomposition
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    customer_city VARCHAR(50) NOT NULL
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE OrderDetails (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO Customer VALUES
(1,'Aarav','Delhi'),(2,'Diya','Lucknow'),(3,'Kabir','Kanpur');

INSERT INTO Orders VALUES
(101,'2026-01-10',1),(102,'2026-01-11',2),(103,'2026-01-12',3);

INSERT INTO Product VALUES
(501,'Keyboard',800),(502,'Mouse',400),(503,'Monitor',7000);

INSERT INTO OrderDetails VALUES
(101,501,2),(101,502,1),(102,501,1),(103,503,1);

SELECT * FROM Customer;
SELECT * FROM Orders;
SELECT * FROM Product;
SELECT * FROM OrderDetails;

-- Verify lossless reconstruction and dependency preservation
SELECT o.order_id, o.order_date, c.customer_name,
       p.product_name, p.unit_price, od.quantity
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Product p ON od.product_id = p.product_id
ORDER BY o.order_id, p.product_id;

-- BCNF check: each determinant in the decomposed relations is a candidate key.
SELECT COUNT(*) AS original_rows FROM Sales_UNF;
SELECT COUNT(*) AS reconstructed_rows
FROM Orders o
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Customer c ON o.customer_id = c.customer_id
JOIN Product p ON od.product_id = p.product_id;
-- Review the functional dependencies listed above.
-- The original relation has a composite key (order_id, product_id).
-- Customer and product details are separated to remove partial/transitive dependencies.
SELECT * FROM Sales_UNF;
SELECT o.order_id, o.order_date, c.customer_name, c.customer_city,
       p.product_name, p.unit_price, od.quantity
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
JOIN OrderDetails od ON od.order_id = o.order_id
JOIN Product p ON p.product_id = od.product_id;

