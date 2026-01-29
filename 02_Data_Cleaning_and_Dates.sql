-- =============================================================================
-- SECTION 2: SCALAR FUNCTIONS & DATA CLEANING
-- Description: String manipulation (TRIM, REPLACE, SUBSTRING) and Math (ABS).
-- =============================================================================

-- 2.1 FIND NAME CONTAINING SPACES (Using TRIM)
SELECT first_name 
FROM customers
WHERE first_name <> TRIM(first_name);

SELECT first_name 
FROM customers
WHERE LEN(first_name) <> LEN(TRIM(first_name));

-- 2.2 REPLACE FUNCTION
SELECT 
    'report.txt' AS old_report ,
    REPLACE('report.txt' , '.txt' , '.csv') AS new_report;

-- 2.3 SUBSTRING FUNCTION
SELECT SUBSTRING('Mahmoud' , 10 , 5) AS Extracted_String;
SELECT SUBSTRING('mahmoud' , 3 , LEN('mahmoud')) AS Dynamic_Substring;

-- 2.4 ABS FUNCTION
SELECT ABS(-10) AS Absolute_Value;

-- =============================================================================
-- SECTION 3: DATE & TIME INTELLIGENCE
-- Description: Extracting date parts, formatting, and aggregations.
-- =============================================================================
USE SalesDB;
GO

SELECT * FROM [Sales].[Orders];

-- 3.1 DATEPART (Integer Extraction)
SELECT 
    CreationTime ,
    DATEPART(YEAR , CreationTime)     AS Year ,
    DATEPART(MONTH , CreationTime)    AS Month ,
    DATEPART(DAY , CreationTime)      AS Day ,
    DATEPART(HOUR , CreationTime)     AS Hour ,
    DATEPART(MINUTE , CreationTime)   AS Minute ,
    DATEPART(SECOND , CreationTime)   AS Second ,
    DATEPART(QUARTER , CreationTime)  AS Quarter ,
    DATEPART(WEEK , CreationTime)     AS Week
FROM [Sales].[Orders];

-- 3.2 DATENAME (String Extraction)
SELECT 
    CreationTime ,
    DATENAME(YEAR , CreationTime)     AS Year ,
    DATENAME(MONTH , CreationTime)    AS Month ,
    DATENAME(DAY , CreationTime)      AS Day ,
    DATENAME(HOUR , CreationTime)     AS Hour ,
    DATENAME(MINUTE , CreationTime)   AS Minute ,
    DATENAME(SECOND , CreationTime)   AS Second ,
    DATENAME(QUARTER , CreationTime)  AS Quarter ,
    DATENAME(WEEK , CreationTime)     AS Week
FROM [Sales].[Orders];

-- 3.3 DATETRUNC (Truncate to specific precision)
SELECT CreationTime, DATETRUNC(MINUTE , CreationTime) AS trun_minte FROM [Sales].[Orders];
SELECT CreationTime, DATETRUNC(HOUR , CreationTime)   AS trun_hour  FROM [Sales].[Orders];
SELECT CreationTime, DATETRUNC(MONTH , CreationTime)  AS trun_month FROM [Sales].[Orders];
SELECT CreationTime, DATETRUNC(YEAR , CreationTime)   AS trun_year  FROM [Sales].[Orders];

-- 3.4 EOMONTH (End of Month)
SELECT 
    CreationTime ,
    EOMONTH(CreationTime) AS End_Of_Month_Date
FROM [Sales].[Orders];

-- 3.5 Aggregation by Quarter
SELECT 
    DATENAME(QUARTER , CreationTime) as QUARTER ,
    COUNT(orderid) AS counting
FROM [Sales].[Orders]
GROUP BY DATENAME(QUARTER , CreationTime);

-- 3.6 FORMAT (Custom Date Strings)
SELECT 
    CreationTime ,
    FORMAT(CreationTime , 'yyyy-MM-dd') AS [Date],
    FORMAT(CreationTime , 'YYYY')        AS Non,
    FORMAT(CreationTime , 'yyyy')        AS [year],
    FORMAT(CreationTime , 'MM')          AS MM,
    FORMAT(CreationTime , 'MMM')         AS MMM,
    FORMAT(CreationTime , 'MMMM')        AS MMMM,
    FORMAT(CreationTime , 'DD')          AS DD,
    FORMAT(CreationTime , 'dd')          AS dd ,
    FORMAT(CreationTime , 'ddd')         AS ddd,
    FORMAT(CreationTime , 'dddd')        AS dddd
FROM [Sales].[Orders];

-- Complex Date Concatenation
SELECT 
    CreationTime ,
    'Day ' + FORMAT(CreationTime , 'ddd MMM') + ' Q' +DATENAME(QUARTER , CreationTime )
    +FORMAT(CreationTime , ' yyyy HH:mm:ss tt') AS Formatted_Full_Date
FROM [Sales].[Orders];

-- Group by Formatted Date
SELECT 
    FORMAT(CreationTime , 'MMM yyyy') AS Month_Year,
    COUNT(*) AS Order_Count
FROM [Sales].[Orders]
GROUP BY format(CreationTime , 'MMM yyyy');

-- 3.7 Percentage Formatting
SELECT FORMAT(0.33333 , 'P') AS Percentage_Value;

-- =============================================================================
-- SECTION 4: CONVERSION & DATE MATH
-- Description: Casting types and calculating date differences/additions.
-- =============================================================================

