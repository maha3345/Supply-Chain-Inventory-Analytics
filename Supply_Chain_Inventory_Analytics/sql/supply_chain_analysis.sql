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