-- Q4: Estimate Customer Lifetime Value (CLV)

WITH customer_txn_summary AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, " ", u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        ROUND(SUM(s.confirmed_amount) / 100.0, 2) AS total_value_naira
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id AND s.confirmed_amount > 0
    WHERE u.is_active = 1
    GROUP BY u.id, u.name, u.date_joined
),
clv_calculation AS (
    SELECT 
        customer_id,
        name,
        tenure_months,
        total_transactions,
        -- estimated_clv = (total_txns / tenure) * 12 * 0.001 * avg_txn_value
        ROUND(
            (total_transactions / NULLIF(tenure_months, 0)) * 12 * 0.001 * 
            (total_value_naira / NULLIF(total_transactions, 0)), 
            2
        ) AS estimated_clv
    FROM customer_txn_summary
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    estimated_clv
FROM clv_calculation
ORDER BY estimated_clv DESC;