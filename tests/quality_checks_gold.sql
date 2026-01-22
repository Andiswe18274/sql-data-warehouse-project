/*
===============================================================================
Quality Checks – Gold Layer (MySQL)
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency,
    and analytical readiness of the Gold layer views.
    
    Checks include:
    - Uniqueness of surrogate keys in dimension views
    - NULL key validation
    - Referential integrity between fact and dimension views

Usage Notes:
    - Run these checks after Gold layer views are created
    - Any returned rows indicate data quality issues
===============================================================================
*/

USE gold;

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================

-- Check for NULL or Duplicate Customer Keys
-- Expectation: No Results
SELECT
    customer_key,
    COUNT(*) AS cnt
FROM gold.dim_customers
GROUP BY customer_key
HAVING customer_key IS NULL
    OR COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================

-- Check for NULL or Duplicate Product Keys
-- Expectation: No Results
SELECT
    product_key,
    COUNT(*) AS cnt
FROM gold.dim_products
GROUP BY product_key
HAVING product_key IS NULL
    OR COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================

-- Check for NULL Foreign Keys in Fact Table
-- Expectation: No Results
SELECT *
FROM gold.fact_sales
WHERE customer_key IS NULL
   OR product_key IS NULL;

-- Check Referential Integrity: Fact → Customers
-- Expectation: No Results
SELECT f.*
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
       ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

-- Check Referential Integrity: Fact → Products
-- Expectation: No Results
SELECT f.*
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
       ON f.product_key = p.product_key
WHERE p.product_key IS NULL;
