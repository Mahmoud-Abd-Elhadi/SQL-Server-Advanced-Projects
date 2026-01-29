# 📊 Advanced SQL Analytics Portfolio

![SQL Server](https://img.shields.io/badge/Database-SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Language](https://img.shields.io/badge/Language-T--SQL-blue?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Data_Analysis_%26_Engineering-success?style=for-the-badge)

## 📌 Executive Summary
This repository serves as a technical portfolio demonstrating advanced proficiency in **Microsoft SQL Server (T-SQL)**. It showcases the ability to transform raw data into actionable business insights through complex querying, optimization techniques, and automated procedures.

The project simulates real-world scenarios faced by Data Analysts and Engineers, including **Customer Segmentation (RFM)**, **Sales Trend Analysis**, **Data Cleansing Pipelines**, and **Automated Reporting**.

---

## 🛠️ Key Technical Competencies
| Skill Area | Concepts Applied |
| :--- | :--- |
| **Advanced Analytics** | Window Functions (`RANK`, `DENSE_RANK`, `NTILE`), Moving Averages, Cumulative Sums |
| **Trend Analysis** | Month-Over-Month (MoM) Growth, Year-Over-Year (YoY), Time-Series Analysis (`LAG`, `LEAD`) |
| **Data Engineering** | recursive CTEs, Hierarchical Data Processing, Views, CTAS, Stored Procedures |
| **Data Quality** | `TRY...CATCH` Error Handling, NULL Handling Strategies (`COALESCE`), Data Type Validation |

---

## 📂 Project Modules & Business Scenarios

### 1️⃣ [Data Consolidation & Integrity](./01_Joins_and_Basics.sql)
**Business Scenario:** Combining disparate data sources (Customers & Orders) while identifying data gaps.
- **Techniques:** Inner, Left, Right, Full Joins.
- **Highlight:** Used **Anti-Joins** to perform "Churn Analysis" (identifying customers who haven't purchased) and integrity checks for orphaned orders.

### 2️⃣ [Data Cleaning & Transformation (ETL)](./02_Data_Cleaning_and_Dates.sql)
**Business Scenario:** Preparing messy raw data for BI reporting.
- **Techniques:** String manipulation (`TRIM`, `REPLACE`), Date standardization (`FORMAT`, `EOMONTH`).
- **Highlight:** Implemented dynamic logic to handle NULL values in financial calculations to prevent reporting errors.

### 3️⃣ [Financial Modeling & Trend Analysis](./03_Window_Functions_Analytics.sql) ⭐ *(Core Module)*
**Business Scenario:** "How are we performing compared to last month?" & "Who are our top 20% customers?"
- **Techniques:** - **Running Totals:** Calculated cumulative sales per region.
    - **MoM Growth:** Used `LAG()` to calculate the percentage change in revenue.
    - **Segmentation:** Used `NTILE(3)` to group customers into High, Medium, and Low value (RFM approach).
    - **Pareto Principle:** Identified products driving the top 80% of revenue.

### 4️⃣ [Hierarchical Data & Optimization](./04_CTEs_Views_Subqueries.sql)
**Business Scenario:** Managing complex organizational structures and modularizing code.
- **Techniques:**
    - **Recursive CTEs:** Built an employee organizational chart (Manager vs. Subordinate) dynamically.
    - **Views:** Created security layers to abstract complex joins from end-users.

### 5️⃣ [Automation & Robust Execution](./05_Stored_Procedures.sql)
**Business Scenario:** Automating the "Monthly Sales Summary" report generation.
- **Techniques:** Stored Procedures with dynamic parameters.
- **Highlight:** Implemented robust **Error Handling** (`TRY...CATCH`) to log failures and ensure pipeline reliability.

---

## 🚀 How to Use
1. Clone this repository.
2. Execute the scripts in `SQL Server Management Studio (SSMS)`.
3. The scripts are designed to run sequentially or as standalone modules.

---
### 📬 Contact & Connect
I am currently open to opportunities as a Data Analyst or SQL Developer. Feel free to reach out!

* 💼 **LinkedIn:** [Mahmoud Abd Elhadi](https://www.linkedin.com/in/mahmoud-abd-elhadi-9477a9261/)
* 📧 **Email:** [My Email](mailto:mahmoudhadi2184@gmail.com)
* 🐈 **GitHub:** [My Profile](https://github.com/mahmoudhadi2184-collab)
*  📞 **Mobile / WhatsApp:** [+20 1097580203](https://wa.me/201097580203)
