USE adashi_staging;

WITH customer_summary AS (
    SELECT
        u.id AS customer_id,
        u.name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        SUM(s.confirmed_amount) / 100.0 AS total_transaction_value_kobo
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY u.id, u.name, u.date_joined
),
clv_calc AS (
    SELECT
        customer_id,
        name,
        tenure_months,
        total_transactions,
        (total_transaction_value_kobo / total_transactions) AS avg_transaction_value,
        -- 0.1% of avg transaction value
        ((total_transactions / tenure_months) * 12 * ((total_transaction_value_kobo / total_transactions) * 0.001)) AS estimated_clv
    FROM customer_summary
    WHERE tenure_months > 0 AND total_transactions > 0
)

SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(estimated_clv, 2) AS estimated_clv
FROM clv_calc
ORDER BY estimated_clv DESC;