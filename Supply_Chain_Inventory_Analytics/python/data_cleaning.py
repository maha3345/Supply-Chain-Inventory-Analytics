import pandas as pd
import numpy as np

df = pd.read_csv("data/supply_chain_dataset1.csv")

print("=" * 60)
print("DATASET OVERVIEW")
print("=" * 60)
print("Shape:", df.shape)
print("Date range:", df["Date"].min(), "to", df["Date"].max())

df["Date"] = pd.to_datetime(df["Date"])

print("\n" + "=" * 60)
print("DATA QUALITY CHECK")
print("=" * 60)
print("Missing values:", df.isnull().sum().sum())
print("Duplicate rows:", df.duplicated().sum())

numeric_cols = [
    "Units_Sold",
    "Inventory_Level",
    "Supplier_Lead_Time_Days",
    "Reorder_Point",
    "Order_Quantity",
    "Unit_Cost",
    "Unit_Price",
    "Demand_Forecast"
]

print("\nNegative values:")
print((df[numeric_cols] < 0).sum())

print("\n" + "=" * 60)
print("BUSINESS DIMENSIONS")
print("=" * 60)
print("Unique SKUs:", df["SKU_ID"].nunique())
print("Warehouses:", df["Warehouse_ID"].nunique())
print("Suppliers:", df["Supplier_ID"].nunique())
print("Regions:", df["Region"].nunique())

df["Inventory_Value"] = df["Inventory_Level"] * df["Unit_Cost"]
df["Sales_Value"] = df["Units_Sold"] * df["Unit_Price"]

df["Gross_Margin"] = (
    df["Units_Sold"] * (df["Unit_Price"] - df["Unit_Cost"])
)

df["Forecast_Error"] = (
    df["Units_Sold"] - df["Demand_Forecast"]
)

df["Absolute_Forecast_Error"] = df["Forecast_Error"].abs()

df["Reorder_Gap"] = (
    df["Inventory_Level"] - df["Reorder_Point"]
)

df["Inventory_Coverage_Days"] = np.where(
    df["Demand_Forecast"] > 0,
    df["Inventory_Level"] / df["Demand_Forecast"],
    0
)

df["Inventory_Status"] = np.select(
    [
        df["Inventory_Level"] < df["Reorder_Point"],
        df["Inventory_Level"] >= df["Reorder_Point"]
    ],
    [
        "Below Reorder Point",
        "Healthy"
    ],
    default="Unknown"
)

print("\n" + "=" * 60)
print("OVERALL KPIs")
print("=" * 60)
print("Total Inventory Value:", round(df["Inventory_Value"].sum(), 2))
print("Total Units Sold:", df["Units_Sold"].sum())
print("Total Sales Value:", round(df["Sales_Value"].sum(), 2))
print("Total Gross Margin:", round(df["Gross_Margin"].sum(), 2))
print("Average Inventory Level:", round(df["Inventory_Level"].mean(), 2))
print("Average Demand Forecast:", round(df["Demand_Forecast"].mean(), 2))
print(
    "Average Supplier Lead Time:",
    round(df["Supplier_Lead_Time_Days"].mean(), 2)
)
print(
    "Average Inventory Coverage Days:",
    round(df["Inventory_Coverage_Days"].mean(), 2)
)

print("\n" + "=" * 60)
print("INVENTORY RISK")
print("=" * 60)

below_reorder = (
    df["Inventory_Level"] < df["Reorder_Point"]
).sum()

print("Records below reorder point:", below_reorder)
print(
    "Percentage below reorder point:",
    round(below_reorder / len(df) * 100, 2),
    "%"
)

print("\nInventory Status:")
print(df["Inventory_Status"].value_counts())

print("\n" + "=" * 60)
print("DEMAND FORECAST ANALYSIS")
print("=" * 60)

print(
    "Mean Absolute Forecast Error:",
    round(df["Absolute_Forecast_Error"].mean(), 2)
)

print(
    "Average Forecast Error:",
    round(df["Forecast_Error"].mean(), 2)
)

print("\n" + "=" * 60)
print("SUPPLIER ANALYSIS")
print("=" * 60)

supplier_summary = (
    df.groupby("Supplier_ID")
    .agg(
        Average_Lead_Time=("Supplier_Lead_Time_Days", "mean"),
        Total_Orders=("Order_Quantity", "sum"),
        Inventory_Value=("Inventory_Value", "sum")
    )
    .sort_values("Average_Lead_Time", ascending=False)
)

print(supplier_summary)

print("\n" + "=" * 60)
print("WAREHOUSE ANALYSIS")
print("=" * 60)

warehouse_summary = (
    df.groupby("Warehouse_ID")
    .agg(
        Average_Inventory=("Inventory_Level", "mean"),
        Total_Units_Sold=("Units_Sold", "sum"),
        Inventory_Value=("Inventory_Value", "sum"),
        Average_Lead_Time=("Supplier_Lead_Time_Days", "mean")
    )
    .sort_values("Inventory_Value", ascending=False)
)

print(warehouse_summary)

print("\n" + "=" * 60)
print("TOP 10 SKUs BY UNITS SOLD")
print("=" * 60)

sku_summary = (
    df.groupby("SKU_ID")
    .agg(
        Total_Units_Sold=("Units_Sold", "sum"),
        Average_Inventory=("Inventory_Level", "mean"),
        Average_Demand=("Demand_Forecast", "mean"),
        Inventory_Value=("Inventory_Value", "mean")
    )
    .sort_values("Total_Units_Sold", ascending=False)
)

print(sku_summary.head(10))

print("\n" + "=" * 60)
print("TOP 10 LOW-INVENTORY SKUs")
print("=" * 60)

low_inventory = (
    df.groupby("SKU_ID")
    .agg(
        Average_Inventory=("Inventory_Level", "mean"),
        Average_Reorder_Point=("Reorder_Point", "mean"),
        Average_Demand=("Demand_Forecast", "mean")
    )
)

low_inventory["Reorder_Gap"] = (
    low_inventory["Average_Inventory"]
    - low_inventory["Average_Reorder_Point"]
)

print(
    low_inventory
    .sort_values("Reorder_Gap")
    .head(10)
)

print("\n" + "=" * 60)
print("FINAL VERIFICATION")
print("=" * 60)

print("Final rows:", len(df))
print("Final columns:", len(df.columns))
print("Missing values:", df.isnull().sum().sum())
print("Duplicate rows:", df.duplicated().sum())

print("\nNew columns created:")
print([
    "Inventory_Value",
    "Sales_Value",
    "Gross_Margin",
    "Forecast_Error",
    "Absolute_Forecast_Error",
    "Reorder_Gap",
    "Inventory_Coverage_Days",
    "Inventory_Status"
])

print("\nEDA completed successfully.")