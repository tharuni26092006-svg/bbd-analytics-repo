-- Business question: What is the order-level fact table (orders + customers + reps)?
SELECT o.order_id, o.order_month, c.first_name, c.last_name, c.region,
       r.rep_name, o.item, o.quantity, o.amount, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN reps r ON c.rep_id = r.rep_id
ORDER BY o.order_id;
