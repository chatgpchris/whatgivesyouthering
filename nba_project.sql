/*
WHAT GIVES YOU THE RING ?

This basic data analysis project by Christos Georgakakis 
is based on freely available data 
uploaded by NocturneBear on https://github.com/NocturneBear/NBA-Data-2010-2024 
*/

-- STEP 1: Creating the database
DROP DATABASE IF EXISTS nba_2010_2024;
CREATE DATABASE IF NOT EXISTS nba_2010_2024;
USE nba_2010_2024;

-- STEP 2: Downloading the data from https://github.com/NocturneBear/NBA-Data-2010-2024 and save it in a pc folder

-- STEP 3: Uploading the data files in MySQL using the Table Data Import Wizard

-- STEP 4: Exploring, cleaning and organizing the data

# make some initial check on the 6 tables
SELECT * 
FROM playoff_totals
ORDER BY SEASON_YEAR, TEAM_ID, GAME_DATE;

SELECT *
FROM play_off_box_scores
ORDER BY season_year, teamID, game_date;

SELECT *
FROM regular_season_totals
ORDER BY SEASON_YEAR, TEAM_ID, GAME_ID;

SELECT *
FROM regular_season_box_scores_1
ORDER BY season_year, game_date, teamID;

SELECT *
FROM regular_season_box_scores_2
ORDER BY season_year, game_date, teamID;

SELECT *
FROM regular_season_box_scores_3
ORDER BY season_year, game_date, teamID;

/*
I observed that the seasons 2010-11 and 2011-12 are missing from the regular_season_totals. 
Let's check whether they are indeed missing (rather than saved, instead, say, in a different data type).
Let's also check whether other tables miss some seasons as well, and whether the regular_season_totals table misses other seasons as well.
*/

SELECT DISTINCT SEASON_YEAR
FROM regular_season_totals
ORDER BY SEASON_YEAR; # yeap indeed 2010-11 and 2011-12 are missing

SELECT DISTINCT SEASON_YEAR
FROM playoff_totals
ORDER BY SEASON_YEAR; # every season is there

SELECT DISTINCT season_year
FROM play_off_box_scores
ORDER BY season_year; #every season is there

SELECT DISTINCT season_year
FROM regular_season_box_scores_1
ORDER BY season_year; #everything season is there

SELECT DISTINCT season_year
FROM regular_season_box_scores_2
ORDER BY season_year; # every season is there

SELECT DISTINCT season_year
FROM regular_season_box_scores_3
ORDER BY season_year; #every season is there

/* 
Since 2010-11 and 2011-12 are missing from one table, 
I will put aside the data of those seasons from each table
and I will start preparing the data 
*/

SELECT * 
FROM playoff_totals
WHERE SEASON_YEAR NOT IN ("2010-11", "2011-12")
ORDER BY SEASON_YEAR, TEAM_ID, GAME_DATE;

SELECT *
FROM play_off_box_scores
WHERE season_year NOT IN ("2010-11", "2011-12")
ORDER BY season_year, teamID, game_date;

SELECT *
FROM regular_season_totals
ORDER BY SEASON_YEAR, TEAM_ID, GAME_ID; # Seasons 2010-11 and 2011-12 are already missing here

SELECT *
FROM regular_season_box_scores_1
WHERE season_year NOT IN ("2010-11", "2011-12")
ORDER BY season_year, game_date, teamID;

SELECT *
FROM regular_season_box_scores_2
WHERE season_year NOT IN ("2010-11", "2011-12")
ORDER BY season_year, game_date, teamID;

SELECT *
FROM regular_season_box_scores_3
WHERE season_year NOT IN ("2010-11", "2011-12")
ORDER BY season_year, game_date, teamID;


/* 
Let's now make some check to see whether there are any duplicates and remove them.
I will count the number of rows of each table, and then use the distinct function to remove duplicates.
*/

# 2032 rows in the initial table (without DISTINCT)
SELECT DISTINCT * 
FROM playoff_totals
WHERE SEASON_YEAR NOT IN ("2010-11", "2011-12")
ORDER BY SEASON_YEAR, TEAM_ID, GAME_DATE; #2032 rows confirmed

# 27058 rows in the initial table (without DISTINCT)
SELECT DISTINCT *
FROM play_off_box_scores
WHERE season_year NOT IN ("2010-11", "2011-12")
ORDER BY season_year, teamID, game_date; #26755 with DISTINCT
SELECT(27058-26755); #303 rows difference. Let's check with the excel file, by using the remove duplicates option. Indeed 303 rows were removed from excel as well.


# 28862 rows in the initial table (without DISTINCT)
SELECT DISTINCT *
FROM regular_season_totals
ORDER BY SEASON_YEAR, TEAM_ID, GAME_ID; #28862 confirmed

# 122798 rows in the initial table (without DISTINCT)
SELECT DISTINCT *
FROM regular_season_box_scores_1
WHERE season_year NOT IN ("2010-11", "2011-12")
ORDER BY season_year, game_date, teamID; #122798 confirmed

# 123309 rows in the initial table (without DISTINCT)
SELECT DISTINCT *
FROM regular_season_box_scores_2
WHERE season_year NOT IN ("2010-11", "2011-12")
ORDER BY season_year, game_date, teamID; #123309 confirmed

# 123441 rows in the initial table (without DISTINCT)
SELECT DISTINCT *
FROM regular_season_box_scores_3
WHERE season_year NOT IN ("2010-11", "2011-12")
ORDER BY season_year, game_date, teamID; # 123441 confirmed


/* 
Let's now make some radical changes to our tables. Before doing so, make sure the raw data are copied and saved.
First, let's delete the seasons 2010-11 and 2011-12 from the 5(out of the 6) tables
*/

DELETE  
FROM playoff_totals
WHERE SEASON_YEAR = "2010-11" OR SEASON_YEAR = "2011-12";

DELETE
FROM play_off_box_scores
WHERE season_year = "2010-11" OR season_year = "2011-12";
 
DELETE
FROM regular_season_box_scores_1
WHERE season_year = "2010-11" OR season_year = "2011-12";

DELETE
FROM regular_season_box_scores_2
WHERE season_year = "2010-11" OR season_year = "2011-12";

DELETE
FROM regular_season_box_scores_3
WHERE season_year = "2010-11" OR season_year = "2011-12";

/* 
Let's now apply union to the regular season box scores, in order to make 1 table with all stats, instead of 3 distinct tables.
*/

SELECT DISTINCT *
FROM regular_season_box_scores_1
UNION
SELECT DISTINCT *
FROM regular_season_box_scores_2
UNION
SELECT DISTINCT *
FROM regular_season_box_scores_3;

/* 
Let's now recreate our tables in meaningful way, removing the duplicates, and with the 3 regular season box scores united.
First we create the structure, and then we insert the data each time. After we create the new tables, we remove the old ones.
*/

CREATE TABLE regular_season_box_scores LIKE regular_season_box_scores_1;

INSERT INTO regular_season_box_scores
SELECT DISTINCT *
FROM regular_season_box_scores_1
UNION
SELECT DISTINCT *
FROM regular_season_box_scores_2
UNION
SELECT DISTINCT *
FROM regular_season_box_scores_3;

CREATE TABLE playoff_boxscores LIKE play_off_box_scores;
INSERT INTO playoff_boxscores
SELECT DISTINCT *
FROM play_off_box_scores;

CREATE TABLE playofftotals LIKE playoff_totals;
INSERT INTO playofftotals
SELECT DISTINCT *
FROM playoff_totals;

CREATE TABLE regseason_totals LIKE regular_season_totals;
INSERT INTO regseason_totals
SELECT DISTINCT *
FROM regular_season_totals;

DROP TABLE regular_season_box_scores_1;
DROP TABLE regular_season_box_scores_2;
DROP TABLE regular_season_box_scores_3;
DROP TABLE play_off_box_scores;
DROP TABLE playoff_totals;
DROP TABLE regular_season_totals;


-- STEP 5: Data analysis

/*
Now, let's find the champions from 2013 onwards. The champions list will
be useful for what we want to explore: Which team characteristics give the championship ?
*/

