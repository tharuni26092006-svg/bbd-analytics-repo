-- Customer profile by region
SELECT c.region,
       COUNT(c.customer_id) AS number_of_customers,
       AVG(c.age)           AS average_age,
       MIN(c.age)           AS min_age,
       MAX(c.age)           AS max_age
FROM customers c
GROUP BY c.region
ORDER BY c.region;
