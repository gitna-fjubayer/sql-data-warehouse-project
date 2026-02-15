-- Silver layer data cleaning
-- Insert cleaned data into silver layer cust_info table

PRINT '>> Truncating table: silver.crm_cust_info'
TRUNCATE TABLE silver.crm_cust_info;
PRINT '>> Inserting data into silver.crm_cust_info'

INSERT INTO silver.crm_cust_info (
  cst_id,
  cst_key,
  cst_firstname,
  cst_lastname,
  cst_marital_status,
  cst_gndr,
  cst_create_date)

-- Ensuring that there is no unwanted spaces before and after the strings in cst_firstname and lastname
SELECT cst_id,
cst_key, 
TRIM (cst_firstname) AS cst_firstname,                
TRIM (cst_lastname) AS cst_lastname,
CASE WHEN UPPER (TRIM(cst_marital_status)) = 'S' THEN 'SINGLE'    -- Normalize marital status to readable format
     WHEN UPPER (TRIM(cst_marital_status)) = 'M' THEN 'MARRIED'
     ELSE 'N/A'
END cst_marital_status,
CASE WHEN UPPER (TRIM(cst_gndr)) = 'F' THEN 'FEMALE'   -- Normalize gender values to readable format
     WHEN UPPER (TRIM(cst_gndr)) = 'M' THEN 'MALE'
     ELSE 'N/A'
END cst_gndr,
cst_create_date
-- Ensures that the cst_id is the most recent per customer and there are no null values
FROM (      
SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS latest_cst_id
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
)t WHERE latest_cst_id = 1;
/*
Verify cleaned table with 
SELECT * FROM silver.crm_cust_info;
*/

-- Insert cleaned data into silver layer prd_info table

PRINT '>> Truncating table: silver.crm_prd_info'
TRUNCATE TABLE silver.crm_prd_info;
PRINT '>> Inserting data into silver.crm_prd_info'

INSERT INTO silver.crm_prd_info (
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt)
SELECT 
prd_id,
REPLACE(SUBSTRING (prd_key, 1, 5), '-', '_') AS cat_id,   -- Extract category id
SUBSTRING (prd_key, 7, LEN(prd_key)) AS prd_key,          -- Extract product key
prd_nm,
ISNULL(prd_cost, 0) AS prd_cost,
CASE WHEN UPPER (TRIM(prd_line)) = 'M' THEN 'Mountain'
     WHEN UPPER (TRIM(prd_line)) = 'S' THEN 'Other Sales'
     WHEN UPPER (TRIM(prd_line)) = 'R' THEN 'Road'
     WHEN UPPER (TRIM(prd_line)) = 'T' THEN 'Touring'
     ELSE 'N/A'
END AS prd_line,                    -- Mapping product line codes to their descriptive values
CAST (prd_start_dt AS DATE) AS prd_start_dt,
CAST (LEAD (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS DATE) AS prd_end_dt   -- Calculate end date as one day before the next start date 
FROM bronze.crm_prd_info;
/*
Verify cleaned table with 
SELECT * FROM silver.crm_prd_info;
*/

-- Insert cleaned data into crm_sales_details table

PRINT '>> Truncating table: silver.crm_sales_details'
TRUNCATE TABLE silver.crm_sales_details;
PRINT '>> Inserting data into silver.crm_sales_details'

INSERT INTO silver.crm_sales_details (
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price)

SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR len(sls_order_dt) != 8 THEN NULL
  ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR len(sls_ship_dt) != 8 THEN NULL
  ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR len(sls_due_dt) != 8 THEN NULL
  ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,                                                               -- Handling invalid data and casting the date from integer DATE format
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * abs(sls_price)
  THEN sls_quantity * ABS(sls_price)
  ELSE sls_sales
END AS sls_sales,    -- Recalculating the sales if original values is missing or incorrect
sls_quantity,
CASE WHEN sls_price IS NULL OR sls_price <= 0 
  THEN sls_sales / NULLIF (sls_quantity, 0)
  ELSE sls_price
END AS sls_price          -- Derive price if original value is invalid
FROM bronze.crm_sales_details;

/*
Verify cleaned table with 
SELECT * FROM silver.crm_sales_details;
*/

-- Insert cleaned data into silver layer erp_cust_az12 table

PRINT '>> Truncating table: silver.erp_cust_az12'
TRUNCATE TABLE silver.erp_cust_az12;
PRINT '>> Inserting data into silver.erp_cust_az12'

INSERT INTO silver.erp_cust_az12 (
cid,
bdate,
gen)

SELECT 
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING (cid, 4, LEN(cid))
  ELSE cid
END AS cid,                                                         -- Remove the 'NAS' prefix if present in the cid
CASE WHEN bdate > GETDATE() THEN NULL
  ELSE bdate
END AS bdate,                                                       -- Declare date beyond current dste as NUll
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
     WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
     ELSE 'N/A'
END AS gen                                                          -- Normalize gender values for readability and handle unknown values
FROM bronze.erp_cust_az12;

/*
Verify cleaned table with 
SELECT * FROM silver.erp_cust_az12;
*/

-- Insert cleaned data into silver layer erp_loc_a101 table

PRINT '>> Truncating table: silver.erp_loc_a101'
TRUNCATE TABLE silver.erp_loc_a101;
PRINT '>> Inserting data into silver.erp_loc_a101'

INSERT INTO silver.erp_loc_a101 (
cid,
cntry)

SELECT 
REPLACE(cid, '-', '') cid,                                 -- Repplace unwanted hyphens '-' from cid
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
     WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
     WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
ELSE TRIM(cntry)
END AS cntry                                                   -- Normalize and handle blank and missing country prefixes
FROM bronze.erp_loc_a101;

/*
Verify cleaned table with 
SELECT * FROM silver.erp_loc_a101;
*/

-- Insert data into silver layer erp_px_cat_g1v2 table

PRINT '>> Truncating table: silver.erp_px_cat_g1v2'
TRUNCATE TABLE silver.erp_px_cat_g1v2;
PRINT '>> Inserting data into silver.erp_px_cat_g1v2'

INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)

SELECT
id,
cat,
subcat,
maintenance 
FROM bronze.erp_px_cat_g1v2;           -- Data quality is good so no transformation needed for this table
