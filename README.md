# Big Billion Days Regional Performance Review: SQL, Spreadsheet, Dashboard and AI-Verified Analysis

A traceable analytics pipeline on the Flipkart Big Billion Days (BBD) sale dataset: SQL order-level facts (Part A), a spreadsheet cleaning and pivot layer (Part B), a dashboard specification and business narrative (Part C), and an AI-assistance log with verification (Part D). All money is in INR and revenue means the sum of `amount` over `completed` orders.

## Tools used

- **SQL compiler and dialect:** SQLite (run through Python's built-in `sqlite3`). The queries use only standard syntax and also run on MySQL and PostgreSQL.
- **Spreadsheet tool:** Google Sheets formulas (`PROPER`, `TRIM`, `VLOOKUP`, `XLOOKUP`; also valid in Excel 365).
- **Tableau Public:** Not used. I wrote the dashboard as a specification in `docs/dashboard_spec.md`, as the brief allows, with every number taken from my spreadsheet pivots.

## Key findings

North is the strongest region with 119,300 INR (34.5% of the 346,200 total from 63 completed orders), but its revenue fell 22.8% from 2026-09 (53,500) to 2026-10 (41,300) and it was below its 40,000 monthly target in 2026-11 (24,500). Electronics is the largest category at 142,300 and the Air Fryer alone brings 104,000 (30.0%); total revenue rose 66.3% from 93,100 in 2026-10 to 154,800 in 2026-11 because Home jumped from 12,600 to 83,200. The assistant's claim in Part D that North's revenue "grew 38% month over month" is contradicted by the data (-22.8%), and its query had four defects.

## File index

| File | Part |
|---|---|
| `README.md` | All (explains everything) |
| `sql/00_schema_and_seed.sql` | Part A |
| `sql/q01.sql` to `sql/q13.sql` | Part A |
| `sql/d1_corrected.sql` | Part D |
| `results/query_results.md` | Part A |
| `data/orders_enriched.csv` | Part A (export of q09, input to Part B) |
| `data/orders_clean.csv` | Part B |
| `docs/spreadsheet_notes.md` | Part B |
| `docs/dashboard_spec.md` | Part C |
| `docs/ai_log.md` | Part D |

## Assumptions

- Revenue counts only `completed` orders; `pending` and `disputed` orders are never revenue.
- The three missing amounts (orders 1001, 1010, 1064, all pending) are left empty and never filled in.
- `data/orders_enriched.csv` keeps the raw customer names exactly as in the database (stray spaces and capitalisation included); cleaning happens in Part B.
- `BETWEEN 25 AND 40` in q04 is inclusive, as in standard SQL.
- Ties in amount are kept in ascending `order_id` order when sorting `completed_orders`.
- Averages are shown rounded to 2 decimals in the Markdown files.
- AI assistance (Claude) was used to prepare these files and is disclosed in `docs/ai_log.md`.
