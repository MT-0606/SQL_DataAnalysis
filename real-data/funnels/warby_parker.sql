-- Quiz funnel: contains the following questions:
-- 1. What are you looking for?
-- 2. What's your fit?
-- 3. Which shapes do you like?
-- 4. Which colours do you like?
-- 5. When was your last eye exam?
SELECT *
FROM survey
LIMIT 10; -- contains all information from the first 10 rows

-- How many users move from Question 1 to Question 2 (and so on)?
SELECT
    question,
    COUNT(DISTINCT user_id) as users_per_question
FROM survey
GROUP BY question;

-- Which question(s) from the quiz have a lower completion rates?
WITH question_users AS (
    SELECT
        question,
        COUNT(DISTINCT user_id) AS users
    FROM survey
    GROUP BY question
),
completion AS (
    SELECT
        question,
        users,
        LAG(users) OVER (ORDER BY question) AS previous_users
    FROM question_users
)
SELECT
    question,
    ROUND(1.0 * users / previous_users, 2) AS completion_rate
FROM completion
ORDER BY question;

-- Home Try-On Funnel
SELECT *
FROM quiz
LIMIT 5; -- columns: user_id, style, fit, shape, colour (spelled color in the dataset)

SELECT *
FROM home_try_on
LIMIT 5; -- columns: user_id, number_of_pairs, address

SELECT *
FROM purchase
LIMIT 5; -- user_id, product_id, style, model_name, colour (spelled color in the dataset), price

-- Create a new table that represents a single user from the browse table.
SELECT
    DISTINCT q.user_id,
    h.user_id IS NOT NULL AS 'is_home_try_on',
    h.number_of_pairs,
    p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
LIMIT 10;

-- Build one row per quiz user for the complete funnel.
WITH funnel AS (
    SELECT
      q.user_id,
      CASE
          WHEN h.user_id IS NOT NULL THEN 1
          ELSE 0
      END AS is_home_try_on,
      h.number_of_pairs,
      CASE
          WHEN p.user_id IS NOT NULL THEN 1
          ELSE 0
      END AS is_purchase
    FROM quiz AS q
    LEFT JOIN home_try_on AS h
      ON q.user_id = h.user_id
    LEFT JOIN purchase AS p
      ON q.user_id = p.user_id
)
SELECT
    COUNT(*) AS quiz_users,
    SUM(is_home_try_on) AS home_try_on_users,
    SUM(is_purchase) AS purchase_users,

    ROUND(
        100.0 * SUM(is_home_try_on) / COUNT(*),
        1
    ) AS quiz_to_home_try_on_rate,

    ROUND(
        100.0 * SUM(is_purchase) / SUM(is_home_try_on),
        1
    ) AS home_try_on_to_purchase_rate,

    ROUND(
        100.0 * SUM(is_purchase) / COUNT(*),
        1
    ) AS overall_purchase_rate
FROM funnel;

-- Compare purchase rates
WITH funnel AS (
    SELECT
        q.user_id,
        h.number_of_pairs,
        CASE
            WHEN p.user_id IS NOT NULL THEN 1
            ELSE 0
        END AS is_purchase
    FROM quiz AS q
    INNER JOIN home_try_on AS h
        ON q.user_id = h.user_id
    LEFT JOIN purchase AS p
        ON q.user_id = p.user_id
)
SELECT
    number_of_pairs,
    COUNT(*) AS home_try_on_users,
    SUM(is_purchase) AS purchasers,
    ROUND(
        100.0 * SUM(is_purchase) / COUNT(*),
        1
    ) AS purchase_rate
FROM funnel
WHERE number_of_pairs IN ('3 pairs', '5 pairs')
GROUP BY number_of_pairs
ORDER BY number_of_pairs;