#NBA CHAMPIONS FROM 2012-2013 to 2023-2024
WITH sfd AS 
(
SELECT SEASON_YEAR AS season, MAX(GAME_DATE) AS final_game
FROM playofftotals
GROUP BY SEASON_YEAR
)
SELECT pl.SEASON_YEAR, pl.TEAM_ID, pl.TEAM_NAME, sfd.final_game
FROM playofftotals pl 
JOIN sfd ON pl.GAME_DATE = sfd.final_game
WHERE pl.WL = "W"
ORDER BY pl.SEASON_YEAR
; # let's export this in csv and then import it as a new table: champions_13_24


#let's reexplore a bit our newly formed data
SELECT *
FROM playoff_boxscores
ORDER BY season_year, teamId, gameId, personId;
SELECT *
FROM playofftotals
ORDER BY SEASON_YEAR, TEAM_ID, GAME_ID;
SELECT *
FROM regular_season_box_scores
ORDER BY season_year, teamId, gameId;
SELECT *
FROM regseason_totals
ORDER BY SEASON_YEAR, TEAM_ID, GAME_ID;
SELECT *
FROM champions_13_24;


#playoff_stats for all teams from 2012-13 to 2023-24
WITH team_stats AS (
  SELECT
    SEASON_YEAR,
    TEAM_ID,
    TEAM_NAME,
    COUNT(*) AS GAMES_PLAYED,
    ROUND(AVG(PTS), 2) AS AVG_PTS,
    ROUND(AVG(AST), 2) AS AVG_AST,
    ROUND(AVG(OREB), 2) AS AVG_OREB,
    ROUND(AVG(DREB), 2) AS AVG_DREB,
    ROUND(AVG(STL), 2) AS AVG_STL,
    ROUND(AVG(BLK), 2) AS AVG_BLK,
    ROUND(AVG(FG3M), 2) AS AVG_3PM,
    ROUND(AVG(FG3A), 2) AS AVG_3PA,
    ROUND(AVG(FG3_PCT), 3) AS AVG_3PCT,
    ROUND(AVG(FGM - FG3M), 2) AS AVG_2PM,
    ROUND(AVG(FGA - FG3A), 2) AS AVG_2PA,
    ROUND(AVG((FGM - FG3M) * 1.0 / NULLIF(FGA - FG3A, 0)), 3) AS AVG_2PCT,
    ROUND(AVG(FTM), 2) AS AVG_FTM,
    ROUND(AVG(FTA), 2) AS AVG_FTA,
    ROUND(AVG(FT_PCT), 3) AS AVG_FT_PCT,
    ROUND(AVG(TOV), 2) AS AVG_TOV
  FROM playofftotals
  GROUP BY SEASON_YEAR, TEAM_ID, TEAM_NAME
),
ranked AS (
  SELECT *,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_PTS DESC) AS PTS_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_AST DESC) AS AST_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_3PM DESC) AS THREES_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_3PCT DESC) AS THREES_PCT_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_2PM DESC) AS TWOS_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_2PCT DESC) AS TWOS_PCT_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_OREB DESC) AS OREB_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_DREB DESC) AS DREB_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_OREB + AVG_DREB DESC) AS REB_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_STL DESC) AS STL_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_BLK DESC) AS BLK_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_TOV ASC) AS TOV_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_FT_PCT DESC) AS FT_PCT_RANK
  FROM team_stats
),
final_output AS (
  SELECT 
    r.SEASON_YEAR,
    r.TEAM_ID,
    r.TEAM_NAME,
    CASE 
      WHEN c.TEAM_ID IS NOT NULL THEN 'Champion'
      ELSE '—'
    END AS CHAMPION_TAG,
    
    -- Average Stats
    r.GAMES_PLAYED,
    r.AVG_PTS,
    r.AVG_AST,
    r.AVG_3PM,
    r.AVG_3PCT,
    r.AVG_2PM,
    r.AVG_2PCT,
    r.AVG_OREB,
    r.AVG_DREB,
    (r.AVG_OREB + r.AVG_DREB) AS AVG_REB,
    r.AVG_STL,
    r.AVG_BLK,
    r.AVG_TOV,
    r.AVG_FT_PCT,

    -- Grouped Rankings
    r.PTS_RANK,
    r.AST_RANK,
    r.THREES_RANK,
    r.THREES_PCT_RANK,
    r.TWOS_RANK,
    r.TWOS_PCT_RANK,
    r.OREB_RANK,
    r.DREB_RANK,
    r.REB_RANK,
    r.STL_RANK,
    r.BLK_RANK,
    r.TOV_RANK,
    r.FT_PCT_RANK

  FROM ranked r
  LEFT JOIN champions_13_24 c
    ON r.SEASON_YEAR = c.SEASON_YEAR AND r.TEAM_ID = c.TEAM_ID
)
SELECT *
FROM final_output
ORDER BY SEASON_YEAR, PTS_RANK; #export it and reimport it with data wizard as: playoff_stats

# Playoff stats only for champions from 2012-13 to 2023-24
WITH team_stats AS (
  SELECT
    SEASON_YEAR,
    TEAM_ID,
    TEAM_NAME,
    COUNT(*) AS GAMES_PLAYED,
    ROUND(AVG(PTS), 2) AS AVG_PTS,
    ROUND(AVG(AST), 2) AS AVG_AST,
    ROUND(AVG(OREB), 2) AS AVG_OREB,
    ROUND(AVG(DREB), 2) AS AVG_DREB,
    ROUND(AVG(STL), 2) AS AVG_STL,
    ROUND(AVG(BLK), 2) AS AVG_BLK,
    ROUND(AVG(FG3M), 2) AS AVG_3PM,
    ROUND(AVG(FG3A), 2) AS AVG_3PA,
    ROUND(AVG(FG3_PCT), 3) AS AVG_3PCT,
    ROUND(AVG(FGM - FG3M), 2) AS AVG_2PM,
    ROUND(AVG(FGA - FG3A), 2) AS AVG_2PA,
    ROUND(AVG((FGM - FG3M) * 1.0 / NULLIF(FGA - FG3A, 0)), 3) AS AVG_2PCT,
    ROUND(AVG(FTM), 2) AS AVG_FTM,
    ROUND(AVG(FTA), 2) AS AVG_FTA,
    ROUND(AVG(FT_PCT), 3) AS AVG_FT_PCT,
    ROUND(AVG(TOV), 2) AS AVG_TOV
  FROM playofftotals
  GROUP BY SEASON_YEAR, TEAM_ID, TEAM_NAME
),
ranked AS (
  SELECT *,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_PTS DESC) AS PTS_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_AST DESC) AS AST_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_3PM DESC) AS THREES_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_3PCT DESC) AS THREES_PCT_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_2PM DESC) AS TWOS_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_2PCT DESC) AS TWOS_PCT_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_OREB DESC) AS OREB_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_DREB DESC) AS DREB_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_OREB + AVG_DREB DESC) AS REB_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_STL DESC) AS STL_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_BLK DESC) AS BLK_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_TOV ASC) AS TOV_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_FT_PCT DESC) AS FT_PCT_RANK
  FROM team_stats
),
final_output AS (
  SELECT 
    r.SEASON_YEAR,
    r.TEAM_ID,
    r.TEAM_NAME,
    CASE 
      WHEN c.TEAM_ID IS NOT NULL THEN 'Champion'
      ELSE '—'
    END AS CHAMPION_TAG,
    
    -- Average Stats
    r.GAMES_PLAYED,
    r.AVG_PTS,
    r.AVG_AST,
    r.AVG_3PM,
    r.AVG_3PCT,
    r.AVG_2PM,
    r.AVG_2PCT,
    r.AVG_OREB,
    r.AVG_DREB,
    (r.AVG_OREB + r.AVG_DREB) AS AVG_REB,
    r.AVG_STL,
    r.AVG_BLK,
    r.AVG_TOV,
    r.AVG_FT_PCT,

    -- Grouped Rankings
    r.PTS_RANK,
    r.AST_RANK,
    r.THREES_RANK,
    r.THREES_PCT_RANK,
    r.TWOS_RANK,
    r.TWOS_PCT_RANK,
    r.OREB_RANK,
    r.DREB_RANK,
    r.REB_RANK,
    r.STL_RANK,
    r.BLK_RANK,
    r.TOV_RANK,
    r.FT_PCT_RANK

  FROM ranked r
  LEFT JOIN champions_13_24 c
    ON r.SEASON_YEAR = c.SEASON_YEAR AND r.TEAM_ID = c.TEAM_ID
)
SELECT *
FROM final_output
WHERE CHAMPION_TAG = 'Champion'
ORDER BY SEASON_YEAR; #export it and reimport it with data wizard as: champions_stats

