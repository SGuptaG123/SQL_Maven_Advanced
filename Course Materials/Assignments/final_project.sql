--
-- Table structure for table `players`
--

CREATE TABLE players (
    playerID VARCHAR(20) PRIMARY KEY,
    birthYear INT,
    birthMonth INT,
    birthDay INT,
    birthCountry VARCHAR(50),
    birthState VARCHAR(50),
    birthCity VARCHAR(50),
    deathYear INT,
    deathMonth INT,
    deathDay INT,
    deathCountry VARCHAR(50),
    deathState VARCHAR(50),
    deathCity VARCHAR(50),
    nameFirst VARCHAR(50),
    nameLast VARCHAR(50),
    nameGiven VARCHAR(100),
    weight INT,
    height INT,
    bats CHAR(1),
    throws CHAR(1),
    debut DATE,
    finalGame DATE,
    retroID VARCHAR(20),
    bbrefID VARCHAR(20)
);

--
-- Table structure for table `salaries`
--

CREATE TABLE salaries (
    yearID INT,
    teamID VARCHAR(3),
    lgID VARCHAR(2),
    playerID VARCHAR(20),
    salary INT,
    PRIMARY KEY (yearID, teamID, playerID)
);

--
-- Table structure for table `school_details`
--

CREATE TABLE school_details (
    schoolID VARCHAR(50) PRIMARY KEY,
    name_full VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(2),
    country VARCHAR(50)
);

--
-- Table structure for table `schools`
--

CREATE TABLE schools (
    playerID VARCHAR(50),
    schoolID VARCHAR(50),
    yearID INT,
    PRIMARY KEY (playerID, schoolID, yearID)
);

BULK INSERT players
FROM 'C:\Users\DELL\Downloads\Advanced+SQL+Querying\Course Materials\Data\players.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
	TABLOCK
);

BULK INSERT salaries
FROM 'C:\Users\DELL\Downloads\Advanced+SQL+Querying\Course Materials\Data\salaries.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
	TABLOCK
);

BULK INSERT school_details
FROM 'C:\Users\DELL\Downloads\Advanced+SQL+Querying\Course Materials\Data\school_details.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
	TABLOCK
);

BULK INSERT schools
FROM 'C:\Users\DELL\Downloads\Advanced+SQL+Querying\Course Materials\Data\schools.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
	TABLOCK
);


Select * from players
Select * from salaries
Select * from school_details
Select * from schools
-- PART I: SCHOOL ANALYSIS
-- 1. View the schools and school details tables
-- 2. In each decade, how many schools were there that produced players?
-- 3. What are the names of the top 5 schools that produced the most players?
-- 4. For each decade, what were the names of the top 3 schools that produced the most players?

-- PART II: SALARY ANALYSIS
-- 1. View the salaries table
-- 2. Return the top 20% of teams in terms of average annual spending
-- 3. For each team, show the cumulative sum of spending over the years
-- 4. Return the first year that each team's cumulative spending surpassed 1 billion

-- PART III: PLAYER CAREER ANALYSIS
-- 1. View the players table and find the number of players in the table
-- 2. For each player, calculate their age at their first game, their last game, and their career length (all in years). Sort from longest career to shortest career.
-- 3. What team did each player play on for their starting and ending years?
-- 4. How many players started and ended on the same team and also played for over a decade?

-- PART IV: PLAYER COMPARISON ANALYSIS
-- 1. View the players table
-- 2. Which players have the same birthday?
-- 3. Create a summary table that shows for each team, what percent of players bat right, left and both
-- 4. How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?
