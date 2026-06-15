# Vehicle Sales Analytics Dashboard

## Project Overview

This project is an end-to-end vehicle sales analytics solution developed using Excel, SQL Server, and Power BI. The project focuses on data cleaning, exploratory data analysis (EDA) using T-SQL, dashboard development, and generating actionable business insights from 550K+ vehicle sales records.

The workflow includes:
- Raw data preprocessing and cleaning using SQL Server (SSMS)
- Advanced data analysis using 12 T-SQL queries with CTEs and Window Functions
- Interactive dashboard development using Power BI
- KPI analysis and sales performance monitoring across 53 brands and 43 US states

---

## Tools & Technologies

- Excel
- SQL Server (SSMS)
- T-SQL
- Power BI
- Power Query
- DAX

---

## Project Workflow

### 1. Data Collection & Preprocessing
- Imported raw vehicle sales dataset (558,837 rows)
- Removed 8,536 duplicate records using CTE + ROW_NUMBER()
- Handled missing values and NULL entries
- Standardized inconsistent make/body/transmission values
- Added cleaned date column (sale_date_clean) using TRY_CONVERT()
- Final cleaned dataset: 550,289 rows

### 2. SQL Data Analysis
- Performed EDA using 12 advanced T-SQL queries
- Used aggregations, GROUP BY, RANK(), DENSE_RANK(), ROW_NUMBER()
- Built running totals using window functions
- Used CTEs for top model per make analysis
- Analyzed pricing vs MMR market value

### 3. Power BI Dashboard Development
- Connected Power BI to cleaned CSV dataset
- Created calculated columns (Condition_Range, Market_Position)
- Built 6 DAX measures
- Developed 4 interactive dashboard pages
- Added navigation buttons, slicers, KPI cards, and map visual

---

## Key KPIs

- Total Revenue: $7.49 Billion
- Total Cars Sold: 550,289
- Average Selling Price: $13,618
- Average Condition Score: 30.7
- Top Brand: Ford ($1.34B revenue)
- Date Range: January 2014 - July 2015

---

## Dashboard Pages

- Sales Overview
- Brand & Model Analysis
- Pricing Analysis
- Regional Analysis

---

## Key Insights

- Ford was the top brand by revenue ($1.34B, 92,536 units)
- Mercedes-Benz had the highest average selling price ($21,638)
- Florida was the top state with 81,823 units sold
- Nissan Altima was the top model with 19,190 units
- February 2015 was the peak month (160,218 transactions, $2.18B revenue)
- 51% of cars sold below market value (MMR)
- Sedans dominated with 44% of total sales

---

## Folder Structure

1_DATASET/
├── RAW_DATA/
│   └── car_prices.csv
└── CLEANED_DATA/
    └── Vehicle_Sales_Cleaned.csv
2_SQL_ANALYSIS/
├── 01_Database_Creation_and_Cleaning.sql
└── 02_Analysis_Queries.sql
3_POWER_BI_DASHBOARD/
└── Vehicle_Sales_Cleaned.pbix
4_DASHBOARD_SCREENSHOTS/
├── 1_Sales_Overview.png
├── 2_Brand_&_Model_Analysis.png
├── 3_Pricing_Analysis.png
└── 4_Regional_Analysis.png

---

## Dashboard Screenshots

### Sales Overview
![Sales Overview](https://raw.githubusercontent.com/ksaidurgaprasad16/VEHICLE-SALES-ANALYTICS/refs/heads/main/4_DASHBOARD_SCREENSHOTS/1_Sales_Overview.png)

### Brand & Model Analysis
![Brand & Model Analysis](https://raw.githubusercontent.com/ksaidurgaprasad16/VEHICLE-SALES-ANALYTICS/refs/heads/main/4_DASHBOARD_SCREENSHOTS/2_Brand_%26_Model_Analysis.png)

### Pricing Analysis
![Pricing Analysis](https://raw.githubusercontent.com/ksaidurgaprasad16/VEHICLE-SALES-ANALYTICS/refs/heads/main/4_DASHBOARD_SCREENSHOTS/3_Pricing_Analysis.png)

### Regional Analysis
![Regional Analysis](https://raw.githubusercontent.com/ksaidurgaprasad16/VEHICLE-SALES-ANALYTICS/refs/heads/main/4_DASHBOARD_SCREENSHOTS/4_Regional_Analysis.png)

---

## Author

K Sai Durga Prasad
