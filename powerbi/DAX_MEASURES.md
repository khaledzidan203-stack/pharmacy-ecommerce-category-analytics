# DAX Measures

```DAX
Net Sales = SUM(FactSales[net_sales])

Gross Margin = SUM(FactSales[net_sales]) - SUM(FactSales[cost_value])

Margin % = DIVIDE([Gross Margin], [Net Sales])

Orders = SUM(FactSales[orders])

Customers = SUM(FactSales[customers])

Average Order Value = DIVIDE([Net Sales], [Orders])

E-commerce Sales =
CALCULATE([Net Sales], DimChannel[channel] = "E-commerce")

E-commerce Sales Mix % =
DIVIDE([E-commerce Sales], [Net Sales])

PDP Views = SUM(FactWeb[product_detail_views])

Add to Cart = SUM(FactWeb[add_to_cart])

Online Orders = SUM(FactWeb[online_orders])

Add-to-Cart Rate = DIVIDE([Add to Cart], [PDP Views])

Conversion Rate = DIVIDE([Online Orders], [PDP Views])

Stock Units = SUM(FactInventory[stock_units])

Stock Cost = SUM(FactInventory[stock_cost])

Supplier Fill Rate =
DIVIDE(SUM(FactPO[received_qty]), SUM(FactPO[ordered_qty]))
```

## Validation Rule
Every core measure must reconcile to the equivalent SQL baseline before report sign-off.
