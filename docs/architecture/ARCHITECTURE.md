# Architecture

## Layer Responsibilities
- **Source / Synthetic Sample**: public reproducible CSV data.
- **Staging**: typed relational tables; no dashboard-specific logic.
- **Data Quality**: duplicate, orphan, arithmetic, domain and referential checks.
- **Analytics**: business-ready views at explicit grains.
- **SQL Validation**: source-to-analytics reconciliation and business baselines.
- **Python**: independent validation, distributions and descriptive EDA.
- **Power BI**: semantic measures, interactions and presentation.
- **GitHub**: version control, reproducibility and portfolio evidence.

## Explicit Fact Grains
- `fact_sales`: one row = Date × Branch × SKU × Channel.
- `fact_inventory_monthly`: one row = Snapshot Date × Branch × SKU.
- `fact_purchase_order`: one row = Purchase Order line.
- `fact_web_daily`: one row = Date × SKU.

Facts are not joined directly to other facts for aggregation. Shared dimensions are used to avoid multiplication.