#Playoff stats for champions from 2012-13 to 2023-24 (with average stats in the last row)
SELECT * 
FROM champions_stats
UNION
SELECT 'AVG' AS SEASON_YEAR,
  NULL AS TEAM_ID,
  'Average Champion Team' AS TEAM_NAME,
  'Average Champion' AS CHAMPION_TAG,
  ROUND(AVG(GAMES_PLAYED), 2) AS AVG_GAMES,
  ROUND(AVG(AVG_PTS), 2),
  ROUND(AVG(AVG_AST), 2),
  ROUND(AVG(AVG_3PM), 2),
  ROUND(AVG(AVG_3PCT), 3),
  ROUND(AVG(AVG_2PM), 2),
  ROUND(AVG(AVG_2PCT), 3),
  ROUND(AVG(AVG_OREB), 2),
  ROUND(AVG(AVG_DREB), 2),
  ROUND(AVG(AVG_OREB + AVG_DREB), 2) AS AVG_REB,
  ROUND(AVG(AVG_STL), 2),
  ROUND(AVG(AVG_BLK), 2),
  ROUND(AVG(AVG_TOV), 2),
  ROUND(AVG(AVG_FT_PCT), 3),
  ROUND(AVG(PTS_RANK), 2),
  ROUND(AVG(AST_RANK), 2),
  ROUND(AVG(THREES_RANK), 2),
  ROUND(AVG(THREES_PCT_RANK), 2),
  ROUND(AVG(TWOS_RANK), 2),
  ROUND(AVG(TWOS_PCT_RANK), 2),
  ROUND(AVG(OREB_RANK), 2),
  ROUND(AVG(DREB_RANK), 2),
  ROUND(AVG(REB_RANK), 2),
  ROUND(AVG(STL_RANK), 2),
  ROUND(AVG(BLK_RANK), 2),
  ROUND(AVG(TOV_RANK), 2),
  ROUND(AVG(FT_PCT_RANK), 2)
FROM champions_stats
ORDER BY SEASON_YEAR; # export champions_stats_avg. Reimport with table Wizard

#explore a bit
SELECT *
FROM champions_stats_avg;


# How many times between 2013-2024 each champion's stat was in the top 3 stats in the playoff ranks
SELECT
    'PTS_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE PTS_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'AST_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE AST_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'THREES_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE THREES_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'THREES_PCT_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE THREES_PCT_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TWOS_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE TWOS_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TWOS_PCT_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE TWOS_PCT_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'OREB_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE OREB_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'DREB_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE DREB_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'REB_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE REB_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'STL_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE STL_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'BLK_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE BLK_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TOV_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE TOV_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'FT_PCT_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg
WHERE FT_PCT_RANK <= 3 AND SEASON_YEAR != 'AVG'
ORDER BY top_3_count DESC;



# How many times between 2013-2024 each champion's stat was in the top 2 stats in the playoff ranks
SELECT
    'PTS_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE PTS_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'AST_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE AST_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'THREES_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE THREES_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'THREES_PCT_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE THREES_PCT_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TWOS_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE TWOS_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TWOS_PCT_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE TWOS_PCT_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'OREB_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE OREB_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'DREB_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE DREB_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'REB_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE REB_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'STL_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE STL_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'BLK_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE BLK_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TOV_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE TOV_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'FT_PCT_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE FT_PCT_RANK <= 2 AND SEASON_YEAR != 'AVG'
ORDER BY top_2_count DESC;

# how many times between 2013-2024 each champion's stat was THE TOP (the 1st) stat in the playoff ranks
SELECT
    'PTS_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg
WHERE PTS_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'AST_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg
WHERE AST_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'THREES_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg
WHERE THREES_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'THREES_PCT_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg
WHERE THREES_PCT_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TWOS_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg
WHERE TWOS_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TWOS_PCT_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg
WHERE TWOS_PCT_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'OREB_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg
WHERE OREB_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'DREB_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg
WHERE DREB_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'REB_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg
WHERE REB_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'STL_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg
WHERE STL_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'BLK_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg
WHERE BLK_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TOV_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg
WHERE TOV_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'FT_PCT_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg
WHERE FT_PCT_RANK <= 1 AND SEASON_YEAR != 'AVG'
ORDER BY top_1_count DESC;



#Attack (points rank, assists rank, threes rank, twos rank)  Vs Defense (rebounds rank, steals rank, blocks rank) comparison (CHAMPIONS, PLAYOFFS only from 2013 to 2024)
SELECT
    SEASON_YEAR,
    TEAM_NAME,
    -- Calculate the average rank for offensive stats
    ROUND(((PTS_RANK + AST_RANK + THREES_RANK + TWOS_RANK + THREES_PCT_RANK + TWOS_PCT_RANK + OREB_RANK + FT_PCT_RANK) / 8), 2) AS Avg_Attack_Rank,
    -- Calculate the average rank for defensive stats
    ROUND(((DREB_RANK + STL_RANK + BLK_RANK) / 3), 2) AS Avg_Defense_Rank
FROM champions_stats_avg
ORDER BY SEASON_YEAR; #export it as csv and reimport it via data wizard as: attack_vs_defence




# some exploration to check whether the number of games is accurate (normal variations especially in 2019-2020 are expected)
SELECT SEASON_YEAR, TEAM_ID, TEAM_NAME, COUNT(*)
FROM regseason_totals
GROUP BY SEASON_YEAR, TEAM_ID, TEAM_NAME
ORDER BY SEASON_YEAR, TEAM_ID, TEAM_NAME
;

SELECT *
FROM regseason_totals
ORDER BY SEASON_YEAR, TEAM_ID, TEAM_NAME
;


