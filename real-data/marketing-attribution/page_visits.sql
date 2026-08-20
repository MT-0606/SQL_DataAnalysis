/*
Here's the first-touch query, in case you need it
*/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)

-- How many first touches is each campaign responsible for?
SELECT ft_attr.utm_source,
       ft_attr.utm_campaign,
       COUNT(*) AS num_first_touches
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

-- How many campaigns and sources does CoolTShirts use?
SELECT COUNT(DISTINCT utm_campaign) AS distinct_campaigns
FROM page_visits;
SELECT COUNT(DISTINCT utm_source) AS distinct_sources
FROM page_visits;
-- Which source is used for each campaign?
SELECT DISTINCT utm_source,
  utm_campaign
FROM page_visits;

-- What pages are on the CoolTShirts website?
SELECT DISTINCT page_name
FROM page_visits;

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)

-- How many last touches is each campaign responsible for?
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*) AS num_last_touches
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

-- How many visitors have made a purchase?
SELECT COUNT(DISTINCT user_id) AS num_purchases
FROM page_visits
WHERE page_name = '4 - purchase';

-- How many purchases has each campaign produced?
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT utm_campaign,
  COUNT(*) AS num_purchases
FROM lt_attr
GROUP BY utm_source, utm_campaign
ORDER BY num_purchases DESC;

-- The campaign they should focus on: weekly newsletters, because it was purchased the most times.