-- U.S. Healthcare Workforce Shortage Tracker
-- Author: Rahma Ras | Source: HRSA Open Data (May 2026)
-- Tool: MySQL Workbench

CREATE DATABASE hpsa_project;
USE hpsa_project;

CREATE TABLE hpsa_shortage (
    hpsa_name VARCHAR(255),
    hpsa_id VARCHAR(50),
    designation_type VARCHAR(100),
    discipline VARCHAR(50),
    hpsa_score INT,
    state_abbr VARCHAR(5),
    hpsa_status VARCHAR(50),
    metropolitan_indicator VARCHAR(50),
    degree_of_shortage VARCHAR(50),
    hpsa_fte FLOAT,
    designation_population FLOAT,
    pct_below_poverty FLOAT,
    formal_ratio VARCHAR(50),
    rural_status VARCHAR(50),
    longitude FLOAT,
    latitude FLOAT,
    estimated_served_pop FLOAT,
    estimated_underserved_pop FLOAT,
    hpsa_shortage FLOAT,
    state_name VARCHAR(100),
    county_name VARCHAR(100)
);

-- Top 10 states by shortage severity
SELECT
    state_name,
    COUNT(*) AS total_shortage_areas,
    ROUND(AVG(hpsa_score), 1) AS avg_shortage_score,
    SUM(estimated_underserved_pop) AS total_underserved
FROM hpsa_shortage
WHERE hpsa_status = 'Designated'
GROUP BY state_name
ORDER BY avg_shortage_score DESC
LIMIT 10;

-- Rural vs urban shortage comparison
SELECT
    rural_status,
    COUNT(*) AS total_areas,
    ROUND(AVG(hpsa_score), 1) AS avg_score,
    SUM(estimated_underserved_pop) AS total_underserved
FROM hpsa_shortage
WHERE hpsa_status = 'Designated'
GROUP BY rural_status
ORDER BY avg_score DESC;

-- Shortage by discipline type
SELECT
    discipline,
    COUNT(*) AS total_areas,
    ROUND(AVG(hpsa_score), 1) AS avg_score,
    SUM(estimated_underserved_pop) AS total_underserved
FROM hpsa_shortage
WHERE hpsa_status = 'Designated'
GROUP BY discipline
ORDER BY total_underserved DESC;

-- Full state export for Tableau
SELECT
    state_name,
    state_abbr,
    COUNT(*) AS total_shortage_areas,
    ROUND(AVG(hpsa_score), 1) AS avg_score,
    SUM(estimated_underserved_pop) AS total_underserved,
    SUM(hpsa_shortage) AS total_providers_needed,
    rural_status
FROM hpsa_shortage
WHERE hpsa_status = 'Designated'
AND state_name IS NOT NULL
GROUP BY state_name, state_abbr, rural_status
ORDER BY total_underserved DESC;
