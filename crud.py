import pandas as pd
from db import get_connection

# ================= GET TABLES =================
def get_tables():
    conn = get_connection()
    query = """
    SELECT TABLE_NAME 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE'
    """
    tables = pd.read_sql(query, conn)["TABLE_NAME"].tolist()
    conn.close()
    return tables


# ================= GET COLUMNS =================
def get_columns(table_name):
    conn = get_connection()
    query = f"""
    SELECT COLUMN_NAME 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = '{table_name}'
    """
    cols = pd.read_sql(query, conn)["COLUMN_NAME"].tolist()
    conn.close()
    return cols


# ================= READ =================
def get_data(table_name):
    conn = get_connection()
    df = pd.read_sql(f"SELECT * FROM {table_name}", conn)
    conn.close()
    return df


# ================= INSERT =================
def insert_data(table_name, data_dict):
    conn = get_connection()
    cursor = conn.cursor()

    cols = ", ".join(data_dict.keys())
    placeholders = ", ".join(["?"] * len(data_dict))

    query = f"INSERT INTO {table_name} ({cols}) VALUES ({placeholders})"

    cursor.execute(query, list(data_dict.values()))
    conn.commit()
    conn.close()


# ================= UPDATE =================
def update_data(table_name, data_dict, pk_col, pk_val):
    conn = get_connection()
    cursor = conn.cursor()

    set_clause = ", ".join([f"{col}=?" for col in data_dict.keys()])

    query = f"UPDATE {table_name} SET {set_clause} WHERE {pk_col}=?"

    cursor.execute(query, list(data_dict.values()) + [pk_val])
    conn.commit()
    conn.close()


# ================= DELETE =================
def delete_data(table_name, pk_col, pk_val):
    conn = get_connection()
    cursor = conn.cursor()

    query = f"DELETE FROM {table_name} WHERE {pk_col}=?"

    cursor.execute(query, (pk_val,))
    conn.commit()
    conn.close()