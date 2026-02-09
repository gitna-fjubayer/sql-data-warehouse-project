/* To verify quality of loaded data -
SELECT * FROM bronze.crm/erp_tablename
To verify if right amount of rows are loaded -
SELECT COUNT (*) bronze.crm/erp_tablename
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS -- this creates a stored procedure for frequently used script
BEGIN
-- Load data into bronze layer tables
-- load data into crm tables
-- load data into cust_info table
TRUNCATE TABLE bronze.crm_cust_info;
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

-- load data into prd_info table
TRUNCATE TABLE bronze.crm_prd_info;
BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);

-- load data intp sales_details table
TRUNCATE TABLE bronze.crm_sales_details;
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);

-- load data into erp tables
TRUNCATE TABLE bronze.erp_cust_az12;
BULK INSERT bronze.erp_cust_az12
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.CSV'

WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);

--load data into loc_a101 
TRUNCATE TABLE bronze.erp_loc_a101;
BULK INSERT bronze.erp_loc_a101
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);

-- load data into px_cat_g12 
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);
END
EXEC bronze.load_bronze;
