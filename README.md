# Pharmacy E-commerce Category Analytics

A production-style pharmacy e-commerce category analytics portfolio that combines **SQL Server analytics, Python validation, and Power BI reporting** to evaluate sales, margin, conversion, inventory risk, supplier performance, promotions, and assortment decisions using realistic synthetic retail data only.

## Executive Summary

The project connects pharmacy retail sales, e-commerce funnel behavior, assortment, pricing/promotions, inventory, supplier service, and profitability into one decision-support workflow for category and commercial teams.

**Primary roles demonstrated:** E-commerce Category Specialist · Category Analyst · Pharmacy Retail Data Analyst · Commercial Analytics Analyst · Inventory Analyst · BI Analyst.

## Business Problem

A pharmacy retailer needs a trusted analytical system to answer:

- Which categories and SKUs drive sales, margin, units, orders, and online conversion?
- Which SKUs should be expanded, maintained, reviewed, or reduced?
- Where are out-of-stock, overstock, dead-stock, and near-expiry risks?
- Which suppliers create service-level or replenishment risk?
- How do promotional periods compare descriptively with non-promotional sales?
- How does e-commerce performance compare across categories, branches, and channels?
- Which areas require pricing, inventory, assortment, or supplier intervention?

## Architecture

```text
Business Problem
→ KPI Definitions
→ Synthetic Data
→ SQL Server Staging
→ Data Quality & Reconciliation
→ Validated SQL Analytics Views
→ Python Validation & EDA
→ Power BI Semantic / Measure Layer
→ Interactive Reporting
→ Management Insights
→ GitHub Portfolio
```

The project deliberately keeps complex transformation and business-rule logic upstream in SQL Server. Power BI is used primarily as the **visualization, interaction, KPI, and decision-support layer**.

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

All names, suppliers, products, branches, and transactions are synthetic.

## Analytical Domains

1. Executive Category Performance
2. E-commerce Funnel & Channel Mix
3. Category / SKU Performance
4. Assortment Decision Support
5. Inventory Coverage & Risk
6. Supplier Performance
7. Pricing & Profitability
8. Promotion Descriptive Analysis
9. Branch / Channel Performance

## Core KPIs

Net Sales · Gross Sales · Units Sold · Orders · Customers · Gross Margin · Margin % · Average Order Value · Sales Contribution % · E-commerce Sales Mix % · PDP Views · Add-to-Cart Rate · Conversion Rate · Days of Coverage · OOS · Overstock · Dead Stock · Near Expiry · Supplier Fill Rate · Lead Time · Late POs · Promotional Sales Mix.

See [KPI Dictionary](docs/kpi_dictionary/KPI_DICTIONARY.md).

## Tech Stack

- SQL Server / T-SQL
- Python / pandas / NumPy
- Power BI / DAX / Power Query
- PBIP / PBIR source-controlled report format
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
powerbi/                PBIP, semantic model, report definitions, DAX docs
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

The SQL demo is intentionally executable and compact. The committed public CSV sample is larger and is validated independently with Python.

# Power BI Reporting Layer

Power BI is the final reporting and decision-support layer of the project.

Instead of rebuilding complex transformations inside Power BI, the report consumes **validated SQL analytical views**. This keeps the analytical logic centralized, auditable, testable, and easier to maintain.

### Analytical Sources

The report is designed around these SQL analytics views:

- `analytics.vw_sales_enriched`
- `analytics.vw_category_scorecard`
- `analytics.vw_ecommerce_funnel`
- `analytics.vw_inventory_risk`
- `analytics.vw_supplier_performance`
- `analytics.vw_assortment_action`

### Reporting Flow

```text
SQL Server
→ Validated Analytics Views
→ Power BI Import Model
→ Dedicated DAX Measures
→ Interactive Report Pages
→ Category / Commercial Decisions
```

### Power BI Design Principles

- SQL remains the analytical source of truth.
- Power BI focuses on KPI presentation, interaction, filtering, ranking, comparison, and management storytelling.
- Import-mode reporting is preferred for this portfolio-scale dataset.
- DAX is used for report-level measures and ratios rather than duplicating complex SQL transformations.
- Ratio measures use safe division patterns such as `DIVIDE()`.
- Analytical views remain domain-oriented; relationships are added only when analytically justified.
- Avoid unnecessary bidirectional, many-to-many, and fact-to-fact relationship patterns.
- PBIP/PBIR project files are version controlled instead of relying only on a binary PBIX artifact.

### Report Architecture

The report is organized into nine business-oriented pages:

1. **Home** — navigation and analytical entry point
2. **Executive Overview** — management-level commercial health check
3. **E-commerce Funnel** — PDP views, add-to-cart behavior, orders, and conversion
4. **Category Performance** — category sales, margin, contribution, and ranking
5. **SKU & Assortment** — SKU performance and assortment decision-support actions
6. **Inventory & Availability** — OOS, overstock, near-expiry, dead stock, and coverage
7. **Supplier Performance** — fill rate, lead time, purchase-order service, and supplier risk
8. **Pricing & Promotions** — discount, promotional mix, sales, and margin comparison
9. **Branch & Channel Performance** — branch performance and e-commerce/store channel mix

See [Power BI Dashboard Inventory](powerbi/DASHBOARD_INVENTORY.md).

### Power BI Project Format

The repository includes a real source-controlled Power BI Project:

```text
powerbi/
├── PharmacyEcommerceCategoryAnalytics.pbip
├── PharmacyEcommerceCategoryAnalytics.Report/
├── PharmacyEcommerceCategoryAnalytics.SemanticModel/
├── DASHBOARD_INVENTORY.md
├── DAX_MEASURES.md
└── MODEL.md
```

Using PBIP/PBIR makes the reporting layer suitable for:

- Git version control
- source review
- semantic-model inspection
- DAX measure tracking
- report-definition inspection
- collaborative development
- portfolio demonstration

### KPI Validation Baselines

Power BI metrics are designed to reconcile with validated SQL/Python baselines. Reference values from the synthetic portfolio dataset include:

- Net Sales: **SAR 4,717,692.51**
- Gross Margin: **SAR 1,672,360.70**
- Units Sold: **74,057**
- Orders: **57,348**
- Average Supplier Fill Rate: **approximately 95%**
- Average Supplier Lead Time: **approximately 5.6 days**
- Near-Expiry Units: **3,314**

These baselines provide an independent validation layer for report measures and business KPIs.

> **Power BI presentation note:** The repository emphasizes reproducible analytical architecture, validated SQL business logic, semantic/report structure, and source-controlled PBIP/PBIR implementation. Visual presentation can continue to be refined without changing the validated analytics layer.

## Validation

Python baseline validation is executable and compares the committed sample to fixed reference totals in `docs/validation/EXPECTED_BASELINES.json`.

SQL validation includes duplicate checks, orphan checks, arithmetic checks, domain rules, and source-to-analytics reconciliation.

Power BI validation is based on reconciliation against SQL/Python baselines, source-controlled report definitions, valid measure bindings, and report-structure checks.

## Portfolio Integrity

- Synthetic data only.
- No employer, customer, patient, prescription, or confidential company data.
- No credentials, connection secrets, or database dumps.
- No causal promotion claims.
- Promotion analysis is descriptive unless a causal methodology is explicitly implemented.
- Assortment actions are decision-support flags, not autonomous commercial decisions.

## Author

**Khaled Zidan**  
Category Management · Pharmacy Retail · Data Analytics · Business Intelligence
