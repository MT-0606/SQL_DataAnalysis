-- 1. Examine the first 10 rows from each table.
SELECT *
FROM users
LIMIT 10;
SELECT *
FROM posts
LIMIT 10;
SELECT *
FROM subreddits
LIMIT 10;

-- 2a. What is the primary key for each table?
-- Easy: id

-- 2b. What are the foreign keys?
-- From users: 'username', 'email', 'join_date', 'score'
-- From posts: 'title'
-- From subreddits: 'name', 'created_date', 'subscriber_count'

-- 3. How many different subreddits are there?
SELECT COUNT(*) AS subreddit_count
FROM subreddits;

-- 4a. Which user has the highest score?
SELECT username, MAX(score) AS highest_user_score
FROM users;

-- 4b. Which post has the highest score?
SELECT title, MAX(score) AS highest_post_score
FROM posts;

-- 4c. What are the top five subreddits with the most subscribers?
SELECT name, subscriber_count
FROM subreddits
ORDER BY subscriber_count DESC
LIMIT 5;

-- 5. How many posts has each user made?
SELECT users.id, users.username,
    COUNT(posts.id) AS posts_made
FROM users
LEFT JOIN posts
    ON users.id = posts.user_id
WHERE users.username IS NOT NULL
GROUP BY users.id, users.username
ORDER BY posts_made DESC, users.username;

-- 6. Find all existing posts where the users are still active.
SELECT *
FROM posts
INNER JOIN users
    ON posts.id = users.id;

-- 7. Stack the new posts2 table under the existing posts table to see them.
SELECT *
FROM posts
UNION
SELECT *
FROM posts2;

-- 8. Find out which subreddits have the most popular posts. If the post has a score of at least 5,000, it is popular.
WITH popular_posts AS (
    SELECT *
    FROM posts
    WHERE score>=5000
)
SELECT subreddits.name,
    popular_posts.title, popular_posts.score
FROM popular_posts
INNER JOIN subreddits
    ON popular_posts.subreddit_id = subreddits.id
ORDER BY popular_posts.score DESC;

-- 9. Find out the highest score for each subreddit.
SELECT posts.title, 
    subreddits.name,
    MAX(posts.score) AS highest_score
FROM subreddits
INNER JOIN posts
    ON subreddits.id = posts.subreddit_id
GROUP BY subreddits.name
ORDER BY highest_score DESC;

-- 10. Calculate the average score of all posts in each subreddit.
SELECT subreddits.name,
    AVG(posts.score) AS 'average_score'
FROM subreddits
INNER JOIN posts
    ON subreddits.id = posts.subreddit_id
GROUP BY subreddits.name
ORDER BY average_score DESC;
