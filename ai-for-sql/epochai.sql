.tables

-- These queries find the influential players.
SELECT
    o.org_name AS organization_name,
    COUNT(s.system) AS number_of_ai_systems_developed
FROM orgs o
JOIN systems s
    ON o.org_id = s.org_id
GROUP BY o.org_name
ORDER BY number_of_ai_systems_developed DESC;
SELECT
    o.org_name AS organization_name,
    COUNT(s.system) AS number_of_ai_systems_developed,
    o.org_type
FROM orgs o
JOIN systems s  
    ON o.org_id = s.org_id
JOIN problems p
    ON s.problem_id = p.problem_id
WHERE p.task = 'Image generation'
GROUP BY o.org_name, o.org_type
ORDER BY number_of_ai_systems_developed DESC;

-- This query analyses development over time.
SELECT
    strftime('%Y', s.publication_date) AS publication_year,
    COUNT(s.system) AS number_of_ai_systems,
    MAX(s.parameters) AS largest_parameter
FROM systems s
GROUP BY publication_year
ORDER BY publication_year;

-- This query finds the top five AI problems organisations focus on.
SELECT
    p.task AS ai_problems,
    COUNT(DISTINCT s.org_id) AS number_of_organizations
FROM problems p
JOIN systems s
    ON p.problem_id = s.problem_id
GROUP BY ai_problems
ORDER BY number_of_organizations DESC
LIMIT 5;
