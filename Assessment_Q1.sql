-- Q1: Identify customers with both a funded savings and a funded investment plan
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS customer_name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100.0, 2) AS total_deposits
FROM users_customuser u
INNER JOIN (
    SELECT DISTINCT owner_id 
    FROM savings_savingsaccount 
    WHERE confirmed_amount > 0
) s_filtered ON s_filtered.owner_id = u.id
INNER JOIN (
    SELECT DISTINCT owner_id 
    FROM plans_plan 
    WHERE amount > 0 AND is_a_fund = 1
) p_filtered ON p_filtered.owner_id = u.id
JOIN savings_savingsaccount s ON s.owner_id = u.id AND s.confirmed_amount > 0
JOIN plans_plan p ON p.owner_id = u.id AND p.amount > 0 AND p.is_a_fund = 1
GROUP BY u.id, u.first_name, u.last_name
ORDER BY total_deposits DESC;