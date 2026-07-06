
# 🎾 Game Analytics: Unlocking Tennis Data with Sportradar API

## Project Overview

A comprehensive solution for managing, visualizing, and analyzing tennis competition data extracted from the **Sportradar Tennis API v3**. The project covers:

1. **Data Extraction** — API calls to 3 Sportradar endpoints (v3, x-api-key header auth)
2. **Database Design** — 6 relational tables with proper FK constraints (PostgreSQL)
3. **SQL Analysis** — 20 analytical queries across competitions, venues, and rankings
4. **Streamlit Dashboard** — Interactive web app with 7 pages of insights
5. **Real Data** — `data.sql` contains 13,375 INSERT statements with live API data

---

## 📁 Project Structure

```
tennis_sportradar_project/
├── 1_config_and_data_extraction.ipynb   # Notebook 1: Config & API extraction (v3)
├── 2_database_setup.ipynb               # Notebook 2: PostgreSQL schema & data insertion
├── 3_sql_analysis_queries.ipynb         # Notebook 3: All 20 SQL analysis queries
├── 4_streamlit_app.ipynb                # Notebook 4: Streamlit app code
├── schema.sql             # PostgreSQL DDL for all 6 tables
├── data.sql        # REAL API data — 13,375 INSERT statements
├── queries.sql            # All 20 analysis SQL queries (PostgreSQL)
├── app.py                 # Streamlit web application (7 pages)
└── requirements.txt       # Python dependencies

```

---

## 📊 Data Summary (from live Sportradar API v3)

| Table | Rows | Source Endpoint |
|-------|------|-----------------|
| Categories | 18 | Competitions |
| Competitions | 6,601 | Competitions |
| Complexes | 763 | Complexes |
| Venues | 3,993 | Complexes |
| Competitors | 1,000 | Doubles Rankings |
| Competitor_Rankings | 1,000 | Doubles Rankings |
| **Total** | **13,375** | |

### API Endpoints Used (v3):
- `GET /tennis/trial/v3/en/competitions.json`
- `GET /tennis/trial/v3/en/complexes.json`
- `GET /tennis/trial/v3/en/double_competitors_rankings.json`

Authentication: `x-api-key` header with your 40-character API key.

---

## 🔧 Setup Instructions

### 1. Prerequisites

- Python 3.9+
- PostgreSQL 14+
- Sportradar API key with Tennis API trial added

### 2. Get Your Sportradar API Key

