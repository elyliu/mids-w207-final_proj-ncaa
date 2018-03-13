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
CREATE TABLE IF NOT EXISTS prod."RegSeasonDetailedResults" (
  "Season" INT, "DayNum" INT, "WTeamID" INT, "WScore" INT,
  "LTeamID" INT, "LScore" INT, "WLoc" CHAR(1), "NumOT" INT,
  
  -- winning team stats
  "WFGM" INT, "WFGA" INT, "WFGM3" INT, "WFGA3" INT, "WFTM" INT,
  "WFTA" INT, "WOR" INT, "WDR" INT, "WAst" INT, "WTO" INT,
  "WStl" INT, "WBlk" INT, "WPF" INT,
  
  -- losing team stats
  "LFGM" INT, "LFGA" INT, "LFGM3" INT, "LFGA3" INT, "LFTM" INT,
  "LFTA" INT, "LOR" INT, "LDR" INT, "LAst" INT, "LTO" INT,
  "LStl" INT, "LBlk" INT, "LPF" INT
  
  CONSTRAINT "RegSeason_pkey" PRIMARY KEY (
    "Season",
    "DayNum",
    "WTeamID",
    "LTeamID"
  )
)
;

-- Tourney Detailed Results
CREATE TABLE IF NOT EXISTS prod."TourneyDetailedResults" (
  "Season" INT, "DayNum" INT, "WTeamID" INT, "WScore" INT,
  "LTeamID" INT, "LScore" INT, "WLoc" CHAR(1), "NumOT" INT,
  
  -- winning team stats
  "WFGM" INT, "WFGA" INT, "WFGM3" INT, "WFGA3" INT, "WFTM" INT,
  "WFTA" INT, "WOR" INT, "WDR" INT, "WAst" INT, "WTO" INT,
  "WStl" INT, "WBlk" INT, "WPF" INT,
  
  -- losting team stats
  "LFGM" INT, "LFGA" INT, "LFGM3" INT, "LFGA3" INT, "LFTM" INT,
  "LFTA" INT, "LOR" INT, "LDR" INT, "LAst" INT, "LTO" INT,
  "LStl" INT, "LBlk" INT, "LPF" INT
  
  CONSTRAINT "Tourney_pkey" PRIMARY KEY (
    "Season",
    "DayNum",
    "WTeamID",
    "LTeamID"
  )
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
CREATE TABLE IF NOT EXISTS prod."MasseyOrdinals" (
  "Season" INT,
  "RankingDayNum" INT,
  "SystemName" VARCHAR(3),
  "TeamID" INT,
  "OrdinalRank" INT
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
  "Outcome" integer NOT NULL,
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