-- let's now work on regular season stats
WITH team_reg_stats AS (
  SELECT
    SEASON_YEAR,
    TEAM_ID,
    TEAM_NAME,
    COUNT(*) AS GAMES_PLAYED,
    ROUND(AVG(PTS), 2) AS AVG_PTS,
    ROUND(AVG(AST), 2) AS AVG_AST,
    ROUND(AVG(OREB), 2) AS AVG_OREB,
    ROUND(AVG(DREB), 2) AS AVG_DREB,
    ROUND(AVG(STL), 2) AS AVG_STL,
    ROUND(AVG(BLK), 2) AS AVG_BLK,
    ROUND(AVG(FG3M), 2) AS AVG_3PM,
    ROUND(AVG(FG3A), 2) AS AVG_3PA,
    ROUND(AVG(FG3_PCT), 3) AS AVG_3PCT,
    ROUND(AVG(FGM - FG3M), 2) AS AVG_2PM,
    ROUND(AVG(FGA - FG3A), 2) AS AVG_2PA,
    ROUND(AVG((FGM - FG3M) * 1.0 / NULLIF(FGA - FG3A, 0)), 3) AS AVG_2PCT,
    ROUND(AVG(FTM), 2) AS AVG_FTM,
    ROUND(AVG(FTA), 2) AS AVG_FTA,
    ROUND(AVG(FT_PCT), 3) AS AVG_FT_PCT,
    ROUND(AVG(TOV), 2) AS AVG_TOV
  FROM regseason_totals
  GROUP BY SEASON_YEAR, TEAM_ID, TEAM_NAME
),
reg_ranked AS (
  SELECT *,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_PTS DESC) AS PTS_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_AST DESC) AS AST_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_3PM DESC) AS THREES_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_3PCT DESC) AS THREES_PCT_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_2PM DESC) AS TWOS_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_2PCT DESC) AS TWOS_PCT_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_OREB DESC) AS OREB_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_DREB DESC) AS DREB_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_OREB + AVG_DREB DESC) AS REB_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_STL DESC) AS STL_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_BLK DESC) AS BLK_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_TOV ASC) AS TOV_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_FT_PCT DESC) AS FT_PCT_RANK
  FROM team_reg_stats
),
final_output_reg AS (
  SELECT 
    rr.SEASON_YEAR,
    rr.TEAM_ID,
    rr.TEAM_NAME,
    CASE 
      WHEN c.TEAM_ID IS NOT NULL THEN 'Champion'
      ELSE '—'
    END AS CHAMPION_TAG,
    
    -- Average Stats
    rr.GAMES_PLAYED,
    rr.AVG_PTS,
    rr.AVG_AST,
    rr.AVG_3PM,
    rr.AVG_3PCT,
    rr.AVG_2PM,
    rr.AVG_2PCT,
    rr.AVG_OREB,
    rr.AVG_DREB,
    (rr.AVG_OREB + rr.AVG_DREB) AS AVG_REB,
    rr.AVG_STL,
    rr.AVG_BLK,
    rr.AVG_TOV,
    rr.AVG_FT_PCT,

    -- Grouped Rankings
    rr.PTS_RANK,
    rr.AST_RANK,
    rr.THREES_RANK,
    rr.THREES_PCT_RANK,
    rr.TWOS_RANK,
    rr.TWOS_PCT_RANK,
    rr.OREB_RANK,
    rr.DREB_RANK,
    rr.REB_RANK,
    rr.STL_RANK,
    rr.BLK_RANK,
    rr.TOV_RANK,
    rr.FT_PCT_RANK

  FROM reg_ranked rr
  LEFT JOIN champions_13_24 c
    ON rr.SEASON_YEAR = c.SEASON_YEAR AND rr.TEAM_ID = c.TEAM_ID
)
SELECT *
FROM final_output_reg
ORDER BY SEASON_YEAR, PTS_RANK; # Export as csv and reimport via data wizard as: regularseason_stats



#let's focus on the regular season stats for champions only
WITH team_reg_stats AS (
  SELECT
    SEASON_YEAR,
    TEAM_ID,
    TEAM_NAME,
    COUNT(*) AS GAMES_PLAYED,
    ROUND(AVG(PTS), 2) AS AVG_PTS,
    ROUND(AVG(AST), 2) AS AVG_AST,
    ROUND(AVG(OREB), 2) AS AVG_OREB,
    ROUND(AVG(DREB), 2) AS AVG_DREB,
    ROUND(AVG(STL), 2) AS AVG_STL,
    ROUND(AVG(BLK), 2) AS AVG_BLK,
    ROUND(AVG(FG3M), 2) AS AVG_3PM,
    ROUND(AVG(FG3A), 2) AS AVG_3PA,
    ROUND(AVG(FG3_PCT), 3) AS AVG_3PCT,
    ROUND(AVG(FGM - FG3M), 2) AS AVG_2PM,
    ROUND(AVG(FGA - FG3A), 2) AS AVG_2PA,
    ROUND(AVG((FGM - FG3M) * 1.0 / NULLIF(FGA - FG3A, 0)), 3) AS AVG_2PCT,
    ROUND(AVG(FTM), 2) AS AVG_FTM,
    ROUND(AVG(FTA), 2) AS AVG_FTA,
    ROUND(AVG(FT_PCT), 3) AS AVG_FT_PCT,
    ROUND(AVG(TOV), 2) AS AVG_TOV
  FROM regseason_totals
  GROUP BY SEASON_YEAR, TEAM_ID, TEAM_NAME
),
reg_ranked AS (
  SELECT *,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_PTS DESC) AS PTS_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_AST DESC) AS AST_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_3PM DESC) AS THREES_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_3PCT DESC) AS THREES_PCT_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_2PM DESC) AS TWOS_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_2PCT DESC) AS TWOS_PCT_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_OREB DESC) AS OREB_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_DREB DESC) AS DREB_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_OREB + AVG_DREB DESC) AS REB_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_STL DESC) AS STL_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_BLK DESC) AS BLK_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_TOV ASC) AS TOV_RANK,
         RANK() OVER (PARTITION BY SEASON_YEAR ORDER BY AVG_FT_PCT DESC) AS FT_PCT_RANK
  FROM team_reg_stats
),
final_output_reg AS (
  SELECT 
    rr.SEASON_YEAR,
    rr.TEAM_ID,
    rr.TEAM_NAME,
    CASE 
      WHEN c.TEAM_ID IS NOT NULL THEN 'Champion'
      ELSE '—'
    END AS CHAMPION_TAG,
    
    -- Average Stats
    rr.GAMES_PLAYED,
    rr.AVG_PTS,
    rr.AVG_AST,
    rr.AVG_3PM,
    rr.AVG_3PCT,
    rr.AVG_2PM,
    rr.AVG_2PCT,
    rr.AVG_OREB,
    rr.AVG_DREB,
    (rr.AVG_OREB + rr.AVG_DREB) AS AVG_REB,
    rr.AVG_STL,
    rr.AVG_BLK,
    rr.AVG_TOV,
    rr.AVG_FT_PCT,

    -- Grouped Rankings
    rr.PTS_RANK,
    rr.AST_RANK,
    rr.THREES_RANK,
    rr.THREES_PCT_RANK,
    rr.TWOS_RANK,
    rr.TWOS_PCT_RANK,
    rr.OREB_RANK,
    rr.DREB_RANK,
    rr.REB_RANK,
    rr.STL_RANK,
    rr.BLK_RANK,
    rr.TOV_RANK,
    rr.FT_PCT_RANK

  FROM reg_ranked rr
  LEFT JOIN champions_13_24 c
    ON rr.SEASON_YEAR = c.SEASON_YEAR AND rr.TEAM_ID = c.TEAM_ID
)
SELECT *
FROM final_output_reg
WHERE CHAMPION_TAG = 'Champion'
ORDER BY SEASON_YEAR, PTS_RANK; # Champions regular season stats . Export it and import it with data wizard as: champions_stats_reg


#Champions' (from 2013 to 2024) stats in regular seasons with an average row at the end 
SELECT * 
FROM champions_stats_reg
UNION
SELECT 'AVG' AS SEASON_YEAR,
  NULL AS TEAM_ID,
  'Average Champion Team' AS TEAM_NAME,
  'Average Champion' AS CHAMPION_TAG,
  ROUND(AVG(GAMES_PLAYED), 2) AS AVG_GAMES,
  ROUND(AVG(AVG_PTS), 2),
  ROUND(AVG(AVG_AST), 2),
  ROUND(AVG(AVG_3PM), 2),
  ROUND(AVG(AVG_3PCT), 3),
  ROUND(AVG(AVG_2PM), 2),
  ROUND(AVG(AVG_2PCT), 3),
  ROUND(AVG(AVG_OREB), 2),
  ROUND(AVG(AVG_DREB), 2),
  ROUND(AVG(AVG_OREB + AVG_DREB), 2) AS AVG_REB,
  ROUND(AVG(AVG_STL), 2),
  ROUND(AVG(AVG_BLK), 2),
  ROUND(AVG(AVG_TOV), 2),
  ROUND(AVG(AVG_FT_PCT), 3),
  ROUND(AVG(PTS_RANK), 2),
  ROUND(AVG(AST_RANK), 2),
  ROUND(AVG(THREES_RANK), 2),
  ROUND(AVG(THREES_PCT_RANK), 2),
  ROUND(AVG(TWOS_RANK), 2),
  ROUND(AVG(TWOS_PCT_RANK), 2),
  ROUND(AVG(OREB_RANK), 2),
  ROUND(AVG(DREB_RANK), 2),
  ROUND(AVG(REB_RANK), 2),
  ROUND(AVG(STL_RANK), 2),
  ROUND(AVG(BLK_RANK), 2),
  ROUND(AVG(TOV_RANK), 2),
  ROUND(AVG(FT_PCT_RANK), 2)
