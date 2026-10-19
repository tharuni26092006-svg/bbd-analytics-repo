--  Pending orders
SELECT o.order_id, o.customer_id, o.item, o.amount
FROM orders o
WHERE o.status = 'pending'
ORDER BY o.order_id ASC;
