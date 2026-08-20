-- 1. Explore the contents of the tables.
SELECT * 
FROM places;

SELECT * 
FROM reviews;

-- 2. What are the places that cost $20 or less?
SELECT *
FROM places
WHERE price_point <= '$$'; -- 1 dollar sign = 10 dollars

-- 3. What columns can be used to join the two tables?
-- 'id' from places, 'place_id' from reviews

-- 4. Perform an INNER JOIN to see all reviews for restauants with at least one review.
SELECT *
FROM places
INNER JOIN reviews
ON places.id = reviews.place_id;

-- 5. Modify the previous query to select only the most important columns in order.address.
SELECT places.name, places.average_rating,
  reviews.username, reviews.rating, reviews.review_date, reviews.note
FROM places
INNER JOIN reviews
ON places.id = reviews.place_id;

-- 6. Now perform a LEFT JOIN query, selecting the same columns as the previous question.
SELECT places.name, places.average_rating,
  reviews.username, reviews.rating, reviews.review_date, reviews.note
FROM places
LEFT JOIN reviews
ON places.id = reviews.place_id;

-- 7. How about the places WITHOUT reviews?
SELECT places.id, places.name
FROM places
LEFT JOIN reviews
  ON places.id = reviews.place_id
WHERE reviews.place_id IS NULL;

-- 8. Find all reviews made in 2020 and join with places.
WITH reviews_2020 AS (
  SELECT place_id, review_date
  FROM reviews
  WHERE strftime('%Y', review_date) = '2020'
)
SELECT *
FROM reviews_2020
JOIN places
ON reviews_2020.place_id = places.id;

-- 9. Find the reviewer with the most reviews that are BELOW the average rating for places.
WITH below_average AS (
    SELECT reviews.username, COUNT(reviews.id) AS review_count
    FROM reviews
    INNER JOIN places
        ON reviews.place_id = places.id
    WHERE reviews.rating < places.average_rating
    GROUP BY reviews.username
)
SELECT *
FROM below_average
ORDER BY review_count DESC;