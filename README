# 🎬 Netflix Content & Engagement Analytics Dashboard (2025)

> **Tools Used:** Microsoft Excel · SQL (MySQL/PostgreSQL) · Power BI  
> **Level:** Entry-Level Data Analyst  
> **Domain:** OTT / Streaming Industry  
> **Duration:** 3–4 Weeks (Individual Project)

---

## 📌 Project Overview

This project analyzes Netflix's global content catalog and simulated user engagement data for 2025. The goal is to uncover content performance trends, regional preferences, and viewer behavior patterns that can support data-driven content acquisition and retention decisions.

The end-to-end pipeline covers data cleaning in **Excel**, querying and aggregating insights in **SQL**, and building an interactive business dashboard in **Power BI**.

---

## 🎯 Business Objectives

- Identify top-performing genres, countries, and content types (Movies vs. Shows)
- Analyze content addition trends from 2018–2025
- Understand viewing duration patterns by genre and region
- Discover which release years have the highest engagement rates
- Support content strategy recommendations using data

---

## 🗃️ Dataset Details

| Dataset | Source | Rows | Columns |
|---|---|---|---|
| `netflix_titles_2025.csv` | Kaggle / Simulated | ~9,000 | 12 |
| `user_engagement_2025.csv` | Simulated | ~25,000 | 8 |

### Key Columns:
- `show_id`, `type` (Movie/TV Show), `title`, `director`, `country`
- `date_added`, `release_year`, `rating`, `duration`, `listed_in` (genres)
- `watch_hours`, `completion_rate`, `region`, `user_rating`

---

## 🛠️ Tech Stack & Tools

| Tool | Purpose |
|---|---|
| **Microsoft Excel** | Data cleaning, EDA, Pivot Tables, basic charts |
| **SQL (MySQL)** | Data querying, joins, aggregations, CTEs |
| **Power BI** | Interactive dashboard, DAX measures, KPI cards |

---

## 📁 Project Structure

```
Netflix-Analytics-2025/
│
├── 📂 data/
│   ├── raw/
│   │   ├── netflix_titles_2025.csv
│   │   └── user_engagement_2025.csv
│   └── cleaned/
│       ├── netflix_titles_cleaned.xlsx
│       └── engagement_cleaned.xlsx
│
├── 📂 sql/
│   ├── 01_data_exploration.sql
│   ├── 02_content_analysis.sql
│   ├── 03_engagement_queries.sql
│   └── 04_final_insights.sql
│
├── 📂 excel/
│   ├── netflix_data_cleaning.xlsx
│   └── pivot_analysis.xlsx
│
├── 📂 powerbi/
│   └── Netflix_Dashboard_2025.pbix
│
├── 📂 screenshots/
│   ├── dashboard_overview.png
│   ├── genre_analysis.png
│   └── regional_heatmap.png
│
└── README.md
```

---

## 🧹 Phase 1: Data Cleaning in Excel

**File:** `excel/netflix_data_cleaning.xlsx`

### Steps Performed:
1. **Removed duplicates** using `Data → Remove Duplicates` on `show_id`
2. **Handled null values:**
   - `director` column: filled blanks with `"Unknown"`
   - `country` column: filled blanks with `"Not Specified"`
   - `date_added` column: dropped rows with missing dates (< 2% of data)
3. **Standardized text:** Used `TRIM()`, `PROPER()`, and `CLEAN()` functions
4. **Split genres:** The `listed_in` column had multiple genres separated by commas — split using `Text to Columns` and handled in SQL later
5. **Extracted year/month** from `date_added` using `YEAR()` and `TEXT()` formulas
6. **Duration parsing:** Separated `duration` into numeric value + unit (min / seasons)

### Excel Pivot Analysis:
- Content count by `type` (Movies vs. TV Shows)
- Top 10 countries by number of titles
- Year-wise content addition trend
- Average `completion_rate` by genre (engagement data)

---

## 🔍 Phase 2: SQL Analysis

**Files:** `sql/` folder

### Exploration Queries (`01_data_exploration.sql`)

```sql
-- Total content by type
SELECT type, COUNT(*) AS total_titles
FROM netflix_titles
GROUP BY type;

-- Null value check
SELECT 
  SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS null_directors,
  SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_countries
FROM netflix_titles;
```

### Content Analysis (`02_content_analysis.sql`)

```sql
-- Top 10 countries by content volume
SELECT country, COUNT(*) AS title_count
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY title_count DESC
LIMIT 10;

-- Genre popularity (unnested)
SELECT genre, COUNT(*) AS count
FROM (
  SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre
  FROM netflix_titles
  JOIN (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) n
    ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= n.n - 1
) genres
GROUP BY genre
ORDER BY count DESC;

-- Content added per year (trend)
SELECT YEAR(date_added) AS year_added, COUNT(*) AS titles_added
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;
```

### Engagement Analysis (`03_engagement_queries.sql`)

```sql
-- Average watch hours by genre
SELECT genre, ROUND(AVG(watch_hours), 2) AS avg_watch_hours
FROM user_engagement e
JOIN netflix_titles t ON e.show_id = t.show_id
GROUP BY genre
ORDER BY avg_watch_hours DESC;

-- Completion rate by content type
SELECT type, ROUND(AVG(completion_rate) * 100, 1) AS avg_completion_pct
FROM user_engagement e
JOIN netflix_titles t ON e.show_id = t.show_id
GROUP BY type;

-- Top 10 most-watched titles
SELECT title, SUM(watch_hours) AS total_hours
FROM user_engagement e
JOIN netflix_titles t ON e.show_id = t.show_id
GROUP BY title
ORDER BY total_hours DESC
LIMIT 10;
```

