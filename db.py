import pyodbc

def get_connection():
    conn = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=HASSAN\\SQLEXPRESS;'
        'DATABASE=Airline_DB;'  # غيّر اسم الداتا بيز
        'Trusted_Connection=yes;'
    )
    return conn