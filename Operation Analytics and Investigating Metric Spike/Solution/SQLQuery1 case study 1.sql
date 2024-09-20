
select * from job_data$;


--Jobs Reviewed Over Time:
--Objective: Calculate the number of jobs reviewed per hour for each day in November 2020.
--Your Task: Write an SQL query to calculate the number of jobs reviewed per hour for each day in November 2020.

select count(distinct job_id)/(30*24) as number_of_jobs from job_data$ where ds between '2020-11-01' and '2020-11-30';


--Throughput Analysis:
--Objective: Calculate the 7-day rolling average of throughput (number of events per second).
--Your Task: Write an SQL query to calculate the 7-day rolling average of throughput. Additionally, explain whether you prefer using the daily metric or the 7-day rolling average for throughput, and why.

SELECT ds,number_of_jobs,
    AVG(number_of_jobs) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS throughput_avg_roll
FROM (SELECT 
        CAST(ds AS DATE) AS ds,
        COUNT(DISTINCT job_id) AS number_of_jobs
    FROM 
        job_data$
    WHERE 
        ds BETWEEN '2020-11-01' AND '2020-11-30'
    GROUP BY 
        CAST(ds AS DATE)
) AS daily_counts
ORDER BY 
    ds;

--Language Share Analysis:
--Objective: Calculate the percentage share of each language in the last 30 days.
--Your Task: Write an SQL query to calculate the percentage share of each language over the last 30 days.

select language, number_of_jobs, 100 * number_of_jobs/ total_jobs as percent_share_jobs from
(select language, count(distinct job_id) as number_of_jobs from job_data$ group by language)a cross join 
(select count(distinct job_id) as total_jobs from job_data$)b;


--Duplicate Rows Detection:
--Objective: Identify duplicate rows in the data.
--Your Task: Write an SQL query to display duplicate rows from the job_data table.

select * from(select *, ROW_NUMBER() over (partition by  ds, job_id, actor_id, event, language, time_spent, org order by (select null)) as rownum from job_data$) as a where rownum > 1;