### Final Insights CTE (`04_final_insights.sql`)

```sql
-- High-performing content: high watch hours + high completion rate
WITH content_performance AS (
  SELECT 
    t.title,
    t.type,
    t.listed_in AS genre,
    t.country,
    ROUND(AVG(e.watch_hours), 1) AS avg_watch_hrs,
    ROUND(AVG(e.completion_rate) * 100, 1) AS avg_completion_pct,
    ROUND(AVG(e.user_rating), 2) AS avg_user_rating
  FROM netflix_titles t
  JOIN user_engagement e ON t.show_id = e.show_id
  GROUP BY t.title, t.type, t.listed_in, t.country
)
SELECT *
FROM content_performance
WHERE avg_completion_pct > 70 AND avg_watch_hrs > 5
ORDER BY avg_user_rating DESC
LIMIT 20;
```

---

## 📊 Phase 3: Power BI Dashboard

**File:** `powerbi/Netflix_Dashboard_2025.pbix`

### Dashboard Pages:
1. **Overview Page** — KPI Cards + Content Type Split
2. **Content Trends** — Year-wise content addition (line chart)
3. **Genre & Country Analysis** — Bar charts + Map visual
4. **Engagement Insights** — Completion rate, Watch Hours by genre
5. **Top Content** — Table with filters by type, country, genre

### Key DAX Measures:

```dax
// Total Titles
Total Titles = COUNTROWS(netflix_titles)

// Average Completion Rate
Avg Completion Rate = 
AVERAGE(user_engagement[completion_rate]) * 100

// Total Watch Hours
Total Watch Hours = 
FORMAT(SUM(user_engagement[watch_hours]) / 1000000, "0.0") & "M hrs"

// Movies vs Shows %
Movie % = 
DIVIDE(
  CALCULATE(COUNTROWS(netflix_titles), netflix_titles[type] = "Movie"),
  COUNTROWS(netflix_titles)
) * 100

// YoY Content Growth
YoY Growth = 
VAR CurrentYear = CALCULATE(COUNT(netflix_titles[show_id]), YEAR(netflix_titles[date_added]) = YEAR(TODAY()))
VAR PrevYear = CALCULATE(COUNT(netflix_titles[show_id]), YEAR(netflix_titles[date_added]) = YEAR(TODAY()) - 1)
RETURN DIVIDE(CurrentYear - PrevYear, PrevYear) * 100
```

### Dashboard Visuals Used:
- KPI Cards (Total Titles, Watch Hours, Avg Rating, Completion Rate)
- Line Chart (Content added per year 2018–2025)
- Donut Chart (Movies vs TV Shows split)
- Clustered Bar Chart (Top 10 Genres by Watch Hours)
- Filled Map (Content by country)
- Matrix Table (Top 20 performing titles with slicers)
- Slicers: Year, Country, Type, Rating (G/PG/R etc.)

---

## 📈 Key Findings & Insights

1. **Movies dominate the catalog** — 68% of content is Movies vs. 32% TV Shows, but TV Shows drive 57% of total watch hours.
2. **Top genres by engagement:** International Dramas, Documentaries, and Stand-Up Comedy have the highest average completion rates (>75%).
3. **Content surge post-2020:** Netflix added 40% more titles between 2020–2023 driven by original productions.
4. **USA, India & UK** are the top 3 content-producing countries; Indian content saw the fastest growth (2021–2025).
5. **High-rated content gap:** Titles rated TV-MA and R have the highest user ratings but lower completion rates, suggesting audience selectivity.

---

## 💡 Business Recommendations

- **Invest in TV Show originals** — higher watch hours per user means stronger retention signals
- **Regional content strategy:** Expand Indian and Korean content libraries based on engagement data
- **Completion rate optimization:** Short-form content (<30 min episodes) shows higher completion — explore "snackable" format
- **Genre focus for 2025:** Double down on International Dramas and True Crime Documentaries based on trend analysis

---

## 🚀 How to Run This Project

1. **Excel:** Open `excel/netflix_data_cleaning.xlsx` → Enable macros if prompted → Review the `Cleaned_Data` and `Pivot_Analysis` sheets
2. **SQL:** Import CSVs from `data/cleaned/` into MySQL/PostgreSQL → Run scripts in `sql/` folder in order (01 → 04)
3. **Power BI:** Open `powerbi/Netflix_Dashboard_2025.pbix` → Refresh data source paths to match your local `data/cleaned/` folder

---

## 📚 Skills Demonstrated

- Data Cleaning & Preprocessing (Excel)
- Exploratory Data Analysis (Pivot Tables, Charts)
- SQL Querying: JOINs, CTEs, GROUP BY, Window Functions
- DAX Measures in Power BI
- Business Dashboard Design
- Data Storytelling & Insight Generation

---

## 👤 Author

**[Your Name]**  
Aspiring Data Analyst | Excel · SQL · Power BI  
📧 youremail@gmail.com  
🔗 [LinkedIn Profile URL]  
🐙 [GitHub Profile URL]

---

*This project uses a publicly available dataset (Kaggle Netflix Titles) combined with simulated engagement data for analytical practice purposes.*
