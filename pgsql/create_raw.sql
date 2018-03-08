-- Teams
CREATE TABLE Teams (
  TeamID INT NOT NULL PRIMARY KEY,
  TeamName VARCHAR(20),
  FirstD1Season INT,
  LastD1Season INT
)
;

-- Coaches
CREATE TABLE TeamCoaches (
  Season INT,
  TeamID INT,
  FirstDayNum INT,
  LastDayNum INT,
  CoachName VARCHAR(25)
)
;

-- Conferences
CREATE TABLE Conferences (
  ConfAbbrev VARCHAR(15),
  Description VARCHAR(50)
)
;

-- Regular Season Detailed Results
CREATE TABLE RegSeasonDetailedResults (
  Season INT, DayNum INT, WTeamID INT, WScore INT,
  LTeamID INT, LScore INT, WLoc CHAR(1), NumOT INT,
  
  -- winning team stats
  WFGM INT, WFGA INT, WFGM3 INT, WFGA3 INT, WFTM INT,
  WFTA INT, WOR INT, WDR INT, WAst INT, WTO INT,
  WStl INT, WBlk INT, WPF INT,
  
  -- losing team stats
  LFGM INT, LFGA INT, LFGM3 INT, LFGA3 INT, LFTM INT,
  LFTA INT, LOR INT, LDR INT, LAst INT, LTO INT,
  LStl INT, LBlk INT, LPF INT
  
  -- two pointers (generate this later)
  --WFGM2 INT, WFGA2 INT,
  --LFGM2 INT, LFGA2 INT
)
;

-- Tourney Detailed Results
CREATE TABLE TourneyDetailedResults (
  Season INT, DayNum INT, WTeamID INT, WScore INT,
  LTeamID INT, LScore INT, WLoc CHAR(1), NumOT INT,
  
  -- winning team stats
  WFGM INT, WFGA INT, WFGM3 INT, WFGA3 INT, WFTM INT,
  WFTA INT, WOR INT, WDR INT, WAst INT, WTO INT,
  WStl INT, WBlk INT, WPF INT,
  
  -- losting team stats
  LFGM INT, LFGA INT, LFGM3 INT, LFGA3 INT, LFTM INT,
  LFTA INT, LOR INT, LDR INT, LAst INT, LTO INT,
  LStl INT, LBlk INT, LPF INT
)
;

-- Conference Tourney
CREATE TABLE ConferenceTourneyGames (
  Season INT,
  ConfAbbrev VARCHAR(16),
  DayNum INT,
  WTeamID INT,
  LTeamID INT
)
;

-- Tourney Seeds
CREATE TABLE TourneySeeds (
  Season INT,
  Seed VARCHAR(5),
  TeamID INT
  --SeedNo INT
)
;

-- Massey Ordinals
CREATE TABLE MasseyOrdinals (
  Season INT,
  RankingDayNum INT,
  SystemName VARCHAR(3),
  TeamID INT,
  OrdinalRank INT
)
;
