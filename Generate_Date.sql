WITH Date_Range AS (
    -- Generate dates and times starting from '2016-09-01 00:00:00'
    SELECT CAST('2016-09-01 00:00:00' AS DATETIME) AS Full_Date
    UNION ALL
    SELECT DATEADD(SECOND, 1, Full_Date)  -- Increment by one second
    FROM Date_Range
    WHERE Full_Date < '2018-12-31 23:59:59'  -- End date and time
)
-- Insert into Date_Dim table
INSERT INTO Date_Dim (Full_Date, Day, Month, Month_Name, Quarter, Year, Day_Of_Week, Week_Of_Year, Hour, Minute, Second, Is_Weekend, Is_Holiday, Season, Time_Period)
SELECT
    Full_Date,
    DAY(Full_Date) AS Day,
    MONTH(Full_Date) AS Month,
    DATENAME(MONTH, Full_Date) AS Month_Name,
    DATEPART(QUARTER, Full_Date) AS Quarter,
    YEAR(Full_Date) AS Year,
    DATENAME(WEEKDAY, Full_Date) AS Day_Of_Week,
    DATEPART(WEEK, Full_Date) AS Week_Of_Year,
    DATEPART(HOUR, Full_Date) AS Hour,
    DATEPART(MINUTE, Full_Date) AS Minute,
    DATEPART(SECOND, Full_Date) AS Second,  -- Extract seconds
    CASE WHEN DATENAME(WEEKDAY, Full_Date) IN ('Saturday', 'Sunday') THEN 'Y' ELSE 'N' END AS Is_Weekend,
    'N' AS Is_Holiday,  -- Placeholder for holidays
    CASE 
        WHEN MONTH(Full_Date) BETWEEN 3 AND 5 THEN 'Spring'
        WHEN MONTH(Full_Date) BETWEEN 6 AND 8 THEN 'Summer'
        WHEN MONTH(Full_Date) BETWEEN 9 AND 11 THEN 'Fall'
        ELSE 'Winter' 
    END AS Season,
    CASE WHEN DATEPART(HOUR, Full_Date) < 12 THEN 'AM' ELSE 'PM' END AS Time_Period
FROM Date_Range
OPTION (MAXRECURSION 0);  -- Allows recursion to run without limit


