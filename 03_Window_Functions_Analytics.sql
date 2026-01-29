-- =============================================================================
-- SECTION 6: WINDOW FUNCTIONS (ADVANCED ANALYTICS)
-- Description: Aggregations, Ranking, Running Totals, and Trend Analysis.
-- =============================================================================

-- 6.1 Basic Window Aggregations
SELECT
     ProductID , SUM(sales) AS Total_Sales_Grouped
FROM [Sales].[Orders]
GROUP BY ProductID;

SELECT
     ProductID , SUM(sales) OVER () Total_Sales
FROM [Sales].[Orders];

SELECT
     ProductID , SUM(sales) OVER (PARTITION BY ProductID) AS Total_Sales
FROM [Sales].[Orders];

SELECT
     ProductID , orderstatus , Sales , SUM(sales) OVER (PARTITION BY ProductID , orderstatus) Total_Sales
FROM [Sales].[Orders];

-- 6.2 Ranking
SELECT
     ProductID , orderstatus , Sales , RANK() OVER (ORDER BY sales ASC) AS Ranking
FROM [Sales].[Orders];

-- 6.3 Percentage Contribution
SELECT 
    ProductID ,
    SUM(Sales) AS SUM_SALES ,
    SUM(SUM(Sales)) OVER() AS TOTAL_SALES ,
    FORMAT( (1.0 * SUM(Sales) / SUM(SUM(Sales)) OVER() ),'P') AS Percentage_Contribution
FROM [Sales].[Orders]
GROUP BY ProductID; 

SELECT 
    ProductID ,
    SUM_SALES ,
    TOTAL_SALES ,
    FORMAT( (1.0 * SUM_SALES / TOTAL_SALES ),'P') AS Percentage_Contribution
FROM (
        SELECT 
            ProductID ,
            SUM(Sales) AS SUM_SALES ,
            SUM(SUM(Sales)) OVER() AS TOTAL_SALES  
        FROM [Sales].[Orders]
        GROUP BY ProductID 
        ) AS NEW;

