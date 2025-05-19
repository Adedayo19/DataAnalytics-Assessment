USE adashi_staging;

-- Summarize user tenure and transaction history
WITH customer_summary AS (
    SELECT
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        -- Convert from kobo to naira
        SUM(s.confirmed_amount) / 100.0 AS total_transaction_value_naira
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY u.id, u.name, u.date_joined
),

-- Calculate average transaction value and estimated CLV
clv_calc AS (
    SELECT
        customer_id,
        name,
        tenure_months,
        total_transactions,
        (total_transaction_value_naira / total_transactions) AS avg_transaction_value,
        -- CLV = Monthly frequency × 12 × 0.1% of avg transaction value
        ((total_transactions / tenure_months) * 12 * ((total_transaction_value_naira / total_transactions) * 0.001)) AS estimated_clv
    FROM customer_summary
    WHERE tenure_months > 0 AND total_transactions > 0
)

-- Final CLV output
SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(estimated_clv, 2) AS estimated_clv
FROM clv_calc
ORDER BY estimated_clv DESC;