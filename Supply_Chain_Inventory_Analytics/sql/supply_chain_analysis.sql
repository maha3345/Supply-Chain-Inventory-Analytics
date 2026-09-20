USE supply_chain_db;

SELECT COUNT(*) AS total_records
FROM inventory_data;

SELECT
    MIN(Date) AS start_date,
    MAX(Date) AS end_date,
    COUNT(DISTINCT SKU_ID) AS total_skus,
    COUNT(DISTINCT Warehouse_ID) AS total_warehouses,
    COUNT(DISTINCT Supplier_ID) AS total_suppliers,
    COUNT(DISTINCT Region) AS total_regions
FROM inventory_data;

SELECT
    COUNT(*) AS total_records,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_sales_value,
    ROUND(SUM(Units_Sold * (Unit_Price - Unit_Cost)), 2) AS total_gross_margin,
    ROUND(SUM(Inventory_Level * Unit_Cost), 2) AS total_inventory_value,
    ROUND(AVG(Inventory_Level), 2) AS average_inventory_level,
    ROUND(AVG(Demand_Forecast), 2) AS average_demand_forecast,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS average_supplier_lead_time
FROM inventory_data;

SELECT
    Region,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_sales,
    ROUND(SUM(Units_Sold * (Unit_Price - Unit_Cost)), 2) AS gross_margin,
    ROUND(
        SUM(Units_Sold * (Unit_Price - Unit_Cost))
        / NULLIF(SUM(Units_Sold * Unit_Price), 0) * 100,
        2
    ) AS margin_percentage
FROM inventory_data
GROUP BY Region
ORDER BY total_sales DESC;

SELECT
    Warehouse_ID,
    ROUND(AVG(Inventory_Level), 2) AS average_inventory,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Inventory_Level * Unit_Cost), 2) AS inventory_value,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS average_lead_time
FROM inventory_data
GROUP BY Warehouse_ID
ORDER BY inventory_value DESC;

SELECT COUNT(*) AS records_below_reorder_point
FROM inventory_data
WHERE Inventory_Level < Reorder_Point;

