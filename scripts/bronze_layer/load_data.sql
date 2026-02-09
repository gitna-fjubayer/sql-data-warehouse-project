/* To verify quality of loaded data -
SELECT * FROM bronze.crm/erp_tablename
To verify if right amount of rows are loaded -
SELECT COUNT (*) bronze.crm/erp_tablename
*/

-- Load data into bronze layer tables

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

-- load data sales_details table
TRUNCATE TABLE bronze.crm_sales_details;
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);
