/*
===============================================================================
Quality Checks – Silver Layer (MySQL)
===============================================================================
Purpose:
    Validate data quality after loading Silver tables from Bronze.
    These checks confirm:
    - Primary key integrity
    - Data standardization correctness
    - Date validity
    - Business rule consistency
    - Transformation accuracy

Usage:
    Run AFTER calling load_silver();
===============================================================================
*/

USE data_warehouse;

-- =====================================================
-- silver.crm_cust_info
-- =====================================================

-- 1. NULL or Duplicate Primary Keys (Expectation: No rows)
SELECT cst_id, COUNT(*) AS cnt
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING cst_id IS NULL OR COUNT(*) > 1;

-- 2. Unwanted Spaces in Names (Expectation: No rows)
SELECT *
FROM silver.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname)
   OR cst_lastname  <> TRIM(cst_lastname);

-- 3. Marital Status Standardization
-- Expectation: Single, Married, n/a
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

-- 4. Gender Standardization
-- Expectation: Male, Female, n/a
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

-- =====================================================
-- silver.crm_prd_info
-- =====================================================

-- 5. NULL or Duplicate Product IDs
SELECT prd_id, COUNT(*) AS cnt
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING prd_id IS NULL OR COUNT(*) > 1;

-- 6. Unwanted Spaces in Product Names
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

-- 7. Negative or NULL Product Costs
-- Expectation: No rows (cost defaulted to 0)
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- 8. Product Line Standardization
-- Expectation: Mountain, Road, Touring, Other Sales, n/a
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- 9. Invalid Date Ranges (Start Date > End Date)
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt IS NOT NULL
  AND prd_end_dt < prd_start_dt;

-- =====================================================
-- silver.crm_sales_details
-- =====================================================

-- 10. Invalid Order / Ship / Due Date Order
SELECT *
FROM silver.crm_sales_details
WHERE (sls_order_dt IS NOT NULL AND sls_ship_dt IS NOT NULL AND sls_order_dt > sls_ship_dt)
   OR (sls_order_dt IS NOT NULL AND sls_due_dt  IS NOT NULL AND sls_order_dt > sls_due_dt);

-- 11. Invalid or Missing Dates
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL
   OR sls_ship_dt  IS NULL
   OR sls_due_dt   IS NULL;

-- 12. Sales Consistency Check
-- Sales must equal Quantity × Price
SELECT *
FROM silver.crm_sales_details
WHERE ABS(sls_sales - (sls_quantity * sls_price)) > 0.01
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0;

-- =====================================================
-- silver.erp_cust_az12
-- =====================================================

-- 13. Future or Unrealistic Birthdates
-- Expectation: Birthdates <= today and >= 1924-01-01
SELECT *
FROM silver.erp_cust_az12
WHERE bdate IS NOT NULL
  AND (bdate > CURDATE() OR bdate < '1924-01-01');

-- 14. Gender Standardization
-- Expectation: Male, Female, n/a
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

-- =====================================================
-- silver.erp_loc_a101
-- =====================================================

-- 15. Country Standardization
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

-- =====================================================
-- silver.erp_px_cat_g1v2
-- =====================================================

-- 16. Unwanted Spaces in Category Fields
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat <> TRIM(cat)
   OR subcat <> TRIM(subcat)
   OR maintenance <> TRIM(maintenance);

-- 17. Maintenance Value Consistency
SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2;
