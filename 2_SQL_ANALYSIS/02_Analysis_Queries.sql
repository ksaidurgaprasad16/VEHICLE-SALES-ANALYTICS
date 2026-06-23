-- ============================================
-- VEHICLE SALES PROJECT
-- FILE 2: EXPLORATORY DATA ANALYSIS (EDA)
-- ============================================

USE VehicleSalesDB;

-- ============================================
-- QUERY 1: OVERALL SALES SUMMARY
-- ============================================

SELECT
    COUNT(*) AS Total_Transactions,
    COUNT(DISTINCT make) AS Total_Brands,
    COUNT(DISTINCT state) AS Total_States,
    SUM(sellingprice) AS Total_Revenue,
    AVG(sellingprice) AS Avg_Selling_Price,
    MIN(sellingprice) AS Min_Price,
    MAX(sellingprice) AS Max_Price,
    MIN(sale_date_clean) AS First_Sale_Date,
    MAX(sale_date_clean) AS Last_Sale_Date
FROM car_sales
WHERE sellingprice IS NOT NULL;

-- Results:
-- Total Transactions : 550,289
-- Total Brands       : 53
-- Total States       : 43
-- Total Revenue      : $7.49 Billion
-- Avg Selling Price  : $13,618
-- Date Range         : Jan 2014 - Jul 2015

-- ============================================
-- QUERY 2: TOP 10 MAKES BY REVENUE
-- ============================================

SELECT TOP 10
    make,
    COUNT(*) AS Total_Units_Sold,
    SUM(sellingprice) AS Total_Revenue,
    AVG(sellingprice) AS Avg_Price,
    MIN(sellingprice) AS Min_Price,
    MAX(sellingprice) AS Max_Price
FROM car_sales
WHERE sellingprice IS NOT NULL
AND make IS NOT NULL
GROUP BY make
ORDER BY Total_Revenue DESC;

-- Results:
-- #1 Ford         : 92,536 units | $1.34B revenue
-- #2 Chevrolet    : 59,618 units | $710M revenue
-- #3 Nissan       : 53,351 units | $626M revenue
-- #4 Toyota       : 39,439 units | $482M revenue
-- #5 BMW          : 20,389 units | $440M revenue

-- ============================================
-- QUERY 3: TOP 10 STATES BY SALES
-- ============================================

SELECT TOP 10
    state,
    COUNT(*) AS Total_Transactions,
    SUM(sellingprice) AS Total_Revenue,
    AVG(sellingprice) AS Avg_Price
FROM car_sales
WHERE sellingprice IS NOT NULL
AND state IS NOT NULL
GROUP BY state
ORDER BY Total_Transactions DESC;

-- Results:
-- #1 FL (Florida)      : 81,823 units | $1.13B
-- #2 CA (California)   : 71,617 units | $1.04B
-- #3 PA (Pennsylvania) : 52,966 units | $846M
-- #4 TX (Texas)        : 45,222 units | $597M
-- #5 GA (Georgia)      : 34,091 units | $441M

-- ============================================
-- QUERY 4: SALES BY BODY TYPE
-- ============================================

SELECT
    body,
    COUNT(*) AS Total_Units,
    SUM(sellingprice) AS Total_Revenue,
    AVG(sellingprice) AS Avg_Price
FROM car_sales
WHERE sellingprice IS NOT NULL
AND body IS NOT NULL
GROUP BY body
ORDER BY Total_Units DESC;

-- Results:
-- #1 Sedan      : 238,333 units | Avg $11,732
-- #2 SUV        : 141,338 units | Avg $16,134
-- #3 Hatchback  :  25,867 units | Avg $10,063

-- ============================================
-- QUERY 5: SELLING PRICE VS MMR BY MAKE
-- ============================================

SELECT
    make,
    COUNT(*) AS Total_Units,
    ROUND(AVG(mmr), 0) AS Avg_Market_Value,
    ROUND(AVG(sellingprice), 0) AS Avg_Selling_Price,
    ROUND(AVG(sellingprice - mmr), 0) AS Avg_Price_Difference,
    ROUND(AVG(sellingprice - mmr) * 100.0 / AVG(mmr), 2) AS Price_Diff_Percentage
FROM car_sales
WHERE sellingprice IS NOT NULL
AND mmr IS NOT NULL
AND make IS NOT NULL
GROUP BY make
ORDER BY Avg_Price_Difference DESC;

-- Results:
-- Aston Martin sold ABOVE market by $1,252 (+2.34%)
-- Most brands sold BELOW market value
-- Ferrari sold below market by -$2,000 (-1.55%)

-- ============================================
-- QUERY 6: MONTHLY SALES TREND
-- ============================================

SELECT
    YEAR(sale_date_clean) AS Sale_Year,
    MONTH(sale_date_clean) AS Sale_Month,
    DATENAME(MONTH, sale_date_clean) AS Month_Name,
    COUNT(*) AS Total_Transactions,
    SUM(sellingprice) AS Total_Revenue,
    AVG(sellingprice) AS Avg_Price
FROM car_sales
WHERE sellingprice IS NOT NULL
AND sale_date_clean IS NOT NULL
GROUP BY YEAR(sale_date_clean), MONTH(sale_date_clean),
         DATENAME(MONTH, sale_date_clean)
ORDER BY Sale_Year, Sale_Month;

-- Results:
-- Peak month : Feb 2015 with 160,218 transactions
-- Revenue    : $2.18B in Feb 2015 alone

