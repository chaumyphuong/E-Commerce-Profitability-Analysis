-- 1. create database and import data

-- 2. cleaning data
-- a. checking data
SELECT * FROM orders LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM marketing_spend LIMIT 10;
-- b. checking NULL
SELECT * FROM orders WHERE order_id IS NULL;
-- c. checking duplicate
SELECT order_id, COUNT(*) 
FROM orders 
GROUP BY order_id
HAVING COUNT(*) > 1;
-- conclusion: data clear, no NULL or duplicate

-- check relation between order and product
select count(*) from (
SELECT order_id, product_id, product_name, primary_category, product_cost, unit_cost, count(*)
FROM orders o 
LEFT JOIN products p 
ON o.primary_category = p.category 
AND o.product_cost = p.unit_cost
GROUP BY o.primary_category, unit_cost
having product_name is null) as order_details;
-- conclusion: total 8 orders can not spot which product they bought

-- 3. Building Data model
-- dim_order
CREATE TABLE dim_order AS
SELECT DISTINCT
    order_id,
    order_date,
    region,
	payment_method,
FROM orders;

ALTER TABLE dim_order
MODIFY order_id VARCHAR(50);

ALTER TABLE dim_order
ADD PRIMARY KEY (order_id);

-- dim_customer
CREATE TABLE dim_customer AS
SELECT DISTINCT
    customer_id
FROM orders;

ALTER TABLE dim_customer
MODIFY customer_id VARCHAR(50);

ALTER TABLE dim_customer
ADD PRIMARY KEY (customer_id);

-- dim_products
CREATE TABLE dim_products AS
SELECT
    product_id,
    supplier,
    category,
    sub_category,
    product_name,
    unit_cost,
    selling_price,
    shipping_cost_per_unit,
    weight_lbs
FROM products;

ALTER TABLE dim_products
MODIFY product_id VARCHAR(50);

ALTER TABLE dim_products
ADD PRIMARY KEY (product_id);

-- dim_platform
CREATE TABLE dim_platform AS
SELECT DISTINCT platform
FROM marketing_spend;

ALTER TABLE dim_platform
MODIFY platform VARCHAR(50);

ALTER TABLE dim_platform
ADD PRIMARY KEY (platform);

-- fact_order_details
CREATE TABLE fact_order_details AS
SELECT
    o.order_id,
    o.customer_id,
    p.product_id,
    o.items_ordered,
    o.gross_revenue,
    o.discount_pct,
    o.discount_amount,
    o.shipping_cost,
    o.platform_fee,
    o.transaction_fee,
    o.returned,
    o.refund_amount,
    o.net_revenue,
    o.total_costs,
    o.profit
FROM orders o
LEFT JOIN products p
ON o.primary_category = p.category and o.product_cost = p.unit_cost;

ALTER TABLE fact_order_details
MODIFY order_id VARCHAR(50),
MODIFY customer_id VARCHAR(50),
MODIFY product_id VARCHAR(50);

ALTER TABLE fact_order_details
ADD CONSTRAINT fk_order
FOREIGN KEY (order_id) REFERENCES dim_order(order_id);

ALTER TABLE fact_order_details
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id);

ALTER TABLE fact_order_details
ADD CONSTRAINT fk_product
FOREIGN KEY (product_id) REFERENCES dim_products(product_id);

-- fact_marketing
CREATE TABLE fact_marketing AS
SELECT
    platform,
    month,
    spend,
    impressions,
    clicks,
    conversions,
    revenue_attributed,
    cpc,
    cpa,
    roas
FROM marketing_spend;

ALTER TABLE fact_marketing
MODIFY platform VARCHAR(50);

ALTER TABLE fact_marketing
ADD CONSTRAINT fk_platform
FOREIGN KEY (platform) REFERENCES dim_platform(platform);

-- drop unuseable table
drop table marketing_spend;
drop table orders;
drop table products;

-- Create view
CREATE VIEW vw_sales_overview AS
SELECT
    DATE_FORMAT(o.order_date,'%Y-%m') AS month,
    o.region,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.net_revenue) AS total_revenue,
    SUM(f.profit) AS total_profit,
    AVG(f.net_revenue) AS avg_order_value
FROM fact_order_details f
JOIN dim_order o
ON f.order_id = o.order_id
GROUP BY month, o.region;

CREATE VIEW vw_product_performance AS
SELECT
    p.category,
    p.sub_category,
    p.product_name,
    SUM(f.items_ordered) AS units_sold,
    SUM(f.net_revenue) AS revenue,
    SUM(f.profit) AS profit,
    SUM(f.profit)/SUM(f.net_revenue) AS profit_margin
FROM fact_order_details f
JOIN dim_products p
ON f.product_id = p.product_id
GROUP BY p.category, p.sub_category, p.product_name;

CREATE VIEW vw_customer_behavior AS
SELECT
    c.customer_id,
    o.region,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.net_revenue) AS total_spent,
    AVG(f.net_revenue) AS avg_order_value
FROM fact_order_details f
JOIN dim_customer c
ON f.customer_id = c.customer_id
JOIN dim_order o
ON f.order_id = o.order_id
GROUP BY c.customer_id, o.region;

