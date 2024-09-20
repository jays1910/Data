create database Investigating_Metric_Spike;

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE' 
  AND TABLE_CATALOG = 'Investigating_Metric_Spike';

select * from users$;
select * from events$;
select * from email_events$;



--Weekly User Engagement:
--Objective: Measure the activeness of users on a weekly basis.
--Your Task: Write an SQL query to calculate the weekly user engagement.

select count(distinct user_id) as active_user, dateadd(week,datediff(week,0,created_at),0) as week_date 
from users$ group by DATEADD(week, DATEDIFF(week, 0, created_at), 0) order by week_date;


--User Growth Analysis:
--Objective: Analyze the growth of users over time for a product.
--Your Task: Write an SQL query to calculate the user growth for the product.


WITH MonthlyUserCounts AS (
    SELECT
        DATEADD(month, DATEDIFF(month, 0, created_at), 0) AS month_date,
        COUNT(DISTINCT user_id) AS user_count
    FROM users$
    GROUP BY DATEADD(month, DATEDIFF(month, 0, created_at), 0)
),
Growth AS (
    SELECT
        month_date,
        user_count,
        LAG(user_count) OVER (ORDER BY month_date) AS prev_month_user_count
    FROM MonthlyUserCounts
)
SELECT
    month_date,
    user_count,
    prev_month_user_count,
    user_count - ISNULL(prev_month_user_count, 0) AS growth
FROM Growth
ORDER BY month_date;


--Weekly Retention Analysis:
--Objective: Analyze the retention of users on a weekly basis after signing up for a product.
--Your Task: Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.

SELECT
  DATEADD(WEEK, DATEDIFF(WEEK, 0, u.created_at), 0) AS signup_week,
  DATEADD(WEEK, DATEDIFF(WEEK, 0, e.occurred_at), 0) AS retention_week,
  COUNT(DISTINCT e.user_id) AS retained_users
FROM
  users$ u
LEFT JOIN
  events$ e ON u.user_id = e.user_id
          AND DATEADD(WEEK, DATEDIFF(WEEK, 0, e.occurred_at), 0) >= DATEADD(WEEK, DATEDIFF(WEEK, 0, u.created_at), 0)
GROUP BY
  DATEADD(WEEK, DATEDIFF(WEEK, 0, u.created_at), 0),
  DATEADD(WEEK, DATEDIFF(WEEK, 0, e.occurred_at), 0)
ORDER BY
  signup_week, retention_week;



--Weekly Engagement Per Device:
--Objective: Measure the activeness of users on a weekly basis per device.
--Your Task: Write an SQL query to calculate the weekly engagement per device.

SELECT 
    DATEADD(WEEK, DATEDIFF(WEEK, 0, occurred_at), 0) AS week_start_date, 
    device, COUNT(DISTINCT user_id) AS active_users_count 
FROM 
    events$
GROUP BY 
    DATEADD(WEEK, DATEDIFF(WEEK, 0, occurred_at), 0), device 
ORDER BY 
    DATEADD(WEEK, DATEDIFF(WEEK, 0, occurred_at), 0), device;


--Email Engagement Analysis:
--Objective: Analyze how users are engaging with the email service.
--Your Task: Write an SQL query to calculate the email engagement metrics.


SELECT action, COUNT(DISTINCT user_id) AS unique_users_count, COUNT(*) AS total_actions_count 
FROM email_events$ GROUP BY action ORDER BY action;

