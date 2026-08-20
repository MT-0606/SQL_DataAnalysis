-- 1. Examine the data from the employees table.
SELECT *
FROM employees;

-- 2. Examine the data from the projects table.
SELECT *
FROM projects;
-- To merge the tables, join current_project from the employees table with project_id from the projects table.

-- 3. What are the names of employees who haven't chosen a project?
SELECT first_name, last_name
FROM employees
WHERE current_project IS NULL;

-- 4. What the names of projects that weren't chosen by any employees?
SELECT project_name
FROM projects
LEFT JOIN employees
    ON projects.project_id = employees.current_project
WHERE employees.current_project IS NULL;

-- 5. What is the most popular project (i.e. the one chosen by the most employees)?
SELECT
    projects.project_name,
    COUNT(employees.employee_id) AS employees_in_project
FROM projects
INNER JOIN employees
    ON projects.project_id = employees.current_project
GROUP BY
    projects.project_id,
    projects.project_name
ORDER BY employees_in_project DESC
LIMIT 1;

-- 6. Which projects were chosen by multiple employees?
SELECT
    projects.project_name,
    COUNT(employees.employee_id) AS employees_in_project
FROM projects
INNER JOIN employees 
  ON projects.project_id = employees.current_project
WHERE current_project IS NOT NULL
GROUP BY current_project
HAVING COUNT(current_project)>1
ORDER BY employees_in_project DESC;

-- 7. How many positions are available for developers?
SELECT (COUNT(*) * 2) - (
    SELECT COUNT(*)
    FROM employees
    WHERE current_project IS NOT NULL
        AND position = 'Developer') AS 'Count'
FROM projects;

-- 8. Create teams based on compatible personalities.
CREATE TABLE personality_incompatibilities (
    personality_a TEXT NOT NULL,
    personality_b TEXT NOT NULL,
    PRIMARY KEY (personality_a, personality_b),
    CHECK (personality_a < personality_b)
);
INSERT INTO personality_incompatibilities
    (personality_a, personality_b)
VALUES
    ('INFP', 'ISFP'),
    ('ESFP', 'INFP'),
    ('INFP', 'ISTP'),
    ('ESTP', 'INFP'),
    ('INFP', 'ISFJ'),
    ('ESFJ', 'INFP'),
    ('INFP', 'ISTJ'),
    ('ESTJ', 'INFP'),

    ('ENFP', 'ISFP'),
    ('ENFP', 'ESFP'),
    ('ENFP', 'ISTP'),
    ('ENFP', 'ESTP'),
    ('ENFP', 'ISFJ'),
    ('ENFP', 'ESFJ'),
    ('ENFP', 'ISTJ'),
    ('ENFP', 'ESTJ'),

    ('INFJ', 'ISFP'),
    ('ESFP', 'INFJ'),
    ('INFJ', 'ISTP'),
    ('ESTP', 'INFJ'),
    ('INFJ', 'ISFJ'),
    ('ESFJ', 'INFJ'),
    ('INFJ', 'ISTJ'),
    ('ESTJ', 'INFJ'),

    ('ENFJ', 'ESFP'),
    ('ENFJ', 'ISTP'),
    ('ENFJ', 'ESTP'),
    ('ENFJ', 'ISFJ'),
    ('ENFJ', 'ESFJ'),
    ('ENFJ', 'ISTJ'),
    ('ENFJ', 'ESTJ');
SELECT
    employees.employee_id,
    employees.first_name,
    employees.last_name,
    employees.personality
FROM employees
WHERE employees.current_project IS NULL
AND NOT EXISTS (
    SELECT 1
    FROM employees AS team_member
    INNER JOIN personality_incompatibilities
        ON (
            personality_incompatibilities.personality_a =
                MIN(employees.personality, team_member.personality)
            AND personality_incompatibilities.personality_b =
                MAX(employees.personality, team_member.personality)
        )
    WHERE team_member.current_project = 7
)
ORDER BY employees.last_name;

-- 9. What is the most common personality?
SELECT personality 
FROM employees
GROUP BY personality
ORDER BY COUNT(personality) DESC
LIMIT 1;

-- 10. Which projects were chosen by employees with the most common personality type?
SELECT
    projects.project_name,
    employees.personality 
FROM projects
INNER JOIN employees 
    ON projects.project_id = employees.current_project
WHERE personality = (
    SELECT personality
    FROM employees
    GROUP BY personality
    ORDER BY COUNT(personality) DESC
    LIMIT 1
);

-- 11. Find the personality type most represented by employees with a selected project.
SELECT first_name, last_name, personality, project_name
FROM employees
INNER JOIN projects 
    ON employees.current_project = projects.project_id
WHERE personality = (
    SELECT personality 
    FROM employees
    WHERE current_project IS NOT NULL
    GROUP BY personality
    ORDER BY COUNT(personality) DESC
    LIMIT 1
);

-- 12. Provide additional information about each employee (e.g. the names of chosen projects, the number of incompatible co-workers).
SELECT
    employee.first_name, employee.last_name, employee.personality,
    projects.project_name, (
        SELECT COUNT(*)
        FROM employees AS coworker
        INNER JOIN personality_incompatibilities
            ON personality_incompatibilities.personality_a =
                MIN(employee.personality, coworker.personality)
            AND personality_incompatibilities.personality_b =
                MAX(employee.personality, coworker.personality)
        WHERE coworker.current_project = employee.current_project
          AND coworker.employee_id <> employee.employee_id
    ) AS incompatible_workers
FROM employees AS employee
LEFT JOIN projects
    ON employee.current_project = projects.project_id;