﻿#-----------------------------------------------------------------
# Databases
#-----------------------------------------------------------------

CREATE DATABASE NCAA;

USE NCAA;

#-----------------------------------------------------------------
# Tables
#-----------------------------------------------------------------

# Teams
CREATE TABLE Teams (TeamID INT NOT NULL PRIMARY KEY, TeamName VARCHAR(20), FirstD1Season INT, LastD1Season INT);

LOAD DATA LOCAL INFILE '/home/matt/w207/Data/Teams.csv'
INTO TABLE Teams
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# TeamCoaches
CREATE TABLE TeamCoaches (Season INT, TeamID INT, FirstDayNum INT, LastDayNum INT, CoachName VARCHAR(25));

LOAD DATA LOCAL INFILE '/home/matt/w207/Data/TeamCoaches.csv'
INTO TABLE TeamCoaches
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# Conferences
CREATE TABLE Conferences (ConfAbbrev VARCHAR(15), Description VARCHAR(50));

LOAD DATA LOCAL INFILE '/home/matt/w207/Data/Conferences.csv'
INTO TABLE Conferences
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# RegSeasonDetailedResults
CREATE TABLE RegSeasonDetailedResults (
Season INT, DayNum INT, WTeamID INT, WScore INT, LTeamID INT, LScore INT, WLoc CHAR(1), NumOT INT,
WFGM INT, WFGA INT, WFGM3 INT, WFGA3 INT, WFTM INT, WFTA INT, WOR INT, WDR INT, WAst INT, WTO INT, WStl INT, WBlk INT, WPF INT,
LFGM INT, LFGA INT, LFGM3 INT, LFGA3 INT, LFTM INT, LFTA INT, LOR INT, LDR INT, LAst INT, LTO INT, LStl INT, LBlk INT, LPF INT,
WFGM2 INT, WFGA2 INT, LFGM2 INT, LFGA2 INT);

LOAD DATA LOCAL INFILE '/home/matt/w207/Data/RegularSeasonDetailedResults.csv'
INTO TABLE RegSeasonDetailedResults
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

UPDATE RegSeasonDetailedResults
SET WFGM2 = (WFGM-WFGM3), WFGA2 = (WFGA-WFGA3), LFGM2 = (LFGM-LFGM3), LFGA2 = (LFGA-LFGA3);

# Create a combined table for statistics
CREATE TABLE RegSeasonDetailedResultsCombined (
Season INT, DayNum INT, TeamID INT, Score INT, Win INT, Loc CHAR(1), NumOT INT, FGM INT, FGA INT, FGM2 INT, FGA2 INT,
FGM3 INT, FGA3 INT, FTM INT, FTA INT, OReb INT, DReb INT, Ast INT, TOvr INT, Stl INT, Blk INT, PF INT);

# Insert both the wins and loses into the table as separate rows
INSERT INTO RegSeasonDetailedResultsCombined
SELECT * FROM (
SELECT Season, DayNum, WTeamID AS TeamID, WScore AS Score, 1 AS Win, WLoc AS Loc, NumOT, WFGM AS FGM, WFGA AS FGA, WFGM2 AS FGM2, WFGA2 AS FGA2,
WFGM3 AS FGM3, WFGA3 AS FGA3, WFTM AS FTM, WFTA AS FTA, WOR AS OReb, WDR AS DReb, WAst AS Ast, WTO AS TOvr, WStl AS Stl, WBlk AS Blk, WPF AS PF FROM RegSeasonDetailedResults
UNION
SELECT Season, DayNum, LTeamID AS TeamID, LScore AS Score, 0 AS Win, WLoc AS Loc, NumOT, LFGM AS FGM, LFGA AS FGA, LFGM2 AS FGM2, LFGA2 AS FGA2,
LFGM3 AS FGM3, LFGA3 AS FGA3, LFTM AS FTM, LFTA AS FTA, LOR AS OReb, LDR AS DReb, LAst AS Ast, LTO AS TOvr, LStl AS Stl, LBlk AS Blk, LPF AS PF FROM RegSeasonDetailedResults
) AS Blah;

# ConferenceTourneyGames
CREATE TABLE ConferenceTourneyGames (Season INT, ConfAbbrev VARCHAR(16), DayNum INT, WTeamID INT, LTeamID INT);

