-- =============================================================================
-- SECTION 8: SUBQUERIES & ADVANCED FILTERING
-- Description: Scalar, Correlated, Exists, Any/All operators.
-- =============================================================================

-- 8.1 Scalar Subquery in WHERE
SELECT *
FROM (
        SELECT 
            PRODUCT , Price ,
            AVG(Price) OVER() AS AVERAGE
        FROM [Sales].[Products]
        ) AS NEW
WHERE Price > AVERAGE;

-- 8.2 Subquery vs Window Function Logic
SELECT 
    CustomerID  , 
    SUM(Sales) AS TOTAL_SALES ,
    RANK() OVER(ORDER BY SUM(Sales) DESC) AS Rank_Value
FROM SALES.Orders
GROUP BY CustomerID;

SELECT * ,
          RANK() OVER(ORDER BY TOTAL_SALES DESC) AS Rank_Value
FROM 
(
    SELECT 
        CustomerID  , 
        SUM(Sales) AS TOTAL_SALES 
    FROM SALES.Orders
    GROUP BY CustomerID
) AS NEW;

-- 8.3 Scalar Subquery in SELECT
SELECT 
    ProductID , Product , Price ,
    (SELECT COUNT(*) FROM [Sales].[Orders]) AS Total_Orders_Count  
FROM [Sales].[Products];

-- 8.4 Correlated Subquery
SELECT CUS.* , NEW.COUNTING_ORDER FROM [Sales].[Customers] AS CUS
LEFT JOIN(
        SELECT 
            CustomerID ,
            COUNT(*) AS COUNTING_ORDER
        FROM [Sales].[Orders]
        GROUP BY CustomerID
        ) AS NEW
ON CUS.CustomerID = NEW.CustomerID;

-- 8.5 IN / NOT IN Operators
SELECT 
    ProductID , 
    Price 
FROM [Sales].[Products]
WHERE Price > (SELECT AVG(Price) FROM [Sales].[Products]);

SELECT 
    CustomerID
FROM [Sales].[Customers]
WHERE Country = 'Germany';

SELECT 
    *
FROM [Sales].[Orders]
WHERE CustomerID IN (SELECT CustomerID FROM [Sales].[Customers] WHERE Country = 'Germany');

SELECT * FROM [Sales].[Orders]
WHERE CustomerID IN (SELECT CustomerID FROM [Sales].[Customers] WHERE Country <> 'Germany');

SELECT * FROM [Sales].[Orders]
WHERE CustomerID NOT IN (SELECT CustomerID FROM [Sales].[Customers] WHERE Country = 'Germany');

-- 8.6 ANY / ALL Operators
SELECT 
    EmployeeID ,
    Gender ,
    Salary
FROM [Sales].[Employees]
WHERE Gender = 'M';

SELECT 
    EmployeeID ,
    Gender ,
    Salary
FROM [Sales].[Employees]
WHERE Gender = 'F' 
AND Salary > ANY (SELECT Salary FROM [Sales].[Employees] WHERE Gender = 'M');

SELECT 
    EmployeeID ,
    Gender ,
    Salary
FROM [Sales].[Employees]
WHERE Gender = 'M'
AND Salary > ALL (SELECT Salary FROM [Sales].[Employees] WHERE Gender = 'F');

-- 8.7 EXISTS / NOT EXISTS
SELECT 
    C.CustomerID , COUNT(*) AS COUNTING 
FROM [Sales].[Customers] C
JOIN [Sales].[Orders] O
ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID;

SELECT 
    * ,
    (SELECT COUNT(*) 
     FROM [Sales].[Orders] O 
     WHERE C.CustomerID = O.CustomerID ) AS COUNTING
FROM [Sales].[Customers] C;

SELECT *
FROM [Sales].[Orders] O
WHERE EXISTS ( SELECT * FROM [Sales].[Customers] C
               WHERE Country = 'Germany' 
               AND O.CustomerID = C.CustomerID);

SELECT O.* FROM [Sales].[Orders] O
JOIN [Sales].[Customers] C
ON O.CustomerID = C.CustomerID
WHERE C.Country = 'Germany';

