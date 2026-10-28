CREATE TABLE SalesData (
    sale_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    sale_date DATE NOT NULL,
    region VARCHAR(30) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL
);

-- Generate 10,000 rows using MySQL 8.0+ recursive CTE.
SET SESSION cte_max_recursion_depth = 11000;
INSERT INTO SalesData
(sale_id, customer_id, product_id, sale_date, region, quantity, unit_price, status)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 10000
)
SELECT n, MOD(n,1000)+1, MOD(n,100)+1,
       DATE_ADD('2025-01-01', INTERVAL MOD(n,365) DAY),
       ELT(MOD(n,4)+1,'North','South','East','West'),
       MOD(n,10)+1, 100 + MOD(n,900),
       ELT(MOD(n,3)+1,'Complete','Pending','Returned')
FROM seq;

SELECT COUNT(*) AS total_rows FROM SalesData;

-- Slow query 1: filter without a suitable index
EXPLAIN SELECT * FROM SalesData WHERE region = 'North';

-- Slow query 2: function applied to indexed candidate date column
EXPLAIN SELECT * FROM SalesData WHERE YEAR(sale_date) = 2025;

-- Slow query 3: correlated subquery
EXPLAIN SELECT s.sale_id, s.customer_id, s.unit_price
FROM SalesData s
WHERE s.unit_price > (
    SELECT AVG(s2.unit_price) FROM SalesData s2
    WHERE s2.customer_id = s.customer_id
);

-- Slow query 4: grouping and sorting
EXPLAIN SELECT region, status, SUM(quantity * unit_price) AS revenue
FROM SalesData GROUP BY region, status ORDER BY revenue DESC;

-- Slow query 5: multiple filters
EXPLAIN SELECT * FROM SalesData
WHERE customer_id = 120 AND status = 'Complete'
  AND sale_date BETWEEN '2025-03-01' AND '2025-06-30';

-- Add indexes and rewrite predicates
CREATE INDEX idx_region ON SalesData(region);
CREATE INDEX idx_sale_date ON SalesData(sale_date);
CREATE INDEX idx_customer_status_date
ON SalesData(customer_id, status, sale_date);

-- Sargable date range instead of YEAR(sale_date) = 2025
EXPLAIN SELECT * FROM SalesData
WHERE sale_date >= '2025-01-01' AND sale_date < '2026-01-01';

-- Rewrite correlated comparison as a join to customer averages
EXPLAIN
SELECT s.sale_id, s.customer_id, s.unit_price
FROM SalesData s
JOIN (SELECT customer_id, AVG(unit_price) AS avg_price
      FROM SalesData GROUP BY customer_id) a
  ON a.customer_id = s.customer_id
WHERE s.unit_price > a.avg_price;

EXPLAIN SELECT * FROM SalesData
WHERE customer_id = 120 AND status = 'Complete'
  AND sale_date BETWEEN '2025-03-01' AND '2025-06-30';

SHOW INDEX FROM SalesData;


EXPLAIN SELECT * FROM SalesData WHERE region = 'North';
EXPLAIN SELECT * FROM SalesData WHERE YEAR(sale_date) = 2025;
EXPLAIN SELECT s.sale_id, s.customer_id, s.unit_price
FROM SalesData s
WHERE s.unit_price > (
    SELECT AVG(s2.unit_price) FROM SalesData s2
    WHERE s2.customer_id = s.customer_id
);
EXPLAIN SELECT region, status, SUM(quantity * unit_price) AS revenue
FROM SalesData GROUP BY region, status ORDER BY revenue DESC;
EXPLAIN SELECT * FROM SalesData
WHERE customer_id = 120 AND status = 'Complete'
AND sale_date BETWEEN '2025-03-01' AND '2025-06-30';




EXPLAIN SELECT * FROM SalesData WHERE region = 'North';

EXPLAIN SELECT * FROM SalesData
WHERE sale_date >= '2025-01-01' AND sale_date < '2026-01-01';

EXPLAIN SELECT * FROM SalesData
WHERE customer_id = 120 AND status = 'Complete'
AND sale_date BETWEEN '2025-03-01' AND '2025-06-30';

SHOW INDEX FROM SalesData;