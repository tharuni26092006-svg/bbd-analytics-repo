-- Region and month report
-- Join type: INNER JOIN, because only customers who have orders can contribute to a region-month
-- revenue row; a LEFT JOIN would add never-ordered customers with no month and empty groups.
-- COUNT(DISTINCT) is necessary because one customer can place several orders in a month, so
-- counting customer_id rows would count the same customer more than once.
SELECT c.region, o.order_month,
       COUNT(o.order_id)             AS number_of_orders,
       COUNT(DISTINCT c.customer_id) AS number_of_customers,
       SUM(o.amount)                 AS total_revenue,
       AVG(o.amount)                 AS average_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region, o.order_month
ORDER BY c.region, o.order_month;
