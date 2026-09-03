# Data Dictionary

## Dimensions
### Branch
`branch_id`, branch name, city, region, cluster, store size.

### Category
`category_id`, category name, department.

### Supplier
`supplier_id`, supplier name, target fill rate, target lead time.

### Product
`sku_id`, SKU name, category, brand, supplier, unit cost, regular price, active flag.

### Promotion
`promotion_id`, category, start/end dates, discount depth.

## Facts
### Sales
Grain: Date × Branch × SKU × Channel.  
Measures: units, orders, customers, gross sales, discount, net sales, cost.

### Inventory Monthly
Grain: Snapshot Date × Branch × SKU.  
Measures: stock units, stock cost, expiry date.

### Purchase Orders
Grain: PO line.  
Measures: ordered qty, received qty, expected/actual dates.

### Web Funnel
Grain: Date × SKU.  
Measures: PDP views, add-to-cart, online orders.