FROM champions_stats_reg
ORDER BY SEASON_YEAR; # export csv and reimport with data wizard as: champions_stats_avg_reg

SELECT *
FROM champions_stats_avg_reg;


#Now let's build regular season Top1_reg, Top2_reg, Top3_reg and attack_vs_defense_reg for champions between 2013-2024

# How many times between 2013-2024 each champion's stat was in the top 3 stats in the regular season ranks
SELECT
    'PTS_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg
WHERE PTS_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'AST_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg
WHERE AST_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'THREES_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg
WHERE THREES_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'THREES_PCT_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg
WHERE THREES_PCT_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TWOS_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg
WHERE TWOS_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TWOS_PCT_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg
WHERE TWOS_PCT_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'OREB_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg
WHERE OREB_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'DREB_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg
WHERE DREB_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'REB_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg
WHERE REB_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'STL_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg 
WHERE STL_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'BLK_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg
WHERE BLK_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TOV_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg
WHERE TOV_RANK <= 3 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'FT_PCT_RANK' AS stat_type,
    COUNT(*) AS top_3_count
FROM champions_stats_avg_reg
WHERE FT_PCT_RANK <= 3 AND SEASON_YEAR != 'AVG'
ORDER BY top_3_count DESC;



# How many times between 2013-2024 each champion's stat was in the top 2 stats in the regular season ranks
SELECT
    'PTS_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE PTS_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'AST_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE AST_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'THREES_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE THREES_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'THREES_PCT_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE THREES_PCT_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TWOS_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE TWOS_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TWOS_PCT_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE TWOS_PCT_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'OREB_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE OREB_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'DREB_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE DREB_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'REB_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE REB_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'STL_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE STL_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'BLK_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE BLK_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TOV_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE TOV_RANK <= 2 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'FT_PCT_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE FT_PCT_RANK <= 2 AND SEASON_YEAR != 'AVG'
ORDER BY top_2_count DESC;



# How many times between 2013-2024 each champion's stat was THE TOP (the 1st) stat in the regular season ranks
SELECT
    'PTS_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg_reg
WHERE PTS_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'AST_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg_reg
WHERE AST_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'THREES_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg_reg
WHERE THREES_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'THREES_PCT_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg_reg
WHERE THREES_PCT_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TWOS_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg_reg
WHERE TWOS_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TWOS_PCT_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg_reg
WHERE TWOS_PCT_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'OREB_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg_reg
WHERE OREB_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'DREB_RANK' AS stat_type,
    COUNT(*) AS top_2_count
FROM champions_stats_avg_reg
WHERE DREB_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'REB_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg_reg
WHERE REB_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'STL_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg_reg
WHERE STL_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'BLK_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg_reg
WHERE BLK_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'TOV_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg_reg
WHERE TOV_RANK <= 1 AND SEASON_YEAR != 'AVG'
UNION ALL
SELECT
    'FT_PCT_RANK' AS stat_type,
    COUNT(*) AS top_1_count
FROM champions_stats_avg_reg
WHERE FT_PCT_RANK <= 1 AND SEASON_YEAR != 'AVG'
ORDER BY top_1_count DESC;



#Champions' attack Vs defense comparison (regular season)
SELECT
    SEASON_YEAR,
    TEAM_NAME,
    -- Calculate the average rank for offensive stats
    ROUND(((PTS_RANK + AST_RANK + THREES_RANK + TWOS_RANK + THREES_PCT_RANK + TWOS_PCT_RANK + OREB_RANK + FT_PCT_RANK) / 8), 2) AS Avg_Attack_Rank,
    -- Calculate the average rank for defensive stats
    ROUND(((DREB_RANK + STL_RANK + BLK_RANK) / 3), 2) AS Avg_Defense_Rank
FROM champions_stats_avg_reg
ORDER BY SEASON_YEAR; # export csv and reimport it with data wizard as: attack_vs_defense_reg

# a bit of reflection
SELECT * 
FROM champions_stats_avg;
SELECT *
FROM champions_stats_avg_reg; 


# Difference of average champions' stats between regular season and playoffs (2012-13 to 2023-24) 
    
SELECT
  'AVG REG of all seasons of champions' AS comparison_metric,
  ROUND(T1.avg_reg_pts, 2) AS PTS, ROUND(T1.avg_reg_ast, 2) AS AST, ROUND(T1.avg_reg_reb, 2) AS REB, ROUND(T1.avg_reg_stl, 2) AS STL, ROUND(T1.avg_reg_blk, 2) AS BLK, ROUND(T1.avg_reg_tov, 2) AS TOV,
  ROUND(T1.avg_reg_threes, 2) AS THREES, ROUND(T1.avg_reg_threes_pct, 2) AS THREES_PCT, ROUND(T1.avg_reg_twos, 2) AS TWOS, ROUND(T1.avg_reg_twos_pct, 2) AS TWOS_PCT, ROUND(T1.avg_reg_oreb, 2) AS OREB, ROUND(T1.avg_reg_dreb, 2) AS DREB, ROUND(T1.avg_reg_ft_pct, 2) AS FT_PCT,
  ROUND(T1.avg_reg_pts_rank, 2) AS PTS_RANK, ROUND(T1.avg_reg_ast_rank, 2) AS AST_RANK, ROUND(T1.avg_reg_reb_rank, 2) AS REB_RANK, ROUND(T1.avg_reg_stl_rank, 2) AS STL_RANK, ROUND(T1.avg_reg_blk_rank, 2) AS BLK_RANK, ROUND(T1.avg_reg_tov_rank, 2) AS TOV_RANK,
  ROUND(T1.avg_reg_threes_rank, 2) AS THREES_RANK, ROUND(T1.avg_reg_threes_pct_rank, 2) AS THREES_PCT_RANK, ROUND(T1.avg_reg_twos_rank, 2) AS TWOS_RANK, ROUND(T1.avg_reg_twos_pct_rank, 2) AS TWOS_PCT_RANK, ROUND(T1.avg_reg_oreb_rank, 2) AS OREB_RANK, ROUND(T1.avg_reg_dreb_rank, 2) AS DREB_RANK, ROUND(T1.avg_reg_ft_pct_rank, 2) AS FT_PCT_RANK
