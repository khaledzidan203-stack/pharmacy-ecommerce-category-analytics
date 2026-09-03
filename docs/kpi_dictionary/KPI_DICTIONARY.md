# KPI Dictionary

| KPI | Definition | Formula / Baseline | Grain / Notes |
|---|---|---|---|
| Net Sales | Sales after discount | Gross Sales - Discount | additive |
| Gross Margin | Commercial margin value | Net Sales - Cost | additive |
| Margin % | Margin relative to sales | Gross Margin / Net Sales | ratio |
| Average Order Value | Sales per order | Net Sales / Orders | ratio |
| Sales Contribution % | Share of selected total | Entity Sales / Relevant Total Sales | filter-context aware |
| E-commerce Sales Mix | Online share | E-commerce Sales / Total Sales | ratio |
| Add-to-Cart Rate | Cart adds per PDP view | Add to Cart / PDP Views | digital funnel |
| Conversion Rate | Online orders per PDP view | Online Orders / PDP Views | digital funnel |
| Days of Coverage | Inventory coverage | Stock Units / Avg Daily Units | snapshot + trailing sales |
| OOS Flag | No available stock | Stock Units = 0 | exception |
| Overstock Flag | Excess coverage | Days of Coverage > 90 | configurable |
| Dead Stock Flag | Stock with no trailing sales | 30-day units = 0 and stock > 0 | configurable |
| Near Expiry Flag | Inventory within risk horizon | Expiry <= Snapshot + 90 days | configurable |
| Supplier Fill Rate | Qty delivered vs ordered | Received Qty / Ordered Qty | supplier |
| Lead Time | Days to receive | Received Date - Order Date | supplier |
| ABC Class | Cumulative sales segmentation | A<=70%, B<=90%, C<=97%, D>97% | decision support |

Every ratio must use safe denominator handling (`NULLIF` in SQL, `DIVIDE` in DAX).
