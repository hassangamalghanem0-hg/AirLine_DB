import streamlit as st
from crud import *

st.set_page_config(page_title="Airline DB", layout="wide")

st.title("✈️ Airline Database Manager")

# ================= TABLE SELECT =================
tables = get_tables()
table = st.sidebar.selectbox("📂 Select Table", tables)

# ================= LOAD DATA =================
df = get_data(table)
st.subheader(f"📊 {table} Data")
st.dataframe(df, use_container_width=True)

# ================= GET COLUMNS =================
columns = get_columns(table)

# نفترض أول عمود هو Primary Key
pk = columns[0]

# ================= ADD =================
st.subheader("➕ Add Record")

with st.form("add_form"):
    new_data = {}

    for col in columns:
        new_data[col] = st.text_input(f"{col}")

    submitted = st.form_submit_button("Add")

    if submitted:
        insert_data(table, new_data)
        st.success("✅ Added Successfully")


# ================= UPDATE =================
st.subheader("✏️ Update Record")

pk_val = st.text_input(f"{pk} (for update)")

update_data_dict = {}

for col in columns[1:]:
    update_data_dict[col] = st.text_input(f"New {col}")

if st.button("Update"):
    update_data(table, update_data_dict, pk, pk_val)
    st.success("✅ Updated")


# ================= DELETE =================
st.subheader("🗑️ Delete Record")

delete_val = st.text_input(f"{pk} (for delete)")

if st.button("Delete"):
    delete_data(table, pk, delete_val)
    st.warning("⚠️ Deleted")