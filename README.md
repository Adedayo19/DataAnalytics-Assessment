# Adashi SQL Assessment

This repository contains SQL solutions to an analytical assessment based on a MySQL database. Each question focuses on extracting insights from customer, savings, and investment data.

## Questions & Solutions

### 1. High-Value Customers with Multiple Products

**Task:** Identify customers who have at least one funded savings plan and one funded investment plan, sorted by total deposits.

**Approach:**
- Created CTEs to filter for regular savings (`is_regular_savings = 1`) and investment plans (`is_a_fund = 1`).
- Aggregated confirmed deposits from the `savings_savingsaccount` table, dividing by 100 to convert from kobo to naira (as the currency stored in kobo).
- Joined user data with CTEs and sorted by total deposits.

### 2. Transaction Frequency Analysis

**Task:** Classify customers into frequency segments based on their average monthly transaction count.

**Approach:**
- Calculated total transaction counts per user.
- Found each user’s first and last transaction date to estimate activity duration in months.
- Grouped users into "High", "Medium", and "Low" frequency categories based on thresholds.

### 3. Account Inactivity Alert

**Task:** Identify all active accounts that have had no inflow transactions in the past 365 days.

**Approach:**
- Queried both `savings_savingsaccount` and `plans_plan` for active accounts.
- Computed days since last inflow transaction using `DATEDIFF`.
- Filtered for inactivity periods over 365 days.

### 4. Customer Lifetime Value (CLV) Estimation

**Task:** Estimate CLV using tenure and transaction history.

**Approach:**
- Calculated account tenure in months using the signup date from `users_customuser`.
- Totaled transactions from `savings_savingsaccount`.
- Used the simplified CLV formula provided:  
  `CLV = (total_transactions / tenure) * 12 * average_profit_per_transaction`

---

# How to Run

### Prerequisites
- MySQL installed locally
- MySQL database imported from `adashi_assessment.sql`

### Steps

1. **Start MySQL server** (if using Homebrew):
   ```bash
   brew services start mysql
   ```
2. **Access MySQL in terminal**:
  ```bash
   mysql -u root -p
   ```
3. **Import the SQL file** (if not already done):
   ```bash
   mysql -u root -p < adashi_assessment.sql
   ```
4. **Verify the database and switch to it:**
  ```sql
    SHOW DATABASES;
    USE adashi_staging;
    SHOW TABLES;
```  
5. **Run queries:**
    - Open the .sql files in your SQL editor or terminal.
    - Execute them while connected to the adashi_staging database.


---
## Challenges Encountered

### 1. Null `name` Field in `users_customuser`
The `name` column in the `users_customuser` table was `NULL` for all users. To address this, I concatenated the `first_name` and `last_name` fields using:

```sql
CONCAT(u.first_name, ' ', u.last_name) AS name
```
This produced a usable full name for presentation and grouping purposes.

### 2. Switching from SQLite to MySQL

I'm more familiar with SQLite, but the provided SQL dump was in MySQL format. This meant I had to adapt to a different syntax (especially for things like date calculations, data types, and MySQL-specific settings in the dump file).

To solve this, I installed MySQL locally on my Mac using Homebrew. This gave me access to the MySQL CLI, where I could import the SQL dump and run queries.



