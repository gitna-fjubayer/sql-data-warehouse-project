/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/


-- Dimension CUSTOMERS
SELECT DISTINCT
   ci.cst_gndr,
   ca.gen,
   CASE WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
       ELSE COALESCE(ca.gen, 'N/A')
   END AS new_gender
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON        ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 lo
ON        ci.cst_key = lo.cid
ORDER BY 1,2

-- Dimension PRODUCTS
CREATE VIEW gold.dim_products AS 
SELECT
    ROW_NUMBER() OVER (ORDER BY pd.prd_start_dt, pd.prd_key) AS product_key,
    pd.prd_id as product_id,
    pd.prd_key as product_number,
    pd.prd_nm as product_name,
    pd.cat_id as category_id,
    pc.cat as category,
    pc.subcat as sub_category,
    pc.maintenance as maintenance,
    pd.prd_cost as product_cost,
    pd.prd_line as product_line,
    pd.prd_start_dt as start_date
FROM silver.crm_prd_info pd
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON        pd.cat_id = pc.id
WHERE prd_end_dt IS NULL -- filters out historical data and keeps only the current data
