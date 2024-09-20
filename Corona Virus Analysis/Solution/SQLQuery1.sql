select * from [dbo].['Corona Virus Dataset$']

--Q1. Write a code to check NULL values
SELECT * FROM [dbo].['Corona Virus Dataset$']
WHERE 
    Province IS NULL OR
	Latitude IS NULL OR 
	Longitude IS NULL OR
	Date IS NULL OR
	Confirmed IS NULL OR
	Deaths IS NULL OR
	[Country/Region] IS NULL OR
	Recovered IS NULL;

--Q2. If NULL values are present, update them with zeros for all columns.

--#NONE#

-- Q3. check total number of rows

SELECT COUNT(*) AS TotalRows FROM [dbo].['Corona Virus Dataset$'];

--65535

-- Q4. Check what is start_date and end_date

Select MIN(Date) AS StartDate, MAX(Date) AS EndDate
FROM [dbo].['Corona Virus Dataset$'];

-- Q5. Number of month present in dataset

SELECT COUNT(DISTINCT DATEPART(MONTH, TRY_CONVERT(date, Date))) AS NumberOfMonths
FROM [dbo].['Corona Virus Dataset$']
WHERE TRY_CONVERT(date, Date) IS NOT NULL;

--Q6.Find monthly average for confirmed, deaths, recovered

	SELECT 
    YEAR(Try_Convert(date, Date)) AS Year,
    MONTH(Try_Convert(date, Date)) AS Month,
    AVG(Confirmed) AS AvgConfirmed,
    AVG(Deaths) AS AvgDeaths,
    AVG(Recovered) AS AvgRecovered
FROM 
    [dbo].['Corona Virus Dataset$']
WHERE 
    Try_Convert(date, Date) IS NOT NULL
GROUP BY 
    YEAR(Try_Convert(date, Date)),
    MONTH(Try_Convert(date, Date))
ORDER BY 
    Year ASC, Month ASC;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

WITH MonthlyCounts AS (
    SELECT 
        YEAR(Try_Convert(date, Date)) AS Year,
        MONTH(Try_Convert(date, Date)) AS Month,
        Confirmed,
        Deaths,
        Recovered,
        ROW_NUMBER() OVER (PARTITION BY YEAR(Try_Convert(date, Date)), MONTH(Try_Convert(date, Date)) ORDER BY COUNT(*) DESC) AS RowNum
    FROM 
        [dbo].['Corona Virus Dataset$']
    WHERE 
        Try_Convert(date, Date) IS NOT NULL
    GROUP BY 
        YEAR(Try_Convert(date, Date)),
        MONTH(Try_Convert(date, Date)),
        Confirmed,
        Deaths,
        Recovered
)
SELECT 
    Year,
    Month,
    Confirmed,
    Deaths,
    Recovered
FROM 
    MonthlyCounts
WHERE 
    RowNum = 1;

-- Q8. Find minimum values for confirmed, deaths, recovered per year

SELECT 
    YEAR(Try_Convert(date, Date)) AS Year,
    MIN(Confirmed) AS MinConfirmed,
    MIN(Deaths) AS MinDeaths,
    MIN(Recovered) AS MinRecovered
FROM 
    [dbo].['Corona Virus Dataset$']
WHERE 
    Try_Convert(date, Date) IS NOT NULL
GROUP BY 
    YEAR(Try_Convert(date, Date));

-- Q9. Find maximum values of confirmed, deaths, recovered per year

SELECT 
    YEAR(Try_Convert(date, Date)) AS Year,
    MAX(Confirmed) AS MinConfirmed,
    MAX(Deaths) AS MinDeaths,
    MAX(Recovered) AS MinRecovered
FROM 
    [dbo].['Corona Virus Dataset$']
WHERE 
    Try_Convert(date, Date) IS NOT NULL
GROUP BY 
    YEAR(Try_Convert(date, Date));

-- Q10. The total number of case of confirmed, deaths, recovered each month

SELECT 
    YEAR(Try_Convert(date, Date)) AS Year,
    MONTH(Try_Convert(date, Date)) AS Month,
    SUM(Confirmed) AS TotalConfirmed,
    SUM(Deaths) AS TotalDeaths,
    SUM(Recovered) AS TotalRecovered
FROM 
    [dbo].['Corona Virus Dataset$']
WHERE 
    Try_Convert(date, Date) IS NOT NULL
GROUP BY 
    YEAR(Try_Convert(date, Date)),
    MONTH(Try_Convert(date, Date))
ORDER BY 
    Year ASC, Month ASC;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    COUNT(*) AS TotalCases,
    AVG(Confirmed) AS AverageConfirmed,
    VAR(Confirmed) AS VarianceConfirmed,
    STDEV(Confirmed) AS StandardDeviationConfirmed
FROM 
    [dbo].['Corona Virus Dataset$'];

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    YEAR(Try_Convert(date, Date)) AS Year,
    MONTH(Try_Convert(date, Date)) AS Month,
    COUNT(*) AS TotalCases,
    AVG(Deaths) AS AverageDeaths,
    VAR(Deaths) AS VarianceDeaths,
    STDEV(Deaths) AS StandardDeviationDeaths
FROM 
    [dbo].['Corona Virus Dataset$']
WHERE 
    Try_Convert(date, Date) IS NOT NULL
GROUP BY 
    YEAR(Try_Convert(date, Date)),
    MONTH(Try_Convert(date, Date))
ORDER BY 
    Year ASC, Month ASC;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    COUNT(*) AS TotalCases,
    AVG(Recovered) AS AverageRecovered,
    VAR(Recovered) AS VarianceRecovered,
    STDEV(Recovered) AS StandardDeviationRecovered
FROM 
    [dbo].['Corona Virus Dataset$'];

-- Q14. Find Country having highest number of the Confirmed case

SELECT TOP 1
    [Country/Region],
    MAX(Confirmed) AS HighestConfirmedCases
FROM 
    [dbo].['Corona Virus Dataset$']
GROUP BY 
    [Country/Region]
ORDER BY 
    MAX(Confirmed) DESC;

-- Q15. Find Country having lowest number of the death case

SELECT TOP 1
    [Country/Region],
    MIN(Deaths) AS LowestDeathCases
FROM 
    [dbo].['Corona Virus Dataset$']
GROUP BY 
    [Country/Region]
ORDER BY 
    MIN(Deaths) ASC;

-- Q16. Find top 5 countries having highest recovered case

SELECT TOP 5
    [Country/Region],
    SUM(Recovered) AS TotalRecoveredCases
FROM 
    [dbo].['Corona Virus Dataset$']
GROUP BY 
    [Country/Region]
ORDER BY 
    SUM(Recovered) DESC;


	


