LOAD DATA LOCAL INFILE '/home/matt/w207/Data/ConferenceTourneyGames.csv'
INTO TABLE ConferenceTourneyGames
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# TourneyDetailedResults
CREATE TABLE TourneyDetailedResults (
Season INT, DayNum INT, WTeamID INT, WScore INT, LTeamID INT, LScore INT, WLoc CHAR(1), NumOT INT,
WFGM INT, WFGA INT, WFGM3 INT, WFGA3 INT, WFTM INT, WFTA INT, WOR INT, WDR INT, WAst INT, WTO INT, WStl INT, WBlk INT, WPF INT,
LFGM INT, LFGA INT, LFGM3 INT, LFGA3 INT, LFTM INT, LFTA INT, LOR INT, LDR INT, LAst INT, LTO INT, LStl INT, LBlk INT, LPF INT);

LOAD DATA LOCAL INFILE '/home/matt/w207/Data/NCAATourneyDetailedResults.csv'
INTO TABLE TourneyDetailedResults
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# TourneySeeds
CREATE TABLE TourneySeeds (Season INT, Seed VARCHAR(5), TeamID INT, SeedNo INT);

LOAD DATA LOCAL INFILE '/home/matt/w207/Data/NCAATourneySeeds.csv'
INTO TABLE TourneySeeds
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

UPDATE TourneySeeds
SET SeedNo = CONVERT(SUBSTR(Seed, 2, 2), UNSIGNED INTEGER);

# MasseyOrdinals
CREATE TABLE MasseyOrdinals(Season INT, RankingDayNum INT, SystemName VARCHAR(3), TeamID INT, OrdinalRank INT);

LOAD DATA LOCAL INFILE '/home/matt/w207/Data/MasseyOrdinals.csv'
INTO TABLE MasseyOrdinals
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#-----------------------------------------------------------------
# Views
#-----------------------------------------------------------------

#-----------------------------------------
# Regular Season Statistics
#-----------------------------------------
# Get the stats
CREATE VIEW vSeasonStatistics AS
SELECT R.Season, T.TeamID, T.TeamName, AVG(COALESCE(FGM2/NULLIF(FGA2,0),0)) AS TwoPointPct, AVG(COALESCE(FGM3/NULLIF(FGA3,0),0)) AS ThreePointPct, AVG(COALESCE(FTM/NULLIF(FTA,0),0)) AS FreeThrowPct, AVG(OReb) AS OffensiveRebounds, AVG(DReb) AS DefensiveRebounds
FROM RegSeasonDetailedResultsCombined R INNER JOIN Teams T
ON R.TeamID = T.TeamID
GROUP BY R.Season, R.TeamID
ORDER BY R.Season ASC, T.TeamName ASC;

#-----------------------------------------
# Win/lose margin difference
#-----------------------------------------
CREATE VIEW vAverageWinMargin AS
SELECT R.Season, R.WTeamID, T.TeamName, AVG(R.WSCore - R.LScore) AS AvgWinMargin
FROM RegSeasonDetailedResults R INNER JOIN Teams T
ON R.WTeamID = T.TeamID
GROUP BY R.Season, R.WTeamID;

CREATE VIEW vAverageLoseMargin AS
SELECT R.Season, R.LTeamID, T.TeamName, AVG(R.WSCore - R.LScore) AS AvgLoseMargin
FROM RegSeasonDetailedResults R INNER JOIN Teams T
ON R.LTeamID = T.TeamID
GROUP BY R.Season, R.LTeamID;

# Get a list of all the regular season games to join with the AverageWinMargin and AverageLoseMargin tables
CREATE VIEW vSeasonTeams AS
SELECT Season, TeamID
FROM RegSeasonDetailedResultsCombined
GROUP BY Season, TeamID;

# List the season, team ID, average win margin, and average lose margin in one table
CREATE VIEW vWinLoseMargins AS
SELECT ST.Season, ST.TeamID, AvgWinMargin, AvgLoseMargin
FROM vSeasonTeams ST
INNER JOIN vAverageWinMargin AWM ON ((ST.Season = AWM.Season) AND (ST.TeamID = AWM.WTeamID))
INNER JOIN vAverageLoseMargin ALM ON ((ST.Season = ALM.Season) AND (ST.TeamID = ALM.LTeamID))
ORDER BY ST.Season, ST.TeamID;

