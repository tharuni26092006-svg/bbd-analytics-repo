-- Business question: Which customers aged 25-40 in North or West form the target segment?
SELECT c.customer_id, c.first_name, c.last_name, c.region, c.age
FROM customers c
WHERE c.region IN ('North', 'West')
  AND c.age BETWEEN 25 AND 40
ORDER BY c.age ASC, c.customer_id ASC;
