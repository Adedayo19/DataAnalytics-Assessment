USE adashi_staging;

WITH customer_tx_summary AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(created_on), MAX(created_on)) + 1 AS active_months
    FROM savings_savingsaccount
    GROUP BY owner_id
),
customer_frequency AS (
    SELECT
        owner_id,
        total_transactions,
        active_months,
        total_transactions * 1.0 / active_months AS avg_tx_per_month,
        CASE
            WHEN total_transactions * 1.0 / active_months >= 10 THEN 'High Frequency'
            WHEN total_transactions * 1.0 / active_months >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_tx_summary
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM customer_frequency
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');