-- What are the column names?
SELECT *
FROM met;

-- How many pieces are in the American Decorative Art collection?
SELECT COUNT('American Decorative Arts')
  AS ada_pieces
FROM met;

-- Count the number of pieces where the category includes 'celery'.
SELECT COUNT(*)
  AS celery_count
FROM met
WHERE category LIKE '%celery%';

-- Find the title and medium of the oldest piece(s) in the collection.
SELECT title, medium,
    MIN(date) AS 'oldest_pieces'
FROM met;

-- Find the top 10 countries with the most pieces in the collection.
SELECT country,
    COUNT(*) AS country_pieces
FROM met
WHERE country IS NOT NULL
GROUP BY country
ORDER BY country_pieces DESC
LIMIT 10;

-- Find the categories HAVING more than 100 pieces.
SELECT category,
    COUNT(category) AS category_pieces
FROM met
GROUP BY category
HAVING category_pieces>100;

-- Count the number of pieces where the medium contains 'gold' or 'silver'.
-- Then sort in descending order.
SELECT medium,
    COUNT(medium) AS medium_pieces
FROM met
WHERE medium LIKE '%gold%' OR medium LIKE '%silver%'
GROUP BY medium
ORDER BY medium_pieces DESC;
