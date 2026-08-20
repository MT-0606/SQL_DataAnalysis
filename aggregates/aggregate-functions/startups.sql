SELECT *
FROM startups;
-- COLUMNS: 10

SELECT COUNT(*)
FROM startups;
-- TOTAL NUMBER OF COMPANIES: 70

SELECT SUM(valuation)
FROM startups;
-- Returns total values of all companies

SELECT MAX(raised)
FROM startups;
-- Returns the maximum amount fo money raised

SELECT MAX(raised)
FROM startups
WHERE stage = 'Seed';
-- Returns the maximum amount of money raised during the seed phase

SELECT MIN(founded)
FROM startups;
-- Returns the year the oldest company was founded

SELECT AVG(valuation)
FROM startups;
-- Returns average valuation

SELECT category, AVG(valuation)
FROM startups
GROUP BY category;
-- Returns average valuation in each category

SELECT category, ROUND(AVG(valuation), 2)
FROM startups
GROUP BY category;
-- Returns average valuation in each category to 2 decimal places

SELECT category, ROUND(AVG(valuation), 2)
FROM startups
GROUP BY category
ORDER BY AVG(valuation) DESC;
-- Returns average valuation in each category to 2 decimal places and from highest to lowest

SELECT category, COUNT(*)
FROM startups
GROUP by category;
-- Counts all companies that belong to a category

SELECT category, COUNT(*)
FROM startups
GROUP by category
HAVING COUNT(*) > 3;
-- Only includes categories with more than three companies
-- The most competitive are Social, Mobile, and Education

SELECT location, AVG(employees)
FROM startups
GROUP BY location;
-- Returns the average size of a startup in each location

SELECT location, AVG(employees)
FROM startups
GROUP BY location
HAVING AVG(employees) > 500;
-- Returns the average size of a startup in each location, where there are more than 500 employees