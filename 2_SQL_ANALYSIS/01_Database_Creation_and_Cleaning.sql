-- ============================================
-- VEHICLE SALES PROJECT
-- FILE 1: DATABASE CREATION & DATA CLEANING
-- ============================================

-- STEP 1: CREATE DATABASE
CREATE DATABASE VehicleSalesDB;

-- ============================================
-- STEP 2: CREATE TABLE
-- ============================================
USE VehicleSalesDB;

DROP TABLE IF EXISTS car_sales;

CREATE TABLE car_sales (
    year          INT NULL,
    make          VARCHAR(50) NULL,
    model         VARCHAR(100) NULL,
    trim          VARCHAR(100) NULL,
    body          VARCHAR(50) NULL,
    transmission  VARCHAR(50) NULL,
    vin           VARCHAR(20) NULL,
    state         VARCHAR(50) NULL,
    condition     FLOAT NULL,
    odometer      FLOAT NULL,
    color         VARCHAR(30) NULL,
    interior      VARCHAR(30) NULL,
    seller        VARCHAR(200) NULL,
    mmr           FLOAT NULL,
    sellingprice  FLOAT NULL,
    saledate      VARCHAR(100) NULL
);

-- ============================================
-- STEP 3: IMPORT DATA
-- ============================================

BULK INSERT car_sales
FROM 'D:\PROJECTS\VEHICLES-SALES-DASHBOARD\car_prices.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    MAXERRORS = 1000,
    TABLOCK
);

-- ============================================
-- STEP 4: VERIFY DATA LOADED
-- ============================================

SELECT COUNT(*) AS Total_Rows FROM car_sales;
SELECT TOP 10 * FROM car_sales;

-- ============================================
-- STEP 5: CHECK NULL VALUES
-- ============================================

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS Null_Year,
    SUM(CASE WHEN make IS NULL THEN 1 ELSE 0 END) AS Null_Make,
    SUM(CASE WHEN model IS NULL THEN 1 ELSE 0 END) AS Null_Model,
    SUM(CASE WHEN trim IS NULL THEN 1 ELSE 0 END) AS Null_Trim,
    SUM(CASE WHEN body IS NULL THEN 1 ELSE 0 END) AS Null_Body,
    SUM(CASE WHEN transmission IS NULL THEN 1 ELSE 0 END) AS Null_Transmission,
    SUM(CASE WHEN vin IS NULL THEN 1 ELSE 0 END) AS Null_VIN,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS Null_State,
    SUM(CASE WHEN condition IS NULL THEN 1 ELSE 0 END) AS Null_Condition,
    SUM(CASE WHEN odometer IS NULL THEN 1 ELSE 0 END) AS Null_Odometer,
    SUM(CASE WHEN color IS NULL THEN 1 ELSE 0 END) AS Null_Color,
    SUM(CASE WHEN interior IS NULL THEN 1 ELSE 0 END) AS Null_Interior,
    SUM(CASE WHEN seller IS NULL THEN 1 ELSE 0 END) AS Null_Seller,
    SUM(CASE WHEN mmr IS NULL THEN 1 ELSE 0 END) AS Null_MMR,
    SUM(CASE WHEN sellingprice IS NULL THEN 1 ELSE 0 END) AS Null_SellingPrice,
    SUM(CASE WHEN saledate IS NULL THEN 1 ELSE 0 END) AS Null_SaleDate
FROM car_sales;

-- ============================================
-- STEP 6: CHECK & REMOVE DUPLICATES
-- ============================================

-- Check duplicates
SELECT vin, COUNT(*) AS duplicate_count
FROM car_sales
WHERE vin IS NOT NULL
GROUP BY vin
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Remove duplicates keeping highest selling price
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY vin
               ORDER BY sellingprice DESC
           ) AS row_num
    FROM car_sales
    WHERE vin IS NOT NULL
)
DELETE FROM CTE WHERE row_num > 1;

-- Verify row count after deduplication
SELECT COUNT(*) AS After_Dedup FROM car_sales;

-- ============================================
-- STEP 7: FIX BODY COLUMN
-- ============================================

-- Check unique body values
SELECT DISTINCT body, COUNT(*) AS count
FROM car_sales
GROUP BY body
ORDER BY body;

-- Fix inconsistent values
UPDATE car_sales
SET body = 'Regular Cab'
WHERE body = 'regular-cab';

UPDATE car_sales
SET body = NULL
WHERE body = 'Navitgation';

-- ============================================
-- STEP 8: FIX COLOR COLUMN
-- ============================================

-- Fix garbage color values
UPDATE car_sales
SET color = NULL
WHERE color LIKE '%G%ö%'
   OR color LIKE '%G%Ç%';

