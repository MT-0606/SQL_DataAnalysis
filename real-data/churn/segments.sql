-- What are the first 100 rows in the subscriptions table?
SELECT *
FROM subscriptions
LIMIT 100;

-- How many different segments are there?
SELECT DISTINCT segment
FROM subscriptions
ORDER BY segment;

-- What is the range of months?
SELECT
  MIN(subscription_start) AS first_day,
  MAX(subscription_end) AS last_day
FROM subscriptions;
-- Churn rate months: December 2016 to March 2017

WITH
-- Create a temporary table called months.
    months AS (
    SELECT 
      '2017-01-01' AS first_day, 
      '2017-01-31' AS last_day 
    UNION 
    SELECT 
      '2017-02-01' AS first_day, 
      '2017-02-28' AS last_day 
    UNION 
    SELECT 
      '2017-03-01' AS first_day, 
      '2017-03-31' AS last_day
  ),

-- Create another temporary table called cross_join using the subscriptions and months tables.
  cross_join AS (
    SELECT *
    FROM subscriptions
    CROSS JOIN months
  ),

-- Create a third temporary table called status using cross_join. This table checks whether users from segments 30 or 87 existed before the beginning of the month.
-- Add two columns to the status table: is_canceled_87 and is_canceled_30.
  status AS (
    SELECT 
      id, 
      first_day AS month, 
      CASE
        WHEN (subscription_start < first_day) 
          AND (
            subscription_end > first_day 
            OR subscription_end IS NULL
          )
          AND segment = 87
          THEN 1
        ELSE 0
      END AS is_active_87, 
      CASE
        WHEN (subscription_start < first_day) 
          AND (
            subscription_end BETWEEN first_day AND last_day
          )
          AND segment = 87
          THEN 1
        ELSE 0
      END AS is_canceled_87, 
      CASE
        WHEN (subscription_start < first_day) 
          AND (
            subscription_end > first_day 
            OR subscription_end IS NULL
          )
          AND segment = 30
          THEN 1
        ELSE 0
      END AS is_active_30,
      CASE
        WHEN (subscription_start < first_day) 
          AND (
            subscription_end BETWEEN first_day AND last_day
          )
          AND segment = 30
          THEN 1
        ELSE 0
      END AS is_canceled_30
    FROM cross_join
  ),

-- Create a status_aggregate temporary table that sums up all the active and cancelled subscriptions for each segment for each month.
  status_aggregate AS (
    SELECT 
      month, 
      SUM(is_active_30) AS sum_active_30, 
      SUM(is_canceled_30) AS sum_canceled_30,
      SUM(is_active_87) AS sum_active_87, 
      SUM(is_canceled_87) AS sum_canceled_87 
    FROM status 
    GROUP BY month
  )

-- Calculate the churn rates for the two segments over the three-month period.
SELECT
  month,
  ROUND(100.0 * sum_canceled_30 / sum_active_30, 3) AS churn_rate_30_percent,
  ROUND(100.0 * sum_canceled_87 / sum_active_87, 3) AS churn_rate_87_percent
FROM status_aggregate;
-- Segment 30 has the lower churn rate in all three months.

-- How to support a large number of segments: use GROUP BY <segment> and aggregate columns dynamically.