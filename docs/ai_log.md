# AI Log (Part D)

## Disclosure

AI assistance (Claude) was used to draft the SQL files, CSV exports and documentation in this repository. The SQL was run on the seed data in SQLite and every number was checked against the brief's checkpoints (row counts 4/9/24/90, q01 to q13 row counts, revenue 346200 from 63 orders, 106 units, d1_corrected returning North and South). I am responsible for the correctness of what is submitted.

## Task 1: Five-part prompt for Part A, query q13

**Role:** You are a senior SQL analyst who writes clean, portable SQL.

**Task:** Write one query that shows each sales rep's revenue against their monthly target, per month, with a performance tier.

**Context:** SQL dialect: SQLite (also valid in MySQL and PostgreSQL). Tables and columns:
- `reps(rep_id, rep_name, region, monthly_target)`
- `customers(customer_id, first_name, last_name, city, region, age, rep_id)`
- `orders(order_id, customer_id, item, quantity, amount, status, order_month)`

`customers.rep_id` refers to `reps.rep_id`; `orders.customer_id` refers to `customers.customer_id`. `order_month` is text such as `2026-09`.

**Constraints:**
- Use completed orders only (`status = 'completed'`).
- Return columns `rep_name`, `order_month`, `monthly_target`, `revenue`, `performance_tier`, grouped by rep, month and `monthly_target`, ordered by `rep_name` then `order_month`.
- `performance_tier` is `Below Target` when revenue is below `monthly_target`, `On Target` when revenue is at least the target but below 1.1 times the target, and `Above Target` otherwise.
- No `WITH` clauses (no CTEs) and no stored procedures.
- Write the aggregate expression out in full in the CASE; do not reference an alias and do not put aggregates in WHERE.
- Qualify every column with its table alias.

**Format:** Raw SQL only, with inline comments. No explanation outside the SQL.

## Task 2: Defects in Scenario D1

Assistant's query:

```sql
SELECT region_name, SUM(total_sales) AS sales
FROM sales
WHERE SUM(total_sales) > 80000
GROUP BY region_name
ORDER BY sales DESC;
```

| # | Defect | Classification | Correct fix |
|---|---|---|---|
| 1 | Table `sales` does not exist in the database | Fake method/function | Use the real tables: `FROM orders o JOIN customers c ON o.customer_id = c.customer_id` |
| 2 | Columns `region_name` and `total_sales` do not exist | Fake method/function | Use `c.region` and `o.amount` (and filter `o.status = 'completed'` so only revenue is counted) |
| 3 | `SUM(...)` placed in `WHERE`; aggregates cannot be used there | Logic error | Move the condition to `HAVING SUM(o.amount) > 80000` after `GROUP BY` |
| 4 | "Its revenue grew 38% month over month" has no supporting query or data | Phantom statistic | Compute the real change from the q11 result (see Task 3); here it is -22.8% |

## Task 3: Verification of Scenario D1

Corrected query (`sql/d1_corrected.sql`):

```sql
SELECT c.region, SUM(o.amount) AS sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY sales DESC;
```

Result (2 rows):

| region | sales |
|---|---|
| North | 119300 |
| South | 82500 |

North's actual change, from q11: 2026-09 revenue 53,500 and 2026-10 revenue 41,300, so (41,300 - 53,500) / 53,500 = **-22.8%**. The assistant's claim of 38% growth is contradicted by the data: North's revenue fell, it did not grow. (North also fell again to 24,500 in 2026-11, -40.7%, so no month-over-month period shows growth.)

## Task 4: Human-in-the-loop protocol for Scenario D1

**Specification.** The colleague's question ("which regions sell the most?") was vague. I made it precise: revenue means the sum of `amount` over completed orders, grouped by the customer's region, keeping regions above 80,000, and month-over-month change for North from 2026-09 to 2026-10.

**Execution.** I ran the assistant's query as written (it fails because table `sales` does not exist), then wrote and ran my corrected query on the seed data, which returned North 119,300 and South 82,500.

