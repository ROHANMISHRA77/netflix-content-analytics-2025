-- ============================================
-- Netflix Analytics 2025
-- File: 01_data_exploration.sql
-- Purpose: Initial data exploration & profiling
-- ============================================

-- 1. Preview data
SELECT * FROM netflix_titles LIMIT 10;
SELECT * FROM user_engagement LIMIT 10;

-- 2. Total records
SELECT COUNT(*) AS total_titles FROM netflix_titles;
SELECT COUNT(*) AS total_engagement_records FROM user_engagement;

-- 3. Content type split
SELECT 
  type, 
  COUNT(*) AS total,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_titles), 1) AS percentage
FROM netflix_titles
GROUP BY type;

-- 4. Null value audit
SELECT 
  SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END)       AS null_title,
  SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END)    AS null_director,
  SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END)     AS null_country,
  SUM(CASE WHEN date_added IS NULL THEN 1 ELSE 0 END)  AS null_date_added,
  SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END)      AS null_rating,
  SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END)    AS null_duration
FROM netflix_titles;

-- 5. Date range of content
SELECT 
  MIN(release_year) AS oldest_content,
  MAX(release_year) AS newest_content,
  MIN(date_added)   AS first_added_on_netflix,
  MAX(date_added)   AS latest_added_on_netflix
FROM netflix_titles;

-- 6. Unique ratings (content rating like PG, R, TV-MA)
SELECT rating, COUNT(*) AS count
FROM netflix_titles
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY count DESC;

-- 7. Engagement data overview
SELECT 
  ROUND(AVG(watch_hours), 2)      AS avg_watch_hours,
  ROUND(AVG(completion_rate), 2)  AS avg_completion_rate,
  ROUND(AVG(user_rating), 2)      AS avg_user_rating,
  MAX(watch_hours)                AS max_watch_hours,
  MIN(watch_hours)                AS min_watch_hours
FROM user_engagement;
