-- Business question: Which products are strong sellers (revenue above 20000)?
SELECT o.item,
       COUNT(o.order_id) AS number_of_orders,
       SUM(o.amount)     AS revenue
FROM orders o
WHERE o.status = 'completed'
GROUP BY o.item
HAVING SUM(o.amount) > 20000
ORDER BY revenue DESC;
