USE dream11;

SELECT * FROM matchdata;

-- Transforming data in the table

-- updating column dismissal where player did not bat 
UPDATE matchdata
SET Dismissal = 'DNB'
WHERE Dismissal NOT LIKE '%_%';


-- updating row where runs and wickets are null but points are not
UPDATE matchdata
SET Runs = 0, Wickets = 0, Dismissal = 'DNB'
WHERE Player = 'Priyam Garg'


-- deleting rows with incomplete data
DELETE FROM matchdata 
WHERE Team NOT LIKE '%_%';



-- Exploratory Data Analysis(EDA)
-- most dream11 points by player
SELECT Player, SUM(CAST(DreamPoints AS int)) AS Dream11Points
FROM matchdata
GROUP BY Player
ORDER BY Dream11Points DESC;


-- number of dismissal by count
SELECT Dismissal, COUNT(Dismissal) AS Dis_Count
FROM matchdata
GROUP BY Dismissal
ORDER BY Dis_Count DESC;


-- number of players in each team
SELECT Team, COUNT(DISTINCT Player) AS Players
FROM matchdata
GROUP BY Team
ORDER BY Players;


-- number of matches played at each ground of UAE
SELECT Ground, COUNT(DISTINCT Match_Id) AS Matches
FROM matchdata
GROUP BY Ground
ORDER BY Matches;


-- delete column from table
ALTER TABLE matchdata
DROP COLUMN Individual_MatchNo;


-- dream11 points by ground
SELECT Ground, SUM(CAST(DreamPoints AS int)) AS Dream11_Points, 
(SUM(CAST(DreamPoints AS int))/COUNT(DISTINCT Match_Id)) AS Avg_Points
FROM matchdata
GROUP BY Ground
ORDER BY Dream11_Points;


-- players who scored more than 50 points most times
SELECT Player, COUNT(DreamPoints) AS POINTS50_OR_MORE, Team, SUM(CAST(DreamPoints AS int)) AS Dream11Points
FROM matchdata
WHERE DreamPoints >= 50
GROUP BY Player, Team
ORDER BY Team, POINTS50_OR_MORE DESC;



-- teams with most dream11 points 
SELECT Team, SUM(CAST(DreamPoints AS int)) AS dream11Points
FROM   matchdata
GROUP BY Team
ORDER BY dream11Points DESC;



-- most points scored by player at each ground
WITH Most_Points_At_Each_Ground AS
(
SELECT Player, Ground, 
SUM(CAST(dreampoints AS int)) AS Dream_Points,
ROW_NUMBER() OVER(PARTITION BY Ground ORDER BY SUM(CAST(DreamPoints AS int))DESC) AS Row_num
FROM matchdata
GROUP BY Player, Ground, DreamPoints
)
SELECT * FROM Most_Points_At_Each_Ground WHERE Row_num = 1;



-- ground with players who scored most points
WITH points_At_Each_Ground AS
(
SELECT Player, Ground,SUM(CAST(DreamPoints AS INT)) AS Most_Points,
ROW_NUMBER() OVER(PARTITION BY Ground ORDER BY SUM(CAST(DreamPoints AS INT)) DESC) AS row_num
FROM matchdata
GROUP BY Player, Ground
)
SELECT * FROM points_At_Each_Ground WHERE Row_num = 1;



-- maximum wickets taken on each ground
WITH Wickets_At_Each_Ground AS
(
SELECT Player, Ground,SUM(CAST(wickets AS INT)) AS Most_Wickets,
ROW_NUMBER() OVER(PARTITION BY ground ORDER BY SUM(CAST(wickets AS INT)) DESC) AS row_num
FROM matchdata
GROUP BY Player, Ground
)
SELECT * FROM Wickets_At_Each_Ground WHERE Row_num = 1;









