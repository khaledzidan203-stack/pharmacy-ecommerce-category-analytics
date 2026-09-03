USE PharmacyEcommerceCategoryAnalytics;
GO
DROP TABLE IF EXISTS staging.fact_web_daily;
DROP TABLE IF EXISTS staging.fact_purchase_order;
DROP TABLE IF EXISTS staging.fact_inventory_monthly;
DROP TABLE IF EXISTS staging.fact_sales;
DROP TABLE IF EXISTS staging.dim_promotion;
DROP TABLE IF EXISTS staging.dim_product;
DROP TABLE IF EXISTS staging.dim_supplier;
DROP TABLE IF EXISTS staging.dim_category;
DROP TABLE IF EXISTS staging.dim_branch;
GO

CREATE TABLE staging.dim_branch(
 branch_id INT PRIMARY KEY, branch_name VARCHAR(100) NOT NULL, city VARCHAR(60) NOT NULL,
 region VARCHAR(40) NOT NULL, cluster_name VARCHAR(30) NOT NULL, store_size VARCHAR(20) NOT NULL
);
CREATE TABLE staging.dim_category(
 category_id INT PRIMARY KEY, category_name VARCHAR(100) NOT NULL, department VARCHAR(80) NOT NULL
);
CREATE TABLE staging.dim_supplier(
 supplier_id INT PRIMARY KEY, supplier_name VARCHAR(120) NOT NULL,
 target_fill_rate DECIMAL(6,4) NOT NULL, target_lead_time_days INT NOT NULL
);
CREATE TABLE staging.dim_product(
 sku_id INT PRIMARY KEY, sku_name VARCHAR(180) NOT NULL, category_id INT NOT NULL,
 brand VARCHAR(80) NOT NULL, supplier_id INT NOT NULL, unit_cost DECIMAL(12,2) NOT NULL,
 regular_price DECIMAL(12,2) NOT NULL, active_flag BIT NOT NULL,
 FOREIGN KEY(category_id) REFERENCES staging.dim_category(category_id),
 FOREIGN KEY(supplier_id) REFERENCES staging.dim_supplier(supplier_id)
);
CREATE TABLE staging.dim_promotion(
 promotion_id INT PRIMARY KEY, promotion_name VARCHAR(100) NOT NULL, category_id INT NOT NULL,
 start_date DATE NOT NULL, end_date DATE NOT NULL, discount_depth DECIMAL(6,4) NOT NULL,
 FOREIGN KEY(category_id) REFERENCES staging.dim_category(category_id)
);
CREATE TABLE staging.fact_sales(
 sales_date DATE NOT NULL, branch_id INT NOT NULL, sku_id INT NOT NULL, channel VARCHAR(20) NOT NULL,
 promotion_id INT NOT NULL DEFAULT 0, units_sold INT NOT NULL, orders INT NOT NULL, customers INT NOT NULL,
 gross_sales DECIMAL(14,2) NOT NULL, discount_value DECIMAL(14,2) NOT NULL,
 net_sales DECIMAL(14,2) NOT NULL, cost_value DECIMAL(14,2) NOT NULL,
 CONSTRAINT PK_fact_sales PRIMARY KEY(sales_date,branch_id,sku_id,channel),
 FOREIGN KEY(branch_id) REFERENCES staging.dim_branch(branch_id),
 FOREIGN KEY(sku_id) REFERENCES staging.dim_product(sku_id)
);
CREATE TABLE staging.fact_inventory_monthly(
 snapshot_date DATE NOT NULL, branch_id INT NOT NULL, sku_id INT NOT NULL,
 stock_units INT NOT NULL, stock_cost DECIMAL(14,2) NOT NULL, expiry_date DATE NOT NULL,
 CONSTRAINT PK_fact_inventory_monthly PRIMARY KEY(snapshot_date,branch_id,sku_id),
 FOREIGN KEY(branch_id) REFERENCES staging.dim_branch(branch_id),
 FOREIGN KEY(sku_id) REFERENCES staging.dim_product(sku_id)
);
CREATE TABLE staging.fact_purchase_order(
 po_id INT PRIMARY KEY, supplier_id INT NOT NULL, sku_id INT NOT NULL, order_date DATE NOT NULL,
 expected_date DATE NOT NULL, received_date DATE NOT NULL, ordered_qty INT NOT NULL, received_qty INT NOT NULL,
 FOREIGN KEY(supplier_id) REFERENCES staging.dim_supplier(supplier_id),
 FOREIGN KEY(sku_id) REFERENCES staging.dim_product(sku_id)
);
CREATE TABLE staging.fact_web_daily(
 activity_date DATE NOT NULL, sku_id INT NOT NULL, product_detail_views INT NOT NULL,
 add_to_cart INT NOT NULL, online_orders INT NOT NULL,
 CONSTRAINT PK_fact_web_daily PRIMARY KEY(activity_date,sku_id),
 FOREIGN KEY(sku_id) REFERENCES staging.dim_product(sku_id)
);
GO