FROM (
  SELECT
    AVG(T1.AVG_PTS) AS avg_reg_pts, AVG(T1.AVG_AST) AS avg_reg_ast, AVG(T1.AVG_REB) AS avg_reg_reb, AVG(T1.AVG_STL) AS avg_reg_stl, AVG(T1.AVG_BLK) AS avg_reg_blk, AVG(T1.AVG_TOV) AS avg_reg_tov,
    AVG(T1.AVG_3PM) AS avg_reg_threes, AVG(T1.AVG_3PCT) AS avg_reg_threes_pct, AVG(T1.AVG_2PM) AS avg_reg_twos, AVG(T1.AVG_2PCT) AS avg_reg_twos_pct, AVG(T1.AVG_OREB) AS avg_reg_oreb, AVG(T1.AVG_DREB) AS avg_reg_dreb, AVG(T1.AVG_FT_PCT) AS avg_reg_ft_pct,
    AVG(T1.PTS_RANK) AS avg_reg_pts_rank, AVG(T1.AST_RANK) AS avg_reg_ast_rank, AVG(T1.REB_RANK) AS avg_reg_reb_rank, AVG(T1.STL_RANK) AS avg_reg_stl_rank, AVG(T1.BLK_RANK) AS avg_reg_blk_rank, AVG(T1.TOV_RANK) AS avg_reg_tov_rank,
    AVG(T1.THREES_RANK) AS avg_reg_threes_rank, AVG(T1.THREES_PCT_RANK) AS avg_reg_threes_pct_rank, AVG(T1.TWOS_RANK) AS avg_reg_twos_rank, AVG(T1.TWOS_PCT_RANK) AS avg_reg_twos_pct_rank, AVG(T1.OREB_RANK) AS avg_reg_oreb_rank, AVG(T1.DREB_RANK) AS avg_reg_dreb_rank, AVG(T1.FT_PCT_RANK) AS avg_reg_ft_pct_rank
  FROM champions_stats_avg_reg AS T1
) AS T1
UNION ALL
SELECT
  'AVG PLAYOFF of all seasons of champions' AS comparison_metric,
  ROUND(T2.avg_playoff_pts, 2) AS PTS, ROUND(T2.avg_playoff_ast, 2) AS AST, ROUND(T2.avg_playoff_reb, 2) AS REB, ROUND(T2.avg_playoff_stl, 2) AS STL, ROUND(T2.avg_playoff_blk, 2) AS BLK, ROUND(T2.avg_playoff_tov, 2) AS TOV,
  ROUND(T2.avg_playoff_threes, 2) AS THREES, ROUND(T2.avg_playoff_threes_pct, 2) AS THREES_PCT, ROUND(T2.avg_playoff_twos, 2) AS TWOS, ROUND(T2.avg_playoff_twos_pct, 2) AS TWOS_PCT, ROUND(T2.avg_playoff_oreb, 2) AS OREB, ROUND(T2.avg_playoff_dreb, 2) AS DREB, ROUND(T2.avg_playoff_ft_pct, 2) AS FT_PCT,
  ROUND(T2.avg_playoff_pts_rank, 2) AS PTS_RANK, ROUND(T2.avg_playoff_ast_rank, 2) AS AST_RANK, ROUND(T2.avg_playoff_reb_rank, 2) AS REB_RANK, ROUND(T2.avg_playoff_stl_rank, 2) AS STL_RANK, ROUND(T2.avg_playoff_blk_rank, 2) AS BLK_RANK, ROUND(T2.avg_playoff_tov_rank, 2) AS TOV_RANK,
  ROUND(T2.avg_playoff_threes_rank, 2) AS THREES_RANK, ROUND(T2.avg_playoff_threes_pct_rank, 2) AS THREES_PCT_RANK, ROUND(T2.avg_playoff_twos_rank, 2) AS TWOS_RANK, ROUND(T2.avg_playoff_twos_pct_rank, 2) AS TWOS_PCT_RANK, ROUND(T2.avg_playoff_oreb_rank, 2) AS OREB_RANK, ROUND(T2.avg_playoff_dreb_rank, 2) AS DREB_RANK, ROUND(T2.avg_playoff_ft_pct_rank, 2) AS FT_PCT_RANK
FROM (
  SELECT
    AVG(T2.AVG_PTS) AS avg_playoff_pts, AVG(T2.AVG_AST) AS avg_playoff_ast, AVG(T2.AVG_REB) AS avg_playoff_reb, AVG(T2.AVG_STL) AS avg_playoff_stl, AVG(T2.AVG_BLK) AS avg_playoff_blk, AVG(T2.AVG_TOV) AS avg_playoff_tov,
    AVG(T2.AVG_3PM) AS avg_playoff_threes, AVG(T2.AVG_3PCT) AS avg_playoff_threes_pct, AVG(T2.AVG_2PM) AS avg_playoff_twos, AVG(T2.AVG_2PCT) AS avg_playoff_twos_pct, AVG(T2.AVG_OREB) AS avg_playoff_oreb, AVG(T2.AVG_DREB) AS avg_playoff_dreb, AVG(T2.AVG_FT_PCT) AS avg_playoff_ft_pct,
    AVG(T2.PTS_RANK) AS avg_playoff_pts_rank, AVG(T2.AST_RANK) AS avg_playoff_ast_rank, AVG(T2.REB_RANK) AS avg_playoff_reb_rank, AVG(T2.STL_RANK) AS avg_playoff_stl_rank, AVG(T2.BLK_RANK) AS avg_playoff_blk_rank, AVG(T2.TOV_RANK) AS avg_playoff_tov_rank,
    AVG(T2.THREES_RANK) AS avg_playoff_threes_rank, AVG(T2.THREES_PCT_RANK) AS avg_playoff_threes_pct_rank, AVG(T2.TWOS_RANK) AS avg_playoff_twos_rank, AVG(T2.TWOS_PCT_RANK) AS avg_playoff_twos_pct_rank, AVG(T2.OREB_RANK) AS avg_playoff_oreb_rank, AVG(T2.DREB_RANK) AS avg_playoff_dreb_rank, AVG(T2.FT_PCT_RANK) AS avg_playoff_ft_pct_rank
  FROM champions_stats_avg AS T2
) AS T2
UNION ALL
SELECT
  'AVG DIFF of all seasons of champions' AS comparison_metric,
  ROUND(T2.avg_playoff_pts - T1.avg_reg_pts, 2) AS PTS, ROUND(T2.avg_playoff_ast - T1.avg_reg_ast, 2) AS AST, ROUND(T2.avg_playoff_reb - T1.avg_reg_reb, 2) AS REB, ROUND(T2.avg_playoff_stl - T1.avg_reg_stl, 2) AS STL, ROUND(T2.avg_playoff_blk - T1.avg_reg_blk, 2) AS BLK, ROUND(T2.avg_playoff_tov - T1.avg_reg_tov, 2) AS TOV,
  ROUND(T2.avg_playoff_threes - T1.avg_reg_threes, 2) AS THREES, ROUND(T2.avg_playoff_threes_pct - T1.avg_reg_threes_pct, 2) AS THREES_PCT, ROUND(T2.avg_playoff_twos - T1.avg_reg_twos, 2) AS TWOS, ROUND(T2.avg_playoff_twos_pct - T1.avg_reg_twos_pct, 2) AS TWOS_PCT, ROUND(T2.avg_playoff_oreb - T1.avg_reg_oreb, 2) AS OREB, ROUND(T2.avg_playoff_dreb - T1.avg_reg_dreb, 2) AS DREB, ROUND(T2.avg_playoff_ft_pct - T1.avg_reg_ft_pct, 2) AS FT_PCT,
  ROUND(T2.avg_playoff_pts_rank - T1.avg_reg_pts_rank, 2) AS PTS_RANK, ROUND(T2.avg_playoff_ast_rank - T1.avg_reg_ast_rank, 2) AS AST_RANK, ROUND(T2.avg_playoff_reb_rank - T1.avg_reg_reb_rank, 2) AS REB_RANK, ROUND(T2.avg_playoff_stl_rank - T1.avg_reg_stl_rank, 2) AS STL_RANK, ROUND(T2.avg_playoff_blk_rank - T1.avg_reg_blk_rank, 2) AS BLK_RANK, ROUND(T2.avg_playoff_tov_rank - T1.avg_reg_tov_rank, 2) AS TOV_RANK,
  ROUND(T2.avg_playoff_threes_rank - T1.avg_reg_threes_rank, 2) AS THREES_RANK, ROUND(T2.avg_playoff_threes_pct_rank - T1.avg_reg_threes_pct_rank, 2) AS THREES_PCT_RANK, ROUND(T2.avg_playoff_twos_rank - T1.avg_reg_twos_rank, 2) AS TWOS_RANK, ROUND(T2.avg_playoff_twos_pct_rank - T1.avg_reg_twos_pct_rank, 2) AS TWOS_PCT_RANK, ROUND(T2.avg_playoff_oreb_rank - T1.avg_reg_oreb_rank, 2) AS OREB_RANK, ROUND(T2.avg_playoff_dreb_rank - T1.avg_reg_dreb_rank, 2) AS DREB_RANK, ROUND(T2.avg_playoff_ft_pct_rank - T1.avg_reg_ft_pct_rank, 2) AS FT_PCT_RANK
