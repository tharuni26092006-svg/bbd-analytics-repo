-- Business question: Which orders have a missing (NULL) amount?
SELECT o.order_id, o.customer_id, o.item, o.status
FROM orders o
WHERE o.amount IS NULL
ORDER BY o.order_id;
