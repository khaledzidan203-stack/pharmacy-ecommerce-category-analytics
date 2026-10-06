# Project Evidence Map

This file maps high-level project claims to the repository artifacts that support them.

| Claim | Evidence | Status |
|---|---|---|
| Synthetic-only pharmacy retail/e-commerce data | `data/sample/`, root README | Supported |
| 8 branches, 6 categories, 6 suppliers, 60 SKUs | `docs/validation/EXPECTED_BASELINES.json` | Automated baseline |
| 48,722 sales rows / 10,860 web rows / 2,880 inventory rows / 450 PO rows | `EXPECTED_BASELINES.json`, `python/validate_portfolio.py` | Automated baseline |
| SAR 4,717,692.51 Net Sales / SAR 1,672,360.70 Gross Margin | baseline JSON + Python validator | Automated baseline |
| Explicit fact grains | `docs/architecture/ARCHITECTURE.md`, SQL DDL | Source contract |
| Six governed analytical views | `sql/analytics/03_create_analytics_views.sql` | Implemented |
| DQ and source-to-analytics reconciliation | `sql/validation/05_data_quality_and_reconciliation.sql` | Executable SQL contract |
| Independent public-sample validation | `python/validate_portfolio.py` | Automated / CI |
| Clone-safe tests | `tests/test_portfolio_data.py` | Automated / CI |
| Power BI project is source controlled | `powerbi/*.pbip`, Report and SemanticModel folders | Implemented |
| 22 current DAX measures | `.../tables/_Measures.tmdl` | Static source evidence |
| 9 current report pages | `.../pages/pages.json` | Static source evidence |
| 62 saved visuals | PBIR per-page `visuals/` folders | Static source evidence |
| Auto Date/Time remains enabled | semantic `model.tmdl` + `relationships.tmdl` | Audited limitation |
| Fresh Power BI runtime reconciliation | No retained Desktop/DAX execution artifact | Not claimed |
| Promotion uplift is causal | No counterfactual design exists | Not claimed |

## Evidence rule

Presentation files may summarize these facts but do not replace the authoritative source artifacts above.