1. Sign up at [https://marketplace.sportradar.com/signup](https://marketplace.sportradar.com/signup)
2. Go to Marketplace → search "Tennis API" → click **Add Trial**
3. Copy your API key from your application page
4. Set it as an environment variable:
   ```bash
   export SPORTRADAR_API_KEY="your_api_key_here"
   ```

### 3. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 4. Database Setup (PostgreSQL)

```bash
# Create the database
createdb -U postgres tennis_db

# Create tables
psql -U postgres -d tennis_db -f schema.sql
```

Configure your DB credentials via environment variables:
```bash
export DB_USER="postgres"
export DB_PASSWORD="your_password"
export DB_HOST="localhost"
export DB_PORT="5432"
export DB_NAME="tennis_db"
```

### 5. Load Data — Two Options

**Option A — Use pre-fetched real data (easiest):**
```bash
psql -U postgres -d tennis_db -f data.sql
```
This loads 13,375 rows of real Sportradar API data (competitions, complexes, venues, doubles rankings).

**Option B — Fetch fresh data from API:**

Using Jupyter Notebooks:
1. Open `1_config_and_data_extraction.ipynb` → Run all cells
2. Open `2_database_setup.ipynb` → Run all cells

Using Python scripts:
```bash
python db_operations.py
```

### 6. Run SQL Analysis Queries

```bash
psql -U postgres -d tennis_db -f queries.sql
```

Or run individual queries from `queries.sql` in pgAdmin, DBeaver, or psql.

### 7. Launch the Streamlit App

```bash
streamlit run app.py
```

The app opens at `http://localhost:8501`.

---

## 🗄️ Database Schema

### Tables & Relationships

```
Categories (1) ──→ (N) Competitions
Complexes  (1) ──→ (N) Venues
Competitors (1) ──→ (N) Competitor_Rankings
```

| Table                   | Primary Key     | Foreign Keys                          |
|-------------------------|-----------------|---------------------------------------|
| Categories              | category_id     | —                                     |
| Competitions            | competition_id  | category_id → Categories              |
|                         |                 | parent_id → Competitions (self-ref)   |
| Complexes               | complex_id      | —                                     |
| Venues                  | venue_id        | complex_id → Complexes                |
| Competitors             | competitor_id   | —                                     |
| Competitor_Rankings     | rank_id (SERIAL)| competitor_id → Competitors           |

---

## 📊 SQL Queries Summary

### Competitions Analysis (7 queries)
1. List all competitions with category names
2. Count competitions per category
3. Find all doubles competitions
4. Get competitions in a specific category (e.g., ITF Men)
5. Identify parent & sub-competitions
6. Distribution of competition types by category
7. List top-level competitions (no parent)

### Venue Analysis (7 queries)
1. List all venues with complex names
2. Count venues per complex
3. Venues in a specific country (e.g., Chile)
4. All venues and their timezones
5. Complexes with more than one venue
6. Venues grouped by country
7. Venues for a specific complex (e.g., Nacional)

### Competitor Ranking Analysis (6 queries)
1. All competitors with rank and points
2. Top 5 ranked competitors
3. Competitors with no rank movement
4. Total points from a specific country (e.g., Croatia)
5. Competitor count per country
6. Competitor with highest points

---

## 🖥️ Streamlit App Features

| Page                        | Features                                              |
|-----------------------------|-------------------------------------------------------|
| Homepage Dashboard          | Key metrics, competition type chart, country chart    |
| Competitions Analysis       | 7 query views with interactive filters & charts       |
| Venues Analysis             | 7 query views with country/complex selectors          |
| Competitor Search & Filter  | Name search, rank range slider, country & points filter|
| Competitor Details Viewer   | Detailed stats for a selected competitor              |
| Country-Wise Analysis       | Competitor count & average points per country         |
| Leaderboards                | Top 10 by rank, top 10 by points, scatter plot        |

---

## 🔒 Error Handling

- **API rate limits**: Exponential back-off with retry on HTTP 429
- **Connection errors**: Retry with timeout handling
- **Database constraints**: Foreign key validation, duplicate prevention
- **Missing data**: Nullable fields (parent_id, country_code) handled gracefully
- **User input**: Streamlit widgets validate ranges and selections

---

## 🛠️ Technologies Used

| Category       | Technology                    |
|----------------|-------------------------------|
| Language       | Python 3.9+                   |
| API            | Sportradar Tennis API v3      |
| Database       | PostgreSQL 14+                |
| ORM            | SQLAlchemy                    |
| Visualization  | Streamlit + Plotly            |
| Data Processing| Pandas                        |

---

## 📝 Notes

- The Sportradar free developer trial has rate limits (~1 request/second). The extraction script includes `time.sleep()` between calls.
- All SQL is written for **PostgreSQL** (uses `SERIAL` for auto-increment, `CASCADE` for drops, `LIMIT 1` for top-1 queries).
- API authentication uses `x-api-key` header (NOT query parameter) per Sportradar v3 docs.
- The `data.sql` file contains **real data** fetched from the Sportradar API on 2026-07-05.
- All API keys and passwords are read from environment variables — never hard-coded.

---

## 📸 Screenshots

### Homepage Dashboard
![Homepage Dashboard](https://github.com/Sarvesh-Nirmale/Game_Analytics_Unlocking_Tennis_Data_with_SportRadar_API---SQL---Python/blob/master/Screenshots/Homepage%20Dashboard.png?raw=true)

### Dashboard Light Theme
![Dashboard Light Theme](https://github.com/Sarvesh-Nirmale/Game_Analytics_Unlocking_Tennis_Data_with_SportRadar_API---SQL---Python/blob/master/Screenshots/Dashboard%20Light%20Theme.png?raw=true)

### Competitions Analysis
![Competitions Analysis](https://github.com/Sarvesh-Nirmale/Game_Analytics_Unlocking_Tennis_Data_with_SportRadar_API---SQL---Python/blob/master/Screenshots/Competitions%20Analysis.png?raw=true)

### Venues Analysis
![Venues Analysis](https://github.com/Sarvesh-Nirmale/Game_Analytics_Unlocking_Tennis_Data_with_SportRadar_API---SQL---Python/blob/master/Screenshots/Venues%20Analysis.png?raw=true)

### Competitor Search & Filter
![Competitor Search & Filter](https://github.com/Sarvesh-Nirmale/Game_Analytics_Unlocking_Tennis_Data_with_SportRadar_API---SQL---Python/blob/master/Screenshots/Competitor%20Search%20&%20Filter.png?raw=true)

### Competitor Search & Filter With Points
![Competitor Search & Filter With Points](https://github.com/Sarvesh-Nirmale/Game_Analytics_Unlocking_Tennis_Data_with_SportRadar_API---SQL---Python/blob/master/Screenshots/Competitor%20Search%20&%20Filter%20With%20Points.png?raw=true)

### Competitor Details
![Competitor Details](https://github.com/Sarvesh-Nirmale/Game_Analytics_Unlocking_Tennis_Data_with_SportRadar_API---SQL---Python/blob/master/Screenshots/Competitor%20Details.png?raw=true)

### Country-Wise Analysis
![Country-Wise Analysis](https://github.com/Sarvesh-Nirmale/Game_Analytics_Unlocking_Tennis_Data_with_SportRadar_API---SQL---Python/blob/master/Screenshots/Country-Wise%20Analysis.png?raw=true)

### Leaderboards
![Leaderboards](https://github.com/Sarvesh-Nirmale/Game_Analytics_Unlocking_Tennis_Data_with_SportRadar_API---SQL---Python/blob/master/Screenshots/LeaderBoards.png?raw=true)

## 📄 License

This project is created for educational purposes as part of the Game Analytics assignment.
