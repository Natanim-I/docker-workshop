<!-- SQL code to create an external table in BigQuery pointing to Parquet files stored in Google Cloud Storage -->
CREATE OR REPLACE EXTERNAL TABLE `kestra-demo-486219.zoomcamp.external_yellow_tripdata_2024`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://kestra-zoomcamp-natanim-demo/yellow_tripdata_2024-*.parquet']
);

<!-- SQL code to create a materialized table in BigQuery by selecting all data from the external table -->
CREATE OR REPLACE TABLE kestra-demo-486219.zoomcamp.yellow_tripdata_materialized_2024 AS
SELECT * FROM kestra-demo-486219.zoomcamp.external_yellow_tripdata_2024;

<!-- Question 1: What is count of records for the 2024 Yellow Taxi Data? -->
SELECT COUNT(*)
FROM `kestra-demo-486219.zoomcamp.external_yellow_tripdata_2024`;

<!-- Question 2: What is the estimated amount of data that will be read when this query is executed on the External Table and the Table? -->
SELECT COUNT(DISTINCT PULocationID)
FROM kestra-demo-486219.zoomcamp.external_yellow_tripdata_2024;

SELECT COUNT(DISTINCT PULocationID)
FROM kestra-demo-486219.zoomcamp.yellow_tripdata_materialized_2024;

<!-- Question 3: Why are the estimated number of Bytes different? -->
<!-- Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery -->
SELECT PULocationID
FROM kestra-demo-486219.zoomcamp.yellow_tripdata_materialized_2024;

<!-- Now write a query to retrieve the PULocationID and DOLocationID on the same table. -->
SELECT PULocationID, DOLocationID
FROM kestra-demo-486219.zoomcamp.yellow_tripdata_materialized_2024;

<!-- Question 4: How many records have a fare_amount of 0? -->
SELECT COUNT(*)
FROM kestra-demo-486219.zoomcamp.yellow_tripdata_materialized_2024
WHERE fare_amount = 0;

<!-- Question 5: What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)? -->
<!-- Partition by tpep_dropoff_datetime and Cluster on VendorID -->
CREATE OR REPLACE TABLE kestra-demo-486219.zoomcamp.yellow_tripdata_2024_partitioned
PARTITION BY
  DATE( tpep_dropoff_datetime) AS
SELECT * FROM kestra-demo-486219.zoomcamp.external_yellow_tripdata_2024;

CREATE OR REPLACE TABLE kestra-demo-486219.zoomcamp.yellow_tripdata_2024_partitioned_clustered
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM kestra-demo-486219.zoomcamp.external_yellow_tripdata_2024;

<!-- Question 6: Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive). Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values? (1 point) -->
SELECT DISTINCT VendorID
FROM kestra-demo-486219.zoomcamp.yellow_tripdata_materialized_2024
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

SELECT DISTINCT VendorID
FROM kestra-demo-486219.zoomcamp.yellow_tripdata_2024_partitioned
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

<!-- Question 9: Write a `SELECT count(*)` query FROM the materialized table you created. How many bytes does it estimate will be read? Why? -->
SELCT COUNT(*)
FROM kestra-demo-486219.zoomcamp.yellow_tripdata_materialized_2024;