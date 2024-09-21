create table [dbo].[netflix_raw](
[show_id] [varchar] (10) primary key,
[type] [varchar] (10) null,
[title] [nvarchar] (300) null,
[director] [varchar] (250) null,
[cast] [varchar] (1000) null,
[country] [varchar] (150) null,
[date_added] [varchar] (20) null,
[release_year] [bigint] null,
[rating] [varchar] (10) null,
[duration] [varchar] (10) null,
[listed_in] [varchar] (100) null,
[description] [varchar] (500) null)

select * from netflix

--Add title Values

select * from netflix_raw where concat(upper(title),type) in(select concat(upper(title),type) from netflix_raw group by upper(title),type having count (*) > 1) order by title;

update netflix_raw
set title = replace(title,'??? ?????','alf mabruk')
where show_id =	's2639';

select * from netflix_raw where show_id = 's2639';

update netflix_raw
set title = replace(title,'????','son of the sea')
where show_id =	's4915';

select * from netflix_raw where show_id = 's4915';



--Remove Duplicates

select show_id, count(*) from netflix_raw group by show_id having count (*) > 1;

select * from netflix_raw where concat(upper(title),type) in(select concat(upper(title),type) from netflix_raw group by upper(title),type having count (*) > 1) order by title;

with cte as(
select *,
row_number() over(partition by title, type order by show_id) as rn from netflix_raw) 
select * from cte where rn = 1;

--updated tables after removing duplicate and null values

with cte as (
select * 
,ROW_NUMBER() over(partition by title , type order by show_id) as rn
from netflix_raw
)
select show_id,type,title,cast(date_added as date) as date_added,release_year
,rating,case when duration is null then rating else duration end as duration,description
into netflix
from cte 



--New table for listed in, director, country,cast

select show_id , trim(value) as listed_in into netflix_listed_in from netflix_raw cross apply string_split(listed_in,',')

select show_id , trim(value) as director into netflix_directors from netflix_raw cross apply string_split(director,',')

select show_id , trim(value) as country into netflix_country from netflix_raw cross apply string_split(country,',')

select show_id , trim(value) as cast into netflix_cast from netflix_raw cross apply string_split(cast,',')



--populate missing null values in country

insert into netflix_country
select  show_id,m.country 
from netflix_raw nr
inner join (
select director,country
from  netflix_country nc
inner join netflix_directors nd on nc.show_id=nd.show_id
group by director,country
) m on nr.director=m.director
where nr.country is null




--- Analysis Started

-- Q-1) For each director, count the number of movies and TV shows they have created in separate columns, 
------) but only for directors who have created both movies and TV shows.

SELECT 
    nd.director,
    count(CASE WHEN n.type = 'Movie' THEN 1 ELSE 0 END) AS Movie_Count,
    count(CASE WHEN n.type = 'TV Show' THEN 1 ELSE 0 END) AS TV_Show_Count
FROM 
    netflix n
JOIN 
    netflix_directors nd ON n.show_id = nd.show_id
GROUP BY 
    nd.director
HAVING 
    count(CASE WHEN n.type = 'Movie' THEN 1 ELSE 0 END) > 0
    AND count(CASE WHEN n.type = 'TV Show' THEN 1 ELSE 0 END) > 0;



--Q-2 which country has highest number of comedy movies

select top 1 nc.country, count(nl.listed_in) as max_genere_comedy from netflix_listed_in nl join netflix_country nc on nl.show_id = nc.show_id where nl.listed_in = 'Comedies' 
group by nc.country order by max_genere_comedy desc;



--3 for each year (as per date added to netflix), which director has maximum number of movies released

with cte as (
select nd.director , year(date_added) as date_year, count(n.show_id) as number_of_movies
from netflix n inner join netflix_directors nd on n.show_id = nd.show_id where n.type = 'movie'
group by nd.director,year(date_added)),

cte2 as (
select *, ROW_NUMBER() over (partition by date_year order by number_of_movies desc, director) as rn
from cte)

SELECT 
    director, date_year, number_of_movies
FROM 
    cte2
WHERE 
    rn = 1
ORDER BY 
    date_year;


--4 what is average duration of movies in each genre

select nl.listed_in, avg(cast(replace(n.duration,'min','')as int)) as avgg_duration from netflix n inner join netflix_listed_in nl on n.show_id = nl.show_id where n.type = 'movie' 
group by nl.listed_in order by avgg_duration desc;


--5  find the list of directors who have created horror and comedy movies both.
-- display director names along with number of comedy and horror movies directed by them 
select * from netflix_listed_in

select nd.director, count(case when nl.listed_in = 'Horror Movies' then n.show_id end) as number_of_horror,
count(case when nl.listed_in = 'comedies' then n.show_id end) as number_of_comedy from netflix  n inner join netflix_listed_in nl on n.show_id = nl.show_id
inner join netflix_directors nd on n.show_id = nd.show_id where n.type = 'movie' and nl.listed_in in ('comedies','Horror Movies')
group by nd.director having count(distinct nl.listed_in) = 2;


--Simple Example for verfication :-
select * from netflix_listed_in where show_id in(select show_id from netflix_directors where director = 'steve Brill') order by listed_in

