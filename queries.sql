-- ============================================================================
-- SQL Query Collection — Tennis Sportradar Analytics
-- Engine: PostgreSQL 14+
-- All 20 analysis queries required by the assignment.
-- ============================================================================

-- \connect tennis_db;  -- uncomment if running from psql CLI

-- ===========================================================================
-- A. COMPETITIONS ANALYSIS  (7 queries)
-- ===========================================================================

-- A1. List all competitions along with their category name
SELECT
    c.competition_id,
    c.competition_name,
    cat.category_name,
    c.type,
    c.gender
FROM competitions c
JOIN categories cat ON c.category_id = cat.category_id
ORDER BY cat.category_name, c.competition_name;

-- A2. Count the number of competitions in each category
SELECT
    cat.category_name,
    COUNT(c.competition_id) AS competition_count
FROM categories cat
LEFT JOIN competitions c ON cat.category_id = c.category_id
GROUP BY cat.category_id, cat.category_name
ORDER BY competition_count DESC;

-- A3. Find all competitions of type 'doubles'
SELECT
    competition_id,
    competition_name,
    type,
    gender
FROM competitions
WHERE type = 'doubles'
ORDER BY competition_name;

-- A4. Get competitions that belong to a specific category (e.g., ITF Men)
SELECT
    c.competition_id,
    c.competition_name,
    c.type,
    c.gender,
    cat.category_name
FROM competitions c
JOIN categories cat ON c.category_id = cat.category_id
WHERE cat.category_name = 'ITF Men'
ORDER BY c.competition_name;

-- A5. Identify parent competitions and their sub-competitions
SELECT
    parent.competition_id   AS parent_id,
    parent.competition_name AS parent_name,
    child.competition_id    AS child_id,
    child.competition_name  AS child_name
FROM competitions child
JOIN competitions parent ON child.parent_id = parent.competition_id
ORDER BY parent.competition_name, child.competition_name;

-- A6. Analyze the distribution of competition types by category
SELECT
    cat.category_name,
    c.type,
    COUNT(*) AS count
FROM competitions c
JOIN categories cat ON c.category_id = cat.category_id
GROUP BY cat.category_id, cat.category_name, c.type
ORDER BY cat.category_name, c.type;

-- A7. List all top-level competitions (no parent)
SELECT
    competition_id,
    competition_name,
    type,
    gender
FROM competitions
WHERE parent_id IS NULL
ORDER BY competition_name;

-- ===========================================================================
-- B. VENUE ANALYSIS  (7 queries)
-- ===========================================================================

-- B1. List all venues along with their associated complex name
SELECT
    v.venue_id,
    v.venue_name,
    v.city_name,
    v.country_name,
    cx.complex_name
FROM venues v
JOIN complexes cx ON v.complex_id = cx.complex_id
ORDER BY cx.complex_name, v.venue_name;

-- B2. Count the number of venues in each complex
SELECT
    cx.complex_name,
    COUNT(v.venue_id) AS venue_count
FROM complexes cx
LEFT JOIN venues v ON cx.complex_id = v.complex_id
GROUP BY cx.complex_id, cx.complex_name
ORDER BY venue_count DESC;

-- B3. Get details of venues in a specific country (e.g., Chile)
SELECT
    v.venue_id,
    v.venue_name,
    v.city_name,
    v.country_name,
    v.timezone,
    cx.complex_name
FROM venues v
JOIN complexes cx ON v.complex_id = cx.complex_id
WHERE v.country_name = 'Chile'
ORDER BY v.city_name;

-- B4. Identify all venues and their timezones
SELECT
    venue_id,
    venue_name,
    city_name,
    country_name,
    timezone
FROM venues
ORDER BY country_name, city_name;

-- B5. Find complexes that have more than one venue
SELECT
    cx.complex_name,
    COUNT(v.venue_id) AS venue_count
FROM complexes cx
JOIN venues v ON cx.complex_id = v.complex_id
GROUP BY cx.complex_id, cx.complex_name
HAVING COUNT(v.venue_id) > 1
ORDER BY venue_count DESC;

-- B6. List venues grouped by country
SELECT
    country_name,
    venue_id,
    venue_name,
    city_name
FROM venues
ORDER BY country_name, city_name;

-- B7. Find all venues for a specific complex (e.g., Nacional)
SELECT
    v.venue_id,
    v.venue_name,
    v.city_name,
    v.country_name,
    v.timezone
FROM venues v
JOIN complexes cx ON v.complex_id = cx.complex_id
WHERE cx.complex_name = 'Nacional'
ORDER BY v.venue_name;

-- ===========================================================================
-- C. COMPETITOR RANKING ANALYSIS  (6 queries)
-- ===========================================================================

-- C1. Get all competitors with their rank and points
SELECT
    comp.name,
    comp.country,
    cr.rank,
    cr.points,
    cr.movement,
    cr.competitions_played
FROM competitor_rankings cr
JOIN competitors comp ON cr.competitor_id = comp.competitor_id
ORDER BY cr.rank;

-- C2. Find competitors ranked in the top 5
SELECT
    comp.name,
    comp.country,
    comp.country_code,
    cr.rank,
    cr.points
FROM competitor_rankings cr
JOIN competitors comp ON cr.competitor_id = comp.competitor_id
WHERE cr.rank <= 5
ORDER BY cr.rank;

-- C3. List competitors with no rank movement (stable rank)
SELECT
    comp.name,
    comp.country,
    cr.rank,
    cr.points,
    cr.movement
FROM competitor_rankings cr
JOIN competitors comp ON cr.competitor_id = comp.competitor_id
WHERE cr.movement = 0
ORDER BY cr.rank;

-- C4. Get the total points of competitors from a specific country (e.g., Croatia)
SELECT
    comp.country,
    SUM(cr.points) AS total_points,
    COUNT(comp.competitor_id) AS competitor_count
FROM competitor_rankings cr
JOIN competitors comp ON cr.competitor_id = comp.competitor_id
WHERE comp.country = 'Croatia'
GROUP BY comp.country;

-- C5. Count the number of competitors per country
SELECT
    country,
    COUNT(*) AS competitor_count
FROM competitors
GROUP BY country
ORDER BY competitor_count DESC;

-- C6. Find the competitor with the highest points in the current week
SELECT
    comp.name,
    comp.country,
    cr.rank,
    cr.points,
    cr.competitions_played
FROM competitor_rankings cr
JOIN competitors comp ON cr.competitor_id = comp.competitor_id
ORDER BY cr.points DESC
LIMIT 1;
