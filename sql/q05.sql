-- Business question: What are the headline KPIs over completed orders?
SELECT COUNT(o.order_id) AS total_orders,
       SUM(o.amount)     AS total_revenue,
       AVG(o.amount)     AS avg_order_value,
       MIN(o.amount)     AS min_order_value,
       MAX(o.amount)     AS max_order_value
FROM orders o
WHERE o.status = 'completed';