-- 6.4 Running Totals (ROWS BETWEEN)
SELECT 
    OrderID , ProductID , OrderStatus , OrderDate , Sales ,
    SUM(sales) OVER( PARTITION BY OrderStatus ORDER BY OrderDate 
                    ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS Running_Total_Next2
FROM [Sales].[Orders]; 

SELECT 
    OrderID , ProductID , OrderStatus , OrderDate , Sales ,
    SUM(sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate 
                    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Running_Total_Prev2
FROM [Sales].[Orders];

SELECT 
    OrderID , ProductID , OrderStatus , OrderDate , Sales ,
    SUM(sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate 
                    ROWS 2 PRECEDING) AS Running_Total_Prev2
FROM [Sales].[Orders]; 

SELECT 
    OrderID , ProductID , OrderStatus , OrderDate , Sales ,
    SUM(sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate 
                    ROWS UNBOUNDED PRECEDING) AS Cumulative_Total
FROM [Sales].[Orders]; 

SELECT 
    OrderID , ProductID , OrderStatus , OrderDate ,Sales ,
    SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
                    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS Total_From_Current
FROM [Sales].[Orders] 
ORDER BY OrderStatus , OrderDate;

-- 6.5 Window Function Rules & Common Errors
SELECT
     ProductID ,OrderDate , Sales , SUM(sales) OVER (PARTITION BY orderstatus) AS Total_By_Status
FROM [Sales].[Orders];

SELECT
     ProductID ,OrderDate , Sales , SUM(sales) OVER (PARTITION BY orderstatus) AS Total_By_Status
FROM [Sales].[Orders]
ORDER BY SUM(sales) OVER (PARTITION BY orderstatus) ASC;

SELECT
     ProductID ,OrderDate , Sales , SUM(sales) OVER (PARTITION BY orderstatus) AS Total_By_Status
FROM [Sales].[Orders]
ORDER BY SUM(sales) OVER (PARTITION BY orderstatus);

-- Error Demo (Window Func in WHERE)
SELECT
     ProductID ,OrderDate , Sales , SUM(sales) OVER (PARTITION BY orderstatus) AS Total_By_Status
FROM [Sales].[Orders]
WHERE SUM(sales) OVER (PARTITION BY orderstatus) > 200;

-- Error Demo (Nested Window Func)
SELECT
     ProductID ,OrderDate , Sales , 
     SUM(SUM(sales) OVER (PARTITION BY orderstatus)) OVER (PARTITION BY orderstatus) AS Nested_Window_Func
FROM [Sales].[Orders];

-- 6.6 RANK vs DENSE_RANK vs ROW_NUMBER (Grouped)
SELECT
    CustomerID ,
    SUM(sales) AS sales ,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS Ranking
FROM [Sales].[Orders]
GROUP BY CustomerID;

SELECT
    CustomerID ,
    SUM(sales) AS sales ,
    RANK() OVER (ORDER BY CustomerID DESC) AS Ranking
FROM [Sales].[Orders]
GROUP BY CustomerID;

-- Error Demo (Column not in Group By)
SELECT
    CustomerID ,
    SUM(sales) AS sales ,
    RANK() OVER (ORDER BY sales DESC) AS Ranking
FROM [Sales].[Orders]
GROUP BY CustomerID;

-- 6.7 Partitioned Counts
SELECT 
    CustomerID , OrderID 
FROM [Sales].[Orders];

SELECT
    CustomerID , COUNT(*) OVER (PARTITION BY CustomerID) AS Orders_Per_Customer
FROM [Sales].[Orders];

SELECT
    OrderStatus , COUNT(*) OVER (PARTITION BY OrderStatus) AS Orders_Per_Status
FROM [Sales].[Orders];

-- 6.8 Total Counts
SELECT 
    * , COUNT(*) OVER () AS Total_Customers
FROM sales.Customers;

SELECT 
    * , COUNT(Score) OVER () AS Count_Scores
FROM sales.Customers;

-- 6.9 Percentage Sales Calculation
SELECT 
    OrderID , ProductID , CustomerID  ,OrderStatus , Sales ,
    SUM(Sales) OVER() Total_Sales,
    ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER() * 100 , 2) AS Percentage_sales
FROM [Sales].[Orders];

-- 6.10 Filtering Window Function Results
SELECT *
FROM (
        SELECT 
            OrderID , ProductID , CustomerID  ,OrderStatus , Sales ,
            AVG(Sales) OVER() AS avg_sales
        FROM [Sales].[Orders]
    ) AS new
WHERE Sales > avg_sales;

-- 6.11 Max/Min Window Functions
SELECT 
    OrderID , ProductID , CustomerID  ,OrderStatus , Sales ,
    MAX(Sales) OVER() AS max_sales
FROM [Sales].[Orders];

SELECT *
FROM (
        SELECT 
            OrderID , ProductID , CustomerID  ,OrderStatus , Sales ,
            MAX(Sales) OVER() AS max_sales
        FROM [Sales].[Orders]
        ) AS new
WHERE Sales = max_sales;

SELECT *
FROM (
        SELECT 
            OrderID , ProductID , CustomerID  ,OrderStatus , Sales ,
            MIN(Sales) OVER() AS min_sales
        FROM [Sales].[Orders]
        ) AS new
WHERE Sales = min_sales;

-- 6.12 Moving Averages
SELECT 
     ProductID , OrderDate , Sales , 
    AVG(sales) OVER(PARTITION BY ProductID) AvgByProductID ,
    AVG(sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) AvgByProductIDByOrderdate ,
    AVG(sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) 
    AS AvgByProductIDByOrderdate
FROM [Sales].[Orders];

-- 6.13 Advanced Ranking
SELECT 
     ProductID , OrderDate , Sales , 
     ROW_NUMBER() OVER (ORDER BY Sales DESC) AS RN ,
     RANK()       OVER (ORDER BY Sales DESC) AS RK ,
     DENSE_RANK() OVER (ORDER BY Sales DESC) AS DR
FROM [Sales].[Orders];

-- Filtering Top 2 Customers
SELECT CustomerID
FROM(
        select 
             CustomerID , SUM(Sales) AS TOTAL_SALES,
             ROW_NUMBER() OVER(ORDER BY SUM(Sales) ASC) AS RN
        FROM [Sales].[Orders]
        group by CustomerID
    ) AS NEW
WHERE RN <= 2;

-- Pagination
SELECT 
    ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime) AS RN ,
    *
