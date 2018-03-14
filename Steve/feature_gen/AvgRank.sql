-- Add feature column to features table
ALTER TABLE prod.features
	ADD COLUMN IF NOT EXISTS "AvgRank" REAL;

-- Regular Season Average Ranking
WITH rank as (
  SELECT
    "Season",
    "RankingDayNum",
    "TeamID",
    AVG("OrdinalRank") as "AvgRank"
  FROM prod."MasseyOrdinals"
  GROUP BY "Season", "RankingDayNum", "TeamID"
  -- Must have more than one available ranking for that day
  HAVING COUNT("OrdinalRank") > 1
),
-- Join to next available DayNum
daily_rank as (
  SELECT DISTINCT ON (f."Season", f."DayNum", f."Team")
    f."Season", f."DayNum", f."Team", r."AvgRank"
  FROM prod.features as f
  LEFT JOIN rank as r
    ON f."Season" = r."Season" and f."Team" = r."TeamID"
  WHERE f."DayNum" <= r."RankingDayNum"
  ORDER BY f."Season", f."DayNum", f."Team", r."RankingDayNum"
)
UPDATE prod.features as t
SET "AvgRank" = dr."AvgRank"
FROM daily_rank as dr
WHERE t."Season" = dr."Season" AND
  t."DayNum" = dr."DayNum" AND
  t."Team" = dr."Team"
;

-- NCAA Tourney Average Ranking
WITH rank as (
  SELECT
    "Season",
    "RankingDayNum",
    "TeamID",
    AVG("OrdinalRank") as "AvgRank"
  FROM prod."MasseyOrdinals"
  WHERE "RankingDayNum" = 133
  GROUP BY "Season", "RankingDayNum", "TeamID"
	-- Must have more than one available ranking for that day
  HAVING COUNT("OrdinalRank") > 1
)
UPDATE prod.features as f
SET "AvgRank" = r."AvgRank"
FROM rank as r
WHERE f."Season" = r."Season" AND
  f."DayNum" > 133 AND
  f."Team" = r."TeamID"
;

-- Add feature column to features table
ALTER TABLE prod.features
	ADD COLUMN IF NOT EXISTS "OpponentAvgRank" REAL;

-- Regular Season Opponent Average Ranking
WITH rank as (
  SELECT
    "Season",
    "RankingDayNum",
    "TeamID",
    AVG("OrdinalRank") as "AvgRank"
  FROM prod."MasseyOrdinals"
  GROUP BY "Season", "RankingDayNum", "TeamID"
  -- Must have more than one available ranking for that day
  HAVING COUNT("OrdinalRank") > 1
),
-- Join to next available DayNum
daily_rank as (
  SELECT DISTINCT ON (f."Season", f."DayNum", f."Opponent")
    f."Season", f."DayNum", f."Opponent", r."AvgRank"
  FROM prod.features as f
  LEFT JOIN rank as r
    ON f."Season" = r."Season" and f."Opponent" = r."TeamID"
  WHERE f."DayNum" <= r."RankingDayNum"
  ORDER BY f."Season", f."DayNum", f."Opponent", r."RankingDayNum"
)
UPDATE prod.features as t
SET "OpponentAvgRank" = dr."AvgRank"
FROM daily_rank as dr
WHERE t."Season" = dr."Season" AND
  t."DayNum" = dr."DayNum" AND
  t."Opponent" = dr."Opponent"
;

-- NCAA Tourney Opponent Average Ranking
WITH rank as (
  SELECT
    "Season",
    "RankingDayNum",
    "TeamID",
    AVG("OrdinalRank") as "AvgRank"
  FROM prod."MasseyOrdinals"
  WHERE "RankingDayNum" = 133
  GROUP BY "Season", "RankingDayNum", "TeamID"
	-- Must have more than one available ranking for that day
  HAVING COUNT("OrdinalRank") > 1
)
UPDATE prod.features as f
SET "OpponentAvgRank" = r."AvgRank"
FROM rank as r
WHERE f."Season" = r."Season" AND
  f."DayNum" > 133 AND
  f."Opponent" = r."TeamID"
;