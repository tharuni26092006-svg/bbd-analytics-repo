# Dashboard Specification (Part C)

Tool target: Tableau Public. All figures come from `data/orders_clean.csv` (63 completed orders, amounts in INR) and agree with Part A (q05, q11) and Part B (pivots).

## 1. Data source

Connect to `data/orders_clean.csv` (text file connection). Set `order_month` to String so it stays as `2026-09`.

| # | Column | Classification |
|---|---|---|
| 1 | order_id | Dimension |
| 2 | order_month | Dimension |
| 3 | clean_first_name | Dimension |
| 4 | clean_last_name | Dimension |
| 5 | region | Dimension |
| 6 | rep_name | Dimension |
| 7 | item | Dimension |
| 8 | category | Dimension |
| 9 | unit_price | Measure |
| 10 | quantity | Measure |
| 11 | amount | Measure |
| 12 | revenue_calc | Measure |
| 13 | status | Dimension |

Totals: 9 Dimensions and 4 Measures. `order_id` is a Dimension because it is an identifier, not something to add up.

## 2. KPI cards

| KPI card | Definition | Value shown |
|---|---|---|
| Total Revenue | SUM(amount) | 346,200 INR |
| Total Units Sold | SUM(quantity) | 106 |

The Total Revenue card equals Part A's q05 `total_revenue` (346200).

## 3. Chart sheets

### 3.1 Revenue by Region (bar chart)

- Columns shelf: SUM(amount). Rows shelf: region (sorted descending). Colour shelf: region.
- Why: a bar chart compares one measure across a few discrete groups, so the ranking of regions is read from bar length.

| region | Revenue (INR) |
|---|---|
| North | 119300 |
| South | 82500 |
| West | 74900 |
| East | 69500 |
| **Total** | **346200** |

### 3.2 Revenue by Category (bar chart)

- Columns shelf: SUM(amount). Rows shelf: category (sorted descending). Colour shelf: category.
- Why: three categories are compared on the same measure, which bars show most clearly.

| category | Revenue (INR) |
|---|---|
| Electronics | 142300 |
| Home | 126400 |
| Apparel | 77500 |
| **Total** | **346200** |

### 3.3 Revenue Trend by Month and Category (line chart)

- Columns shelf: order_month (discrete). Rows shelf: SUM(amount). Colour shelf: category (one line per category).
- Why: a line over ordered months shows direction and change over time, and one line per category shows which category drives the change.

| order_month | Apparel | Electronics | Home | Month total |
|---|---|---|---|---|
| 2026-09 | 24700 | 43000 | 30600 | 98300 |
| 2026-10 | 30600 | 49900 | 12600 | 93100 |
| 2026-11 | 22200 | 49400 | 83200 | 154800 |
| **Total** | 77500 | 142300 | 126400 | **346200** |

### 3.4 Region x Category Detail (text table)

- Rows shelf: region. Columns shelf: category. Text (label) on the Marks card: SUM(amount). Colour shelf: none (optional light shading by SUM(amount)).
- Why: a text table gives the exact value for every region/category pair, which a chart cannot.

| region | Apparel | Electronics | Home | Total |
|---|---|---|---|---|
| North | 19400 | 73400 | 26500 | 119300 |
| South | 10000 | 28700 | 43800 | 82500 |
| West | 37500 | 18800 | 18600 | 74900 |
| East | 10600 | 21400 | 37500 | 69500 |
| **Total** | 77500 | 142300 | 126400 | **346200** |

## 4. Dashboard layout

Placement order, top to bottom:

1. KPI cards (Total Revenue, Total Units Sold)
2. Category filter
3. Revenue Trend by Month and Category (line chart, full width)
4. Comparison charts: Revenue by Region and Revenue by Category, side by side
5. Region x Category Detail (text table)

Containers: one outer **vertical container** holds everything. Inside it, a **horizontal container** holds the two KPI cards (top band), followed by a **horizontal container** for the category filter (the top band directly below the KPI cards), then the trend chart, then a **horizontal container** with the two bar charts side by side, and finally the detail table.

Category filter: a single-value/multiple-value (list) filter on `category`, set to **Apply to Worksheets > All Using This Data Source**, so it filters all worksheets built on `orders_clean.csv`, including the four chart sheets.

Use as Filter: with **Use as Filter** switched on for Revenue by Region, clicking the North bar filters every other sheet on the dashboard (KPI cards, category chart, trend lines and detail table) to North's orders only, for example Total Revenue becomes 119,300.

## 5. Insight and recommendation narrative

### Visualization summary

The dashboard shows total completed-order revenue of 346,200 INR from 106 units, and breaks it down by region (North highest), by category (Electronics highest), by month (a sharp rise in 2026-11) and as a region-by-category grid. The category filter and click-to-filter on the region bars let a manager isolate any region or category.

### Summary analysis

1. **Region comparison.** North earned 119,300, about 34.5% of the total and 49,800 more than East at 69,500, the lowest region.
2. **Change across months.** Total revenue fell from 98,300 in 2026-09 to 93,100 in 2026-10 (-5.3%), then jumped to 154,800 in 2026-11 (+66.3%).
3. **Category driving the swing.** Home revenue went from 12,600 in 2026-10 to 83,200 in 2026-11, while Apparel dropped from 30,600 to 22,200 (-27.5%) over the same months.
4. **Category concentration.** Electronics is the largest category at 142,300 (41.1% of revenue), and North alone contributes 73,400 of it.
5. **Region-specific change.** North's own revenue fell from 53,500 in 2026-09 to 41,300 in 2026-10 (-22.8%) and to 24,500 in 2026-11.

### Recommendations

1. **West and East: Electronics promotional push.** Electronics is only 18,800 in West and 21,400 in East (40,200 combined) against 73,400 in North. Run an Electronics promotion (Wireless Earbuds and Smart Watch) in both regions. Metric to watch: combined West + East Electronics completed revenue next cycle versus the 40,200 baseline.
2. **Home (Air Fryer): stock decision for South and East.** Air Fryer earned 104,000 (30.0% of revenue) and Home jumped from 12,600 to 83,200 in 2026-11, with South (36,400) and East (31,200) the top Air Fryer regions. Increase Air Fryer stock in South and East before the next sale. Metric to watch: Air Fryer units sold per region and number of stock-out days.
3. **South and East: Apparel promotion.** Apparel fell from 30,600 to 22,200 (-27.5%) between 2026-10 and 2026-11, and is only 10,000 in South and 10,600 in East versus 37,500 in West. Run an Apparel offer (Running Shoes, Denim Jacket) in South and East. Metric to watch: combined South + East Apparel revenue versus the 20,600 baseline.

## 6. Reconciliation

| Check | Value (INR) |
|---|---|
| Total Revenue KPI | 346200 |
| Sum of Revenue by Region (119300 + 82500 + 74900 + 69500) | 346200 |
| Sum of Revenue by Category (142300 + 126400 + 77500) | 346200 |
| Part B pivot (i) grand total | 346200 |

All four values are equal.
