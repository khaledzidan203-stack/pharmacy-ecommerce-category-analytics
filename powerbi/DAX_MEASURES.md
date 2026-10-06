# Current DAX Measures

This document mirrors the current saved semantic-model measure layer. The authoritative implementation is:

`powerbi/PharmacyEcommerceCategoryAnalytics.SemanticModel/definition/tables/_Measures.tmdl`

The current saved model contains **22 explicit measures**.

## Commercial

```DAX
Net Sales = SUM('analytics vw_sales_enriched'[net_sales])

Gross Margin = SUM('analytics vw_sales_enriched'[gross_margin])

Margin % = DIVIDE([Gross Margin], [Net Sales])

Average Order Value = DIVIDE([Net Sales], [Orders])

Promo Sales Mix =
DIVIDE(
    CALCULATE(
        [Net Sales],
        'analytics vw_sales_enriched'[promotion_id] <> 0
    ),
    [Net Sales]
)
```

## Core

```DAX
Units Sold = SUM('analytics vw_sales_enriched'[units_sold])

Orders = SUM('analytics vw_sales_enriched'[orders])

Customers = SUM('analytics vw_sales_enriched'[customers])
```

## E-commerce

```DAX
E-commerce Sales =
CALCULATE(
    [Net Sales],
    'analytics vw_sales_enriched'[channel] = "E-commerce"
)

E-commerce Sales Mix =
DIVIDE([E-commerce Sales], [Net Sales])

PDP Views =
SUM('analytics vw_ecommerce_funnel'[pdp_views])

Add to Cart =
SUM('analytics vw_ecommerce_funnel'[add_to_cart])

Online Orders =
SUM('analytics vw_ecommerce_funnel'[online_orders])

Conversion Rate =
DIVIDE([Online Orders], [PDP Views])

Add-to-Cart Rate =
DIVIDE([Add to Cart], [PDP Views])
```

## Inventory

```DAX
Stock Cost =
SUM('analytics vw_inventory_risk'[stock_cost])

Near Expiry Units =
SUMX(
    FILTER(
        'analytics vw_inventory_risk',
        'analytics vw_inventory_risk'[near_expiry_flag] = 1
    ),
    'analytics vw_inventory_risk'[stock_units]
)

Dead Stock Units =
SUMX(
    FILTER(
        'analytics vw_inventory_risk',
        'analytics vw_inventory_risk'[dead_stock_flag] = 1
    ),
    'analytics vw_inventory_risk'[stock_units]
)

Average Days of Coverage =
AVERAGE('analytics vw_inventory_risk'[days_of_coverage])
```

## Supplier

```DAX
Supplier Fill Rate =
DIVIDE(
    SUM('analytics vw_supplier_performance'[received_qty]),
    SUM('analytics vw_supplier_performance'[ordered_qty])
)

Average Lead Time =
AVERAGE('analytics vw_supplier_performance'[actual_lead_time_days])

Ordered Quantity =
SUM('analytics vw_supplier_performance'[ordered_qty])
```

## Validation rule

SQL remains the fixed business-rule source of truth. DAX is used for filter-context-aware reporting measures and should reconcile to compatible SQL/Python baselines before any runtime sign-off is claimed.

This document intentionally follows the saved TMDL names rather than older conceptual names such as `FactSales`, `FactWeb`, `FactInventory` or `FactPO`.
