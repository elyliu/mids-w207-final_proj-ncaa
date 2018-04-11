-- Add Team Stats -----------------------------------------------
ALTER TABLE prod.features
  ADD COLUMN IF NOT EXISTS "FieldGoalPct_Team" REAL,
  ADD COLUMN IF NOT EXISTS "TwoPointAttPct_Team" REAL,
  ADD COLUMN IF NOT EXISTS "ThreePointAttPct_Team" REAL,
  ADD COLUMN IF NOT EXISTS "FieldGoalAtt_Team" REAL,
  ADD COLUMN IF NOT EXISTS "TwoPointAtt_Team" REAL,
  ADD COLUMN IF NOT EXISTS "ThreePointAtt_Team" REAL,
  ADD COLUMN IF NOT EXISTS "FreeThrowAtt_Team" REAL,
  ADD COLUMN IF NOT EXISTS "Assists_Team" REAL,
  ADD COLUMN IF NOT EXISTS "Turnovers_Team" REAL,
  ADD COLUMN IF NOT EXISTS "Steals_Team" REAL,
  ADD COLUMN IF NOT EXISTS "Blocks_Team" REAL,
  ADD COLUMN IF NOT EXISTS "PersonalFouls_Team" REAL
;

WITH regseasondetailedresultscombined as (
	SELECT "Season", "DayNum", "WTeamID" AS "TeamID", "WScore" AS "Score", 1 AS "Win", "WLoc" AS "Loc", "NumOT", "WFGM" AS "FGM", "WFGA" AS "FGA", "WFGM2" AS "FGM2", "WFGA2" AS "FGA2",
	"WFGM3" AS "FGM3", "WFGA3" AS "FGA3", "WFTM" AS "FTM", "WFTA" AS "FTA", "WOR" AS "OReb", "WDR" AS "DReb", "WAst" AS "Ast", "WTO" AS "TOvr", "WStl" AS "Stl", "WBlk" AS "Blk", "WPF" AS "PF"
  FROM prod."RegSeasonDetailedResults"
	UNION
	SELECT "Season", "DayNum", "LTeamID" AS "TeamID", "LScore" AS "Score", 0 AS "Win", "WLoc" AS "Loc", "NumOT", "LFGM" AS "FGM", "LFGA" AS "FGA", "LFGM2" AS "FGM2", "LFGA2" AS "FGA2",
	"LFGM3" AS "FGM3", "LFGA3" AS "FGA3", "LFTM" AS "FTM", "LFTA" AS "FTA", "LOR" AS "OReb", "LDR" AS "DReb", "LAst" AS "Ast", "LTO" AS "TOvr", "LStl" AS "Stl", "LBlk" AS "Blk", "LPF" AS "PF"
  FROM prod."RegSeasonDetailedResults"
),
seasonstatistics as (
	SELECT
		R."Season",
		R."TeamID",
		R."DayNum",
    AVG(COALESCE("FGM"::float/NULLIF("FGA",0),0)) OVER w AS "FieldGoalPct",
    AVG(COALESCE("FGA2"::float/NULLIF("FGA",0),0)) OVER w AS "TwoPointAttPct",
    AVG(COALESCE("FGA3"::float/NULLIF("FGA",0),0)) OVER w AS "ThreePointAttPct",
    AVG("FGA") OVER w AS "FieldGoalAtt",
    AVG("FGA2") OVER w AS "TwoPointAtt",
    AVG("FGA3") OVER w AS "ThreePointAtt",
    AVG("FTA") OVER w AS "FreeThrowAtt",
    AVG("Ast") OVER w AS "Assists",
    AVG("TOvr") OVER w AS "Turnovers",
    AVG("Stl") OVER w AS "Steals",
    AVG("Blk") OVER w AS "Blocks",
    AVG("PF") OVER w AS "PersonalFouls"
	FROM regseasondetailedresultscombined R
	WINDOW w as (
	  PARTITION BY "Season", "TeamID"
    ORDER BY "DayNum"
    ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
  )
),
stats_join as (
	SELECT DISTINCT ON (f."Season", f."DayNum", f."Team")
		f."Season", f."DayNum", f."Team",
		s."FieldGoalPct", s."TwoPointAttPct", s."ThreePointAttPct",
		s."FieldGoalAtt", s."TwoPointAtt", s."ThreePointAtt",
    s."FreeThrowAtt", s."Assists", s."Turnovers", s."Steals",
    s."Blocks", s."PersonalFouls"
	FROM prod.features as f
	LEFT JOIN seasonstatistics as s
    ON f."Season" = s."Season" and f."Team" = s."TeamID"
	WHERE f."DayNum" >= s."DayNum"
  ORDER BY f."Season", f."DayNum", f."Team", s."DayNum" DESC
)

UPDATE prod."features" F
SET
  "FieldGoalPct_Team" = SS."FieldGoalPct",
  "TwoPointAttPct_Team" = SS."TwoPointAttPct",
  "ThreePointAttPct_Team" = SS."ThreePointAttPct",
  "FieldGoalAtt_Team" = SS."FieldGoalAtt",
  "TwoPointAtt_Team" = SS."TwoPointAtt",
  "ThreePointAtt_Team" = SS."ThreePointAtt",
  "FreeThrowAtt_Team" = SS."FreeThrowAtt",
  "Assists_Team" = SS."Assists",
  "Turnovers_Team" = SS."Turnovers",
  "Steals_Team" = SS."Steals",
  "Blocks_Team" = SS."Blocks",
  "PersonalFouls_Team" = SS."PersonalFouls"
FROM stats_join SS
WHERE F."Season" = SS."Season" AND
	F."Team" = SS."Team" AND
	F."DayNum" = SS."DayNum"
;