FROM (
  SELECT
    AVG(T1.AVG_PTS) AS avg_reg_pts, AVG(T1.AVG_AST) AS avg_reg_ast, AVG(T1.AVG_REB) AS avg_reg_reb, AVG(T1.AVG_STL) AS avg_reg_stl, AVG(T1.AVG_BLK) AS avg_reg_blk, AVG(T1.AVG_TOV) AS avg_reg_tov,
    AVG(T1.AVG_3PM) AS avg_reg_threes, AVG(T1.AVG_3PCT) AS avg_reg_threes_pct, AVG(T1.AVG_2PM) AS avg_reg_twos, AVG(T1.AVG_2PCT) AS avg_reg_twos_pct, AVG(T1.AVG_OREB) AS avg_reg_oreb, AVG(T1.AVG_DREB) AS avg_reg_dreb, AVG(T1.AVG_FT_PCT) AS avg_reg_ft_pct,
    AVG(T1.PTS_RANK) AS avg_reg_pts_rank, AVG(T1.AST_RANK) AS avg_reg_ast_rank, AVG(T1.REB_RANK) AS avg_reg_reb_rank, AVG(T1.STL_RANK) AS avg_reg_stl_rank, AVG(T1.BLK_RANK) AS avg_reg_blk_rank, AVG(T1.TOV_RANK) AS avg_reg_tov_rank,
    AVG(T1.THREES_RANK) AS avg_reg_threes_rank, AVG(T1.THREES_PCT_RANK) AS avg_reg_threes_pct_rank, AVG(T1.TWOS_RANK) AS avg_reg_twos_rank, AVG(T1.TWOS_PCT_RANK) AS avg_reg_twos_pct_rank, AVG(T1.OREB_RANK) AS avg_reg_oreb_rank, AVG(T1.DREB_RANK) AS avg_reg_dreb_rank, AVG(T1.FT_PCT_RANK) AS avg_reg_ft_pct_rank
  FROM champions_stats_avg_reg AS T1
) AS T1,
(
  SELECT
    AVG(T2.AVG_PTS) AS avg_playoff_pts, AVG(T2.AVG_AST) AS avg_playoff_ast, AVG(T2.AVG_REB) AS avg_playoff_reb, AVG(T2.AVG_STL) AS avg_playoff_stl, AVG(T2.AVG_BLK) AS avg_playoff_blk, AVG(T2.AVG_TOV) AS avg_playoff_tov,
    AVG(T2.AVG_3PM) AS avg_playoff_threes, AVG(T2.AVG_3PCT) AS avg_playoff_threes_pct, AVG(T2.AVG_2PM) AS avg_playoff_twos, AVG(T2.AVG_2PCT) AS avg_playoff_twos_pct, AVG(T2.AVG_OREB) AS avg_playoff_oreb, AVG(T2.AVG_DREB) AS avg_playoff_dreb, AVG(T2.AVG_FT_PCT) AS avg_playoff_ft_pct,
    AVG(T2.PTS_RANK) AS avg_playoff_pts_rank, AVG(T2.AST_RANK) AS avg_playoff_ast_rank, AVG(T2.REB_RANK) AS avg_playoff_reb_rank, AVG(T2.STL_RANK) AS avg_playoff_stl_rank, AVG(T2.BLK_RANK) AS avg_playoff_blk_rank, AVG(T2.TOV_RANK) AS avg_playoff_tov_rank,
    AVG(T2.THREES_RANK) AS avg_playoff_threes_rank, AVG(T2.THREES_PCT_RANK) AS avg_playoff_threes_pct_rank, AVG(T2.TWOS_RANK) AS avg_playoff_twos_rank, AVG(T2.TWOS_PCT_RANK) AS avg_playoff_twos_pct_rank, AVG(T2.OREB_RANK) AS avg_playoff_oreb_rank, AVG(T2.DREB_RANK) AS avg_playoff_dreb_rank, AVG(T2.FT_PCT_RANK) AS avg_playoff_ft_pct_rank
  FROM champions_stats_avg AS T2
) AS T2
UNION ALL
SELECT
  'AVG REG percentile' AS comparison_metric,
  NULL AS PTS, NULL AS AST, NULL AS REB, NULL AS STL, NULL AS BLK, NULL AS TOV, NULL AS THREES, NULL AS THREES_PCT, NULL AS TWOS, NULL AS TWOS_PCT, NULL AS OREB, NULL AS DREB, NULL AS FT_PCT,
  CONCAT(ROUND(T1.avg_reg_pts_rank, 2), '/30 (', ROUND(T1.avg_reg_pts_rank / 30.0, 2), ')') AS PTS_RANK, CONCAT(ROUND(T1.avg_reg_ast_rank, 2), '/30 (', ROUND(T1.avg_reg_ast_rank / 30.0, 2), ')') AS AST_RANK, CONCAT(ROUND(T1.avg_reg_reb_rank, 2), '/30 (', ROUND(T1.avg_reg_reb_rank / 30.0, 2), ')') AS REB_RANK, CONCAT(ROUND(T1.avg_reg_stl_rank, 2), '/30 (', ROUND(T1.avg_reg_stl_rank / 30.0, 2), ')') AS STL_RANK, CONCAT(ROUND(T1.avg_reg_blk_rank, 2), '/30 (', ROUND(T1.avg_reg_blk_rank / 30.0, 2), ')') AS BLK_RANK, CONCAT(ROUND(T1.avg_reg_tov_rank, 2), '/30 (', ROUND(T1.avg_reg_tov_rank / 30.0, 2), ')') AS TOV_RANK,
  CONCAT(ROUND(T1.avg_reg_threes_rank, 2), '/30 (', ROUND(T1.avg_reg_threes_rank / 30.0, 2), ')') AS THREES_RANK, CONCAT(ROUND(T1.avg_reg_threes_pct_rank, 2), '/30 (', ROUND(T1.avg_reg_threes_pct_rank / 30.0, 2), ')') AS THREES_PCT_RANK, CONCAT(ROUND(T1.avg_reg_twos_rank, 2), '/30 (', ROUND(T1.avg_reg_twos_rank / 30.0, 2), ')') AS TWOS_RANK, CONCAT(ROUND(T1.avg_reg_twos_pct_rank, 2), '/30 (', ROUND(T1.avg_reg_twos_pct_rank / 30.0, 2), ')') AS TWOS_PCT_RANK, CONCAT(ROUND(T1.avg_reg_oreb_rank, 2), '/30 (', ROUND(T1.avg_reg_oreb_rank / 30.0, 2), ')') AS OREB_RANK, CONCAT(ROUND(T1.avg_reg_dreb_rank, 2), '/30 (', ROUND(T1.avg_reg_dreb_rank / 30.0, 2), ')') AS DREB_RANK, CONCAT(ROUND(T1.avg_reg_ft_pct_rank, 2), '/30 (', ROUND(T1.avg_reg_ft_pct_rank / 30.0, 2), ')') AS FT_PCT_RANK