-- ============================================
-- QUERY 7: CONDITION VS AVERAGE PRICE
-- ============================================

SELECT
    condition,
    COUNT(*) AS Total_Units,
    ROUND(AVG(sellingprice), 0) AS Avg_Price,
    ROUND(MIN(sellingprice), 0) AS Min_Price,
    ROUND(MAX(sellingprice), 0) AS Max_Price
FROM car_sales
WHERE sellingprice IS NOT NULL
AND condition IS NOT NULL
GROUP BY condition
ORDER BY condition DESC;

-- Results:
-- Condition 49 (best) : Avg price $22,903
-- Condition 1  (worst): Avg price $3,872
-- Clear positive correlation between condition and price

-- ============================================
-- QUERY 8: TOP 10 SELLERS BY REVENUE
-- ============================================

SELECT TOP 10
    seller,
    COUNT(*) AS Total_Units_Sold,
    ROUND(SUM(sellingprice), 0) AS Total_Revenue,
    ROUND(AVG(sellingprice), 0) AS Avg_Price
FROM car_sales
WHERE sellingprice IS NOT NULL
AND seller IS NOT NULL
GROUP BY seller
ORDER BY Total_Revenue DESC;

-- Results:
-- #1 Ford Motor Credit     : 18,957 units | $337M
-- #2 Nissan-Infiniti LT    : 19,569 units | $270M
-- #3 The Hertz Corporation : 18,159 units | $248M

-- ============================================
-- QUERY 9: ABOVE VS BELOW MARKET PRICE
-- ============================================

SELECT
    CASE
        WHEN sellingprice > mmr THEN 'Above Market'
        WHEN sellingprice < mmr THEN 'Below Market'
        WHEN sellingprice = mmr THEN 'At Market'
    END AS Price_Category,
    COUNT(*) AS Total_Units,
    ROUND(AVG(sellingprice), 0) AS Avg_Selling_Price,
    ROUND(AVG(mmr), 0) AS Avg_Market_Value,
    ROUND(AVG(sellingprice - mmr), 0) AS Avg_Difference
FROM car_sales
WHERE sellingprice IS NOT NULL
AND mmr IS NOT NULL
GROUP BY
    CASE
        WHEN sellingprice > mmr THEN 'Above Market'
        WHEN sellingprice < mmr THEN 'Below Market'
        WHEN sellingprice = mmr THEN 'At Market'
    END
ORDER BY Total_Units DESC;

-- Results:
-- Below Market : 280,200 units (51%)
-- Above Market : 258,962 units (47%)
-- At Market    :  11,122 units (2%)

-- ============================================
-- QUERY 10: RANK MAKES BY REVENUE (WINDOW FUNCTION)
-- ============================================

SELECT
    make,
    COUNT(*) AS Total_Units,
    ROUND(SUM(sellingprice), 0) AS Total_Revenue,
    RANK() OVER (ORDER BY SUM(sellingprice) DESC) AS Revenue_Rank,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS Units_Rank
FROM car_sales
WHERE sellingprice IS NOT NULL
AND make IS NOT NULL
GROUP BY make
ORDER BY Revenue_Rank;

-- Results:
-- Ford       : Revenue Rank #1 | Units Rank #1
-- Chevrolet  : Revenue Rank #2 | Units Rank #2
-- BMW        : Revenue Rank #5 | Units Rank #8 (premium brand)

-- ============================================
-- QUERY 11: RUNNING TOTAL BY DATE (WINDOW FUNCTION)
-- ============================================

SELECT
    sale_date_clean,
    COUNT(*) AS Daily_Transactions,
    ROUND(SUM(sellingprice), 0) AS Daily_Revenue,
    ROUND(SUM(SUM(sellingprice)) OVER (
        ORDER BY sale_date_clean
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 0) AS Running_Total_Revenue
FROM car_sales
WHERE sellingprice IS NOT NULL
AND sale_date_clean IS NOT NULL
GROUP BY sale_date_clean
ORDER BY sale_date_clean;

-- Results:
-- Starting  : $563,400 on 2014-01-01
-- Final     : $7,493,777,997 by 2015-07-21
-- Shows clear revenue growth trend over time

-- ============================================
-- QUERY 12: TOP MODEL PER MAKE (CTE + ROW_NUMBER)
-- ============================================

WITH ModelRanking AS (
    SELECT
        make,
        model,
        COUNT(*) AS Total_Units,
        ROUND(SUM(sellingprice), 0) AS Total_Revenue,
        ROW_NUMBER() OVER (
            PARTITION BY make
            ORDER BY COUNT(*) DESC
        ) AS rank_num
    FROM car_sales
    WHERE sellingprice IS NOT NULL
    AND make IS NOT NULL
    AND model IS NOT NULL
    GROUP BY make, model
)
SELECT
    make,
    model AS Top_Model,
    Total_Units,
    Total_Revenue
FROM ModelRanking
WHERE rank_num = 1
ORDER BY Total_Units DESC;

-- Results:
-- Nissan     : Altima     - 19,190 units
-- Ford       : F-150      - 14,145 units | $266M revenue
-- Toyota     : Camry      - 12,423 units
-- Honda      : Accord     -  9,050 units
-- BMW        : 3 Series   -  8,068 units

-- ============================================
-- END OF ANALYSIS QUERIES
-- Total Records Analyzed : 550,289
-- Date Range             : Jan 2014 - Jul 2015
-- Total Revenue          : $7.49 Billion
-- ============================================