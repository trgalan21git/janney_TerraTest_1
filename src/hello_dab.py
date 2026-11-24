# Databricks notebook source
dbutils.widgets.text("catalog", "")
dbutils.widgets.text("schema", "")
dbutils.widgets.text("target", "")

catalog = dbutils.widgets.get("catalog")
schema = dbutils.widgets.get("schema")
target = dbutils.widgets.get("target")
print(f"hello_dab running in target: {target}")

# COMMAND ----------

table = f"{catalog}.{schema}.hello_dab_runs"
spark.sql(f"CREATE TABLE IF NOT EXISTS {table} "
          "(target STRING, run_ts TIMESTAMP, run_by STRING)")
spark.sql(f"INSERT INTO {table} "
          f"SELECT '{target}', current_timestamp(), current_user()")
display(spark.table(table).orderBy("run_ts", ascending=False))