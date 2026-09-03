USE PharmacyEcommerceCategoryAnalytics;
GO
-- 1. Category ranking by sales and margin
SELECT * FROM analytics.vw_category_scorecard ORDER BY net_sales DESC;

-- 2. E-commerce funnel by category
SELECT * FROM analytics.vw_ecommerce_funnel ORDER BY conversion_rate DESC;

-- 3. Inventory exceptions
SELECT TOP (100) * FROM analytics.vw_inventory_risk
WHERE oos_flag=1 OR near_expiry_flag=1 OR dead_stock_flag=1 OR overstock_flag=1
ORDER BY stock_cost DESC;

-- 4. Supplier risk
SELECT * FROM analytics.vw_supplier_performance
ORDER BY fill_rate ASC, actual_lead_time_days DESC;

-- 5. Assortment actions / ABC
SELECT * FROM analytics.vw_assortment_action ORDER BY net_sales DESC;

-- 6. Promotion descriptive comparison (not causal)
SELECT promotion_id,
       SUM(net_sales) net_sales,SUM(units_sold) units_sold,SUM(gross_margin) gross_margin
FROM analytics.vw_sales_enriched
GROUP BY promotion_id
ORDER BY promotion_id;

-- 7. Channel mix
SELECT channel,SUM(net_sales) net_sales,SUM(orders) orders,
       CAST(SUM(net_sales)/NULLIF(SUM(orders),0) AS DECIMAL(12,2)) average_order_value
FROM analytics.vw_sales_enriched
GROUP BY channel;
GO
