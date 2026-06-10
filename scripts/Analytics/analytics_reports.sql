/*
===============================================================================
ANALYTICS & REPORTING SCRIPTS
===============================================================================
Purpose:  Business intelligence queries built on top of the Gold layer views
Database: gold
Views:    dim_customers, dim_products, fact_sales
===============================================================================
*/

USE gold;

-- ============================================================================
-- SECTION 1: CUSTOMER BEHAVIOR
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1.1 Total Revenue & Orders per Customer (Top Customers)
-- ----------------------------------------------------------------------------
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    c.country,
    c.gender,
    c.marital_status,
    COUNT(DISTINCT f.order_number)  AS total_orders,
    SUM(f.sales_amount)             AS total_revenue,
    SUM(f.quantity)                 AS total_items_bought,
    ROUND(AVG(f.sales_amount), 2)   AS avg_order_value,
    MIN(f.order_date)               AS first_purchase_date,
    MAX(f.order_date)               AS last_purchase_date,
    DATEDIFF(MAX(f.order_date), MIN(f.order_date)) AS customer_lifespan_days
FROM fact_sales f
JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY
    c.customer_key, c.first_name, c.last_name,
    c.country, c.gender, c.marital_status
ORDER BY total_revenue DESC;


-- ----------------------------------------------------------------------------
-- 1.2 Customer Segmentation by Revenue (VIP / Regular / Low Value)
-- ----------------------------------------------------------------------------
SELECT
    customer_segment,
    COUNT(*)            AS customer_count,
    SUM(total_revenue)  AS segment_revenue
FROM (
    SELECT
        c.customer_key,
        c.first_name,
        c.last_name,
        SUM(f.sales_amount) AS total_revenue,
        CASE
            WHEN SUM(f.sales_amount) >= 5000  THEN 'VIP'
            WHEN SUM(f.sales_amount) >= 1000  THEN 'Regular'
            ELSE 'Low Value'
        END AS customer_segment
    FROM fact_sales f
    JOIN dim_customers c ON f.customer_key = c.customer_key
    GROUP BY c.customer_key, c.first_name, c.last_name
) segmented
GROUP BY customer_segment
ORDER BY segment_revenue DESC;


-- ----------------------------------------------------------------------------
-- 1.3 Revenue by Country
-- ----------------------------------------------------------------------------
SELECT
    c.country,
    COUNT(DISTINCT c.customer_key) AS total_customers,
    COUNT(DISTINCT f.order_number) AS total_orders,
    SUM(f.sales_amount)            AS total_revenue,
    ROUND(AVG(f.sales_amount), 2)  AS avg_order_value
FROM fact_sales f
JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_revenue DESC;


-- ----------------------------------------------------------------------------
-- 1.4 Revenue by Gender
-- ----------------------------------------------------------------------------
SELECT
    c.gender,
    COUNT(DISTINCT c.customer_key) AS total_customers,
    SUM(f.sales_amount)            AS total_revenue,
    ROUND(AVG(f.sales_amount), 2)  AS avg_order_value
FROM fact_sales f
JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.gender
ORDER BY total_revenue DESC;


-- ----------------------------------------------------------------------------
-- 1.5 Revenue by Marital Status
-- ----------------------------------------------------------------------------
SELECT
    c.marital_status,
    COUNT(DISTINCT c.customer_key) AS total_customers,
    SUM(f.sales_amount)            AS total_revenue,
    ROUND(AVG(f.sales_amount), 2)  AS avg_order_value
FROM fact_sales f
JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.marital_status
ORDER BY total_revenue DESC;


-- ============================================================================
-- SECTION 2: PRODUCT PERFORMANCE
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 2.1 Top Products by Revenue
-- ----------------------------------------------------------------------------
SELECT
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.product_line,
    p.cost,
    SUM(f.sales_amount)             AS total_revenue,
    SUM(f.quantity)                 AS total_units_sold,
    COUNT(DISTINCT f.order_number)  AS total_orders,
    ROUND(AVG(f.price), 2)          AS avg_selling_price,
    ROUND(SUM(f.sales_amount) - (p.cost * SUM(f.quantity)), 2) AS total_profit
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY
    p.product_key, p.product_name, p.category,
    p.subcategory, p.product_line, p.cost
ORDER BY total_revenue DESC;


-- ----------------------------------------------------------------------------
-- 2.2 Revenue by Category
-- ----------------------------------------------------------------------------
SELECT
    p.category,
    COUNT(DISTINCT p.product_key)   AS total_products,
    SUM(f.sales_amount)             AS total_revenue,
    SUM(f.quantity)                 AS total_units_sold,
    ROUND(AVG(f.price), 2)          AS avg_selling_price
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;


