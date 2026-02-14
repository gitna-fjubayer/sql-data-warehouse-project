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
