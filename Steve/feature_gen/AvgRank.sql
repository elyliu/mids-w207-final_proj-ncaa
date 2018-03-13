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
)
UPDATE prod.features as f
SET "AvgRank" = r."AvgRank"
FROM rank as r
WHERE f."Season" = r."Season" AND
  f."DayNum" = r."RankingDayNum" AND
  f."Team" = r."TeamID"
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
)
UPDATE prod.features as f
SET "AvgRank" = r."AvgRank"
FROM rank as r
WHERE f."Season" = r."Season" AND
  f."DayNum" > 133 AND
  f."Team" = r."TeamID"
;
