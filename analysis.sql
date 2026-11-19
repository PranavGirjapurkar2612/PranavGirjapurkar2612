-- SQLite. Run in an empty database. Each row is a fictional order.
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id TEXT NOT NULL,
    ordered_on TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('paid', 'refunded'))
);
INSERT INTO orders VALUES
    (1,'A','2026-07-01','paid'), (2,'A','2026-07-31','paid'),
    (3,'B','2026-07-04','paid'), (4,'B','2026-08-04','paid'),
    (5,'C','2026-07-10','paid'), (6,'C','2026-07-15','refunded'),
    (7,'D','2026-07-20','paid'), (8,'D','2026-07-25','paid'),
    (9,'E','2026-08-01','paid'), (10,'E','2026-08-01','paid'),
    (11,'F','2026-08-12','paid'), (12,'F','2026-08-15','paid'),
    (13,'G','2026-08-30','paid'), (14,'H','2026-09-15','paid');

-- The extract ends on September 30. Only include customers observed
-- for a full 30 days. Same-day orders count as a single shopping day.
WITH shopping_days AS (
    SELECT DISTINCT customer_id, ordered_on
    FROM orders
    WHERE status = 'paid' AND ordered_on <= '2026-09-30'
), first_purchase AS (
    SELECT customer_id, MIN(ordered_on) AS first_day
    FROM shopping_days
    GROUP BY customer_id
), eligible_customers AS (
    SELECT customer_id, first_day
    FROM first_purchase
    WHERE date(first_day, '+30 days') <= '2026-09-30'
), repeat_flags AS (
    SELECT c.customer_id, substr(c.first_day, 1, 7) AS cohort,
           EXISTS (
               SELECT 1 FROM shopping_days s
               WHERE s.customer_id = c.customer_id
                 AND s.ordered_on > c.first_day
                 AND s.ordered_on <= date(c.first_day, '+30 days')
           ) AS repeated
    FROM eligible_customers c
)
SELECT cohort, COUNT(*) AS eligible_customers, SUM(repeated) AS repeat_buyers,
       ROUND(100.0 * AVG(repeated), 1) AS repeat_pct
FROM repeat_flags
GROUP BY cohort
ORDER BY cohort;