#-----------------------------------------
# Create training view
#-----------------------------------------
CREATE VIEW vTrainingTable AS
SELECT
    R.Season,
    CASE WHEN R.WTeamID < R.LTeamID THEN R.WTeamID ELSE R.LTeamID END AS Team1,
    CASE WHEN R.WTeamID > R.LTeamID THEN R.WTeamID ELSE R.LTeamID END AS Team2,
    CAST( (R.WTeamID < R.LTeamID) AS UNSIGNED) AS Win,
    CASE WHEN R.WTeamID < R.LTeamID THEN WLM1.AvgWinMargin ELSE WLM2.AvgWinMargin END AS AvgWinMargin1,
    CASE WHEN R.WTeamID < R.LTeamID THEN WLM1.AvgLoseMargin ELSE WLM2.AvgLoseMargin END AS AvgLoseMargin1,
    CASE WHEN R.WTeamID < R.LTeamID THEN SS1.TwoPointPct ELSE SS2.TwoPointPct END AS TwoPointPct1,
    CASE WHEN R.WTeamID < R.LTeamID THEN SS1.ThreePointPct ELSE SS2.ThreePointPct END AS ThreePointPct1,
    CASE WHEN R.WTeamID < R.LTeamID THEN SS1.FreeThrowPct ELSE SS2.FreeThrowPct END AS FreeThrowPct1,
    CASE WHEN R.WTeamID < R.LTeamID THEN SS1.OffensiveRebounds ELSE SS2.OffensiveRebounds END AS OffensiveRebounds1,
    CASE WHEN R.WTeamID < R.LTeamID THEN SS1.DefensiveRebounds ELSE SS2.DefensiveRebounds END AS DefensiveRebounds1,
    CASE WHEN R.WTeamID > R.LTeamID THEN WLM1.AvgWinMargin ELSE WLM2.AvgWinMargin END AS AvgWinMargin2,
    CASE WHEN R.WTeamID > R.LTeamID THEN WLM1.AvgLoseMargin ELSE WLM2.AvgLoseMargin END AS AvgLoseMargin2,
    CASE WHEN R.WTeamID > R.LTeamID THEN SS1.TwoPointPct ELSE SS2.TwoPointPct END AS TwoPointPct2,
    CASE WHEN R.WTeamID > R.LTeamID THEN SS1.ThreePointPct ELSE SS2.ThreePointPct END AS ThreePointPct2,
    CASE WHEN R.WTeamID > R.LTeamID THEN SS1.FreeThrowPct ELSE SS2.FreeThrowPct END AS FreeThrowPct2,
    CASE WHEN R.WTeamID > R.LTeamID THEN SS1.OffensiveRebounds ELSE SS2.OffensiveRebounds END AS OffensiveRebounds2,
    CASE WHEN R.WTeamID > R.LTeamID THEN SS1.DefensiveRebounds ELSE SS2.DefensiveRebounds END AS DefensiveRebounds2
FROM RegSeasonDetailedResults R
INNER JOIN vWinLoseMargins WLM1 ON ( (R.WTeamID = WLM1.TeamID) AND (R.Season = WLM1.Season) )
INNER JOIN vWinLoseMargins WLM2 ON ( (R.LTeamID = WLM2.TeamID) AND (R.Season = WLM2.Season) )
INNER JOIN vSeasonStatistics SS1 ON ( (R.WTeamID = SS1.TeamID) AND (R.Season = SS1.Season) )
INNER JOIN vSeasonStatistics SS2 ON ( (R.LTeamID = SS2.TeamID) AND (R.Season = SS2.Season) );