-- Verify
SELECT COUNT(*) AS Remaining_Garbage_Color
FROM car_sales
WHERE color LIKE '%G%ö%'
   OR color LIKE '%G%Ç%';

-- ============================================
-- STEP 9: FIX TRANSMISSION COLUMN
-- ============================================

-- Check unique transmission values
SELECT DISTINCT transmission, COUNT(*) AS count
FROM car_sales
GROUP BY transmission
ORDER BY transmission;

-- Fix wrong values
UPDATE car_sales
SET transmission = NULL
WHERE transmission = 'Sedan';

-- ============================================
-- STEP 10: FIX INTERIOR COLUMN
-- ============================================

UPDATE car_sales
SET interior = NULL
WHERE interior LIKE '%G%ö%'
   OR interior LIKE '%G%Ç%';

-- ============================================
-- STEP 11: FIX MAKE COLUMN
-- ============================================

-- Check unique make values
SELECT DISTINCT make, COUNT(*) AS count
FROM car_sales
GROUP BY make
ORDER BY make;

-- Fix inconsistent make values
UPDATE car_sales SET make = 'Chevrolet' WHERE make = 'chev truck';
UPDATE car_sales SET make = 'Dodge' WHERE make = 'dodge tk';
UPDATE car_sales SET make = 'Ford' WHERE make IN ('ford tk', 'ford truck');
UPDATE car_sales SET make = 'GMC' WHERE make IN ('gmc truck');
UPDATE car_sales SET make = 'Hyundai' WHERE make = 'hyundai tk';
UPDATE car_sales SET make = 'Mazda' WHERE make = 'mazda tk';
UPDATE car_sales SET make = 'Land Rover' WHERE make = 'landrover';
UPDATE car_sales SET make = 'Mercedes-Benz' WHERE make IN ('mercedes', 'mercedes-b');
UPDATE car_sales SET make = 'Mitsubishi' WHERE make = 'mitsubishi';
UPDATE car_sales SET make = 'Volkswagen' WHERE make = 'vw';
UPDATE car_sales SET make = NULL WHERE make IN ('airstream', 'dot');

-- ============================================
-- STEP 12: FIX SELLING PRICE
-- ============================================

-- Check zero or negative prices
SELECT COUNT(*) AS Zero_Or_Negative_Price
FROM car_sales
WHERE sellingprice <= 0;

-- Check price range
SELECT
    MIN(sellingprice) AS Min_Price,
    MAX(sellingprice) AS Max_Price,
    AVG(sellingprice) AS Avg_Price
FROM car_sales
WHERE sellingprice IS NOT NULL;

-- ============================================
-- STEP 13: ADD CLEAN DATE COLUMN
-- ============================================

ALTER TABLE car_sales
ADD sale_date_clean DATE;

UPDATE car_sales
SET sale_date_clean = TRY_CONVERT(DATE,
    SUBSTRING(saledate, 5, 20),
    107)
WHERE saledate IS NOT NULL;

-- Verify date conversion
SELECT TOP 5 saledate, sale_date_clean
FROM car_sales
WHERE sale_date_clean IS NOT NULL;

-- ============================================
-- STEP 14: REMOVE USELESS ROWS
-- ============================================

DELETE FROM car_sales
WHERE sellingprice IS NULL
AND sale_date_clean IS NULL;

-- ============================================
-- STEP 15: FINAL VERIFICATION
-- ============================================

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN make IS NULL THEN 1 ELSE 0 END) AS Null_Make,
    SUM(CASE WHEN model IS NULL THEN 1 ELSE 0 END) AS Null_Model,
    SUM(CASE WHEN body IS NULL THEN 1 ELSE 0 END) AS Null_Body,
    SUM(CASE WHEN transmission IS NULL THEN 1 ELSE 0 END) AS Null_Transmission,
    SUM(CASE WHEN color IS NULL THEN 1 ELSE 0 END) AS Null_Color,
    SUM(CASE WHEN condition IS NULL THEN 1 ELSE 0 END) AS Null_Condition,
    SUM(CASE WHEN sellingprice IS NULL THEN 1 ELSE 0 END) AS Null_Price,
    SUM(CASE WHEN sale_date_clean IS NULL THEN 1 ELSE 0 END) AS Null_Date
FROM car_sales;

-- ============================================
-- STEP 16: EXPORT CLEANED DATA
-- ============================================

SELECT
    year, make, model, trim, body,
    transmission, state, condition,
    odometer, color, interior,
    seller, mmr, sellingprice,
    sale_date_clean
FROM car_sales
WHERE sellingprice IS NOT NULL;

-- Final row count = 550,289 rows
-- Export as Vehicle_Sales_Cleaned.csv