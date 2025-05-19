# DataAnalytics-Assessment

Welcome to the SQL Proficiency Assessment submission. This repository contains solutions to the four business-driven SQL tasks involving customer behavior, transaction analytics, and value estimation using a relational database.

---

## ✅ Repository Structure

```
DataAnalytics-Assessment/
│
├── Assessment_Q1.sql
├── Assessment_Q2.sql
├── Assessment_Q3.sql
├── Assessment_Q4.sql
└── README.md
```

---

## 📌 Per-Question Explanations

### Q1: High-Value Customers with Multiple Products

**Goal:** Identify customers with both a funded savings and investment plan, ordered by total deposits.

**Approach:**
- Used inner joins on the `users_customuser`, `savings_savingsaccount`, and `plans_plan` tables.
- Filtered savings with `confirmed_amount > 0` and `is_regular_savings = 1`.
- Filtered investments with `amount > 0` and `is_a_fund = 1`.
- Grouped by user and aggregated counts and deposit amounts.
- Ensured amounts were converted from **kobo to naira** using `ROUND(... / 100.0, 2)`.

---

### Q2: Transaction Frequency Analysis

**Goal:** Segment users based on average number of transactions per month.

**Approach:**
- Counted total savings transactions per user.
- Calculated tenure as the difference in months between the first transaction and the current date.
- Computed average monthly transaction rate.
- Categorized frequency:
  - High (≥ 10)
  - Medium (3–9)
  - Low (≤ 2)
- Used `CASE` statements and common table expressions (CTEs) for clarity.

---

### Q3: Account Inactivity Alert

**Goal:** Flag all savings and investment accounts that have had no inflow activity in the past 365 days.

**Approach:**
- Considered active savings if `confirmed_amount > 0`.
- For investments, checked `plans_plan.amount > 0 AND is_a_fund = 1`.
- Used `transaction_date` (savings) and `last_charge_date` (investments) to determine last activity.
- Combined both into a unified dataset and filtered for inactivity using:
  ```sql
  last_transaction_date < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
  ```

---

### Q4: Customer Lifetime Value (CLV) Estimation

**Goal:** Estimate CLV using total transactions, average transaction value, and tenure since signup.

**Approach:**
- Used `date_joined` to calculate tenure in months.
- Aggregated `confirmed_amount` to determine total transaction value (converted from kobo to naira).
- Applied the formula:
  ```
  CLV = (total_transactions / tenure_months) * 12 * 0.001 * avg_transaction_value
  ```
- Used `NULLIF(..., 0)` to safely avoid division-by-zero issues.
- Final result ranks customers by estimated CLV descending.

---

## 🧩 Challenges Faced

1. **Field Uncertainty:**  
   Several date and amount fields across tables had unclear semantics. This was resolved by carefully reviewing column names and selecting the most contextually appropriate ones (e.g., `last_charge_date` for investments).

2. **Division by Zero:**  
   Tenure and transaction counts could be zero, requiring use of `NULLIF(..., 0)` in calculations to prevent errors.

3. **Unit Conversion:**  
   Transaction values in **kobo** required consistent division by 100.0 for correct reporting in **naira**.

4. **Categorical Ordering in SQL:**  
   Used `CASE` in `ORDER BY` to enforce custom frequency category order (High > Medium > Low).

---

## ✅ Final Notes

- All queries are written for **MySQL** and use best practices including CTEs, type-safe division, and clear formatting.
- Code is modular and designed for performance and readability.
- All queries were tested with realistic assumptions based on schema descriptions.

---