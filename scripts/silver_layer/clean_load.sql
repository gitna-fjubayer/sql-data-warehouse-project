-- Silver layer data cleaning
-- Insert cleaned data into silver layer cust_info table

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