SELECT *
FROM [Sales].[Orders] O
WHERE NOT EXISTS ( SELECT * FROM [Sales].[Customers] C
               WHERE Country = 'Germany' 
               AND O.CustomerID = C.CustomerID);

SELECT O.* FROM [Sales].[Orders] O
JOIN [Sales].[Customers] C
ON O.CustomerID = C.CustomerID
WHERE C.Country <> 'Germany';

-- =============================================================================
-- SECTION 9: COMMON TABLE EXPRESSIONS (CTEs)
-- Description: Standard, Nested, and Recursive CTEs for hierarchy/sequences.
-- =============================================================================

-- 9.1 Simple CTE
WITH SALES_BY_CUSTOMER AS
(
    SELECT 
        CustomerID ,
        SUM(Sales) AS TOTAL_SALES
    FROM [Sales].[Orders]
    GROUP BY CustomerID
)

SELECT 
    C.* ,
    SBC.TOTAL_SALES
FROM [Sales].[Customers] C 
LEFT JOIN SALES_BY_CUSTOMER SBC
ON C.CustomerID = SBC.CustomerID;

-- 9.2 Multiple CTEs
WITH SALES_BY_CUSTOMER AS
(
    SELECT 
        CustomerID ,
        SUM(Sales) AS TOTAL_SALES
    FROM [Sales].[Orders]
    GROUP BY CustomerID
)
, CUSTOMER_BY_LASTDATE AS
(
    SELECT 
        CustomerID ,
        MAX(OrderDate) AS LAST_ADTE
    FROM [Sales].[Orders]
    GROUP BY CustomerID
)

SELECT 
    C.* ,
    SBC.TOTAL_SALES ,
    CBL.LAST_ADTE
FROM [Sales].[Customers] C 
LEFT JOIN SALES_BY_CUSTOMER AS SBC
ON C.CustomerID = SBC.CustomerID
LEFT JOIN CUSTOMER_BY_LASTDATE AS CBL 
ON CBL.CustomerID = SBC.CustomerID;

-- 9.3 Nested CTEs (Customer Segmentation)
WITH CTE_Total_Sales AS
(
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
)
, CTE_Last_Order AS
(
    SELECT
        CustomerID,
        MAX(OrderDate) AS Last_Order
    FROM Sales.Orders
    GROUP BY CustomerID
)
, CTE_Customer_Rank AS
(
    SELECT
        CustomerID,
        TotalSales,
        RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank
    FROM CTE_Total_Sales
)
, CTE_Customer_Segments AS
(
    SELECT
        CustomerID,
        TotalSales,
        CASE 
            WHEN TotalSales > 100 THEN 'High'
            WHEN TotalSales > 80  THEN 'Medium'
            ELSE 'Low'
        END AS CustomerSegments
    FROM CTE_Total_Sales
)
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    cts.TotalSales,
    clo.Last_Order,
    ccr.CustomerRank,
    ccs.CustomerSegments
FROM Sales.Customers AS c
LEFT JOIN CTE_Total_Sales AS cts
    ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order AS clo
    ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank AS ccr
    ON ccr.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segments AS ccs
    ON ccs.CustomerID = c.CustomerID;

-- 9.4 Recursive CTE (Sequence Generation)
WITH Series AS (
    SELECT 
        1 AS MyNumbers

    UNION ALL
-- Recursive Query
    SELECT 
        MyNumbers + 1
    FROM Series
    WHERE MyNumbers < 20
)

SELECT * FROM Series
OPTION (MAXRECURSION 40);

-- Number Sequence
WITH Series AS (
    SELECT 
        100 AS Number

    UNION ALL
 
 SELECT
        Number + 10
    FROM Series
    WHERE Number < 300)

SELECT * FROM Series;

-- 9.5 Recursive CTE (Employee Hierarchy)
WITH CTE_Emp_Hierarchy AS
(
    -- Anchor Query: Top-level employees (no manager)
    SELECT
        EmployeeID,
        FirstName,
        ManagerID,
        1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL
    UNION ALL
    -- Recursive Query: Get subordinate employees and increment level
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        Level + 1
    FROM Sales.Employees AS e
    INNER JOIN CTE_Emp_Hierarchy AS ceh
        ON e.ManagerID = ceh.EmployeeID
)
SELECT *
FROM CTE_Emp_Hierarchy;

