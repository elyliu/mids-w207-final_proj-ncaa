# Feature Engineering

This directory contains all source used to create features. Below are feature definitions of the "base" features.
Note that we generated each of these features for the Team and Opponent, and created a feature for the difference between the two.

| Base Feature      | Short Description                                                                 | Source                                                             |
|-------------------|-----------------------------------------------------------------------------------|--------------------------------------------------------------------|
| AvgRank           | Average daily rank from MasseyOrdinals on days with at least two system rankings. | [AvgRank.sql](./AvgRank.sql)                                       |
| TwoPointPct       | Percentage of Two Point FGs Made                                                  | [Matt_Feature_Modifications.txt](./Matt_Feature_Modifications.txt) |
| ThreePointPct     | Percentage of Three Point FGs Made                                                | [Matt_Feature_Modifications.txt](./Matt_Feature_Modifications.txt) |
| FreeThrowPct      | Percentage of Free Throws Made                                                    | [Matt_Feature_Modifications.txt](./Matt_Feature_Modifications.txt) |
| OffensiveRebounds | Average Offensive Rebounds                                                        | [Matt_Feature_Modifications.txt](./Matt_Feature_Modifications.txt) |
| DefensiveRebounds | Average Defensive Rebounds                                                        | [Matt_Feature_Modifications.txt](./Matt_Feature_Modifications.txt) |
| WinPct            | Regular Season Win Percentage                                                     | [Add Features.ipynb](./Add%20Features.ipynb)                       |
| AvgPointsFor      | Average Points For in Regular Season                                              | [Add Features.ipynb](./Add%20Features.ipynb)                       |
| AvgPointsAgainst  | Average Points Against in Regular Season                                          | [Add Features.ipynb](./Add%20Features.ipynb)                       |
| AvgNetPointsFor   | Average Net Points For in Regular Season                                          | [Add Features.ipynb](./Add%20Features.ipynb)                       |
| SeedDiff          | Seed Difference (Only for Approach 1)                                             | [Add Features.ipynb](./Add%20Features.ipynb)                       |
| TourWins          | Historical Tournament Wins                                                        | [Add Features-Ely.ipynb](./Add%20Features-Ely.ipynb)               |
| FieldGoalPct      | Percentage FGs Made                                                               | [GameStats.sql](./GameStats.sql)                                   |
| TwoPointAttPct    | Percentage of Two Point Attempts of all FG Attempts                               | [GameStats.sql](./GameStats.sql)                                   |
| ThreePointAttPct  | Percentage of Three Point Attempts of all FG Attempts                             | [GameStats.sql](./GameStats.sql)                                   |
| FieldGoalAtt      | Average Field Goal Attempts per Game                                              | [GameStats.sql](./GameStats.sql)                                   |
| TwoPointAtt       | Average Two Point Attempts per Game                                               | [GameStats.sql](./GameStats.sql)                                   |
| ThreePointAtt     | Average Three Point Attempts per Game                                             | [GameStats.sql](./GameStats.sql)                                   |
| FreeThrowAtt      | Average Free Throw Attempts per Game                                              | [GameStats.sql](./GameStats.sql)                                   |
| Assists           | Average Assists per Game                                                          | [GameStats.sql](./GameStats.sql)                                   |
| Turnovers         | Averaage Turnovers per Game                                                       | [GameStats.sql](./GameStats.sql)                                   |
| Steals            | Average Steals per Game                                                           | [GameStats.sql](./GameStats.sql)                                   |
| Blocks            | Average Blocks per Game                                                           | [GameStats.sql](./GameStats.sql)                                   |
| PersonalFouls     | Average Personal Fouls per Game                                                   | [GameStats.sql](./GameStats.sql)                                   |
