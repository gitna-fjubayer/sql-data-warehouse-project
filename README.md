# SQL Data Warehouse and Analytics Portfolio Project

Welcome to the my data warehouse portfolio project repo!!!

A production-style SQL data warehouse designed to transform raw operational data into analytics-ready datasets.
Features layered ETL processing, dimensional modeling, and a star schema for business reporting.

---

## Project Requirements

## Building the Data Warehouse (Data Engineering)

## Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.
Specifications
•	Data Sources: Import data from two source systems (ERP and CRM) provided as CSV files.
•	Data Quality: Cleanse and resolve data quality issues prior to analysis.
•	Integration: Combine both sources into a single, user-friendly data model designed for analytical queries.
•	Scope: Focus on the latest dataset only; historization of data is not required.
•	Documentation: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

## BI: Analytics & Reporting (Data Analysis)

## Objective
Develop SQL-based analytics to deliver detailed insights into:
•	Customer Behavior
•	Product Performance
•	Sales Trends
These insights empower stakeholders with key business metrics, enabling strategic decision-making.

## Data Architecture
Selected Architecture
The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers:
1.	Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2.	Silver Layer: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3.	Gold Layer: Houses business-ready data modelled into a star schema required for reporting and analytics.

## Rationale for choosing Medallion Architecture
1. Clear Data Quality Progression: Each layer has defined quality standards, making it easy to ensure data reliability before it reaches analytics. 
2. Modern Best Practice: Medallion is the industry-standard pattern for cloud data platforms (Databricks, Snowflake, Azure Synapse), ensuring our architecture is current and scalable. 
3. Separation of Concerns: Raw ingestion (Bronze), transformation (Silver), and analytics (Gold) are isolated, allowing independent development and troubleshooting. 4. Flexibility and Scalability: Can easily add new data sources at Bronze, new transformations at Silver, or new data marts at Gold without affecting other layers.

## Alternatives not considered
## Inmon (Enterprise Data Warehouse): - Source → Staging → EDW (Enterprise Data Warehouse) → Data Marts
Rejected due to excessive complexity for single-domain project - Would require months of upfront enterprise modeling - Too rigid for our iterative development approach 
## Kimball (Dimensional Modeling): - Source → Staging → Data Marts
Partially adopted (used in Gold layer for star schema) - But lacks modern data lake benefits (raw data preservation, quality layers) - Medallion provides Kimball benefits plus additional modern capabilities 
## Data Vault: - Source → Staging → Raw Vault → Business Vault → Data Marts
Rejected due to over-engineering for project scope - Complex modeling (Hubs/Links/Satellites) unnecessary for retail analytics - Steeper learning curve without proportional benefit
## Data Mesh: -
Rejected due to organizational scale mismatch - Designed for large organizations with many autonomous teams - Our project: Single team, single domain

## Licensing 
This project is licensed under the [MIT License](LICENSE). Feel free to use, make changes to the project as you like with proper attribution :)