-- =============================================================================
-- SECTION 10: VIEWS & TABLE MANAGEMENT (CTAS)
-- Description: Creating Views for simplifying queries and CTAS for snapshots.
-- =============================================================================

-- 10.1 CTE vs VIEW logic
WITH MON_SALES AS 
(
SELECT 
    DATETRUNC(MONTH , OrderDate) AS ORDER_MONTH ,
    SUM(Sales) AS TOTAL_SALSE ,
    COUNT(OrderID) COUNT_ID ,
    SUM(Quantity) COUN_QUANT
FROM [Sales].[Orders] 
GROUP BY DATETRUNC(MONTH , OrderDate) 
)

SELECT
    ORDER_MONTH ,
    TOTAL_SALSE ,
    COUNT_ID ,
    COUN_QUANT ,
    SUM(TOTAL_SALSE) OVER (ORDER BY ORDER_MONTH) AS Total_Sales
FROM MON_SALES;

-- 10.2 Creating Views
IF OBJECT_ID ('Sales.MON_SALES_VIEW' , 'V') IS NOT NULL
    DROP VIEW Sales.MON_SALES_VIEW
GO

CREATE VIEW Sales.MON_SALES_VIEW AS
(
SELECT 
    DATETRUNC(MONTH , OrderDate) AS ORDER_MONTH ,
    SUM(Sales) AS TOTAL_SALSE ,
    COUNT(OrderID) COUNT_ID ,
    SUM(Quantity) COUN_QUANT
FROM [Sales].[Orders]
GROUP BY DATETRUNC(MONTH , OrderDate)
)
--------
SELECT * FROM Sales.MON_SALES_VIEW;

-- Dropping Views
DROP VIEW MON_SALES_VIEW;

-- 10.3 Complex Views (Joins)
IF OBJECT_ID ('Sales.V_Order_Details','V') IS NOT NULL
    DROP VIEW Sales.V_Order_Details
GO
CREATE VIEW Sales.V_Order_Details AS
(
    SELECT 
        o.OrderID,
        o.OrderDate,
        p.Product,
        p.Category,
        COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') AS CustomerName,
        c.Country AS CustomerCountry,
        COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') AS SalesName,
        e.Department,
        o.Sales,
        o.Quantity
    FROM Sales.Orders AS o
    LEFT JOIN Sales.Products AS p ON p.ProductID = o.ProductID
    LEFT JOIN Sales.Customers AS c ON c.CustomerID = o.CustomerID
    LEFT JOIN Sales.Employees AS e ON e.EmployeeID = o.SalesPersonID
)
GO

SELECT * FROM Sales.V_Order_Details;

-- Filtered Views
CREATE VIEW Sales.V_Order_Details_EU AS
(
    SELECT 
        o.OrderID,
        o.OrderDate,
        p.Product,
        p.Category,
        COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') AS CustomerName,
        c.Country AS CustomerCountry,
        COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') AS SalesName,
        e.Department,
        o.Sales,
        o.Quantity
    FROM Sales.Orders AS o
    LEFT JOIN Sales.Products AS p ON p.ProductID = o.ProductID
    LEFT JOIN Sales.Customers AS c ON c.CustomerID = o.CustomerID
    LEFT JOIN Sales.Employees AS e ON e.EmployeeID = o.SalesPersonID
    WHERE c.Country != 'USA'
);
GO

SELECT * FROM Sales.V_Order_Details_EU;

-- 10.4 CTAS (SELECT INTO)
SELECT
    DATENAME(MONTH,[OrderDate]) AS ORDER_DATE ,
    COUNT([OrderID]) AS COUNTING
INTO Sales.MonthlyOrders
FROM [Sales].[Orders]
GROUP BY DATENAME(MONTH,[OrderDate]);

SELECT * FROM Sales.MonthlyOrders;
DROP TABLE Sales.MonthlyOrders;
