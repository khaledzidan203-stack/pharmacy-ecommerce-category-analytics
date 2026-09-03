# Data Quality Framework

## Checks
- Primary/business-key uniqueness.
- Referential integrity across products, categories, suppliers and branches.
- Sales arithmetic: Net Sales = Gross Sales - Discount.
- Non-negative quantities and commercial values where required.
- Purchase-order quantity and date logic.
- Web-funnel monotonicity: PDP Views >= Add to Cart >= Orders.
- Inventory validity.
- Source-to-analytics reconciliation.
- Ratio denominator safety.

## Policy
Do not hide bad rows with `DISTINCT`, blanket zero-filling or silent dropping. Classify, quantify and document exceptions.