-- ----------------------------------------------------------------------------
-- 2.3 Revenue by Subcategory
-- ----------------------------------------------------------------------------
SELECT
    p.category,
    p.subcategory,
    SUM(f.sales_amount)  AS total_revenue,
    SUM(f.quantity)      AS total_units_sold
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.category, p.subcategory
ORDER BY p.category, total_revenue DESC;


-- ----------------------------------------------------------------------------
-- 2.4 Product Profitability (Revenue vs Cost)
-- ----------------------------------------------------------------------------
SELECT
    p.product_name,
    p.category,
    p.cost                                                          AS unit_cost,
    ROUND(AVG(f.price), 2)                                          AS avg_selling_price,
    ROUND(AVG(f.price) - p.cost, 2)                                 AS avg_profit_per_unit,
    ROUND(((AVG(f.price) - p.cost) / NULLIF(p.cost, 0)) * 100, 2)  AS profit_margin_pct
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.product_name, p.category, p.cost
ORDER BY profit_margin_pct DESC;


-- ----------------------------------------------------------------------------
-- 2.5 Slow Moving Products (Low Sales Volume)
-- ----------------------------------------------------------------------------
SELECT
    p.product_name,
    p.category,
    p.subcategory,
    SUM(f.quantity)     AS total_units_sold,
    SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.product_name, p.category, p.subcategory
ORDER BY total_units_sold ASC
LIMIT 10;


-- ============================================================================
-- SECTION 3: SALES TRENDS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 3.1 Monthly Revenue Trend
-- ----------------------------------------------------------------------------
SELECT
    DATE_FORMAT(f.order_date, '%Y-%m')  AS month,
    COUNT(DISTINCT f.order_number)      AS total_orders,
    SUM(f.sales_amount)                 AS monthly_revenue,
    SUM(f.quantity)                     AS total_units_sold,
    ROUND(AVG(f.sales_amount), 2)       AS avg_order_value
FROM fact_sales f
WHERE f.order_date IS NOT NULL
GROUP BY month
ORDER BY month;


-- ----------------------------------------------------------------------------
-- 3.2 Yearly Revenue Summary
-- ----------------------------------------------------------------------------
SELECT
    YEAR(f.order_date)              AS year,
    COUNT(DISTINCT f.order_number)  AS total_orders,
    COUNT(DISTINCT f.customer_key)  AS unique_customers,
    SUM(f.sales_amount)             AS yearly_revenue,
    ROUND(AVG(f.sales_amount), 2)   AS avg_order_value
FROM fact_sales f
WHERE f.order_date IS NOT NULL
GROUP BY year
ORDER BY year;


-- ----------------------------------------------------------------------------
-- 3.3 Month-over-Month Revenue Growth
-- ----------------------------------------------------------------------------
WITH monthly AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(sales_amount)                AS monthly_revenue
    FROM fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY month
)
SELECT
    month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY month)  AS prev_month_revenue,
    ROUND(
        ((monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month))
        / NULLIF(LAG(monthly_revenue) OVER (ORDER BY month), 0)) * 100
    , 2)                                         AS mom_growth_pct
FROM monthly
ORDER BY month;


-- ----------------------------------------------------------------------------
-- 3.4 Shipping Performance (Order to Ship Duration)
-- ----------------------------------------------------------------------------
SELECT
    ROUND(AVG(DATEDIFF(f.shipping_date, f.order_date)), 1)  AS avg_days_to_ship,
    MIN(DATEDIFF(f.shipping_date, f.order_date))            AS min_days_to_ship,
    MAX(DATEDIFF(f.shipping_date, f.order_date))            AS max_days_to_ship,
    COUNT(DISTINCT f.order_number)                          AS total_orders
FROM fact_sales f
WHERE f.shipping_date IS NOT NULL AND f.order_date IS NOT NULL;


-- ----------------------------------------------------------------------------
-- 3.5 Revenue by Product Line Over Time (Yearly)
-- ----------------------------------------------------------------------------
SELECT
    YEAR(f.order_date)  AS year,
    p.product_line,
    SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY year, p.product_line
ORDER BY year, total_revenue DESC;


-- ============================================================================
-- SECTION 4: EXECUTIVE SUMMARY (Key KPIs)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 4.1 Overall Business KPIs
-- ----------------------------------------------------------------------------
SELECT
    COUNT(DISTINCT f.order_number)                  AS total_orders,
    COUNT(DISTINCT f.customer_key)                  AS total_customers,
    COUNT(DISTINCT f.product_key)                   AS total_products_sold,
    SUM(f.sales_amount)                             AS total_revenue,
    ROUND(AVG(f.sales_amount), 2)                   AS avg_order_value,
    SUM(f.quantity)                                 AS total_units_sold,
    MIN(f.order_date)                               AS first_order_date,
    MAX(f.order_date)                               AS last_order_date
FROM fact_sales f;
