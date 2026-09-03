# Power BI Semantic Model

Recommended model:
- Dimensions: Date, Branch, Category, Product, Supplier, Promotion, Channel.
- Facts: Sales, Inventory Monthly, Purchase Order, Web Daily.
- One-to-many single-direction relationships from dimensions to facts.
- Dedicated Date table; mark as date table.
- Avoid fact-to-fact relationships.
- Hide technical keys from report users.
- Use measures instead of implicit aggregations.

For this portfolio scale, Import mode is recommended. Preserve query folding and push fixed transformations upstream where practical.
