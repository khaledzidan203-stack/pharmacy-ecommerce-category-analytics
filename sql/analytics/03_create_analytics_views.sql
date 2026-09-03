USE PharmacyEcommerceCategoryAnalytics;
GO
CREATE OR ALTER VIEW analytics.vw_sales_enriched AS
SELECT
    s.sales_date,s.branch_id,b.branch_name,b.city,b.cluster_name,s.sku_id,p.sku_name,
    c.category_id,c.category_name,p.brand,p.supplier_id,s.channel,s.promotion_id,
    s.units_sold,s.orders,s.customers,s.gross_sales,s.discount_value,s.net_sales,s.cost_value,
    s.net_sales-s.cost_value AS gross_margin
FROM staging.fact_sales s
JOIN staging.dim_branch b ON b.branch_id=s.branch_id
JOIN staging.dim_product p ON p.sku_id=s.sku_id
JOIN staging.dim_category c ON c.category_id=p.category_id;
GO

CREATE OR ALTER VIEW analytics.vw_category_scorecard AS
SELECT category_id,category_name,
       SUM(net_sales) net_sales,
       SUM(gross_margin) gross_margin,
       CAST(SUM(gross_margin)/NULLIF(SUM(net_sales),0) AS DECIMAL(10,4)) margin_pct,
       SUM(units_sold) units_sold,SUM(orders) orders,SUM(customers) customers,
       CAST(SUM(net_sales)/NULLIF(SUM(orders),0) AS DECIMAL(12,2)) average_order_value
FROM analytics.vw_sales_enriched
GROUP BY category_id,category_name;
GO

CREATE OR ALTER VIEW analytics.vw_ecommerce_funnel AS
SELECT c.category_id,c.category_name,
       SUM(w.product_detail_views) pdp_views,SUM(w.add_to_cart) add_to_cart,SUM(w.online_orders) online_orders,
       CAST(SUM(w.add_to_cart)*1.0/NULLIF(SUM(w.product_detail_views),0) AS DECIMAL(10,4)) add_to_cart_rate,
       CAST(SUM(w.online_orders)*1.0/NULLIF(SUM(w.product_detail_views),0) AS DECIMAL(10,4)) conversion_rate
FROM staging.fact_web_daily w
JOIN staging.dim_product p ON p.sku_id=w.sku_id
JOIN staging.dim_category c ON c.category_id=p.category_id
GROUP BY c.category_id,c.category_name;
GO

CREATE OR ALTER VIEW analytics.vw_inventory_risk AS
WITH sales30 AS (
 SELECT branch_id,sku_id,SUM(units_sold) units_30
 FROM staging.fact_sales
 WHERE sales_date > DATEADD(DAY,-30,(SELECT MAX(sales_date) FROM staging.fact_sales))
 GROUP BY branch_id,sku_id
)
SELECT i.snapshot_date,i.branch_id,b.branch_name,i.sku_id,p.sku_name,c.category_name,
       i.stock_units,i.stock_cost,i.expiry_date,
       CAST(i.stock_units/NULLIF(s.units_30/30.0,0) AS DECIMAL(10,1)) days_of_coverage,
       CASE WHEN i.stock_units=0 THEN 1 ELSE 0 END oos_flag,
       CASE WHEN i.expiry_date<=DATEADD(DAY,90,i.snapshot_date) AND i.stock_units>0 THEN 1 ELSE 0 END near_expiry_flag,
       CASE WHEN s.units_30=0 AND i.stock_units>0 THEN 1 ELSE 0 END dead_stock_flag,
       CASE WHEN i.stock_units/NULLIF(s.units_30/30.0,0)>90 THEN 1 ELSE 0 END overstock_flag
FROM staging.fact_inventory_monthly i
JOIN staging.dim_branch b ON b.branch_id=i.branch_id
JOIN staging.dim_product p ON p.sku_id=i.sku_id
JOIN staging.dim_category c ON c.category_id=p.category_id
LEFT JOIN sales30 s ON s.branch_id=i.branch_id AND s.sku_id=i.sku_id;
GO

CREATE OR ALTER VIEW analytics.vw_supplier_performance AS
SELECT s.supplier_id,s.supplier_name,
       SUM(po.ordered_qty) ordered_qty,SUM(po.received_qty) received_qty,
       CAST(SUM(po.received_qty)*1.0/NULLIF(SUM(po.ordered_qty),0) AS DECIMAL(10,4)) fill_rate,
       CAST(AVG(CAST(DATEDIFF(DAY,po.order_date,po.received_date) AS DECIMAL(10,2))) AS DECIMAL(10,2)) actual_lead_time_days,
       s.target_fill_rate,s.target_lead_time_days,
       SUM(CASE WHEN po.received_date>po.expected_date THEN 1 ELSE 0 END) late_po_count
FROM staging.fact_purchase_order po
JOIN staging.dim_supplier s ON s.supplier_id=po.supplier_id
GROUP BY s.supplier_id,s.supplier_name,s.target_fill_rate,s.target_lead_time_days;
GO

CREATE OR ALTER VIEW analytics.vw_assortment_action AS
WITH sku AS (
 SELECT sku_id,sku_name,category_name,
        SUM(net_sales) net_sales,SUM(gross_margin) gross_margin,SUM(units_sold) units_sold
 FROM analytics.vw_sales_enriched
 GROUP BY sku_id,sku_name,category_name
), ranked AS (
 SELECT *,
   SUM(net_sales) OVER() portfolio_sales,
   SUM(net_sales) OVER(ORDER BY net_sales DESC ROWS UNBOUNDED PRECEDING) cumulative_sales
 FROM sku
)
SELECT sku_id,sku_name,category_name,net_sales,gross_margin,units_sold,
       CAST(cumulative_sales/NULLIF(portfolio_sales,0) AS DECIMAL(10,4)) cumulative_sales_pct,
       CASE WHEN cumulative_sales/NULLIF(portfolio_sales,0)<=0.70 THEN 'A'
            WHEN cumulative_sales/NULLIF(portfolio_sales,0)<=0.90 THEN 'B'
            WHEN cumulative_sales/NULLIF(portfolio_sales,0)<=0.97 THEN 'C' ELSE 'D' END abc_class,
       CASE WHEN units_sold=0 THEN 'REVIEW / REMOVE'
            WHEN gross_margin<=0 THEN 'MARGIN REVIEW'
            ELSE 'KEEP / OPTIMIZE' END assortment_action
FROM ranked;
GO
