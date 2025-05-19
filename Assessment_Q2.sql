-- Q2: Analyze transaction frequency and segment customers accordingly
WITH customer_transactions AS (
    SELECT 
        u.id AS customer_id,
        COUNT(s.id) AS total_transactions,
        EXTRACT(YEAR FROM CURRENT_DATE) * 12 + EXTRACT(MONTH FROM CURRENT_DATE) -
        (EXTRACT(YEAR FROM MIN(s.transaction_date)) * 12 + EXTRACT(MONTH FROM MIN(s.transaction_date))) + 1
        AS tenure_months
    FROM users_customuser u
    JOIN savings_savingsaccount s ON s.owner_id = u.id
    GROUP BY u.id
),
avg_transactions AS (
    SELECT 
        customer_id,
        total_transactions,
        tenure_months,
        ROUND(1.0 * total_transactions / NULLIF(tenure_months, 0), 2) AS avg_txn_per_month
    FROM customer_transactions
),
categorized AS (
    SELECT 
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txn_per_month
    FROM avg_transactions
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
