# Spreadsheet Notes (Part B)

Source: `data/orders_enriched.csv` (Part A, query q09). Tool: Google Sheets formulas (also valid in Excel 365).

## (a) Formulas typed in the first data row (row 2 of the `orders` tab)

Column layout on `orders`: A order_id, B order_month, C first_name, D last_name, E region, F rep_name, G item, H quantity, I amount, J status, then the added columns K to O.

| Added column | Formula (row 2) |
|---|---|
| clean_first_name (K) | `=PROPER(TRIM(C2))` |
| clean_last_name (L) | `=PROPER(TRIM(D2))` |
| category (M) | `=VLOOKUP(G2,products!$A$2:$C$10,2,FALSE)` |
| unit_price (N) | `=XLOOKUP(G2,products!$A$2:$A$10,products!$C$2:$C$10,"UNKNOWN_ITEM")` |
| revenue_calc (O) | `=N2*H2` |

All formulas were copied down rows 2 to 91 (90 rows). Lookup ranges are fully anchored with `$`, so they do not drift when copied.

## (b) Aggregates on `completed_orders` (amount column)

| Measure | Formula | Result |
|---|---|---|
| COUNT | `=COUNT(K2:K64)` | 63 |
| SUM | `=SUM(K2:K64)` | 346200 |
| AVERAGE | `=AVERAGE(K2:K64)` | 5495.24 |
| MIN | `=MIN(K2:K64)` | 1100 |
| MAX | `=MAX(K2:K64)` | 15600 |

(The block sits in a labelled area to the right of the data, outside the exported range.)

## (c) Pivot tables on `completed_orders`

**Pivot (i): rows = category, columns = region, values = SUM of amount**

| category | East | North | South | West | Grand Total |
|---|---|---|---|---|---|
| Apparel | 10600 | 19400 | 10000 | 37500 | 77500 |
| Electronics | 21400 | 73400 | 28700 | 18800 | 142300 |
| Home | 37500 | 26500 | 43800 | 18600 | 126400 |
| **Grand Total** | 69500 | 119300 | 82500 | 74900 | **346200** |

**Pivot (ii): rows = order_month, values = SUM of amount and COUNT of order_id**

| order_month | Sum of amount | Count of order_id |
|---|---|---|
| 2026-09 | 98300 | 19 |
| 2026-10 | 93100 | 20 |
| 2026-11 | 154800 | 24 |
| **Grand Total** | **346200** | **63** |

## (d) Reconciliation with Part A (q05)

| Measure | Spreadsheet | Part A q05 | Match/Mismatch |
|---|---|---|---|
| COUNT | 63 | 63 (total_orders) | Match |
| SUM | 346200 | 346200 (total_revenue) | Match |
| AVERAGE | 5495.24 | 5495.24 (avg_order_value) | Match |

## (e) Data validation

- **Missing amounts.** Three orders have a blank amount: 1001, 1010 and 1064 (the same three order ids returned by Part A's q02). All three are `pending`, so the `status = completed` filter removes them and they never enter revenue. I left the cells blank instead of replacing them with 0 or with `unit_price * quantity`, because a guessed value would invent revenue for orders that have not been paid or confirmed, and a 0 would pull the average down.
- **Data types.** `amount`, `quantity`, `unit_price` and `revenue_calc` are right-aligned numbers; `=COUNT(I2:I91)` returns 87 (90 rows minus the 3 blanks), so nothing numeric is stored as text. `order_month` was deliberately kept as plain text (`2026-09`, `2026-10`, `2026-11`).
- **Duplicates.** No duplicate `order_id` exists: 90 rows and 90 distinct ids (1001 to 1090).
- **Outliers.** Among the 63 completed orders the largest amount is 15600, shared by four orders: 1061, 1065, 1069 and 1077 (all Air Fryer, quantity 3). The smallest is 1100 (Table Lamp). None is an error: for every completed order `amount` equals `revenue_calc` (unit_price x quantity).
- **Decision for a colleague who inherits the sheet.** Revenue always means `status = completed`; pending and disputed rows (including the blank amounts) must be filtered out before summing, and blank amounts must not be filled in.

## (f) Setup

- Tabs created: `orders` and `products` (plus the derived `completed_orders` tab).
- Rows imported into `orders`: 90.
- `products` tab occupies range `A1:C10` (header in row 1, 9 products), pasted from `SELECT item, category, unit_price FROM products ORDER BY item`.
- Filter and sort applied before building `completed_orders`: filter `status = completed` (63 visible rows), then sort by `amount` from largest to smallest; those 63 rows were pasted as values. Ties were kept in ascending `order_id` order.
- order_month import: Sheets converted the values to dates on import, so I rebuilt the column as text with =TEXT(B2,"yyyy-mm"), pasted the results back as values only, and set the column to Plain text. The values are now text such as 2026-09.
- Fallback test of XLOOKUP in a spare cell outside the data: `=XLOOKUP("Mystery Item",products!$A$2:$A$10,products!$C$2:$C$10,"UNKNOWN_ITEM")` displays `UNKNOWN_ITEM`. No real order uses a missing item, so the fallback never fires on the data rows.
- Export: `data/orders_clean.csv` holds the header plus the 63 data rows with the 13 columns required by the brief; the aggregate block and pivot tables are outside that range.