-- 4.1 CONVERT & CAST
SELECT CONVERT(INT , '123') convert_to_int;
SELECT CAST('123' AS INT) casting_to_int;
SELECT CAST('2004-8-21' AS DATE)  casting_to_date;
SELECT CAST('Mahmoud' AS VARCHAR) cast_to_varchar;

-- 4.2 DATEADD
SELECT 
    orderdate ,
    DATEADD(year , 2 ,orderdate)      AS add_two_years,
    DATEADD(year , -2 ,orderdate)     AS miunse_two_years,
    DATEADD(month , 10 , orderdate)   AS add_ten_month,
    DATEADD(month , -10 , orderdate)  AS minuse_ten_month,
    DATEADD(day , 20 , orderdate)     AS add_twenty_days,
    DATEADD(month , -20 , orderdate)  AS minuse_twenty_days
FROM [Sales].[Orders];

-- 4.3 DATEDIFF
SELECT 
    EmployeeID ,
    DATEDIFF(YEAR , Birthdate, GETDATE()) AS Age
FROM [Sales].[Employees];

SELECT DATEDIFF(DAY , CAST('2004-9-21' AS date) , CAST('2004-8-21' AS date)) AS Diff_In_Days;

SELECT 
    FORMAT(shipdate , 'yyyy MMM') ,
    AVG(DATEDIFF(DAY , OrderDate , ShipDate)) AS shiping_date_avg
FROM [Sales].[Orders] 
GROUP BY FORMAT(shipdate , 'yyyy MMM');

-- Using LAG with DATEDIFF
SELECT 
    [OrderDate] ,
    LAG(OrderDate) OVER (ORDER BY OrderDate) AS currentdate,
    DATEDIFF(DAY , LAG(OrderDate) OVER (ORDER BY OrderDate) , orderdate) AS diff_day
FROM [Sales].[Orders];

-- 4.4 ISDATE Validation
SELECT ISDATE('2025-08-21') AS Is_Date_1, ISDATE('2025-08') AS Is_Date_2, ISDATE('2025') AS Is_Date_3, ISDATE('21') AS Is_Date_4;

-- Cleaning Invalid Dates
SELECT order_date ,
       ISDATE(order_date) is_date ,
       CASE
            WHEN ISDATE(order_date) = 1 THEN CAST(order_date AS DATE) 
            ELSE NULL
       END NewOrderDate
FROM (
        SELECT '2025-08-21' AS order_date
        UNION
        SELECT '2025-08-22'
        UNION
        SELECT '2025-08-23'
        UNION
        SELECT '2025-08'
    ) T
WHERE ISDATE(order_date) = 1;

-- =============================================================================
-- SECTION 5: HANDLING NULLS & LOGICAL FUNCTIONS
-- Description: Using COALESCE, NULLIF, and CASE statements.
-- =============================================================================

-- 5.1 COALESCE
SELECT 
    CustomerID ,
    Score ,
    Avg(Score) OVER () Avg_Null ,
    Avg(coalesce(Score , 0)) OVER() Avg_not_null
FROM [Sales].[Customers]; 

SELECT
    * ,
    AVG(NEW_SCORE) OVER()                AS WITHOUT_COALESCE_AVG,
    AVG(COALESCE(NEW_SCORE , 0)) OVER() AS COALESCE_AVG 
FROM (
        SELECT 
            CustomerID ,
            FirstName ,
            LastName ,
            Country ,
            CASE 
                WHEN Score = 0  THEN  NULL
                ELSE Score
            END  AS NEW_SCORE
        FROM [Sales].[Customers]
        ) AS NEW_TABLE;

SELECT 
    firstname ,
    lastname ,
    COALESCE(firstname , '') +' '+ COALESCE(lastname , '') AS full_name ,
    COALESCE(score , 0) + 10 AS bonus_scoore
FROM [Sales].[Customers];

-- 5.2 NULLIF
SELECT NULLIF(0,0) AS Null_Result;
SELECT NULLIF(10,20) AS Value_Result;

SELECT 
    orderid ,
    sales ,
    quantity ,
    sales / quantity AS Unit_Price
FROM [Sales].[Orders];

SELECT 
    orderid ,
    sales ,
    quantity ,
    sales / NULLIF(quantity ,0) AS Safe_Unit_Price
FROM [Sales].[Orders];

-- 5.3 Data Policy (LEN vs DATALENGTH)
SELECT 1 ID , 'A' Category  UNION
SELECT 2 , NULL UNION
SELECT 3 , '' UNION
SELECT 4 , ' ' 

SELECT LEN('  ali') AS Len_Trimmed_Space;
SELECT LEN('') AS Len_Empty;
SELECT LEN(' ') AS Len_Space;
SELECT LEN(null) AS Len_Null;

SELECT LEN(TRIM('  ali')) AS Len_Trim_Func;
SELECT LEN(TRIM('')) AS Len_Trim_Empty;
SELECT LEN(TRIM(' ')) AS Len_Trim_Space;
SELECT LEN(TRIM(NULL)) AS Len_Trim_Null;

-- 5.4 CASE STATEMENT
SELECT
    Country ,
    CASE Country
        WHEN 'Germany' THEN 'DE'
        WHEN 'USA' THEN 'USA'
    END country_code
FROM sales.Customers;