CREATE VIEW vw_order_operations AS
SELECT
    DATE_FORMAT(o.order_date,'%Y-%m') AS month,
    SUM(f.discount_amount) AS total_discount,
    SUM(f.shipping_cost) AS total_shipping_cost,
    SUM(f.platform_fee) AS platform_fees,
    SUM(f.transaction_fee) AS transaction_fees,
    SUM(f.refund_amount) AS refunds,
    SUM(f.total_costs) AS total_costs
FROM fact_order_details f
JOIN dim_order o
ON f.order_id = o.order_id
GROUP BY month;

CREATE VIEW vw_marketing_performance AS
SELECT
    m.month,
    p.platform,
    SUM(m.spend) AS total_spend,
    SUM(m.impressions) AS impressions,
    SUM(m.clicks) AS clicks,
    SUM(m.conversions) AS conversions,
    SUM(m.revenue_attributed) AS revenue,
    AVG(m.cpc) AS avg_cpc,
    AVG(m.cpa) AS avg_cpa,
    AVG(m.roas) AS avg_roas
FROM fact_marketing m
JOIN dim_platform p
ON m.platform = p.platform
GROUP BY m.month, p.platform;

CREATE VIEW vw_product_region_sales AS
SELECT
    o.region,
    p.category,
    p.product_name,
    SUM(f.items_ordered) AS units_sold,
    SUM(f.net_revenue) AS revenue,
    SUM(f.profit) AS profit
FROM fact_order_details f
JOIN dim_products p
ON f.product_id = p.product_id
JOIN dim_order o
ON f.order_id = o.order_id
GROUP BY o.region, p.category, p.product_name;

-- 4. Data analyst
SELECT * FROM vw_sales_overview
LIMIT 20;
-- top 10 customers 
SELECT *
FROM vw_customer_behavior
ORDER BY total_spent DESC
LIMIT 10;

-- Best selling products
SELECT *
FROM vw_product_performance
ORDER BY units_sold DESC
LIMIT 10;

-- Revenue trend
SELECT month, total_revenue
FROM vw_sales_overview
ORDER BY month;

-- Total Revenue
SELECT SUM(total_revenue)
FROM vw_sales_overview;
-- 234881.081

-- Total Profit
SELECT SUM(total_profit)
FROM vw_sales_overview;
-- 56110

-- Average ROAS
SELECT AVG(avg_roas)
FROM vw_marketing_performance;
-- 15.381944444444445

-- Category Profitability
SELECT
    p.category,
    SUM(f.net_revenue) AS total_revenue,
    SUM(f.total_costs) AS total_costs,
    SUM(f.profit) AS total_profit,
    ROUND(SUM(f.profit) / SUM(f.net_revenue) * 100,2) AS profit_margin_pct
FROM fact_order_details f
JOIN dim_products p
ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY total_profit DESC;
-- Electronics had the highes total revenue, total_profit but with the large total_costs, its profit margin wasn't significant
-- meanwhile books was the only product that has the profit margin was below 0
-- home & kitchen and food && Beverage were the highest profit margin with high total revenue and low cost

-- Identify performers
SELECT *
FROM (
    SELECT
        p.category,
        SUM(f.profit) AS total_profit
    FROM fact_order_details f
    JOIN dim_products p
    ON f.product_id = p.product_id
    GROUP BY p.category
) t
ORDER BY total_profit ASC
LIMIT 3;
-- Top performers: Electrocnic - 1736, Home & Kitchen - 1356, Food & Beverage - 1234
-- Bottom performer: Books - -96, Beauty - 123, Sports - 783
-- Conclusion: customer tended to buy Domestic items like home & kitchen, food && Beverage and Electronics -> should invest
-- Conclusion: Less focus on books , beauty and sports

-- Channel Analysis
SELECT
    o.channel,
    COUNT(DISTINCT f.order_id) AS total_orders,
    AVG(f.net_revenue) AS avg_order_value,
    AVG(f.profit) AS avg_profit,
    SUM(CASE WHEN f.returned = "Yes" THEN 1 ELSE 0 END) AS total_returns
FROM fact_order_details f
JOIN dim_order o
ON f.order_id = o.order_id
GROUP BY o.channel
ORDER BY avg_profit DESC;
-- many customer ordered by website and but total returns high, while social commerce was opposite trend
-- The most avg order value and profit was from mobile app
-- Conclusion: mainly benefited from mobile app and website

-- Marketing ROI
SELECT
    p.platform,
    SUM(m.spend) AS total_spend,
    SUM(m.revenue_attributed) AS total_revenue,
    SUM(m.clicks) AS total_clicks,
    SUM(m.conversions) AS total_conversions,
    ROUND(SUM(m.revenue_attributed) / SUM(m.spend),2) AS roas,
    ROUND(SUM(m.spend) / SUM(m.conversions),2) AS cost_per_acquisition,
    ROUND(SUM(m.spend) / SUM(m.clicks),2) AS cost_per_click
FROM fact_marketing m
JOIN dim_platform p
ON m.platform = p.platform
GROUP BY p.platform
ORDER BY roas DESC;
-- Email Marketing had to spend many costs on acquisition and click, lead to it become the highest spend
-- Email marketing brought high revenue but lower in return on ad spend through clicks and conversions
-- Ads appered in google and influencer were clicked and talked the most
-- Email marketing was underperforming