WITH last_touch AS (
    SELECT user_id,
       MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    GROUP BY user_id)
SELECT lt.user_id,
   lt.last_touch_at,
   pv.utm_source
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
   ON lt.user_id = pv.user_id
   AND lt.last_touch_at = pv.timestamp;
   -- WHERE lt.user_id = 10069;