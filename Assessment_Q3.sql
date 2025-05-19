USE adashi_staging;

-- Get the last transaction date per plan
WITH last_deposit AS (
    SELECT
        plan_id,
        MAX(created_on) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY plan_id
),

-- Combine plan metadata with last activity and compute inactivity duration
plan_with_activity AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        -- Classify plan type based on flags
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
        END AS type,
        ld.last_transaction_date,
        -- Days since last transaction
        DATEDIFF(CURDATE(), ld.last_transaction_date) AS inactivity_days
    FROM plans_plan p
    LEFT JOIN last_deposit ld ON p.id = ld.plan_id
    -- Include only Savings or Investment plans
    WHERE p.is_regular_savings = 1 OR p.is_a_fund = 1
)

-- Filter plans inactive for over a year
SELECT *
FROM plan_with_activity
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC;