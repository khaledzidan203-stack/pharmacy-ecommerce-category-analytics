# Pharmacy E-commerce Category Analytics

Production-style portfolio project for **pharmacy retail and e-commerce category management**, built with realistic synthetic data only.

## Executive Summary
The project connects sales, e-commerce funnel behavior, assortment, pricing/promotions, inventory, supplier service, and profitability into one decision-support system for category teams.

**Primary roles demonstrated:** E-commerce Category Specialist · Category Analyst · Pharmacy Retail Data Analyst · Commercial Analytics Analyst · Inventory Analyst · BI Analyst.

## Business Problem
A pharmacy retailer needs a trusted analytical system to answer:
- Which categories/SKUs drive sales, margin, orders and online conversion?
- Which SKUs should be kept, optimized, reviewed or removed?
- Where are OOS, overstock, dead-stock and near-expiry risks?
- Which suppliers create service-level risk?
- How do promotions change sales/margin descriptively?
- How does e-commerce perform versus store channels?
- Which categories require pricing, inventory, assortment or supplier intervention?

## Architecture
```text
Business Problem
→ KPI Definitions
→ Synthetic Data
→ STAGING
→ Data Quality
→ Analytics Views / Star-Schema-Oriented Model
→ SQL Validation
→ Python Validation & EDA
→ Power BI Semantic Model / DAX
→ Dashboard Design
→ Insights
→ GitHub Portfolio
```

## Public Synthetic Dataset
- Branches: 8
- Categories: 6
- Suppliers: 6
- SKUs: 60
- Sales rows: 48,722
- Web funnel rows: 10,860
- Inventory snapshot rows: 2,880
- Purchase orders: 450
- Period: Jan–Jun 2026

All names, suppliers, products, branches and transactions are synthetic.

## Analytical Domains
1. Executive Category Performance
2. E-commerce Funnel & Channel Mix
3. SKU / Brand / Category Performance
4. Assortment & ABC Segmentation
5. Inventory Coverage & Risk
6. Supplier Performance
7. Pricing & Profitability
8. Promotion Descriptive Analysis
9. Branch / Cluster Localization

## Core KPIs
Net Sales · Units · Orders · Customers · Gross Margin · Margin % · Average Order Value · Sales Contribution % · E-commerce Sales Mix · PDP Views · Add-to-Cart Rate · Conversion Rate · Days of Coverage · OOS · Overstock · Dead Stock · Near Expiry · Supplier Fill Rate · Lead Time · ABC Class.

See [KPI Dictionary](docs/kpi_dictionary/KPI_DICTIONARY.md).

## Tech Stack
- SQL Server / T-SQL
- Python / pandas / NumPy
- Power BI / DAX / Power Query design
- Git / GitHub
- CSV synthetic public dataset

## Repository Structure
```text
data/sample/            synthetic portfolio data
sql/ddl/                database and staging tables
sql/staging/            deterministic SQL demo seed
sql/analytics/          analytical views
sql/analysis/           business analysis queries
sql/validation/         DQ and reconciliation
python/                 validation and EDA
src/data_generation/    reproducibility helpers
powerbi/                semantic model, DAX and report design
docs/                   architecture, dictionaries, insights, validation
tests/                  automated Python tests
```

## Quick Start
### Python
```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python python/validate_portfolio.py
python python/category_eda.py
```

### SQL Server
Run in order:
1. `sql/ddl/00_create_database.sql`
2. `sql/ddl/01_create_staging_tables.sql`
3. `sql/staging/02_seed_demo_data.sql`
4. `sql/analytics/03_create_analytics_views.sql`
5. `sql/validation/05_data_quality_and_reconciliation.sql`
6. `sql/analysis/04_business_analysis.sql`

The SQL demo is intentionally compact and executable. The committed CSV public sample is larger and is validated separately with Python.

## Power BI
The repository includes:
- star-schema-oriented semantic design
- DAX measure catalog
- page-by-page report inventory
- SQL-to-DAX validation rules

A `.pbix` file is intentionally not fabricated here. Power BI Desktop execution and screenshots must be produced only after manual build/reconciliation.

## Validation
Python baseline validation is executable and compares the committed sample to fixed reference totals in `docs/validation/EXPECTED_BASELINES.json`.

SQL validation includes duplicate checks, orphan checks, arithmetic checks, domain rules and source-to-analytics reconciliation.

## Portfolio Integrity
- Synthetic data only.
- No employer/customer/patient/prescription data.
- No credentials or database dumps.
- No causal promotion claims.
- Assortment actions are decision-support flags, not autonomous commercial decisions.

## Author
**Khaled Zidan**  
Category Management · Pharmacy Retail · Data Analytics · Business Intelligence
