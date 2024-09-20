create table df_orders (
[order_id] int primary key,
[order_date] date, 
[ship_mode] varchar(20), 
[segment] varchar(20), 
[country] varchar(20), 
[city] varchar(20),
[state] varchar(20), 
[postal_code] varchar(20), 
[region] varchar(20), 
[category] varchar(20), 
[sub_category] varchar(20),
[product_id] varchar(50), 
[quantity] int, 
[discount] decimal(7,2), 
[sale_price] decimal(7,2), 
[profit] decimal(7,2));

select * from df_orders;



--Find the top 10 highest revenue-generating products.

select top 10 product_id,sum(sale_price) as sales from df_orders group by product_id order by sales desc; 

--Find the top 5 highest-selling products in each region.

select region, product_id, sales,rn
from 
(select region, product_id, sum(sale_price) as sales, row_number() over(partition by region order by sum(sale_price) desc) as rn
from df_orders group by region, product_id) as ranked_sales
where rn <= 5;

--Compare month-over-month sales growth for 2022 and 2023 (e.g., January 2022 vs January 2023).

with cte as (
select year(order_date) as order_year, month(order_date) as order_month, sum(sale_price) as sales from df_orders group by year(order_date), month(order_date))
select order_month, sum(case when order_year = 2022 then sales else 0 end) as sales_2022, sum(case when order_year = 2023 then sales else 0 end) as sales_2023 from cte
group by order_month order by order_month;

--For each product category, identify which month had the highest sales.

with cte as(
select category, FORMAT(order_date, 'yyyy-MM') as month, sum(sale_price) as sales from df_orders group by category, FORMAT(order_date, 'yyyy-MM'))
select category, month, sales from(select category, month, sales , ROW_NUMBER() over(partition by category order by sales desc) as rn from cte) subquery
where rn = 1;


--Identify the sub-category with the highest growth in profit in 2023 compared to 2022.

with cte as(
select sub_category, year(order_date) as order_year, sum(sale_price) as sales from df_orders group by sub_category,YEAR(order_date)), cte2 as (
select sub_category, sum(case when order_year = 2022 then sales else 0 end) as sales_2022, sum(case when order_year = 2023 then sales else 0 end) as sales_2023 from cte group by sub_category)
select top 1 *, (sales_2023 - sales_2022) from cte2 order by (sales_2023 - sales_2022) desc;

