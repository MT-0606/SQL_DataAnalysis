SELECT DISTINCT neighborhood
FROM nomnom;
-- DISTINCT NEIGHBOURHOODS: Brooklyn, Midtown, Chinatown, Uptown, Queens, Downtown

SELECT DISTINCT cuisine
FROM nomnom;
-- DISTINCT CUISINES: Steak, Korean, Chinese, Pizza, Ethiopian, Vegetarian, Italian, Japanese, American, Mediterranean, Indian, Soul Food, Mexican

SELECT name
FROM nomnom
WHERE cuisine = 'Chinese';
-- OPTIONS FOR CHINESE TAKEAWAY: Nom Wah Tea Parlor, Nan Xiang Xiao Long Bao, Mission Chinese Food, Baohaus, Xi'an Famous Foods, Sonnyboy's, Great NY Noodletown, Golden Unicorn, Wo Hop, Ping's Seafood, XO Kitchen

SELECT name
FROM nomnom
WHERE review > 4; -- i.e. all well-received restaurants

SELECT name
FROM nomnom
WHERE cuisine = 'Italian'
  AND price = '$$$'; -- i.e. all fancy Italian restaurants

SELECT name
FROM nomnom
WHERE name LIKE '%meatball%'; -- all restaurants containing the word 'meatball'

SELECT *
FROM nomnom
WHERE neighborhood = 'Midtown'
  OR neighborhood = 'Downtown'
  OR neighborhood = 'Chinatown'; -- for deliveries

SELECT *
FROM nomnom
WHERE health IS NULL; -- all restaurants with pending health ratings

SELECT *
FROM nomnom
ORDER BY review DESC
LIMIT 10; -- i.e. the top 10 restaurants

SELECT name,
CASE
  WHEN review > 4.5 THEN 'Extraordinary'
  WHEN review > 4 THEN 'Excellent'
  WHEN review > 3 THEN 'Good'
  WHEN review > 2 THEN 'Fair'
  ELSE 'Poor'
END AS 'Rating'
FROM nomnom; -- answers the question 'How good is this restaurant?'