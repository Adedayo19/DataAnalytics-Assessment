USE adashi_staging;

WITH last_deposit AS (
    SELECT
        plan_id,
        MAX(created_on) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY plan_id
),
plan_with_activity AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        ld.last_transaction_date,
        DATEDIFF(CURDATE(), ld.last_transaction_date) AS inactivity_days
    FROM plans_plan p
    LEFT JOIN last_deposit ld ON p.id = ld.plan_id
)
SELECT *
FROM plan_with_activity
WHERE inactivity_days > 365;