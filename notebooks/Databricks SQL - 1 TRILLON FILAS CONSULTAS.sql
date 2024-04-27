-- Databricks notebook source
-- MAGIC %md
-- MAGIC %md
-- MAGIC # 🚀 Databricks SQL Serverless 1 TRILLON DE FILAS - 2/2 CONSULTAS

-- COMMAND ----------

-- MAGIC %md
-- MAGIC %md
-- MAGIC ➡️ https://github.com/gallardo-rivilla/databricks_1trillonfilas/tree/main

-- COMMAND ----------

-- MAGIC
-- MAGIC %md
-- MAGIC <div style="text-align: center; line-height: 0; padding-top: 9px;">
-- MAGIC   <img src="https://github.com/gallardo-rivilla/databricks_1trillonfilas/raw/main/images/databricks1trillon.png" alt="Databricks Learning" style="width: 600px">
-- MAGIC </div>

-- COMMAND ----------

USE CATALOG DEMOSQL1TRILLON;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC # 1 TRILLON Row Challenge

-- COMMAND ----------

SET use_cached_result=false;

SELECT group, station, min(measure), max(measure), mean(measure)
FROM demosql1trillon.1trillon.measurements_delta
GROUP BY group, station
ORDER BY group, station;

-- COMMAND ----------

SET use_cached_result=false;
SELECT station, sum(measure) as total_measure
FROM demosql1trillon.1trillon.measurements_delta
GROUP BY station
ORDER BY total_measure DESC;

-- COMMAND ----------

-- Consulta que encuentra las 10 estaciones con la mayor diferencia entre la temperatura máxima y mínima registrada:
SET use_cached_result=false;
WITH temp_diff AS (
    SELECT station, max(measure) - min(measure) AS temp_difference
    FROM demosql1trillon.1trillon.measurements_delta
    GROUP BY station
)
SELECT s.station, s.mean_temp, td.temp_difference
FROM demosql1trillon.1trillon.stations s
JOIN temp_diff td ON s.station = td.station
ORDER BY td.temp_difference DESC
LIMIT 10;


-- COMMAND ----------

-- Consulta que calcula la suma de las medidas para estaciones con una temperatura media por encima del promedio general:

SET use_cached_result=false;
WITH avg_temp AS (
    SELECT AVG(mean_temp) AS overall_avg_temp
    FROM demosql1trillon.1trillon.stations
),
stations_above_avg AS (
    SELECT station
    FROM demosql1trillon.1trillon.stations s
    JOIN avg_temp at ON s.mean_temp > at.overall_avg_temp
)
SELECT saa.station, SUM(md.measure) AS total_measure
FROM demosql1trillon.1trillon.measurements_delta md
JOIN stations_above_avg saa ON md.station = saa.station
GROUP BY saa.station;
