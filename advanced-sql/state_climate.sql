-- What are the contents of our database?
SELECT *
FROM state_climate;

/*
Aggregate and Value Functions
*/
-- How does average temperature change over time in each state?
SELECT state,
  year,
  tempc,
  AVG(tempc) OVER (
    PARTITION BY state
    ORDER BY year
    ) AS running_avg_temp
FROM state_climate;

-- What are the lowest temperatures of each state?
SELECT state,
  year,
  tempc,
  FIRST_VALUE(tempc) OVER (
    PARTITION BY state
    ORDER BY year
    ) AS lowest_temp
FROM state_climate;

-- What are the highest temperatures of each state?
SELECT state,
  year,
  tempc,
  LAST_VALUE(tempc) OVER (
    PARTITION BY state
    ORDER BY year
    RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS highest_temp
FROM state_climate;

-- How much has temperature changed over time in each state?
SELECT state,
  year,
  tempc,
  tempc - LAG(tempc, 1, 0) OVER (
    PARTITION BY state
    ORDER BY year
  ) AS change_in_temp
FROM state_climate
ORDER BY change_in_temp DESC;

/*
Ranking Functions
*/
-- Rank all the coldest temperatures on record.
WITH coldest_rank AS (
  SELECT year,
  state,
  tempc,
  RANK() OVER (
    PARTITION BY state
    ORDER BY tempc ASC
  ) AS coldest_rank
  FROM state_climate
)
SELECT year,
  state,
  tempc
FROM coldest_rank
WHERE coldest_rank = 1
ORDER BY state, year;

-- Rank all the warmest temperatures on record.
WITH warmest_rank AS (
  SELECT year,
  state,
  tempc,
  RANK() OVER (
    PARTITION BY state
    ORDER BY tempc DESC
  ) AS warmest_rank
  FROM state_climate
)
SELECT year,
  state,
  tempc
FROM warmest_rank
WHERE warmest_rank = 1
ORDER BY state, year;

-- Return the average annual temperatures in quartiles.
SELECT NTILE(4) OVER (
  PARTITION BY state
  ORDER BY tempc
  ) AS quartile,
  year,
  state,
  tempc
FROM state_climate
ORDER BY quartile;

-- Return the average annual temperatures in quintiles.
SELECT NTILE(5) OVER (ORDER BY tempc) AS quintile,
  year,
  state,
  tempc
FROM state_climate
ORDER BY quintile;