FROM [Sales].[OrdersArchive];

SELECT * FROM(
        SELECT 
            ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime) AS RN ,
            *
        FROM [Sales].[OrdersArchive]
        ) AS NEW
WHERE RN = 1;

-- 6.14 NTILE (Segmentation)
SELECT 
     ProductID , OrderDate , Sales , 
     NTILE(1) OVER (ORDER BY Sales DESC) AS NT,
     NTILE(2) OVER (ORDER BY Sales DESC) AS NT,
     NTILE(3) OVER (ORDER BY Sales DESC) AS NT,
     NTILE(4) OVER (ORDER BY Sales DESC) AS NT,
     NTILE(5) OVER (ORDER BY Sales DESC) AS NT
FROM [Sales].[OrdersArchive];

SELECT * ,
            CASE NT
                WHEN 1 THEN 'HIGH'
                WHEN 2 THEN 'MED'
                ELSE 'LOW'
            END AS Segment_Name
FROM (
        SELECT 
            OrderID , Sales ,
            NTILE(3) OVER(ORDER BY Sales DESC) AS NT

        FROM [Sales].[Orders]
        ) AS NEW;

-- 6.15 Statistical Ranks (CUME_DIST, PERCENT_RANK)
SELECT 
    * , CONCAT(DISTRANK * 100 , '%') AS Rank_Percentage       
FROM (
        SELECT * ,
            CUME_DIST() OVER (ORDER BY Price DESC) AS DISTRANK
        FROM [Sales].[Products]
        ) AS NEW;

SELECT * , CONCAT(PERRANK * 100 , '%') AS Pct_Rank_Formatted    
FROM (
        SELECT * ,
            PERCENT_RANK() OVER (ORDER BY Price DESC) AS PERRANK
        FROM [Sales].[Products]
        ) AS NEW;

-- 6.16 Trend Analysis (LAG - Month Over Month)
SELECT * ,
         TOTAL_SALES - PREVIOUS_MONTH AS DIFF_MONTH
FROM(
        SELECT 
             MONTH(OrderDate) AS MONTH ,
             SUM(Sales) AS TOTAL_SALES ,
             LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) AS PREVIOUS_MONTH 
        FROM [Sales].[Orders]
        GROUP BY MONTH(OrderDate)
        ) AS NEW;

-- 6.17 Trend Analysis (LEAD - Time Diff)
SELECT 
    CustomerID ,
    AVG(DATE_DIFF) AS AVG_DATE_DIFF
FROM (
        SELECT 
            OrderID , CustomerID , OrderDate ,
            LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS NEXT_DATE ,
            DATEDIFF(DAY , OrderDate , LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) AS DATE_DIFF
        FROM [Sales].[Orders]
        ) AS NEW
GROUP BY CustomerID;

-- 6.18 FIRST_VALUE & LAST_VALUE
SELECT 
    OrderID , ProductID , Sales ,
    FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS F_VALUE ,
    LAST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS L_VALUE
FROM [Sales].[Orders];

SELECT 
    OrderID , ProductID , Sales ,
    FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY SALES) AS FIRST_VALUE ,
    LAST_VALUE(Sales)  OVER(PARTITION BY ProductID ORDER BY SALES
                            ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS LAST_VALUE
FROM [Sales].[Orders]; 

-- =============================================================================
-- SECTION 7: METADATA & SCHEMA INFO
-- Description: Exploring database tables and columns dynamically.
-- =============================================================================

SELECT * FROM INFORMATION_SCHEMA.TABLES;
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

SELECT DISTINCT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS;
