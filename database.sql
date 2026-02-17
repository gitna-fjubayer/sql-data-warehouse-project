/*
================================================
Create Database and Schemas
================================================
Script Purpose:

This script creates a new database called 'DataWarehouse' after checking if it already exists.
If the database already exists then it is dropped and recreated. Additionally, the script sets up three schemas within the database: 'bronze', 'silver', 'gold'.

WARNING:

Running this script will drop the entire database if it exists. All data in the database will be permanently wiped out so please proceed with caution at your own risk and make sure to have proper backup.
*/

use master;
GO

-- Drop database if exists already to recreate
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO
-- -- Create the database 'DataWarehouse'  

Create database DataWarehouse;
Use DataWarehouse;
-- Create schemas

Create Schema bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO

