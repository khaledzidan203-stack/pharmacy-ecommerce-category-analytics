# Power BI Reporting Model

## Purpose

The Power BI layer is intentionally lightweight because the project already performs the main transformation, data-quality, reconciliation, and analytical business logic in SQL Server.

Power BI consumes validated analytical outputs and turns them into interactive business reporting.

```text
SQL Server Staging
→ SQL Validation
→ SQL Analytics Views
→ Power BI Import Model
→ DAX Measures
→ Interactive Reports
```

## Primary Analytical Sources

- `analytics.vw_sales_enriched`
- `analytics.vw_category_scorecard`
- `analytics.vw_ecommerce_funnel`
- `analytics.vw_inventory_risk`
- `analytics.vw_supplier_performance`
- `analytics.vw_assortment_action`

These views are domain-oriented analytical datasets prepared specifically for category, commercial, e-commerce, inventory, and supplier analysis.

## Modeling Principles

- Prefer **Import mode** for this portfolio-scale dataset.
- Keep complex fixed transformations upstream in SQL Server.
- Use a dedicated DAX measure layer for reusable report calculations.
- Avoid duplicating SQL business rules in DAX unless interaction or filter context requires it.
- Add relationships only where analytically justified.
- Avoid unnecessary fact-to-fact relationships.
- Avoid unexpected many-to-many relationships.
- Avoid bidirectional filtering unless a specific validated use case requires it.
- Use explicit measures instead of uncontrolled implicit aggregations.
- Hide technical fields from report consumers where practical.
- Keep report pages aligned to clear business questions and analytical grains.

## Why Analytical Views Are Used

The reporting architecture deliberately separates responsibilities:

**SQL Server**
- transformations
- business rules
- data quality
- reconciliation
- reusable analytical views

**Power BI**
- KPI presentation
- filter context
- rankings
- visual comparisons
- interactive slicing
- decision-support storytelling

This reduces duplicated logic and makes validation easier because Power BI results can be reconciled against independent SQL/Python baselines.

## Source-Control Strategy

The report is stored in Power BI Project format:

- `PharmacyEcommerceCategoryAnalytics.pbip`
- `PharmacyEcommerceCategoryAnalytics.Report/`
- `PharmacyEcommerceCategoryAnalytics.SemanticModel/`

PBIP/PBIR is preferred for the repository because it exposes report and semantic-model definitions as source-controlled artifacts instead of relying only on a binary PBIX file.
