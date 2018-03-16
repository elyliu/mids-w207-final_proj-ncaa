-- Teams
CREATE TABLE IF NOT EXISTS prod."Teams" (
  "TeamID" INT NOT NULL PRIMARY KEY,
  "TeamName" VARCHAR(20),
  "FirstD1Season" INT,
  "LastD1Season" INT
)
;

-- Coaches
CREATE TABLE IF NOT EXISTS prod."TeamCoaches" (
  "Season" INT,
  "TeamID" INT,
  "FirstDayNum" INT,
  "LastDayNum" INT,
  "CoachName" VARCHAR(25)
)
;

-- Conferences
CREATE TABLE IF NOT EXISTS prod."Conferences" (
  "ConfAbbrev" VARCHAR(15),
  "Description" VARCHAR(50)
)
;

-- Regular Season Detailed Results
CREATE TABLE IF NOT EXISTS prod."RegSeasonDetailedResults"
(
    "Season" integer NOT NULL,
    "DayNum" integer NOT NULL,
    "WTeamID" integer NOT NULL,
    "WScore" integer,
    "LTeamID" integer NOT NULL,
    "LScore" integer,
    "WLoc" character(1) COLLATE pg_catalog."default",
    "NumOT" integer,
    "WFGM" integer,
    "WFGA" integer,
    "WFGM3" integer,
    "WFGA3" integer,
    "WFTM" integer,
    "WFTA" integer,
    "WOR" integer,
    "WDR" integer,
    "WAst" integer,
    "WTO" integer,
    "WStl" integer,
    "WBlk" integer,
    "WPF" integer,
    "LFGM" integer,
    "LFGA" integer,
    "LFGM3" integer,
    "LFGA3" integer,
    "LFTM" integer,
    "LFTA" integer,
    "LOR" integer,
    "LDR" integer,
    "LAst" integer,
    "LTO" integer,
    "LStl" integer,
    "LBlk" integer,
    "LPF" integer,
    CONSTRAINT reg_pkey PRIMARY KEY ("Season", "DayNum", "WTeamID", "LTeamID")
)
;

-- Tourney Detailed Results
CREATE TABLE prod."TourneyDetailedResults"
(
    "Season" integer NOT NULL,
    "DayNum" integer NOT NULL,
    "WTeamID" integer NOT NULL,
    "WScore" integer,
    "LTeamID" integer NOT NULL,
    "LScore" integer,
    "WLoc" character(1) COLLATE pg_catalog."default",
    "NumOT" integer,
    "WFGM" integer,
    "WFGA" integer,
    "WFGM3" integer,
    "WFGA3" integer,
    "WFTM" integer,
    "WFTA" integer,
    "WOR" integer,
    "WDR" integer,
    "WAst" integer,
    "WTO" integer,
    "WStl" integer,
    "WBlk" integer,
    "WPF" integer,
    "LFGM" integer,
    "LFGA" integer,
    "LFGM3" integer,
    "LFGA3" integer,
    "LFTM" integer,
    "LFTA" integer,
    "LOR" integer,
    "LDR" integer,
    "LAst" integer,
    "LTO" integer,
    "LStl" integer,
    "LBlk" integer,
    "LPF" integer,
    CONSTRAINT "Tourney_pkey" PRIMARY KEY ("Season", "DayNum", "WTeamID", "LTeamID")
)
;

-- Conference Tourney
CREATE TABLE IF NOT EXISTS prod."ConferenceTourneyGames" (
  "Season" INT,
  "ConfAbbrev" VARCHAR(16),
  "DayNum" INT,
  "WTeamID" INT,
  "LTeamID" INT
)
;

-- Tourney Seeds
CREATE TABLE IF NOT EXISTS prod."TourneySeeds" (
  "Season" INT,
  "Seed" VARCHAR(5),
  "TeamID" INT
  --SeedNo INT
)
;

-- Massey Ordinals
CREATE TABLE prod."MasseyOrdinals"
(
    "Season" integer NOT NULL,
    "RankingDayNum" integer NOT NULL,
    "SystemName" character varying(3) COLLATE pg_catalog."default" NOT NULL,
    "TeamID" integer NOT NULL,
    "OrdinalRank" integer,
    CONSTRAINT "Massey_pkey" PRIMARY KEY ("Season", "RankingDayNum", "SystemName", "TeamID")
)
;

-- -- Features Example Table
-- CREATE TABLE IF NOT EXISTS features_example (
--   "Season" INT,
--   "DayNum" INT,
--   "Team" INT,
--   "Opponent" INT,
--   "Outcome" INT,
--   "Score" INT,
--   "OpponentScore" INT,
--   "NumOT" INT,
--   "WLoc" VARCHAR(1),
--   holdout INT
-- )
-- ;

-- Features Table
CREATE TABLE IF NOT EXISTS prod.features (
  "Season" integer NOT NULL,
  "DayNum" integer NOT NULL,
  "Team" integer NOT NULL,
  "Opponent" integer NOT NULL,
  "Outcome" integer,
  "Score" integer,
  "OpponentScore" integer,
  "NumOT" integer,
  "WLoc" character varying COLLATE pg_catalog."default",
  "Season Type" character varying COLLATE pg_catalog."default",
  CONSTRAINT features_pkey PRIMARY KEY (
    "Season",
    "DayNum",
    "Team",
    "Opponent"
  )
)
;