SELECT
    ROUND(
        SUM(CASE WHEN Inventory_Level < Reorder_Point THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS percentage_below_reorder_point
FROM inventory_data;

SELECT
    CASE
        WHEN Inventory_Level < Reorder_Point THEN 'Below Reorder Point'
        ELSE 'Healthy'
    END AS inventory_status,
    COUNT(*) AS record_count
FROM inventory_data
GROUP BY
    CASE
        WHEN Inventory_Level < Reorder_Point THEN 'Below Reorder Point'
        ELSE 'Healthy'
    END;

SELECT
    Supplier_ID,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS average_lead_time,
    COUNT(*) AS total_records,
    ROUND(SUM(Inventory_Level * Unit_Cost), 2) AS inventory_value
FROM inventory_data
GROUP BY Supplier_ID
ORDER BY average_lead_time DESC;

SELECT
    SKU_ID,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(AVG(Inventory_Level), 2) AS average_inventory,
    ROUND(AVG(Demand_Forecast), 2) AS average_demand,
    ROUND(SUM(Inventory_Level * Unit_Cost), 2) AS inventory_value
FROM inventory_data
GROUP BY SKU_ID
ORDER BY total_units_sold DESC
LIMIT 10;

SELECT
    SKU_ID,
    ROUND(AVG(Inventory_Level), 2) AS average_inventory,
    ROUND(AVG(Reorder_Point), 2) AS average_reorder_point,
    ROUND(AVG(Demand_Forecast), 2) AS average_demand,
    ROUND(AVG(Inventory_Level) - AVG(Reorder_Point), 2) AS reorder_gap
FROM inventory_data
GROUP BY SKU_ID
ORDER BY average_inventory ASC
LIMIT 10;

SELECT
    ROUND(AVG(ABS(Units_Sold - Demand_Forecast)), 2) AS mean_absolute_forecast_error,
    ROUND(AVG(Units_Sold - Demand_Forecast), 2) AS average_forecast_error
FROM inventory_data;

SELECT
    Region,
    SUM(Units_Sold) AS actual_units_sold,
    ROUND(SUM(Demand_Forecast), 2) AS forecast_units,
    ROUND(SUM(Units_Sold - Demand_Forecast), 2) AS forecast_error,
    ROUND(AVG(ABS(Units_Sold - Demand_Forecast)), 2) AS mean_absolute_error
FROM inventory_data
GROUP BY Region
ORDER BY mean_absolute_error DESC;

SELECT
    Promotion_Flag,
    COUNT(*) AS records,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(AVG(Units_Sold), 2) AS average_units_sold,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_sales
FROM inventory_data
GROUP BY Promotion_Flag
ORDER BY Promotion_Flag;

SELECT
    Stockout_Flag,
    COUNT(*) AS records,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(AVG(Inventory_Level), 2) AS average_inventory
FROM inventory_data
GROUP BY Stockout_Flag;

SELECT
    SKU_ID,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_sales,
    ROUND(
        SUM(Units_Sold * (Unit_Price - Unit_Cost)),
        2
    ) AS gross_margin
FROM inventory_data
GROUP BY SKU_ID
ORDER BY gross_margin DESC
LIMIT 10;

SELECT
    SKU_ID,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(AVG(Inventory_Level), 2) AS average_inventory,
    ROUND(AVG(Demand_Forecast), 2) AS average_demand,
    ROUND(AVG(Reorder_Point), 2) AS average_reorder_point
FROM inventory_data
GROUP BY SKU_ID
ORDER BY total_units_sold DESC, average_inventory ASC
LIMIT 10;

SELECT
    DATE_FORMAT(Date, '%Y-%m') AS month,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_sales,
    ROUND(
        SUM(Units_Sold * (Unit_Price - Unit_Cost)),
        2
    ) AS gross_margin
FROM inventory_data
GROUP BY DATE_FORMAT(Date, '%Y-%m')
ORDER BY month;

SELECT
    DATE_FORMAT(Date, '%Y-%m') AS month,
    ROUND(AVG(Inventory_Level), 2) AS average_inventory,
    ROUND(SUM(Inventory_Level * Unit_Cost), 2) AS inventory_value
FROM inventory_data
GROUP BY DATE_FORMAT(Date, '%Y-%m')
ORDER BY month;

SELECT
    Supplier_ID,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS average_lead_time,
    COUNT(*) AS total_records,
    ROUND(SUM(Inventory_Level * Unit_Cost), 2) AS inventory_value
FROM inventory_data
GROUP BY Supplier_ID
HAVING AVG(Supplier_Lead_Time_Days) > 8
ORDER BY average_lead_time DESC;

SELECT
    Warehouse_ID,
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN Inventory_Level < Reorder_Point THEN 1
            ELSE 0
        END
    ) AS below_reorder_records,
    ROUND(
        SUM(
            CASE
                WHEN Inventory_Level < Reorder_Point THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS risk_percentage
FROM inventory_data
GROUP BY Warehouse_ID
ORDER BY risk_percentage DESC;

SELECT
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_revenue,
    ROUND(
        SUM(Units_Sold * (Unit_Price - Unit_Cost)),
        2
    ) AS total_gross_margin,
    ROUND(
        SUM(Inventory_Level * Unit_Cost),
        2
    ) AS total_inventory_value,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS average_supplier_lead_time,
    ROUND(
        SUM(
            CASE
                WHEN Inventory_Level < Reorder_Point THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS inventory_risk_percentage,
    ROUND(
        AVG(ABS(Units_Sold - Demand_Forecast)),
        2
    ) AS forecast_mae
FROM inventory_data;

SELECT
    Supplier_ID,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS average_lead_time,
    RANK() OVER (ORDER BY AVG(Supplier_Lead_Time_Days) DESC) AS lead_time_rank
FROM inventory_data
GROUP BY Supplier_ID;

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(Date, '%Y-%m') AS month,
        ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_sales
    FROM inventory_data
    GROUP BY DATE_FORMAT(Date, '%Y-%m')
)
SELECT
    month,
    total_sales,
    ROUND(SUM(total_sales) OVER (ORDER BY month), 2) AS running_total_sales,
    LAG(total_sales) OVER (ORDER BY month) AS previous_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY month))
        / NULLIF(LAG(total_sales) OVER (ORDER BY month), 0) * 100,
        2
    ) AS mom_growth_pct
FROM monthly_sales
ORDER BY month;

WITH sku_by_warehouse AS (
    SELECT
        Warehouse_ID,
        SKU_ID,
        SUM(Units_Sold) AS total_units_sold
    FROM inventory_data
    GROUP BY Warehouse_ID, SKU_ID
),
ranked AS (
    SELECT
        Warehouse_ID,
        SKU_ID,
        total_units_sold,
        ROW_NUMBER() OVER (
            PARTITION BY Warehouse_ID
            ORDER BY total_units_sold DESC
        ) AS sku_rank
    FROM sku_by_warehouse
)
SELECT Warehouse_ID, SKU_ID, total_units_sold, sku_rank
FROM ranked
WHERE sku_rank <= 3
ORDER BY Warehouse_ID, sku_rank;

WITH region_margin AS (
    SELECT
        Region,
        ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_sales,
        ROUND(SUM(Units_Sold * (Unit_Price - Unit_Cost)), 2) AS gross_margin
    FROM inventory_data
    GROUP BY Region
)
SELECT
    Region,
    total_sales,
    gross_margin,
    ROUND(gross_margin / NULLIF(total_sales, 0) * 100, 2) AS margin_pct,
    RANK() OVER (ORDER BY gross_margin / NULLIF(total_sales, 0) DESC) AS margin_rank,
    ROUND(gross_margin * 100.0 / SUM(gross_margin) OVER (), 2) AS share_of_total_margin
FROM region_margin
ORDER BY margin_rank;

WITH sku_sales AS (
    SELECT
        SKU_ID,
        SUM(Units_Sold) AS total_units_sold,
        ROUND(SUM(Units_Sold * (Unit_Price - Unit_Cost)), 2) AS gross_margin
    FROM inventory_data
    GROUP BY SKU_ID
),
sku_risk AS (
    SELECT
        SKU_ID,
        ROUND(
            SUM(CASE WHEN Inventory_Level < Reorder_Point THEN 1 ELSE 0 END)
            * 100.0 / COUNT(*),
            2
        ) AS below_reorder_pct
    FROM inventory_data
    GROUP BY SKU_ID
)
SELECT
    s.SKU_ID,
    s.total_units_sold,
    s.gross_margin,
    r.below_reorder_pct
FROM sku_sales s
JOIN sku_risk r ON s.SKU_ID = r.SKU_ID
ORDER BY s.total_units_sold DESC, r.below_reorder_pct DESC
LIMIT 10;

WITH warehouse_risk AS (
    SELECT
        Warehouse_ID,
        ROUND(
            SUM(CASE WHEN Inventory_Level < Reorder_Point THEN 1 ELSE 0 END)
            * 100.0 / COUNT(*),
            2
        ) AS risk_pct
    FROM inventory_data
    GROUP BY Warehouse_ID
),
overall_risk AS (
    SELECT
        ROUND(
            SUM(CASE WHEN Inventory_Level < Reorder_Point THEN 1 ELSE 0 END)
            * 100.0 / COUNT(*),
            2
        ) AS overall_pct
    FROM inventory_data
)
SELECT
    w.Warehouse_ID,
    w.risk_pct,
    o.overall_pct,
    ROUND(w.risk_pct - o.overall_pct, 2) AS diff_vs_overall
FROM warehouse_risk w
CROSS JOIN overall_risk o
ORDER BY diff_vs_overall DESC;

SELECT
    ROUND(SUM(Inventory_Level * Unit_Cost) / COUNT(DISTINCT Date), 2) AS avg_daily_inventory_value
FROM inventory_data;
