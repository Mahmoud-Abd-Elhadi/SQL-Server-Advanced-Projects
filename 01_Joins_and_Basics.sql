/*
=============================================================================
Project:      Advanced SQL Querying & Data Analysis Portfolio
Author:       Mahmoud Abd Elhadi
Description:  A complete reference for T-SQL querying, including Joins, 
              Window Functions, CTEs, Views, and Error Handling.
=============================================================================
*/

USE MyDatabase;
GO

-- =============================================================================
-- SECTION 1: JOINS & SET OPERATIONS
-- Description: Combining data from multiple tables using standard and anti-joins.
-- =============================================================================

SELECT * FROM [dbo].[customers];
SELECT * FROM [dbo].[orders];

-- 1.1 INNER JOIN
SELECT *
FROM customers C JOIN orders O
ON C.id = O.customer_id;

-- 1.2 LEFT JOIN
SELECT *
FROM customers C LEFT JOIN orders O
ON C.id = O.customer_id;

-- 1.3 RIGHT JOIN
SELECT *
FROM customers C RIGHT JOIN orders O
ON C.id = O.customer_id;

-- 1.4 FULL JOIN
SELECT *
FROM customers C FULL JOIN orders O
on C.id = O.customer_id;

-- 1.5 ANTI RIGHT JOIN (Orders with no Customer)
SELECT *
FROM customers C RIGHT JOIN orders O
ON C.id = O.customer_id
WHERE C.id IS NULL;

-- 1.6 ANTI LEFT JOIN (Customers with no Orders)
SELECT *
FROM customers C LEFT JOIN orders O
ON C.id = O.customer_id
WHERE O.customer_id IS NULL;

-- 1.7 ANTI FULL JOIN (Non-matching records from both sides)
SELECT *
FROM customers C FULL JOIN orders O
on C.id = O.customer_id
where C.id IS NULL OR O.customer_id IS NULL;

-- 1.8 SIMULATING INNER JOIN (Using Full Join)
SELECT *
FROM customers C FULL JOIN orders O
ON C.id = O.customer_id
WHERE C.id IS NOT NULL AND O.customer_id IS NOT NULL;

-- 1.9 CROSS JOIN
SELECT * FROM customers C CROSS JOIN orders O;
