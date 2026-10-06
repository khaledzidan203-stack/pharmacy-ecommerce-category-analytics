# Technical Walkthrough — 60–90 Seconds

**0–10 seconds — Scope**

Pharmacy E-commerce Category Analytics is a synthetic end-to-end category intelligence system covering commercial sales, digital funnel behavior, inventory risk, suppliers, promotions, assortment and branch/channel performance.

**10–25 seconds — Grain and governance**

The key design choice is grain control. Sales is Date × Branch × SKU × Channel, inventory is Snapshot Date × Branch × SKU, web activity is Date × SKU, and purchase orders remain at PO-line grain. Those facts are not directly joined for aggregation.

**25–45 seconds — SQL and data quality**

SQL Server holds the fixed business rules. Staging tables enforce typed structures, validation checks duplicates, orphans, arithmetic and funnel consistency, and six analytical views publish business-ready outputs for sales, category, funnel, inventory, supplier and assortment analysis.

**45–60 seconds — Independent validation**

Python validates the committed public sample independently against fixed baselines. The current sample reconciles to SAR 4.72M Net Sales, SAR 1.67M Gross Margin, 74,057 units and 57,348 orders.

**60–75 seconds — Power BI**

Power BI is deliberately thin: six SQL analytical views are imported, a disconnected measure table contains 22 explicit DAX measures, and the saved PBIR report contains 9 pages and 62 visuals.

**75–90 seconds — Evidence boundary**

GitHub Actions runs repository-contract checks, Python validation, pytest and compilation. SQL Server validation is executable locally. Power BI source structure is version controlled, while fresh Desktop/DAX runtime reconciliation is not claimed unless explicit execution evidence is retained.

## Presentation order

Start with the overview image, then explain grain control, the six SQL views, validation baselines, and finally the Power BI report architecture.
