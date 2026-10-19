-- Corrected D1: which regions sell the most? Revenue = completed orders only; keep the 80000 threshold.
SELECT c.region, SUM(o.amount) AS sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY sales DESC;
