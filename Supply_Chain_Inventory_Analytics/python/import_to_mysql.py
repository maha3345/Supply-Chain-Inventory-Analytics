import pandas as pd
import mysql.connector

csv_path = "data/supply_chain_dataset1.csv"

df = pd.read_csv(csv_path)

print("CSV loaded successfully!")
print("Rows:", len(df))
print("Columns:", len(df.columns))

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password=input("Enter MySQL root password: "),
    database="supply_chain_db"
)

cursor = conn.cursor()

print("Connected to MySQL!")

query = """
INSERT INTO inventory_data (
    Date,
    SKU_ID,
    Warehouse_ID,
    Supplier_ID,
    Region,
    Units_Sold,
    Inventory_Level,
    Supplier_Lead_Time_Days,
    Reorder_Point,
    Order_Quantity,
    Unit_Cost,
    Unit_Price,
    Promotion_Flag,
    Stockout_Flag,
    Demand_Forecast
)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
"""

df["Date"] = pd.to_datetime(df["Date"]).dt.date

data = [
    tuple(row)
    for row in df.itertuples(index=False, name=None)
]

batch_size = 5000

for i in range(0, len(data), batch_size):
    batch = data[i:i + batch_size]
    cursor.executemany(query, batch)
    conn.commit()

    print(
        f"Imported {min(i + batch_size, len(data))} / {len(data)} rows"
    )

cursor.execute("SELECT COUNT(*) FROM inventory_data")
count = cursor.fetchone()[0]

print("\nImport completed!")
print("Rows in MySQL:", count)

cursor.close()
conn.close()

print("MySQL connection closed.")