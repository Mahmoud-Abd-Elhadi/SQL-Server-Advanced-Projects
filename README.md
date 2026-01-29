# 🚀 SQL Server Advanced Analytics Portfolio

## 📌 Overview
This repository demonstrates advanced data manipulation and analytical skills using **Microsoft SQL Server (T-SQL)**. It contains a collection of optimized scripts designed to solve real-world business problems, ranging from data cleaning to complex trend analysis.

## 📂 Project Structure

### 1️⃣ [Joins & Set Operations](./01_Joins_and_Basics.sql)
- **Goal:** Combining datasets effectively.
- **Techniques:** Inner, Left, Right, Full, and Anti-Joins.
- **Key Insight:** Using Anti-Joins for data integrity checks (e.g., finding customers without orders).

### 2️⃣ [Data Cleaning & Date Intelligence](./02_Data_Cleaning_and_Dates.sql)
- **Goal:** Preparing raw data for analysis.
- **Techniques:** `TRIM`, `COALESCE`, `NULLIF`, `DATEPART`, `DATEDIFF`.
- **Key Insight:** Handling NULLs dynamically and calculating shipping durations.

### 3️⃣ [Advanced Window Functions](./03_Window_Functions_Analytics.sql) 💎 *(Core Module)*
- **Goal:** Performing complex aggregations without collapsing rows.
- **Techniques:**
  - **Ranking:** `ROW_NUMBER`, `RANK`, `DENSE_RANK`.
  - **Trend Analysis:** `LAG` & `LEAD` (Month-over-Month Growth).
  - **Aggregations:** Running Totals (Cumulative Sums) & Moving Averages.
  - **Segmentation:** `NTILE` for customer grouping (RFM Analysis).

### 4️⃣ [CTEs, Views & Subqueries](./04_CTEs_Views_Subqueries.sql)
- **Goal:** Simplifying complex logic and modularizing code.
- **Techniques:**
  - **Recursive CTEs:** Generating hierarchies (Org Charts) and number sequences.
  - **Nested CTEs:** Breaking down logic for customer segmentation.
  - **Views:** Creating abstraction layers for reporting.

### 5️⃣ [Stored Procedures & Error Handling](./05_Stored_Procedures.sql)
- **Goal:** Automating tasks and ensuring robust execution.
- **Techniques:** Dynamic parameters, `TRY...CATCH` blocks for error logging, and business logic encapsulation.

---

## 🛠️ Tech Stack
- **Database:** Microsoft SQL Server
- **Language:** T-SQL
- **Concepts:** Window Functions, CTEs, Data Cleaning, Performance Optimization.

---
*Created by [Mahmoud Abd Elhadi]*
