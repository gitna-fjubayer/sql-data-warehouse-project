/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.
===============================================================================
*/

/* To verify quality of loaded data -
SELECT * FROM bronze.crm/erp_tablename
To verify if right amount of rows are loaded -
SELECT COUNT (*) bronze.crm/erp_tablename
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS -- this creates a stored procedure for frequently used script
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY
SET @batch_start_time = GETDATE ();
-- Load data into bronze layer tables
-- load data into crm tables
PRINT '=========================';
PRINT 'LOADING BRONZE LAYER';
PRINT '=========================';

PRINT '-------------------------';
PRINT 'LOADING CRM TABLES';
PRINT '-------------------------';

SET @start_time = GETDATE();
PRINT '>> TRUNCATING TABLE: bronze.crm_cust_info';
TRUNCATE TABLE bronze.crm_cust_info;

PRINT 'INSERTING DATA INTO TABLE: bronze.crm_cust_info';
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
SET @end_time = GETDATE ();

PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds';

-- load data into prd_info table
SET @start_time = GETDATE ();

PRINT'>> TRUNCATING TABLE: bronze.crm_prd_info';
TRUNCATE TABLE bronze.crm_prd_info;

PRINT 'INSERTING DATA INTO TABLE: bronze.crm_prd_info';
BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);
SET @end_time = GETDATE ();

PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
PRINT '********************';

-- load data into sales_details table

SET @start_time = GETDATE ();
PRINT'>> TRUNCATING TABLE: bronze.crm_sales_details';
TRUNCATE TABLE bronze.crm_sales_details;

PRINT 'INSERTING DATA INTO TABLE: bronze.crm_psales_details';
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);
SET @end_time = GETDATE ();
PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
PRINT '********************';
PRINT '===========================';
PRINT 'LOADING ERP TABLES'
PRINT '===========================';

-- load data into erp tables

SET @start_time = GETDATE ();
PRINT '>> TRUNACTING TABLE: bronze.erp_cust_az12';
TRUNCATE TABLE bronze.erp_cust_az12;

PRINT '>> INSERTING DATA INTO TABLE: bronze.erp_cust_az12';
BULK INSERT bronze.erp_cust_az12
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.CSV'

WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);
SET @end_time = GETDATE ();
PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
PRINT '*********************';

--load data into loc_a101 
SET @start_time = GETDATE ();
PRINT '>> TRUNACTING TABLE: bronze.erp_loc_a101';
TRUNCATE TABLE bronze.erp_loc_a101;

PRINT '>> INSERTING DATA INTO TABLE: bronze.erp_loc_a101';
BULK INSERT bronze.erp_loc_a101
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);
SET @end_time = getdate ();
PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
PRINT '************************';

-- load data into px_cat_g12 
SET @start_time = GETDATE ();
PRINT '>> TRUNACTING TABLE: bronze.erp_px_cat_g1v2';
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

PRINT '>> INSERTING DATA INTO TABLE: bronze.erp_px_cat_g1v2';
BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\Users\User\OneDrive\SQL PROJECT\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
);
SET @end_time = GETDATE ();
PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
PRINT '***************************';
 
SET @batch_end_time = GETDATE ();
PRINT 'BRONZE LAYER LOADING HAS COMPLETED';
PRINT ' TOTAL DURATION: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds'
 END TRY
 BEGIN CATCH
 PRINT '===========================';
 PRINT 'ERROR LOADING BRONZE LAYER';
 PRINT 'ERROR MESSAGE' + ERROR_MESSAGE ();
 PRINT 'ERROR NUMBER' + CAST (ERROR_NUMBER () AS NVARCHAR);
 PRINT '===========================';
 END CATCH
END
/*
To run the stored procedure run the following statement
EXEC bronze.load_bronze;
*/
