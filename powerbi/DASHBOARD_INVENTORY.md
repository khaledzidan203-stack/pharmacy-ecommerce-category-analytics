# Power BI Dashboard Inventory

The Power BI report is designed as the final visualization and decision-support layer of the project. It consumes validated SQL analytics views rather than duplicating complex transformation logic inside the report.

## 1. Home

Purpose:
- provide a clean navigation entry point
- route users to each analytical domain

Navigation targets:
- Executive Overview
- E-commerce Funnel
- Category Performance
- SKU & Assortment
- Inventory & Availability
- Supplier Performance
- Pricing & Promotions
- Branch & Channel Performance

## 2. Executive Overview

Purpose:
- management-level commercial health check

Core KPIs:
- Net Sales
- Gross Margin
- Margin %
- Units Sold
- Orders
- Average Order Value
- E-commerce Sales Mix %
- Conversion Rate

Major analytical areas:
- category sales and margin
- e-commerce funnel summary
- inventory-risk summary
- supplier-service summary

## 3. E-commerce Funnel

Primary SQL source:
- `analytics.vw_ecommerce_funnel`

Focus:
- PDP Views
- Add to Cart
- Online Orders
- Add-to-Cart Rate
- Conversion Rate
- category-level conversion performance

## 4. Category Performance

Primary SQL source:
- `analytics.vw_category_scorecard`

Focus:
- category sales ranking
- gross-margin ranking
- margin %
- units
- contribution
- commercial performance comparison

## 5. SKU & Assortment

Primary SQL source:
- `analytics.vw_assortment_action`

Focus:
- SKU performance
- assortment decision-support flags
- stock versus demand
- days of coverage
- OOS / overstock / dead-stock / near-expiry context

Assortment recommendations are decision-support outputs based on validated SQL logic; they are not autonomous commercial decisions.

## 6. Inventory & Availability

Primary SQL source:
- `analytics.vw_inventory_risk`

Focus:
- stock units and stock cost
- OOS
- overstock
- near expiry
- dead stock
- days of coverage
- inventory-risk prioritization

## 7. Supplier Performance

Primary SQL source:
- `analytics.vw_supplier_performance`

Focus:
- ordered versus received quantity
- supplier fill rate
- lead time
- late purchase orders
- supplier-service risk

## 8. Pricing & Promotions

Primary SQL source:
- `analytics.vw_sales_enriched`

Focus:
- gross versus net sales
- discount value and discount depth
- promotional versus non-promotional sales
- promotional sales mix
- margin comparison

Promotion analysis is descriptive only. The project does not claim causal uplift unless a separate causal methodology is implemented.

## 9. Branch & Channel Performance

Primary SQL source:
- `analytics.vw_sales_enriched`

Focus:
- branch sales and margin
- average order value
- e-commerce sales
- store sales
- e-commerce channel mix
- branch/channel ranking

## Reporting Principles

- SQL is the analytical source of truth.
- Power BI is the visualization, filtering, comparison, ranking, and management-storytelling layer.
- Import mode is preferred for this project scale.
- Complex business transformations remain upstream in SQL.
- DAX is used for report-level measures, ratios, and interaction logic.
- Avoid unnecessary fact-to-fact, many-to-many, and bidirectional relationships.
- Use progressive disclosure and concise navigation instead of overloaded report pages.
- Validate important Power BI KPIs against SQL/Python baselines before final sign-off.
