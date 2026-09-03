USE PharmacyEcommerceCategoryAnalytics;
GO
INSERT INTO staging.dim_branch VALUES
(1,'Khobar Central','Khobar','Eastern','A','Large'),
(2,'Dammam Corniche','Dammam','Eastern','A','Large'),
(3,'Online Fulfillment Hub','Khobar','Eastern','E-COM','Hub');

INSERT INTO staging.dim_category VALUES
(10,'Vitamins & Supplements','Wellness'),
(20,'Dermocosmetics','Beauty & Skin'),
(30,'Oral Care','Personal Care');

INSERT INTO staging.dim_supplier VALUES
(101,'Gulf Health Distribution',0.96,5),
(102,'Arabian Consumer Care',0.97,4),
(104,'Dermacare Supply',0.98,4);

INSERT INTO staging.dim_product VALUES
(1001,'Vitamin C 1000mg',10,'VitaPlus',101,18.00,29.00,1),
(1002,'Multivitamin 30 Tabs',10,'DailyHealth',101,24.00,39.00,1),
(1003,'Moisturizing Cream 100ml',20,'DermaSoft',104,35.00,59.00,1),
(1004,'Sunscreen SPF50',20,'SunGuard',104,42.00,79.00,1),
(1005,'Sensitive Toothpaste',30,'SmileCare',102,12.00,22.00,1),
(1006,'Whitening Toothpaste',30,'BrightDent',102,10.00,19.00,1);

INSERT INTO staging.dim_promotion VALUES
(1,'Wellness January Promo',10,'2026-01-10','2026-01-16',0.15),
(2,'Dermocosmetics February Promo',20,'2026-02-05','2026-02-11',0.20);

;WITH dates AS (
 SELECT CAST('2026-01-01' AS DATE) d
 UNION ALL SELECT DATEADD(DAY,1,d) FROM dates WHERE d<'2026-02-28'
), x AS (
 SELECT d.d,b.branch_id,p.sku_id,
        CASE WHEN b.branch_id=3 THEN 'E-commerce' ELSE 'Store' END channel,
        p.unit_cost,p.regular_price,p.category_id
 FROM dates d CROSS JOIN staging.dim_branch b CROSS JOIN staging.dim_product p
)
INSERT INTO staging.fact_sales
SELECT d,branch_id,sku_id,channel,
       CASE WHEN category_id=10 AND d BETWEEN '2026-01-10' AND '2026-01-16' THEN 1
            WHEN category_id=20 AND d BETWEEN '2026-02-05' AND '2026-02-11' THEN 2 ELSE 0 END,
       1 + ((branch_id*11 + sku_id + DAY(d)) % 5) units_sold,
       1 + ((branch_id + sku_id + DAY(d)) % 3) orders,
       1 + ((branch_id + sku_id + DAY(d)) % 3) customers,
       CAST((1 + ((branch_id*11 + sku_id + DAY(d)) % 5))*regular_price AS DECIMAL(14,2)),
       CAST((1 + ((branch_id*11 + sku_id + DAY(d)) % 5))*regular_price *
          CASE WHEN category_id=10 AND d BETWEEN '2026-01-10' AND '2026-01-16' THEN 0.15
               WHEN category_id=20 AND d BETWEEN '2026-02-05' AND '2026-02-11' THEN 0.20 ELSE 0 END AS DECIMAL(14,2)),
       CAST((1 + ((branch_id*11 + sku_id + DAY(d)) % 5))*regular_price *
          (1-CASE WHEN category_id=10 AND d BETWEEN '2026-01-10' AND '2026-01-16' THEN 0.15
                  WHEN category_id=20 AND d BETWEEN '2026-02-05' AND '2026-02-11' THEN 0.20 ELSE 0 END) AS DECIMAL(14,2)),
       CAST((1 + ((branch_id*11 + sku_id + DAY(d)) % 5))*unit_cost AS DECIMAL(14,2))
FROM x OPTION (MAXRECURSION 1000);

INSERT INTO staging.fact_inventory_monthly
SELECT '2026-02-28',b.branch_id,p.sku_id,
       10 + ((b.branch_id*17+p.sku_id)%80),
       CAST((10 + ((b.branch_id*17+p.sku_id)%80))*p.unit_cost AS DECIMAL(14,2)),
       DATEADD(DAY,45+((b.branch_id*31+p.sku_id)%240),CAST('2026-02-28' AS DATE))
FROM staging.dim_branch b CROSS JOIN staging.dim_product p;

INSERT INTO staging.fact_purchase_order VALUES
(1,101,1001,'2026-01-05','2026-01-10','2026-01-10',300,294),
(2,101,1002,'2026-01-08','2026-01-13','2026-01-15',250,230),
(3,104,1003,'2026-02-01','2026-02-05','2026-02-05',220,220),
(4,104,1004,'2026-02-03','2026-02-07','2026-02-08',200,196),
(5,102,1005,'2026-02-04','2026-02-08','2026-02-08',400,400),
(6,102,1006,'2026-02-05','2026-02-09','2026-02-10',350,336);

;WITH dates AS (
 SELECT CAST('2026-01-01' AS DATE) d
 UNION ALL SELECT DATEADD(DAY,1,d) FROM dates WHERE d<'2026-02-28'
)
INSERT INTO staging.fact_web_daily
SELECT d,p.sku_id,
       20 + ((p.sku_id + DAY(d)*3) % 60) views,
       3 + ((p.sku_id + DAY(d)) % 10) add_to_cart,
       1 + ((p.sku_id + DAY(d)) % 4) online_orders
FROM dates CROSS JOIN staging.dim_product p
OPTION (MAXRECURSION 1000);
GO
