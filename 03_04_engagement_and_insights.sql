-- ============================================
-- Netflix Analytics 2025
-- File: 03_engagement_queries.sql
-- Purpose: User engagement & viewing behavior
-- ============================================

-- 1. Total & average watch hours by content type
SELECT 
  t.type,
  COUNT(DISTINCT e.show_id)          AS titles_watched,
  ROUND(SUM(e.watch_hours), 0)       AS total_watch_hours,
  ROUND(AVG(e.watch_hours), 2)       AS avg_watch_hours,
  ROUND(AVG(e.completion_rate)*100, 1) AS avg_completion_pct
FROM user_engagement e
JOIN netflix_titles t ON e.show_id = t.show_id
GROUP BY t.type;

-- 2. Top 10 most-watched titles overall
SELECT 
  t.title,
  t.type,
  t.country,
  ROUND(SUM(e.watch_hours), 0)  AS total_watch_hours,
  ROUND(AVG(e.user_rating), 2) AS avg_rating
FROM user_engagement e
JOIN netflix_titles t ON e.show_id = t.show_id
GROUP BY t.title, t.type, t.country
ORDER BY total_watch_hours DESC
LIMIT 10;

-- 3. Average completion rate by country (Top 10)
SELECT 
  t.country,
  COUNT(DISTINCT t.show_id)            AS titles_count,
  ROUND(AVG(e.completion_rate)*100, 1) AS avg_completion_pct,
  ROUND(AVG(e.user_rating), 2)         AS avg_user_rating
FROM user_engagement e
JOIN netflix_titles t ON e.show_id = t.show_id
WHERE t.country IS NOT NULL AND t.country != 'Not Specified'
GROUP BY t.country
ORDER BY avg_completion_pct DESC
LIMIT 10;

-- 4. Engagement by release year (are older or newer titles more watched?)
SELECT 
  t.release_year,
  COUNT(DISTINCT t.show_id) AS titles,
  ROUND(AVG(e.watch_hours), 2) AS avg_watch_hours,
  ROUND(AVG(e.completion_rate)*100, 1) AS avg_completion_pct
FROM user_engagement e
JOIN netflix_titles t ON e.show_id = t.show_id
WHERE t.release_year >= 2015
GROUP BY t.release_year
ORDER BY t.release_year DESC;

-- 5. Regional viewership patterns
SELECT 
  e.region,
  t.type,
  COUNT(*) AS records,
  ROUND(SUM(e.watch_hours), 0) AS total_hours,
  ROUND(AVG(e.completion_rate)*100, 1) AS avg_completion_pct
FROM user_engagement e
JOIN netflix_titles t ON e.show_id = t.show_id
GROUP BY e.region, t.type
ORDER BY e.region, total_hours DESC;


-- ============================================
-- File: 04_final_insights.sql
-- Purpose: CTE-based final analysis for dashboard
-- ============================================

-- 1. High-performing content (CTE)
WITH content_performance AS (
  SELECT 
    t.show_id,
    t.title,
    t.type,
    t.listed_in AS genres,
    t.country,
    t.release_year,
    t.rating,
    ROUND(AVG(e.watch_hours), 1)         AS avg_watch_hours,
    ROUND(AVG(e.completion_rate)*100, 1) AS avg_completion_pct,
    ROUND(AVG(e.user_rating), 2)         AS avg_user_rating,
    COUNT(e.show_id)                     AS total_views
  FROM netflix_titles t
  JOIN user_engagement e ON t.show_id = e.show_id
  GROUP BY t.show_id, t.title, t.type, t.listed_in, t.country, t.release_year, t.rating
),
ranked_content AS (
  SELECT *,
    RANK() OVER (PARTITION BY type ORDER BY avg_user_rating DESC, avg_completion_pct DESC) AS rank_by_type
  FROM content_performance
  WHERE avg_completion_pct > 65 AND avg_watch_hours > 3
)
SELECT *
FROM ranked_content
WHERE rank_by_type <= 10
ORDER BY type, rank_by_type;


-- 2. Content gap analysis (genres with low supply but high demand)
WITH genre_supply AS (
  SELECT listed_in AS genre, COUNT(*) AS total_titles
  FROM netflix_titles
  GROUP BY listed_in
),
genre_demand AS (
  SELECT t.listed_in AS genre, ROUND(AVG(e.watch_hours), 2) AS avg_demand
  FROM user_engagement e
  JOIN netflix_titles t ON e.show_id = t.show_id
  GROUP BY t.listed_in
)
SELECT 
  s.genre,
  s.total_titles AS supply,
  d.avg_demand AS demand_score,
  ROUND(d.avg_demand / s.total_titles, 2) AS demand_supply_ratio
FROM genre_supply s
JOIN genre_demand d ON s.genre = d.genre
ORDER BY demand_supply_ratio DESC
LIMIT 10;


-- 3. Monthly content release vs engagement correlation
SELECT 
  MONTH(t.date_added) AS month_num,
  MONTHNAME(t.date_added) AS month_name,
  COUNT(DISTINCT t.show_id) AS titles_added,
  ROUND(AVG(e.watch_hours), 2) AS avg_watch_hours
FROM netflix_titles t
JOIN user_engagement e ON t.show_id = e.show_id
WHERE t.date_added IS NOT NULL
GROUP BY month_num, month_name
ORDER BY month_num;
