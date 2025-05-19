USE adashi_staging;

-- Count of regular savings plans per user
WITH savings_plans AS (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1
    GROUP BY owner_id
),

-- Count of investment plans per user
investment_plans AS (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
),

-- Total deposits converted from kobo to naira (divide by 100)
total_deposits AS (
    SELECT owner_id, SUM(confirmed_amount) / 100.0 AS total_deposits
    FROM savings_savingsaccount
    GROUP BY owner_id
)

-- Final aggregation and join of all metrics per user
SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    sp.savings_count,
    ip.investment_count,
    ROUND(td.total_deposits,2) AS total_deposits
FROM users_customuser u
JOIN savings_plans sp ON u.id = sp.owner_id
JOIN investment_plans ip ON u.id = ip.owner_id
LEFT JOIN total_deposits td ON u.id = td.owner_id  -- some users may have no deposits
ORDER BY td.total_deposits DESC;