-- Let's find the most popular Hacker News stories.
SELECT title, score
FROM hacker_news
ORDER BY score DESC
LIMIT 5;

-- Find the total score of all the stories.
SELECT COUNT(score) AS story_scores
FROM hacker_news;

-- Finds all users each with a total score of over 200.
SELECT user, SUM(score) AS user_scores
FROM hacker_news
GROUP BY user
HAVING user_scores > 200
ORDER BY user;

-- Find the extent of dominance of the four users found above.
SELECT (517 + 309 + 304 + 282) / 6366.0 AS dominance;

-- Count the number of rickrolls.
SELECT user, COUNT(*)
FROM hacker_news
WHERE url LIKE 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
GROUP BY user
ORDER BY COUNT(*) DESC;

-- Count the number of stories in each website below.
FROM hacker_news
SELECT CASE
    WHEN url LIKE '%github.com%' THEN 'GitHub'
    WHEN url LIKE '%medium.com%' THEN 'Medium'
    WHEN url LIKE '%nytimes.com%' THEN 'New York Times'
    ELSE 'Other'
  END AS 'Source',
  COUNT(*) AS website_stories 
GROUP BY 1; -- column 1 = title

-- Get the top 10 timestamps.
SELECT timestamp
FROM hacker_news
LIMIT 10;

-- Get the hour of the top 20 timestamps.
SELECT timestamp,
   strftime('%H', timestamp)
FROM hacker_news
GROUP BY 1
LIMIT 20;

-- Get hours, average scores, and number of stories for each hour.
SELECT
   strftime('%H', timestamp),
   AVG(score),
   COUNT(*)
FROM hacker_news
GROUP BY 1
ORDER BY 2 DESC;

-- Get the best hours to post on Hacker News.
SELECT
   strftime('%H', timestamp) AS 'Hour',
   ROUND(AVG(score), 2) AS 'Average Score',
   COUNT(*) AS 'Number of Stories'
FROM hacker_news
WHERE timestamp IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;
