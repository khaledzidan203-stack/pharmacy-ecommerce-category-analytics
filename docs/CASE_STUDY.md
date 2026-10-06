# Case Study — Pharmacy E-commerce Category Analytics

## Context

A pharmacy retailer needs to manage category performance across physical and digital channels while also controlling stock risk, supplier reliability, pricing, promotions and assortment. These domains do not share one natural grain, so a flat “all-in-one” table can easily multiply sales, stock or order values.

This project implements a governed synthetic decision-support system that keeps each domain at its appropriate grain and centralizes fixed business logic in SQL Server.

## Analytical challenge

The implementation must connect several questions without conflating them:

- commercial performance: sales, margin, units and orders;
- digital behavior: PDP views, add-to-cart and online orders;
- stock health: OOS, overstock, dead stock and near expiry;
- supplier execution: ordered versus received quantity and lead time;
- category/SKU decisions: contribution, ABC class and assortment review;
- pricing/promotions: discount exposure and descriptive comparison;
- branch/channel mix: store versus e-commerce contribution.

## Solution design

The public synthetic sample contains 8 branches, 6 categories, 6 suppliers and 60 SKUs covering Jan–Jun 2026.

SQL Server defines explicit staging grains and publishes six domain-oriented analytical views. Python independently validates keys, arithmetic, domains and fixed release baselines. Power BI imports the governed views and adds a lightweight measure/report layer rather than duplicating SQL transformations.

## Grain control

The four main analytical facts remain separate:

| Fact | Grain |
|---|---|
| Sales | Date × Branch × SKU × Channel |
| Inventory | Snapshot Date × Branch × SKU |
| Purchase Orders | PO line |
| Web Funnel | Date × SKU |

The project avoids direct fact-to-fact aggregation. This is important because, for example, monthly inventory snapshots cannot be safely joined to daily sales rows without first controlling grain.

## Business-rule examples

- Net Sales = Gross Sales − Discount Value.
- Gross Margin = Net Sales − Cost Value.
- Funnel monotonicity requires PDP Views ≥ Add to Cart ≥ Online Orders.
- Supplier Fill Rate = Received Qty / Ordered Qty.
- Near-expiry, dead-stock and overstock are configurable review thresholds.
- ABC segmentation uses cumulative sales contribution.
- Promotion comparisons remain descriptive.
- Assortment actions are review signals, not autonomous decisions.

## Validated public-sample baseline

The committed sample reconciles to:

- Net Sales: SAR 4,717,692.51
- Gross Margin: SAR 1,672,360.70
- Units Sold: 74,057
- Orders: 57,348
- 48,722 sales rows
- 10,860 web-funnel rows
- 2,880 inventory rows
- 450 purchase-order rows

## Reporting implementation

The saved Power BI project contains:

- 6 imported analytical views;
- 22 explicit DAX measures in `_Measures`;
- 9 report pages;
- 62 saved visuals.

The report covers Executive Overview, E-commerce Funnel, Category Performance, SKU & Assortment, Inventory & Availability, Supplier Performance, Pricing & Promotions, and Branch & Channel Performance.

## Validation design

The repository separates validation evidence:

1. Python baseline validation — automated and executed in CI.
2. Pytest — clone-safe grain/arithmetic/funnel checks.
3. SQL validation — executable locally with SQL Server.
4. Power BI source validation — static PBIP/PBIR/TMDL structure.
5. Power BI runtime validation — not claimed unless a Desktop/DAX execution artifact is explicitly retained.

## Engineering outcome

The project demonstrates a reusable pattern for pharmacy category intelligence: fixed business rules upstream, independent reconciliation, clear grain contracts, source-controlled BI artifacts and explicit analytical limitations.

All data is synthetic.
