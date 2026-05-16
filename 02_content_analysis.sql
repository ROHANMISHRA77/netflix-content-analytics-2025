-- ============================================
-- Netflix Analytics 2025
-- File: 02_content_analysis.sql
-- Purpose: Deep-dive content catalog analysis
-- ============================================

-- 1. Top 10 content-producing countries
SELECT 
  TRIM(country) AS country,
  COUNT(*) AS title_count
FROM netflix_titles
WHERE country IS NOT NULL AND country != 'Not Specified'
GROUP BY TRIM(country)
ORDER BY title_count DESC
LIMIT 10;

-- 2. Year-wise content addition trend (2018–2025)
SELECT 
  YEAR(date_added) AS year_added,
  COUNT(*) AS titles_added,
  SUM(CASE WHEN type = 'Movie' THEN 1 ELSE 0 END) AS movies_added,
  SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) AS shows_added
FROM netflix_titles
WHERE date_added IS NOT NULL AND YEAR(date_added) >= 2018
GROUP BY year_added
ORDER BY year_added;

-- 3. Month-wise content addition (seasonality check)
SELECT 
  MONTHNAME(date_added) AS month_name,
  MONTH(date_added) AS month_num,
  COUNT(*) AS titles_added
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY month_name, month_num
ORDER BY month_num;

-- 4. Top directors with most titles on Netflix
SELECT 
  director,
  COUNT(*) AS total_titles,
  COUNT(DISTINCT type) AS content_types
FROM netflix_titles
WHERE director IS NOT NULL AND director != 'Unknown'
GROUP BY director
ORDER BY total_titles DESC
LIMIT 15;

-- 5. Movie duration distribution (bucketed)
SELECT 
  CASE 
    WHEN CAST(REPLACE(duration, ' min', '') AS UNSIGNED) < 60  THEN 'Short (<60 min)'
    WHEN CAST(REPLACE(duration, ' min', '') AS UNSIGNED) < 100 THEN 'Standard (60-100 min)'
    WHEN CAST(REPLACE(duration, ' min', '') AS UNSIGNED) < 150 THEN 'Long (100-150 min)'
    ELSE 'Very Long (150+ min)'
  END AS duration_bucket,
  COUNT(*) AS movie_count
FROM netflix_titles
WHERE type = 'Movie' AND duration LIKE '%min%'
GROUP BY duration_bucket
ORDER BY movie_count DESC;

-- 6. TV Show seasons distribution
SELECT 
  duration AS seasons,
  COUNT(*) AS show_count
FROM netflix_titles
WHERE type = 'TV Show'
GROUP BY duration
ORDER BY show_count DESC
LIMIT 10;

-- 7. Content rating breakdown by type
SELECT 
  type,
  rating,
  COUNT(*) AS count
FROM netflix_titles
WHERE rating IS NOT NULL
GROUP BY type, rating
ORDER BY type, count DESC;

-- 8. Oldest vs newest content added per country (Top 5 countries)
SELECT 
  country,
  MIN(release_year) AS oldest_title_year,
  MAX(release_year) AS newest_title_year,
  COUNT(*) AS total_titles
FROM netflix_titles
WHERE country IN ('United States', 'India', 'United Kingdom', 'Japan', 'South Korea')
GROUP BY country;
