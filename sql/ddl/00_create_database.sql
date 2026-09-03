IF DB_ID('PharmacyEcommerceCategoryAnalytics') IS NULL
    CREATE DATABASE PharmacyEcommerceCategoryAnalytics;
GO
USE PharmacyEcommerceCategoryAnalytics;
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='staging') EXEC('CREATE SCHEMA staging');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='analytics') EXEC('CREATE SCHEMA analytics');
GO
