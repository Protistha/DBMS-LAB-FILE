CREATE TABLE RailwayBooking (
    booking_id INT PRIMARY KEY,
    passenger_name VARCHAR(60) NOT NULL,
    train_no INT NOT NULL,
    journey_date DATE NOT NULL,
    source_station VARCHAR(40) NOT NULL,
    destination_station VARCHAR(40) NOT NULL,
    seat_no INT NOT NULL,
    fare DECIMAL(8,2) NOT NULL,
    booking_status VARCHAR(20) NOT NULL
);

-- Generate 5,000 rows using a recursive CTE (MySQL 8.0+).
SET SESSION cte_max_recursion_depth = 6000;
INSERT INTO RailwayBooking
(booking_id, passenger_name, train_no, journey_date, source_station,
 destination_station, seat_no, fare, booking_status)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 5000
)
SELECT n,
       CONCAT('Passenger', n),
       12000 + MOD(n, 25),
       DATE_ADD('2026-01-01', INTERVAL MOD(n, 180) DAY),
       ELT(MOD(n,5)+1,'Delhi','Lucknow','Kanpur','Agra','Jaipur'),
       ELT(MOD(n+2,5)+1,'Delhi','Lucknow','Kanpur','Agra','Jaipur'),
       MOD(n, 72) + 1,
       250 + MOD(n, 1500),
       ELT(MOD(n,3)+1,'Confirmed','Waiting','Cancelled')
FROM seq;

SELECT COUNT(*) AS total_bookings FROM RailwayBooking;

-- Baseline: inspect plan and time this query before adding indexes.
EXPLAIN SELECT * FROM RailwayBooking
WHERE train_no = 12005 AND journey_date = '2026-02-15';

SELECT * FROM RailwayBooking
WHERE train_no = 12005 AND journey_date = '2026-02-15';

-- Single-column index
CREATE INDEX idx_train_no ON RailwayBooking(train_no);
EXPLAIN SELECT * FROM RailwayBooking WHERE train_no = 12005;

-- Composite index for combined filtering
CREATE INDEX idx_train_date ON RailwayBooking(train_no, journey_date);
EXPLAIN SELECT * FROM RailwayBooking
WHERE train_no = 12005 AND journey_date = '2026-02-15';

-- Compare the EXPLAIN plans and measured execution times.
SHOW INDEX FROM RailwayBooking;

EXPLAIN SELECT * FROM RailwayBooking
WHERE train_no = 12005 AND journey_date = '2026-02-15';

SELECT * FROM RailwayBooking
WHERE train_no = 12005 AND journey_date = '2026-02-15';

-- Create single-column index if it does not exist
SET @idx_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'RailwayBooking'
      AND INDEX_NAME = 'idx_train_no'
);

SET @sql = IF(
    @idx_exists = 0,
    'CREATE INDEX idx_train_no ON RailwayBooking(train_no)',
    'SELECT ''idx_train_no already exists'' AS Message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- Create composite index if it does not exist
SET @idx_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'RailwayBooking'
      AND INDEX_NAME = 'idx_train_date'
);

SET @sql = IF(
    @idx_exists = 0,
    'CREATE INDEX idx_train_date ON RailwayBooking(train_no, journey_date)',
    'SELECT ''idx_train_date already exists'' AS Message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- Test query
EXPLAIN
SELECT *
FROM RailwayBooking
WHERE train_no = 12005
  AND journey_date = '2026-02-15';

-- Display all indexes
SHOW INDEX FROM RailwayBooking;