-- Add Opponent Stats -----------------------------------------------

ALTER TABLE prod.features
  ADD COLUMN IF NOT EXISTS "FieldGoalPct_Opponent" REAL,
  ADD COLUMN IF NOT EXISTS "TwoPointAttPct_Opponent" REAL,
  ADD COLUMN IF NOT EXISTS "ThreePointAttPct_Opponent" REAL,
  ADD COLUMN IF NOT EXISTS "FieldGoalAtt_Opponent" REAL,
  ADD COLUMN IF NOT EXISTS "TwoPointAtt_Opponent" REAL,
  ADD COLUMN IF NOT EXISTS "ThreePointAtt_Opponent" REAL,
  ADD COLUMN IF NOT EXISTS "FreeThrowAtt_Opponent" REAL,
  ADD COLUMN IF NOT EXISTS "Assists_Opponent" REAL,
  ADD COLUMN IF NOT EXISTS "Turnovers_Opponent" REAL,
  ADD COLUMN IF NOT EXISTS "Steals_Opponent" REAL,
  ADD COLUMN IF NOT EXISTS "Blocks_Opponent" REAL,
  ADD COLUMN IF NOT EXISTS "PersonalFouls_Opponent" REAL
;

WITH regseasondetailedresultscombined as (
	SELECT "Season", "DayNum", "WTeamID" AS "TeamID", "WScore" AS "Score", 1 AS "Win", "WLoc" AS "Loc", "NumOT", "WFGM" AS "FGM", "WFGA" AS "FGA", "WFGM2" AS "FGM2", "WFGA2" AS "FGA2",
	"WFGM3" AS "FGM3", "WFGA3" AS "FGA3", "WFTM" AS "FTM", "WFTA" AS "FTA", "WOR" AS "OReb", "WDR" AS "DReb", "WAst" AS "Ast", "WTO" AS "TOvr", "WStl" AS "Stl", "WBlk" AS "Blk", "WPF" AS "PF" FROM prod."RegSeasonDetailedResults"
	UNION
	SELECT "Season", "DayNum", "LTeamID" AS "TeamID", "LScore" AS "Score", 0 AS "Win", "WLoc" AS "Loc", "NumOT", "LFGM" AS "FGM", "LFGA" AS "FGA", "LFGM2" AS "FGM2", "LFGA2" AS "FGA2",
	"LFGM3" AS "FGM3", "LFGA3" AS "FGA3", "LFTM" AS "FTM", "LFTA" AS "FTA", "LOR" AS "OReb", "LDR" AS "DReb", "LAst" AS "Ast", "LTO" AS "TOvr", "LStl" AS "Stl", "LBlk" AS "Blk", "LPF" AS "PF" FROM prod."RegSeasonDetailedResults"
),
seasonstatistics as (
	SELECT
		R."Season",
		R."TeamID",
		R."DayNum",
    AVG(COALESCE("FGM"::float/NULLIF("FGA",0),0)) OVER w AS "FieldGoalPct",
    AVG(COALESCE("FGA2"::float/NULLIF("FGA",0),0)) OVER w AS "TwoPointAttPct",
    AVG(COALESCE("FGA3"::float/NULLIF("FGA",0),0)) OVER w AS "ThreePointAttPct",
    AVG("FGA") OVER w AS "FieldGoalAtt",
    AVG("FGA2") OVER w AS "TwoPointAtt",
    AVG("FGA3") OVER w AS "ThreePointAtt",
    AVG("FTA") OVER w AS "FreeThrowAtt",
    AVG("Ast") OVER w AS "Assists",
    AVG("TOvr") OVER w AS "Turnovers",
    AVG("Stl") OVER w AS "Steals",
    AVG("Blk") OVER w AS "Blocks",
    AVG("PF") OVER w AS "PersonalFouls"
	FROM regseasondetailedresultscombined R
	WINDOW w as (
	  PARTITION BY "Season", "TeamID"
    ORDER BY "DayNum"
    ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
  )
),
stats_join as (
	SELECT DISTINCT ON (f."Season", f."DayNum", f."Team")
		f."Season", f."DayNum", f."Team",
    s."FieldGoalPct", s."TwoPointAttPct", s."ThreePointAttPct",
		s."FieldGoalAtt", s."TwoPointAtt", s."ThreePointAtt",
    s."FreeThrowAtt", s."Assists", s."Turnovers", s."Steals",
    s."Blocks", s."PersonalFouls"
	FROM prod.features as f
	LEFT JOIN seasonstatistics as s
    ON f."Season" = s."Season" and f."Team" = s."TeamID"
	WHERE f."DayNum" >= s."DayNum"
  ORDER BY f."Season", f."DayNum", f."Team", s."DayNum" DESC
)

UPDATE prod."features" F
SET
  "FieldGoalPct_Opponent" = SS."FieldGoalPct",
  "TwoPointAttPct_Opponent" = SS."TwoPointAttPct",
  "ThreePointAttPct_Opponent" = SS."ThreePointAttPct",
  "FieldGoalAtt_Opponent" = SS."FieldGoalAtt",
  "TwoPointAtt_Opponent" = SS."TwoPointAtt",
  "ThreePointAtt_Opponent" = SS."ThreePointAtt",
  "FreeThrowAtt_Opponent" = SS."FreeThrowAtt",
  "Assists_Opponent" = SS."Assists",
  "Turnovers_Opponent" = SS."Turnovers",
  "Steals_Opponent" = SS."Steals",
  "Blocks_Opponent" = SS."Blocks",
  "PersonalFouls_Opponent" = SS."PersonalFouls"
FROM stats_join SS
WHERE F."Season" = SS."Season" AND
	F."Opponent" = SS."Team" AND
	F."DayNum" = SS."DayNum"
;