**Inspection.** I read the original line by line and found four defects: a non-existent table, non-existent columns, an aggregate in WHERE, and a growth statistic with no source. I also noticed it never restricts to completed orders.

**Verification.** I checked the numbers myself using my own q11 result: North 53,500 in 2026-09 and 41,300 in 2026-10, a -22.8% change. I also confirmed that 119,300 and 82,500 are consistent with Part B's region totals (pivot grand total 346,200).

**Decision.** Reject the assistant's original answer: its query cannot run and its 38% growth claim is contradicted by the data (-22.8%). Accept my corrected version: it runs on the seed, returns exactly 2 rows (North 119,300 and South 82,500) and matches q11 and the Part B pivots.

## Task 5: Prompt for Scenario D2 and repair

**Role:** You are a spreadsheet expert in Google Sheets and Excel.

**Task:** Find the root cause of a lookup error and give the repaired formula.

**Context:** The `products` tab occupies `A1:C10` (header in row 1; item names in column A; unit prices in column C). On the `orders` tab, cell `G2` (the item column) contains the text ` Smart Watch` (with a space before the first letter). The formula is `=VLOOKUP(G2, $A$2:$C$10, 3, FALSE)`. It returns an error saying the value was not found, even though "Smart Watch" is in the products table.

**Constraints:** Keep the exact-match lookup (last argument FALSE); keep the absolute range `$A$2:$C$10`; do not change the products table; the formula must still be copyable down the column.

**Format:** Give the root cause in one or two sentences, then the repaired formula on its own line.

**Root cause (my own words):** The item in `G2` has a leading space, so the lookup key is " Smart Watch" while the table holds "Smart Watch". An exact-match VLOOKUP compares the text character by character, so the two strings are different and nothing is found (`#N/A`).

**Repaired formula:** `=VLOOKUP(TRIM(G2), $A$2:$C$10, 3, FALSE)`

## Task 6: Skeptical-analyst check on Part C's first recommendation

**Prompt:**

> **Role:** You are a skeptical senior business analyst who challenges recommendations.
> **Task:** Challenge this recommendation and list the unstated assumptions behind it: "Run an Electronics promotion in West and East, because Electronics revenue there is only 18,800 and 21,400 against 73,400 in North. Success metric: combined West + East Electronics revenue next cycle versus 40,200."
> **Context:** BBD sale data, completed orders only, 63 orders, 346,200 INR, three months (2026-09 to 2026-11), 6 customers per region. Region x category revenue table attached.
> **Constraints:** Ask for evidence of cause, not just correlation. List every assumption the recommendation relies on without stating it, and for each say what figure or check would confirm or weaken it.
> **Format:** A numbered list: assumption, why it matters, what data would test it.

**Unstated assumptions and checks from my data:**

1. **The low Electronics revenue comes from missing promotion, not from low demand.** Check: West's Apparel revenue (37,500) is double its Electronics revenue (18,800), and East's Home revenue (37,500) is higher than its Electronics (21,400). If customers there prefer other categories, the figures weaken the recommendation.
2. **Electronics orders in West and East are being lost to weak demand rather than to payment or fulfilment problems.** Check: West has 2 disputed (12,800) and 3 pending (10,100) Electronics orders, and East has 1 disputed (9,000) and 2 pending (16,700). If these converted, West would be 18,800 + 22,900 = 41,700, which would weaken the case for a promotion.
3. **North's 73,400 is a normal level that West and East could reach.** Check: North Electronics was 16,700 in 2026-09, 39,400 in 2026-10 and 17,300 in 2026-11, so most of its total comes from one month. A repeatable level is closer to 17,000 a month, which weakens the benchmark.
4. **West and East have enough customers to respond to a promotion.** Check: each region has 6 customers and 5 of them completed an order (customers 11 and 24 never ordered), so the pool is small; the 10,000 to 20,000 uplift needed could require changing the behaviour of only a few people.
5. **A promotion would cause the increase (causation).** Check: compare Electronics revenue in West and East before and after the promotion against the North change in the same period; a rise in all three regions would indicate seasonality rather than the promotion.
