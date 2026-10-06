# Pharmacy E-commerce Category Analytics

## Governed Category, Digital Funnel, Inventory & Supplier Intelligence

[![Repository Validation](https://github.com/khaledzidan203-stack/pharmacy-ecommerce-category-analytics/actions/workflows/python-validation.yml/badge.svg)](https://github.com/khaledzidan203-stack/pharmacy-ecommerce-category-analytics/actions/workflows/python-validation.yml)

Pharmacy E-commerce Category Analytics is an end-to-end decision-support implementation for synthetic pharmacy retail and digital-commerce data. It combines **SQL Server business logic**, **Python validation and descriptive analysis**, and a source-controlled **Power BI PBIP/PBIR/TMDL report** across sales, margin, digital funnel behavior, inventory risk, supplier service, promotions, assortment, and branch/channel performance.

> **Data boundary:** all branches, products, suppliers, promotions, transactions, web-funnel activity, inventory, and purchase orders are synthetic. The repository contains no employer, customer, patient, prescription, or confidential company data.

<img src="docs/assets/Pharmacy%20E-Commerce%20Analytics%20Pipeline.png" alt="Pharmacy E-commerce Category Analytics end-to-end pipeline" width="100%">

**Start here:** [Case study](docs/CASE_STUDY.md) · [Technical walkthrough](docs/TECHNICAL_WALKTHROUGH.md) · [Evidence map](docs/PROJECT_EVIDENCE_MAP.md) · [Project index](docs/PROJECT_INDEX.md) · [Validation](docs/FINAL_RELEASE_VALIDATION.md)

## Project at a glance

| Area | Implemented state |
|---|---|
| Public dataset | Synthetic pharmacy retail + e-commerce CSV data, Jan–Jun 2026 |
| Business scope | Category, SKU, digital funnel, inventory, supplier, promotion, branch and channel analytics |
| Dataset scale | 8 branches · 6 categories · 6 suppliers · 60 SKUs |
| Core activity | 48,722 sales rows · 10,860 web rows · 2,880 inventory rows · 450 purchase-order rows |
| SQL Server | Staging tables + DQ/reconciliation + 6 governed analytical views |
| Python | Independent baseline validation + descriptive EDA |
| Power BI | Import model over 6 analytical views + disconnected `_Measures` table |
| Saved semantic layer | 22 explicit DAX measures |
| Saved report | 9 pages · 62 saved visuals |
| Validation baseline | SAR 4,717,692.51 Net Sales · SAR 1,672,360.70 Gross Margin · 74,057 units · 57,348 orders |
| CI | GitHub Actions executes repository contract checks, public-sample validation, pytest and Python compilation |

## Business problem

Pharmacy e-commerce performance is not a single sales question. Category teams need to evaluate demand, profitability, digital conversion, stock coverage, supplier execution, promotional exposure and assortment together without mixing incompatible grains or duplicating business logic.

This implementation answers questions such as:

- Which categories and SKUs drive sales, margin, units and orders?
- Which digital categories convert PDP views into carts and orders most effectively?
- Where are OOS, overstock, dead-stock and near-expiry risks?
- Which suppliers create replenishment or service-level risk?
- Which SKUs require assortment review or margin intervention?
- How do promotional and non-promotional periods compare descriptively?
- How does channel mix vary by branch and commercial segment?

## End-to-end architecture

```text
Synthetic CSV sources
        ↓
SQL Server STAGING
        ↓
Data Quality + Reconciliation
        ↓
6 governed ANALYTICS views
        ↓
┌───────────────────────┬────────────────────────┐
│ Python validation/EDA │ Power BI Import model  │
│ independent baselines │ 22 explicit measures   │
└───────────────────────┴────────────────────────┘
        ↓
9-page decision-support report
```

The design deliberately keeps fixed transformation, classification and business-rule logic upstream in SQL Server. Power BI acts as a **thin reporting semantic layer** over governed analytical views rather than recreating the SQL transformations.

## Governed analytical grains

| Dataset | Grain |
|---|---|
| Sales | Date × Branch × SKU × Channel |
| Inventory | Snapshot Date × Branch × SKU |
| Purchase Orders | Purchase-order line |
| Web Funnel | Date × SKU |

Facts are not directly joined to other facts for aggregation. Domain-specific SQL views are built at explicit grains to avoid multiplication and misleading totals.

## SQL analytical layer

Six views form the reporting contract:

- `analytics.vw_sales_enriched`
- `analytics.vw_category_scorecard`
- `analytics.vw_ecommerce_funnel`
- `analytics.vw_inventory_risk`
- `analytics.vw_supplier_performance`
- `analytics.vw_assortment_action`

They centralize sales enrichment, category scorecards, funnel ratios, stock-risk rules, supplier service metrics and assortment/ABC logic.

Key business rules include safe denominators, descriptive-only promotion analysis, configurable inventory thresholds and decision-support assortment flags rather than autonomous commercial actions.

## Power BI reporting layer

The repository contains a real source-controlled Power BI Project:

```text
powerbi/
├── PharmacyEcommerceCategoryAnalytics.pbip
├── PharmacyEcommerceCategoryAnalytics.Report/
├── PharmacyEcommerceCategoryAnalytics.SemanticModel/
├── DASHBOARD_INVENTORY.md
├── DAX_MEASURES.md
└── MODEL.md
```

The current saved report contains **9 pages and 62 visuals**:

1. Home
2. Executive Overview
3. E-commerce Funnel
4. Category Performance
5. SKU & Assortment
6. Inventory & Availability
7. Supplier Performance
8. Pricing & Promotions
9. Branch & Channel Performance

The semantic model imports the six governed SQL views and uses a dedicated disconnected `_Measures` table containing **22 explicit measures**. The current saved model also uses Power BI Auto Date/Time for three date relationships; this is documented as a model-hygiene improvement boundary rather than being changed without Desktop regression testing. See [Power BI time-intelligence audit](docs/architecture/POWER_BI_TIME_INTELLIGENCE_AUDIT.md).

## Validation and evidence

Validation is intentionally layered:

| Layer | Current evidence |
|---|---|
| Public CSV sample | Automated Python validation against committed fixed baselines |
| Data quality | Duplicate, orphan, arithmetic, quantity and web-funnel consistency checks |
| SQL | Executable DQ and source-to-analytics reconciliation scripts |
| Python tests | Clone-safe pytest checks for sales grain, arithmetic and funnel monotonicity |
| Power BI structure | Source-controlled PBIP/PBIR/TMDL with 9 pages, 62 visuals and 22 measures |
| Power BI runtime | No fresh Desktop/DAX runtime execution artifact is claimed in the repository |
| CI | Repository contract + protected-core hashes + Python validation + tests + compilation |

This distinction matters: the Power BI implementation is real and source controlled, but repository evidence should not be described as a fresh runtime DAX reconciliation unless that execution evidence is explicitly retained.

## Validated synthetic baselines

| KPI | Baseline |
|---|---:|
| Net Sales | SAR 4,717,692.51 |
| Gross Margin | SAR 1,672,360.70 |
| Units Sold | 74,057 |
| Orders | 57,348 |
| Near-Expiry Units | 3,314 |
| Average Supplier Fill Rate | ~95.0% |
| Average Actual Lead Time | ~5.6 days |

Additional descriptive findings are available in [Python findings](docs/insights/python_findings.md).

## Data-quality policy

The project does not hide exceptions with blanket `DISTINCT`, silent row deletion or uncontrolled zero-filling. Validation checks include key uniqueness, referential integrity, commercial arithmetic, purchase-order domains, non-negative inventory, funnel monotonicity and source-to-analytics reconciliation.

Inventory and assortment flags are business rules, not universal truths. OOS, overstock, dead-stock, near-expiry and ABC thresholds should be treated as governed decision-support definitions.

## Promotion and assortment boundaries

Promotion analysis is **descriptive**, not causal. The project does not claim promotional uplift without a valid counterfactual methodology.

Assortment outputs such as `KEEP / OPTIMIZE`, `MARGIN REVIEW` and `REVIEW / REMOVE` are analytical review flags. They do not automatically prescribe delisting or purchasing decisions.

## Quick Start

### Python

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python python/validate_portfolio.py
python python/category_eda.py
pytest -q
```

### SQL Server

Run in order:

1. `sql/ddl/00_create_database.sql`
2. `sql/ddl/01_create_staging_tables.sql`
3. `sql/staging/02_seed_demo_data.sql`
4. `sql/analytics/03_create_analytics_views.sql`
5. `sql/validation/05_data_quality_and_reconciliation.sql`
6. `sql/analysis/04_business_analysis.sql`

The SQL demo is intentionally compact and executable. The larger committed CSV sample is independently validated by Python and should not be confused with the smaller SQL seed dataset.

### Power BI

Open `powerbi/PharmacyEcommerceCategoryAnalytics.pbip` in a compatible Power BI Desktop environment and configure the local SQL Server connection as needed. PBIP/PBIR/TMDL source is committed; the repository does not rely on a binary PBIX as the only implementation artifact.

## Repository structure

```text
data/sample/            synthetic public sample
sql/ddl/                SQL Server database and staging definitions
sql/staging/            deterministic compact SQL demo seed
sql/analytics/          six governed analytical views
sql/analysis/           business-analysis queries
sql/validation/         DQ and reconciliation
python/                 baseline validation and descriptive EDA
src/data_generation/    reproducibility helpers
powerbi/                PBIP/PBIR/TMDL report source
docs/                   architecture, rules, dictionaries, evidence and validation
tests/                  clone-safe automated tests
scripts/                repository contract validation
```

## Documentation

- [Project index](docs/PROJECT_INDEX.md)
- [Case study](docs/CASE_STUDY.md)
- [Technical walkthrough](docs/TECHNICAL_WALKTHROUGH.md)
- [Project evidence map](docs/PROJECT_EVIDENCE_MAP.md)
- [Architecture](docs/architecture/ARCHITECTURE.md)
- [KPI dictionary](docs/kpi_dictionary/KPI_DICTIONARY.md)
- [Business rules](docs/BUSINESS_RULES.md)
- [Data quality](docs/DATA_QUALITY.md)
- [Setup](docs/SETUP.md)
- [Final release validation](docs/FINAL_RELEASE_VALIDATION.md)

## Limitations

- All data is synthetic and represents a designed retail scenario, not actual pharmacy operations.
- The SQL demo seed is smaller than the committed public CSV sample.
- Promotion comparisons are descriptive.
- Inventory and assortment thresholds are configurable business rules.
- The Power BI model currently retains Auto Date/Time local date tables.
- A fresh Power BI Desktop runtime reconciliation artifact is not stored in the repository.
- No screenshots are presented as report evidence unless they originate from the saved report itself.

Licensed under the [MIT License](LICENSE).
