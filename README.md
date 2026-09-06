# Supply Chain & Inventory Analytics

## 📌 Project Overview

An end-to-end Data Analytics and Business Analysis project analyzing supply chain operations, inventory performance, warehouse efficiency, supplier lead times, and demand forecasting using Python, MySQL, SQL, and Power BI.

The project analyzes **91,250 supply chain records** to identify inventory risks, evaluate warehouse and supplier performance, analyze SKU demand, measure forecast accuracy, and generate actionable business insights.

---

## 🎯 Business Problem

Efficient supply chain management requires organizations to maintain optimal inventory levels while avoiding stockouts, excessive inventory, and supplier delays.

This project answers:

- Which warehouses hold the highest inventory value?
- Which suppliers have the longest lead times?
- How much inventory is below the reorder point?
- Which SKUs have the highest sales volume?
- How accurate are demand forecasts?
- How do sales and inventory change over time?
- Which warehouses have the highest inventory risk?
- How do suppliers and warehouses compare in performance?

---

## 🛠️ Tools Used

### Python

- Data Cleaning
- Data Quality Validation
- Exploratory Data Analysis
- Feature Engineering
- KPI Analysis
- Supplier and Warehouse Analysis

### MySQL & SQL

- Database Management
- Data Import
- Business KPI Analysis
- Inventory Risk Analysis
- Supplier Performance Analysis
- Warehouse Performance Analysis
- Forecast Accuracy Analysis

### Power BI

- Interactive Dashboard
- KPI Visualization
- Inventory Analysis
- Warehouse Performance Analysis
- Supplier Analysis
- Sales Trend Analysis
- Interactive Filters

---

## 📊 Dataset

- **Supply Chain Records:** 91,250
- **Date Range:** January 2024 – December 2024
- **SKUs:** 50
- **Warehouses:** 5
- **Suppliers:** 10
- **Regions:** 4
- **Columns:** 15

### Key Columns

- Date
- SKU_ID
- Warehouse_ID
- Supplier_ID
- Region
- Units_Sold
- Inventory_Level
- Supplier_Lead_Time_Days
- Reorder_Point
- Order_Quantity
- Unit_Cost
- Unit_Price
- Promotion_Flag
- Stockout_Flag
- Demand_Forecast

---

## 📈 Key KPIs

| KPI | Result |
|---|---:|
| Total Records | 91,250 |
| Total Units Sold | 1,829,979 |
| Total Sales Value | 33,426,337.22 |
| Total Gross Margin | 11,088,201.23 |
| Total Inventory Value | 525,243,991.12 |
| Average Inventory Level | 471.52 |
| Average Demand Forecast | 20.08 |
| Average Supplier Lead Time | 7.98 Days |
| Average Inventory Coverage | 44.69 Days |
| Records Below Reorder Point | 4,787 |
| Inventory Risk | 5.25% |
| Mean Absolute Forecast Error | 2.38 |

---

## 🔍 Key Insights

- **5.25% of inventory records were below the reorder point**, representing 4,787 potential inventory risk records.
- **WH_2 held the highest inventory value**, approximately 121.4M.
- **SUP_4 had the longest average supplier lead time of 8.64 days**.
- **SUP_5 had the lowest average supplier lead time of 6.96 days**.
- **SKU_18 recorded the highest total units sold**.
- Demand forecasting achieved a **Mean Absolute Forecast Error of 2.38 units**.
- The average forecast error was close to zero, indicating limited overall forecasting bias.

---

## 💡 Business Recommendations

1. Monitor inventory below reorder points and establish automated alerts to reduce stockout risks.
2. Review suppliers with longer lead times and consider backup supplier strategies.
3. Optimize warehouse inventory distribution to avoid excessive inventory concentration.
4. Prioritize high-demand SKUs when planning inventory replenishment.
5. Continuously monitor forecast errors to improve demand planning.

---

## 🧹 Data Preparation & Analysis

Data preparation and exploratory analysis were performed using Python.

Key steps included:

- Validating 91,250 supply chain records
- Checking missing values and duplicate records
- Checking negative values in numerical columns
- Converting the Date column into a valid date format
- Creating business metrics for inventory and sales analysis
- Calculating inventory value and sales value
- Calculating gross margin
- Measuring forecast errors
- Calculating reorder gaps
- Creating inventory status categories
- Analyzing supplier, warehouse, and SKU performance

---

## 🗄️ SQL Business Analysis

The dataset was imported into a MySQL database and analyzed using SQL.

The analysis included:

- Dataset verification
- Overall business KPIs
- Regional performance
- Warehouse performance
- Inventory risk analysis
- Inventory status analysis
- Supplier performance
- Top-performing SKUs
- Low-inventory SKUs
- Demand forecast accuracy
- Promotion analysis
- Stockout analysis
- Monthly sales trends
- Monthly inventory trends
- Supplier lead-time analysis
- Warehouse inventory risk analysis

---

## 📊 Power BI Dashboard

The interactive Power BI dashboard includes:

### KPIs

- Total Sales
- Total Gross Margin
- Total Inventory Value
- Total Units Sold
- Average Inventory Level
- Inventory Risk Percentage

### Interactive Analysis

- Monthly Sales Trend
- Warehouse Performance
- Inventory Risk Analysis
- Supplier Lead Time Analysis
- Regional Performance
- Top SKU Performance
- Inventory Status

### Interactive Filters

- Date
- Region
- Warehouse
- Supplier
- SKU

---

## 🔄 Analysis Workflow

**Raw Dataset → Python Data Cleaning → Data Validation → Exploratory Data Analysis → Feature Engineering → MySQL Database → SQL Business Analysis → Power BI Dashboard → Business Insights & Recommendations**

---

## 📁 Project Structure

```text
supply-chain-inventory-analytics/
│
├── data/
│   └── supply_chain_dataset1.csv
│
├── python/
│   ├── data_cleaning.py
│   └── import_to_mysql.py
│
├── sql/
│   └── supply_chain_analysis.sql
│
├── PowerBI/
│   └── Supply_Chain_Inventory_Analytics.pbix
│
├── Dashboard/
│   └── dashboard.png
│
└── README.md
