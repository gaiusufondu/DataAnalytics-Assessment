-- Q3: Find active savings or investment accounts with no transactions in the last 365 days

WITH recent_savings AS (
    SELECT 
        s.plan_id,
        s.owner_id,
        'Savings' AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount > 0
    GROUP BY s.plan_id, s.owner_id
),
recent_investments AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        'Investment' AS type,
        MAX(p.last_charge_date) AS last_transaction_date
    FROM plans_plan p
    WHERE p.amount > 0 AND p.is_a_fund = 1
    GROUP BY p.id, p.owner_id
),
all_accounts AS (
    SELECT * FROM recent_savings
    UNION ALL
    SELECT * FROM recent_investments
)
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM all_accounts
WHERE last_transaction_date < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
ORDER BY inactivity_days DESC;