FROM (
  SELECT
    AVG(T1.PTS_RANK) AS avg_reg_pts_rank, AVG(T1.AST_RANK) AS avg_reg_ast_rank, AVG(T1.REB_RANK) AS avg_reg_reb_rank, AVG(T1.STL_RANK) AS avg_reg_stl_rank, AVG(T1.BLK_RANK) AS avg_reg_blk_rank, AVG(T1.TOV_RANK) AS avg_reg_tov_rank,
    AVG(T1.THREES_RANK) AS avg_reg_threes_rank, AVG(T1.THREES_PCT_RANK) AS avg_reg_threes_pct_rank, AVG(T1.TWOS_RANK) AS avg_reg_twos_rank, AVG(T1.TWOS_PCT_RANK) AS avg_reg_twos_pct_rank, AVG(T1.OREB_RANK) AS avg_reg_oreb_rank, AVG(T1.DREB_RANK) AS avg_reg_dreb_rank, AVG(T1.FT_PCT_RANK) AS avg_reg_ft_pct_rank
  FROM champions_stats_avg_reg AS T1
) AS T1
UNION ALL
SELECT
  'AVG PLAYOFF percentile' AS comparison_metric,
  NULL AS PTS, NULL AS AST, NULL AS REB, NULL AS STL, NULL AS BLK, NULL AS TOV, NULL AS THREES, NULL AS THREES_PCT, NULL AS TWOS, NULL AS TWOS_PCT, NULL AS OREB, NULL AS DREB, NULL AS FT_PCT,
  CONCAT(ROUND(T2.avg_playoff_pts_rank, 2), '/16 (', ROUND(T2.avg_playoff_pts_rank / 16.0, 2), ')') AS PTS_RANK, CONCAT(ROUND(T2.avg_playoff_ast_rank, 2), '/16 (', ROUND(T2.avg_playoff_ast_rank / 16.0, 2), ')') AS AST_RANK, CONCAT(ROUND(T2.avg_playoff_reb_rank, 2), '/16 (', ROUND(T2.avg_playoff_reb_rank / 16.0, 2), ')') AS REB_RANK, CONCAT(ROUND(T2.avg_playoff_stl_rank, 2), '/16 (', ROUND(T2.avg_playoff_stl_rank / 16.0, 2), ')') AS STL_RANK, CONCAT(ROUND(T2.avg_playoff_blk_rank, 2), '/16 (', ROUND(T2.avg_playoff_blk_rank / 16.0, 2), ')') AS BLK_RANK, CONCAT(ROUND(T2.avg_playoff_tov_rank, 2), '/16 (', ROUND(T2.avg_playoff_tov_rank / 16.0, 2), ')') AS TOV_RANK,
  CONCAT(ROUND(T2.avg_playoff_threes_rank, 2), '/16 (', ROUND(T2.avg_playoff_threes_rank / 16.0, 2), ')') AS THREES_RANK, CONCAT(ROUND(T2.avg_playoff_threes_pct_rank, 2), '/16 (', ROUND(T2.avg_playoff_threes_pct_rank / 16.0, 2), ')') AS THREES_PCT_RANK, CONCAT(ROUND(T2.avg_playoff_twos_rank, 2), '/16 (', ROUND(T2.avg_playoff_twos_rank / 16.0, 2), ')') AS TWOS_RANK, CONCAT(ROUND(T2.avg_playoff_twos_pct_rank, 2), '/16 (', ROUND(T2.avg_playoff_twos_pct_rank / 16.0, 2), ')') AS TWOS_PCT_RANK, CONCAT(ROUND(T2.avg_playoff_oreb_rank, 2), '/16 (', ROUND(T2.avg_playoff_oreb_rank / 16.0, 2), ')') AS OREB_RANK, CONCAT(ROUND(T2.avg_playoff_dreb_rank, 2), '/16 (', ROUND(T2.avg_playoff_dreb_rank / 16.0, 2), ')') AS DREB_RANK, CONCAT(ROUND(T2.avg_playoff_ft_pct_rank, 2), '/16 (', ROUND(T2.avg_playoff_ft_pct_rank / 16.0, 2), ')') AS FT_PCT_RANK
FROM (
  SELECT
    AVG(T2.PTS_RANK) AS avg_playoff_pts_rank, AVG(T2.AST_RANK) AS avg_playoff_ast_rank, AVG(T2.REB_RANK) AS avg_playoff_reb_rank, AVG(T2.STL_RANK) AS avg_playoff_stl_rank, AVG(T2.BLK_RANK) AS avg_playoff_blk_rank, AVG(T2.TOV_RANK) AS avg_playoff_tov_rank,
    AVG(T2.THREES_RANK) AS avg_playoff_threes_rank, AVG(T2.THREES_PCT_RANK) AS avg_playoff_threes_pct_rank, AVG(T2.TWOS_RANK) AS avg_playoff_twos_rank, AVG(T2.TWOS_PCT_RANK) AS avg_playoff_twos_pct_rank, AVG(T2.OREB_RANK) AS avg_playoff_oreb_rank, AVG(T2.DREB_RANK) AS avg_playoff_dreb_rank, AVG(T2.FT_PCT_RANK) AS avg_playoff_ft_pct_rank
  FROM champions_stats_avg AS T2
) AS T2
UNION ALL
SELECT
  'AVG Percentile Difference' AS comparison_metric,
  NULL AS PTS, NULL AS AST, NULL AS REB, NULL AS STL, NULL AS BLK, NULL AS TOV, NULL AS THREES, NULL AS THREES_PCT, NULL AS TWOS, NULL AS TWOS_PCT, NULL AS OREB, NULL AS DREB, NULL AS FT_PCT,
  ROUND((T2.avg_playoff_pts_rank / 16.0) - (T1.avg_reg_pts_rank / 30.0), 2) AS PTS_RANK, ROUND((T2.avg_playoff_ast_rank / 16.0) - (T1.avg_reg_ast_rank / 30.0), 2) AS AST_RANK, ROUND((T2.avg_playoff_reb_rank / 16.0) - (T1.avg_reg_reb_rank / 30.0), 2) AS REB_RANK, ROUND((T2.avg_playoff_stl_rank / 16.0) - (T1.avg_reg_stl_rank / 30.0), 2) AS STL_RANK, ROUND((T2.avg_playoff_blk_rank / 16.0) - (T1.avg_reg_blk_rank / 30.0), 2) AS BLK_RANK, ROUND((T2.avg_playoff_tov_rank / 16.0) - (T1.avg_reg_tov_rank / 30.0), 2) AS TOV_RANK,
  ROUND((T2.avg_playoff_threes_rank / 16.0) - (T1.avg_reg_threes_rank / 30.0), 2) AS THREES_RANK, ROUND((T2.avg_playoff_threes_pct_rank / 16.0) - (T1.avg_reg_threes_pct_rank / 30.0), 2) AS THREES_PCT_RANK, ROUND((T2.avg_playoff_twos_rank / 16.0) - (T1.avg_reg_twos_rank / 30.0), 2) AS TWOS_RANK, ROUND((T2.avg_playoff_twos_pct_rank / 16.0) - (T1.avg_reg_twos_pct_rank / 30.0), 2) AS TWOS_PCT_RANK, ROUND((T2.avg_playoff_oreb_rank / 16.0) - (T1.avg_reg_oreb_rank / 30.0), 2) AS OREB_RANK, ROUND((T2.avg_playoff_dreb_rank / 16.0) - (T1.avg_reg_dreb_rank / 30.0), 2) AS DREB_RANK, ROUND((T2.avg_playoff_ft_pct_rank / 16.0) - (T1.avg_reg_ft_pct_rank / 30.0), 2) AS FT_PCT_RANK
FROM (
  SELECT
    AVG(T1.PTS_RANK) AS avg_reg_pts_rank, AVG(T1.AST_RANK) AS avg_reg_ast_rank, AVG(T1.REB_RANK) AS avg_reg_reb_rank, AVG(T1.STL_RANK) AS avg_reg_stl_rank, AVG(T1.BLK_RANK) AS avg_reg_blk_rank, AVG(T1.TOV_RANK) AS avg_reg_tov_rank,
    AVG(T1.THREES_RANK) AS avg_reg_threes_rank, AVG(T1.THREES_PCT_RANK) AS avg_reg_threes_pct_rank, AVG(T1.TWOS_RANK) AS avg_reg_twos_rank, AVG(T1.TWOS_PCT_RANK) AS avg_reg_twos_pct_rank, AVG(T1.OREB_RANK) AS avg_reg_oreb_rank, AVG(T1.DREB_RANK) AS avg_reg_dreb_rank, AVG(T1.FT_PCT_RANK) AS avg_reg_ft_pct_rank
  FROM champions_stats_avg_reg AS T1
) AS T1,
(
  SELECT
    AVG(T2.PTS_RANK) AS avg_playoff_pts_rank, AVG(T2.AST_RANK) AS avg_playoff_ast_rank, AVG(T2.REB_RANK) AS avg_playoff_reb_rank, AVG(T2.STL_RANK) AS avg_playoff_stl_rank, AVG(T2.BLK_RANK) AS avg_playoff_blk_rank, AVG(T2.TOV_RANK) AS avg_playoff_tov_rank,
    AVG(T2.THREES_RANK) AS avg_playoff_threes_rank, AVG(T2.THREES_PCT_RANK) AS avg_playoff_threes_pct_rank, AVG(T2.TWOS_RANK) AS avg_playoff_twos_rank, AVG(T2.TWOS_PCT_RANK) AS avg_playoff_twos_pct_rank, AVG(T2.OREB_RANK) AS avg_playoff_oreb_rank, AVG(T2.DREB_RANK) AS avg_playoff_dreb_rank, AVG(T2.FT_PCT_RANK) AS avg_playoff_ft_pct_rank
  FROM champions_stats_avg AS T2
) AS T2; # export csv and reimport with data wizard as: average_differences_reg_playoffs