#-----------------------------------------
# Create test view
#-----------------------------------------
CREATE VIEW vTestTable AS
SELECT
    T.Season,
    CASE WHEN T.WTeamID < T.LTeamID THEN T.WTeamID ELSE T.LTeamID END AS Team1,
    CASE WHEN T.WTeamID > T.LTeamID THEN T.WTeamID ELSE T.LTeamID END AS Team2,
    CAST( (T.WTeamID < T.LTeamID) AS UNSIGNED) AS Win,
    CASE WHEN T.WTeamID < T.LTeamID THEN WLM1.AvgWinMargin ELSE WLM2.AvgWinMargin END AS AvgWinMargin1,
    CASE WHEN T.WTeamID < T.LTeamID THEN WLM1.AvgLoseMargin ELSE WLM2.AvgLoseMargin END AS AvgLoseMargin1,
    CASE WHEN T.WTeamID < T.LTeamID THEN SS1.TwoPointPct ELSE SS2.TwoPointPct END AS TwoPointPct1,
    CASE WHEN T.WTeamID < T.LTeamID THEN SS1.ThreePointPct ELSE SS2.ThreePointPct END AS ThreePointPct1,
    CASE WHEN T.WTeamID < T.LTeamID THEN SS1.FreeThrowPct ELSE SS2.FreeThrowPct END AS FreeThrowPct1,
    CASE WHEN T.WTeamID < T.LTeamID THEN SS1.OffensiveRebounds ELSE SS2.OffensiveRebounds END AS OffensiveRebounds1,
    CASE WHEN T.WTeamID < T.LTeamID THEN SS1.DefensiveRebounds ELSE SS2.DefensiveRebounds END AS DefensiveRebounds1,
    CASE WHEN T.WTeamID > T.LTeamID THEN WLM1.AvgWinMargin ELSE WLM2.AvgWinMargin END AS AvgWinMargin2,
    CASE WHEN T.WTeamID > T.LTeamID THEN WLM1.AvgLoseMargin ELSE WLM2.AvgLoseMargin END AS AvgLoseMargin2,
    CASE WHEN T.WTeamID > T.LTeamID THEN SS1.TwoPointPct ELSE SS2.TwoPointPct END AS TwoPointPct2,
    CASE WHEN T.WTeamID > T.LTeamID THEN SS1.ThreePointPct ELSE SS2.ThreePointPct END AS ThreePointPct2,
    CASE WHEN T.WTeamID > T.LTeamID THEN SS1.FreeThrowPct ELSE SS2.FreeThrowPct END AS FreeThrowPct2,
    CASE WHEN T.WTeamID > T.LTeamID THEN SS1.OffensiveRebounds ELSE SS2.OffensiveRebounds END AS OffensiveRebounds2,
    CASE WHEN T.WTeamID > T.LTeamID THEN SS1.DefensiveRebounds ELSE SS2.DefensiveRebounds END AS DefensiveRebounds2
FROM TourneyDetailedResults T
INNER JOIN vWinLoseMargins WLM1 ON ( (T.WTeamID = WLM1.TeamID) AND (T.Season = WLM1.Season) )
INNER JOIN vWinLoseMargins WLM2 ON ( (T.LTeamID = WLM2.TeamID) AND (T.Season = WLM2.Season) )
INNER JOIN vSeasonStatistics SS1 ON ( (T.WTeamID = SS1.TeamID) AND (T.Season = SS1.Season) )
INNER JOIN vSeasonStatistics SS2 ON ( (T.LTeamID = SS2.TeamID) AND (T.Season = SS2.Season) );

#-----------------------------------------------------------------
# Queries
#-----------------------------------------------------------------

#-----------------------------------------
# Difference in Seeds for wins and losses
#-----------------------------------------

# Determine the difference in seeds for the teams that play in a tournament
SELECT R.Season, R.WTeamID, R.LTeamID, TSW.SeedNo AS WinSeed, TSL.SeedNo AS LoseSeed, (TSW.SeedNo-TSL.SeedNo) AS SeedDiff
FROM TourneyDetailedResults R
LEFT OUTER JOIN TourneySeeds TSW ON ( (R.Season = TSW.Season) AND (R.WTeamID = TSW.TeamID) )
LEFT OUTER JOIN TourneySeeds TSL ON ( (R.Season = TSL.Season) AND (R.LTeamID = TSL.TeamID) )
ORDER BY R.Season, R.WTeamID;

#-----------------------------------------
# Ranking prior to the tournament
#-----------------------------------------

# Full rankings before the tournament
SELECT M.Season, T.TeamID, T.TeamName, AVG(M.OrdinalRank) AS AvgRank
FROM MasseyOrdinals M
INNER JOIN Teams T ON M.TeamID = T.TeamID
WHERE M.RankingDayNum=(SELECT MAX(RankingDayNum) FROM MasseyOrdinals)
GROUP BY M.Season, M.TeamID
ORDER BY M.Season, AvgRank;



