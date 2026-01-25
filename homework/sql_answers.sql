!-- SQL Queries for Homework -->

!-- Question 3: For the trips in November 2025, how many trips had a trip_distance of less than or equal to 1 mile? --> 
SELECT COUNT(1) FROM public.yellow_taxi_trips_2025_11 WHERE trip_distance <= 1;


!-- Question 4. Which was the pick up day with the longest trip distance? Only consider trips with trip_distance less than 100 miles. -->
SELECT lpep_pickup_datetime FROM public.yellow_taxi_trips_2025_11 
WHERE trip_distance = (
	SELECT MAX(trip_distance) 
	FROM public.yellow_taxi_trips_2025_11
	WHERE trip_distance < 100
)

!-- Question 5. Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025? -->
SELECT
    z."Zone" AS pickup_zone,
    SUM(t.total_amount) AS total_revenue
FROM public.yellow_taxi_trips_2025_11 t
JOIN public.yellow_taxi_zones_2025_11 z
  ON t."PULocationID" = z."LocationID"
WHERE t.lpep_pickup_datetime >= '2025-11-18'
  AND t.lpep_pickup_datetime < '2025-11-19'
GROUP BY z."Zone"
ORDER BY total_revenue DESC
LIMIT 1;

!-- Question 6. For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip? -->
SELECT
    dz."Zone" AS dropoff_zone,
    MAX(t.tip_amount) AS largest_tip
FROM public.yellow_taxi_trips_2025_11 t
JOIN public.yellow_taxi_zones_2025_11 pz
  ON t."PULocationID" = pz."LocationID"
JOIN public.yellow_taxi_zones_2025_11 dz
  ON t."DOLocationID" = dz."LocationID"
WHERE pz."Zone" = 'East Harlem North'
  AND t.lpep_pickup_datetime >= '2025-11-01'
  AND t.lpep_pickup_datetime < '2025-12-01'
GROUP BY dz."Zone"
ORDER BY largest_tip DESC
LIMIT 1;

