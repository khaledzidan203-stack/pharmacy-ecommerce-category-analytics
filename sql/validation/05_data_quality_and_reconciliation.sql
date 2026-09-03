USE PharmacyEcommerceCategoryAnalytics;
GO
-- Duplicate grains
SELECT sales_date,branch_id,sku_id,channel,COUNT(*) duplicate_count
FROM staging.fact_sales GROUP BY sales_date,branch_id,sku_id,channel HAVING COUNT(*)>1;

SELECT snapshot_date,branch_id,sku_id,COUNT(*) duplicate_count
FROM staging.fact_inventory_monthly GROUP BY snapshot_date,branch_id,sku_id HAVING COUNT(*)>1;

-- Referential / arithmetic / domain checks
SELECT COUNT(*) orphan_sales_products
FROM staging.fact_sales s LEFT JOIN staging.dim_product p ON p.sku_id=s.sku_id
WHERE p.sku_id IS NULL;

SELECT COUNT(*) orphan_sales_branches
FROM staging.fact_sales s LEFT JOIN staging.dim_branch b ON b.branch_id=s.branch_id
WHERE b.branch_id IS NULL;

SELECT COUNT(*) invalid_sales_arithmetic
FROM staging.fact_sales
WHERE ABS(net_sales-(gross_sales-discount_value))>0.01;

SELECT COUNT(*) negative_inventory
FROM staging.fact_inventory_monthly
WHERE stock_units<0 OR stock_cost<0;

SELECT COUNT(*) invalid_po
FROM staging.fact_purchase_order
WHERE ordered_qty<=0 OR received_qty<0 OR received_qty>ordered_qty
   OR expected_date<order_date OR received_date<order_date;

SELECT COUNT(*) invalid_web_funnel
FROM staging.fact_web_daily
WHERE add_to_cart>product_detail_views OR online_orders>add_to_cart;

-- Reconcile analytics to source
SELECT
  (SELECT SUM(net_sales) FROM staging.fact_sales) source_net_sales,
  (SELECT SUM(net_sales) FROM analytics.vw_sales_enriched) analytics_net_sales,
  (SELECT SUM(net_sales) FROM staging.fact_sales)-
  (SELECT SUM(net_sales) FROM analytics.vw_sales_enriched) difference;

SELECT
  (SELECT SUM(net_sales-cost_value) FROM staging.fact_sales) source_gross_margin,
  (SELECT SUM(gross_margin) FROM analytics.vw_sales_enriched) analytics_gross_margin,
  (SELECT SUM(net_sales-cost_value) FROM staging.fact_sales)-
  (SELECT SUM(gross_margin) FROM analytics.vw_sales_enriched) difference;
GO
