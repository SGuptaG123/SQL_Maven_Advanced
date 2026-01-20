Create database AnkitBansalClass

Use AnkitBansalClass

--28-Dec-2025----1--------------Day 1  ICC Points Table------------------------------

create table icc_world_cup(
							Team_1 Varchar(20),
							Team_2 Varchar(20),
							Winner Varchar(20)
							);

Truncate table icc_world_cup

INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;

With CricketCTEs as( 
			Select	Team_1 as Team_Name, 1 as Matches_Played,
					Case when Team_1 = Winner then 1 else 0 end as no_of_wins,
					Case when Team_1 <> Winner then 1 else 0 end as no_of_losses
			From	ICC_World_Cup

			Union All

			Select	Team_2 as Team_Name, 1 as Matches_Played,
					Case when Team_2 = Winner then 1 else 0 end as no_of_wins,
					Case when Team_2 <> Winner then 1 else 0 end as no_of_losses
			From	ICC_World_Cup)

Select	Team_Name,  Sum(Matches_Played) as Matches_Played, Sum(no_of_wins) as no_of_wins , Sum(no_of_losses) as no_of_losses
From	CricketCTEs
Group by Team_Name




--28-Dec-2025---1---------------------Day 2 - Self Join - Employee Manager Hierarchy----------------------------
--Find Manager with Salary more than their managers Salary 

create table emp(emp_id int,emp_name varchar(10),salary int ,manager_id int);

insert into emp values(1,'Ankit',10000,4);
insert into emp values(2,'Mohit',15000,5);
insert into emp values(3,'Vikas',10000,4);
insert into emp values(4,'Rohit',5000,2);
insert into emp values(5,'Mudit',12000,6);
insert into emp values(6,'Agam',12000,2);
insert into emp values(7,'Sanjay',9000,2);
insert into emp values(8,'Ashish',5000,2);

Select * from emp;

Select		e1.emp_id, e1.emp_name, e1.salary, e1.manager_id,
			m1.emp_name as manager_name, m1.salary as manager_salary
from		emp e1
Left Join	emp m1
			on e1.manager_id = m1.emp_id
Where		e1.salary > m1.salary


--28-Dec-2025-----1-------------------Day 3 - New and Repeat Customer----------------------------
--Find New and Repeat customer from the customer orders table


create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

Truncate Table customer_orders
insert into customer_orders values
				(1,100,cast('2022-01-01' as date),2000),
				(2,200,cast('2022-01-01' as date),2500),
				(3,300,cast('2022-01-01' as date),2100),
				(4,100,cast('2022-01-02' as date),2000),
				(5,400,cast('2022-01-02' as date),2200),
				(6,500,cast('2022-01-02' as date),2700),
				(7,100,cast('2022-01-03' as date),3000),
				(8,400,cast('2022-01-03' as date),1000),
				(9,600,cast('2022-01-03' as date),3000);

select * from customer_orders;

with FirstOrdered as (
					Select customer_id, min(order_date) as first_date
					from customer_orders
					Group by customer_id),
	 prior_query as (
					select co.*, fo.first_date,
							case when co.order_date = first_date then 1 else 0 end as NewCustomer,
							case when co.order_date <> first_date then 1 else 0 end as RepeatCustomer
					from customer_orders as co
					join FirstOrdered as fo
					on co.customer_id = fo.customer_id)

Select order_date, sum(NewCustomer) NewCustomer, sum(RepeatCustomer) RepeatCustomer
from prior_query
Group by order_date
order by order_date

------------Other alternatives using window functions----

Select a.order_date,
		Sum(Case when a.order_date = a.first_order_date then 1 else 0 end) as new_customer,
		Sum(Case when a.order_date != a.first_order_date then 1 else 0 end) as repeat_customer
from(
	Select customer_id, order_date, min(order_date) over(partition by customer_id) as first_order_date 
	from customer_orders) a 
group by a.order_date;



SELECT a.order_date, 
		SUM(CASE WHEN a.cust_order_row = 1 THEN 1 ELSE 0 END) AS new_customers, 
		SUM(CASE WHEN a.cust_order_row <> 1 THEN 1 ELSE 0 END) AS repeat_customers 
FROM
	(SELECT order_date, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS cust_order_row 
	FROM customer_orders) a 
GROUP BY a.order_date;



--29-Dec-2025---2---------------------Day 4 - Most Visited Floor----------------------------

create table entries ( 
			name varchar(20),
			address varchar(20),
			email varchar(20),
			floor int,
			resources varchar(10));

insert into entries values 
			('A','Bangalore','A@gmail.com',1,'CPU'),
			('A','Bangalore','A1@gmail.com',1,'CPU'),
			('A','Bangalore','A2@gmail.com',2,'DESKTOP'),
			('B','Bangalore','B@gmail.com',2,'DESKTOP'),
			('B','Bangalore','B1@gmail.com',2,'DESKTOP'),
			('B','Bangalore','B2@gmail.com',1,'MONITOR');

Select * from entries;

With distinct_resources as	(Select distinct name, resources from entries),
		 agg_resources		as	(Select name, STRING_AGG(resources, ', ') as resources_used from distinct_resources group by name),
		 tot_vst			as	(Select name, count(1) as total_visits from entries group by name),
		 floorRank			as	(Select	name, floor as most_visited_floor,
									RANK() over (partition by floor order by Count(1) DESC) as flr_rnk
									from	entries
									Group by name, floor)


Select	fr.name, tv.total_visits, fr.most_visited_floor,
		ar.resources_used
from	floorRank fr
		left join tot_vst tv on (fr.name = tv.name)
		left join agg_resources ar on (fr.name = ar.name)
where	fr.flr_rnk =1


--31-Dec-2025---3---------------------Day 5 - Pivot and Unpivot the data----------------------------

create table emp_compensation (
						emp_id int,
						salary_component_type varchar(20),
						val int);

insert into emp_compensation values 
					 (1,'salary',10000),(1,'bonus',5000),(1,'hike_percent',10),
					 (2,'salary',15000),(2,'bonus',7000),(2,'hike_percent',8),
					 (3,'salary',12000),(3,'bonus',6000),(3,'hike_percent',7);

select * from emp_compensation;

with emp_pivot as (
								Select emp_id,
											Sum(case when salary_component_type = 'salary' then val else Null end) as  salary,
											Sum(case when salary_component_type = 'bonus' then val else Null end) as  bonus,
											Sum(case when salary_component_type = 'hike_percent' then val else Null end) as  hike_percent
								from emp_compensation
								group by emp_id),
		emp_unpivot as (
								Select emp_id, 'salary' as salary_component, salary as val from emp_pivot
								union all
								Select emp_id, 'bonus' as salary_component, bonus as val from emp_pivot
								union all
								Select emp_id, 'hike_percent' as salary_component, hike_percent as val from emp_pivot)

Select * from emp_unpivot
order by emp_id


--31-Dec-2025----4--------------------Day 6 - Amazon Interview Question----------------------------
--Write a query to provide the date for nth occurance of sunday in future from given date
--Sunday				-1
--Monday			-2
--Tuesday			-3
--Wednesday		-4
--Thurday			-5
--Friday				-6
--Saturday			-7


declare @today_date date;
declare @n int;
declare @looking_day as int;
set @today_date = '2025-12-31'; -- wednesday
set @n = 2;
set @looking_day = 5

Select DATEPART(WEEKDAY, @today_date)
Select DateAdd(DAY,  7 + @looking_day - DATEPART(WEEKDAY, @today_date), @today_date)
Select DATEADD(Week, @n-1, DateAdd(DAY,  7 + @looking_day - DATEPART(WEEKDAY, @today_date), @today_date))

-- Solving different way ----------------------------
Select Top 5 * FROM master.dbo.spt_values v
WHERE v.type = 'P'
ORDER BY v.number

Select DatePart(Weekday, getDate())
Select DateAdd(Day, 1, getDate())
Select DateAdd(Day, 1, Cast(getDate() as Date))
Select (7 - DATEPART(WEEKDAY, GETDATE()) + 7) % 7
Select DateAdd(Day, (1 - DATEPART(WEEKDAY, GETDATE()) + 7) % 7, Cast(getDate() as Date))
select DATEADD(WEEK, 1, GetDate())
select DATEADD(WEEK, 1, DateAdd(Day, (1 - DATEPART(WEEKDAY, GETDATE()) + 7) % 7, Cast(getDate() as Date)))

select DateName(weekday, DATEADD(WEEK, 1, DateAdd(Day, (1 - DATEPART(WEEKDAY, GETDATE()) + 7) % 7, Cast(getDate() as Date))))


declare @date_header varchar(50);
set @date_header = 'Upcoming ' + DateName(weekday, DATEADD(WEEK, 1, DateAdd(Day, (1 - DATEPART(WEEKDAY, GETDATE()) + 7) % 7, Cast(getDate() as Date)))) + 's'
Select  @date_header 



WITH NextMondays AS (
						SELECT TOP 6 DATEADD(WEEK, v.number,  DATEADD(DAY, (2 - DATEPART(WEEKDAY, GETDATE()) + 7) % 7, CAST(GETDATE() AS DATE))) AS MondayDate
						FROM master.dbo.spt_values v
						WHERE v.type = 'P'
						ORDER BY v.number)
SELECT *
FROM NextMondays;


declare @week_num int;
set @week_num = 2

Select Top 5 DATEADD(WEEK, v.number, DateAdd(Day, (@week_num - DATEPART(WEEKDAY, GETDATE()) + 7) % 7, Cast(getDate() as Date))) as upcomingSaturdays
FROM master.dbo.spt_values v
WHERE v.type = 'P'
ORDER BY v.number


--1-Jan-2026------5------------------Day 7 - Pareto Principal----------------------------
-- how a 20% of product responsible for 80% of Sales

CREATE TABLE orders(
	row_id float NULL,
	order_id varchar(255) NULL,
	order_date datetime NULL,
	ship_date datetime NULL,
	ship_mode varchar(255) NULL,
	customer_id varchar(255) NULL,
	customer_name varchar(255) NULL,
	segment varchar(255) NULL,
	country varchar(255) NULL,
	city varchar(255) NULL,
	state varchar(255) NULL,
	postal_code float NULL,
	region varchar(255) NULL,
	product_id varchar(255) NULL,
	category varchar(255) NULL,
	sub_category varchar(255) NULL,
	product_name varchar(255) NULL,
	sales float NULL,
	quantity float NULL,
	discount float NULL,
	profit float NULL
) ;

Select * from orders;

with product_wise_sales as (Select product_id, sum(sales) as total_sales
													from orders
													Group by product_id),
		running_Sales_total as (
													Select product_id, total_sales,
																Sum(total_sales) over (order by total_sales desc rows between unbounded preceding  and  0 preceding) as running_total
													from product_wise_sales)
		

Select * from running_Sales_total
where running_total < (Select sum(sales)*.8 from orders)



--2-Jan-2026----6--------------------Day 8 - Friends score----------------------------
--Write a query to find PersonID, Name, number of friends, sum of marks of a person who have friends with total score greater than 100

Create table friend (pid int, fid int);
insert into friend (pid , fid ) values ('1','2');
insert into friend (pid , fid ) values ('1','3');
insert into friend (pid , fid ) values ('2','1');
insert into friend (pid , fid ) values ('2','3');
insert into friend (pid , fid ) values ('3','5');
insert into friend (pid , fid ) values ('4','2');
insert into friend (pid , fid ) values ('4','3');
insert into friend (pid , fid ) values ('4','5');

create table person (PersonID int,	Name varchar(50),	Score int);
insert into person(PersonID,Name ,Score) values('1','Alice','88');
insert into person(PersonID,Name ,Score) values('2','Bob','11');
insert into person(PersonID,Name ,Score) values('3','Devis','27');
insert into person(PersonID,Name ,Score) values('4','Tara','45');
insert into person(PersonID,Name ,Score) values('5','John','63');

select * from person;
select * from friend;

Select pid,  Count(*)  as friend_count, STRING_AGG(Name, ', ') as friend_list, sum(score) as total_score
from friend f
Join person p
		on (f.fid  = p.PersonID)
Group by pid
having sum(score) >= 100


--3-Jan-2026---7---------------------Day 9 - Where vs having clause----------------------------
--Where clause is used when we want to apply filters on row level
--Having clause is used when we want to apply the filters on aggregated values

create table emp(emp_id int,emp_name varchar(10),salary int ,manager_id int);

insert into emp values(1,'Ankit',10000,4);
insert into emp values(2,'Mohit',15000,5);
insert into emp values(3,'Vikas',10000,4);
insert into emp values(4,'Rohit',5000,2);
insert into emp values(5,'Mudit',12000,6);
insert into emp values(6,'Agam',12000,2);
insert into emp values(7,'Sanjay',9000,2);
insert into emp values(8,'Ashish',5000,2);

select * from emp;

Select * from emp
where salary > 10000

Select manager_id, AVG(salary)  average_salary_managerwise
from emp
Group by manager_id
Having AVG(salary)  >10000

Select manager_id, AVG(salary)  average_salary_managerwise
from emp
where salary > 10000
Group by manager_id
Having AVG(salary)  >10000


--3-Jan-2026----7--------------------Day 10 - Leetcode hardest problem----------------------------
/* Write a sql query to find the cancellation rate of requests with unbanned users.
	(both client and driver must not be banned) each day between '2013-10-01 and 2013-10-03'
	Round cancellation to two decimal places.

	The cancellation rate is computed by dividing the number of cancelled (by client and driver)
	requests with unbanned users by total number of requests with unbanned users on that day.
*/

Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
Create table Users (users_id int, banned varchar(50), role varchar(50));

insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');

insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');

Select * from Trips
Select * from Users;

--Retake/Revision on 4 Jan 2025 
with trip_details as (
									Select t.request_at, count(1) as total_trip,
												Sum(Case when t.status like 'cancelled%' then 1 else 0 end) as cancelled_cases,
												sum(Case when t.status =  'completed' then 1 else 0 end) as completed_cases
									from Trips t
									Join Users c on (t.client_id = c.users_id)
									Join Users d on (t.driver_id = d.users_id)
									where c.banned != 'Yes' and d.banned != 'Yes'
									Group by t.request_at)

Select *,  Round((1.0*cancelled_cases / total_trip)*100,2) as cancellation_percentage
from trip_details



Select *
from Trips t
join users c on (t.client_id = c.users_id)
join users d on (t.driver_id = d.users_id)
where c.banned = 'No' and d.banned = 'No'

Select t.request_at, 1 as total_trips,
			Case when status = 'completed' then 1 else 0 end as completed,
			Case when status in ('cancelled_by_client', 'cancelled_by_driver') then 1 else 0 end as cancelled
from Trips t
join users c on (t.client_id = c.users_id)
join users d on (t.driver_id = d.users_id)
where c.banned = 'No' and d.banned = 'No'

with trips_detail as (
								Select t.request_at, count(1) as total_trips,
											sum(Case when status = 'completed' then 1 else 0 end) as completed,
											sum(Case when status in ('cancelled_by_client', 'cancelled_by_driver') then 1 else 0 end) as cancelled
								from Trips t
								join users c on (t.client_id = c.users_id)
								join users d on (t.driver_id = d.users_id)
								where c.banned = 'No' and d.banned = 'No'
								group by t.request_at),
		prior_query as (
								Select request_at, cancelled as cancelled_trip_count8, total_trips,
											(1.0*cancelled/total_trips)*100 as cancelled_percent
								from trips_detail)

Select * from prior_query



--4-Jan-2026---8---------------------Day 11 - Leetcode hardest problem----------------------------
-- How to calculate median
-- method #1 -- median using ROW_NUMBER
-- method #2 -- median using percentile_cont

create table empDept(
										emp_id int,
										emp_name varchar(20),
										department_id int,
										salary int,
										manager_id int,
										emp_age int);

insert into empDept values
								(1, 'Ankit', 100,10000, 4, 39),
								(2, 'Mohit', 100, 15000, 5, 48),
								(3, 'Vikas', 100, 10000,4,37),
								(4, 'Rohit', 100, 5000, 2, 16),
								(5, 'Mudit', 200, 12000, 6,55),
								(6, 'Agam', 200, 12000,2, 14),
								(7, 'Sanjay', 200, 9000, 2,13),
								(8, 'Ashish', 200,5000,2,12),
								(9, 'Mukesh',300,6000,6,51),
								(10, 'Rakesh',300,7000,6,50);

Select * from empDept

-- method #1 -- median using ROW_NUMBER
With CTEempDept as (
										Select *,
													ROW_NUMBER() over (order by emp_age) as rn_ASC,
													ROW_NUMBER() over (order by emp_age Desc) as rn_DESC
										from empDept)

Select AVG(emp_age) as median_age_of_Table from CTEempDept
where ABS(rn_ASC - rn_DESC) <=1

-- method #2 -- median using percentile_cont
Select *,
			PERCENTILE_CONT(0.5) within group (order by emp_age) over () as median_age_complete,
			PERCENTILE_CONT(0.5) within group (order by emp_age) over (Partition by department_id) as median_age
from empDept


--5-Jan-2026---9---------------------Day 12 - Find Winner in each group----------------------------
--Write a SQL query to find the winner in each group
--The winner in each group is the player who scored the maximum total points within the group
--In case of tie the lowest player_id wins
Use AnkitBansalClass

create table players
					(player_id int,
					group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
						(
						match_id int,
						first_player int,
						second_player int,
						first_score int,
						second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);


Select * from players;
Select * from matches;

with match_details as (
									Select match_id, first_player as player_id, first_score as score from matches 
									Union All
									Select match_id, second_player, second_score from matches),
		player_score as (
									Select group_id, p.player_id, sum(score) as score
									from players p
									join match_details md
											on (p.player_id = md.player_id)
									group by group_id, p.player_id),
		
		player_win_rnk as (
									select *,
												ROW_NUMBER() over (Partition by group_id order by score desc, player_id ASC) as rnk
									from player_score)
Select group_id, player_id, score
from player_win_rnk
where rnk = 1

--6-Jan-2026---10---------------------Day 13 - ----------------------------
--Market Analysis, Write a SQL query to find for each seller, whether the brand of the second item (by Date) they sold is their fovorite
--If a seller sold less than two items, report the answer for the seller as no. o/p
--Seller id			2nd_item_fav_brand
--1						yes/No
--2						yes/No

create table users13 (
						user_id         int     ,
						 join_date       date    ,
						 favorite_brand  varchar(50));

 create table orders13 (order_id       int     ,
									 order_date     date    ,
									 item_id        int     ,
									 buyer_id       int     ,
									 seller_id      int );

 create table items13 (
			 item_id        int     ,
			 item_brand     varchar(50));


 insert into users13 values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');
 insert into items13 values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');
 insert into orders13 values 
							(1,'2019-08-01',4,1,2),
							(2,'2019-08-02',2,1,3),
							(3,'2019-08-03',3,2,3),
							(4,'2019-08-04',1,4,2),
							(5,'2019-08-04',1,3,4),
							(6,'2019-08-05',2,2,4);

Select * from users13
Select * from items13
Select * from orders13;

with rnk_order as (
							Select *,
										ROW_NUmber() over (Partition by seller_id order by order_date) as rnk
							from orders13
							),
		second_fav_order as (Select ro.*, i.item_brand
												from rnk_order as ro
												left join items13 as i on (i.item_id = ro.item_id)
												where rnk = 2)

Select u.user_id, u.favorite_brand as first_favorite, sfo.item_brand as second_bought_brand,
			case when u.favorite_brand=sfo.item_brand then 'Yes' else 'No' end as favorite_Brand
from users13 u
left join second_fav_order sfo
		on (u.user_id = sfo.seller_id)

--10-Jan-2026---11---------------------Day 14 - ----------------------------
--User Purchase Platform
-- The table logs the spending history of the users that make purchases from online shopping website via desktop and mobile app
-- Write a SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date

create table spending 
				(
				user_id int,
				spend_date date,
				platform varchar(10),
				amount int
				);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);

Select * from spending;

With spending_order as (
							Select spend_date, max(platform) as platform, sum(amount) as total_amount, count(distinct user_id) as total_user
							from spending 
							Group by spend_date, user_id
							having(count(platform)) =1
							
							Union All
							
							Select spend_date, 'Both' as platform, sum(amount) as total_amount, count(distinct user_id) as total_user
							from spending 
							Group by spend_date, user_id
							having(count(platform)) =2
							
							Union All
							
							Select Distinct(spend_date), 'Both' as platform , Null as total_amount, Null as total_user
							from spending 
							)

Select spend_date, platform, sum(total_amount) as total_amount, Sum(total_user) as total_user
from spending_order
group by spend_date, platform
order by spend_date, platform desc

---------------------------------Another Solution------------------------------------------------------------
Select spend_date,
			case when count(distinct platform)=1 then max(platform) else 'both' end as platform,
			sum(amount) as total_amount,
			count(distinct user_id) as total_user
from spending
group by spend_date, user_id;


WITH spending_order AS (
										SELECT spend_date,
														CASE WHEN COUNT(DISTINCT platform) = 1 THEN MAX(platform) ELSE 'both' END AS platform,
														SUM(amount) AS total_amount,
														COUNT(DISTINCT user_id) AS total_users
										FROM spending
										GROUP BY spend_date, user_id

										Union All

										Select Distinct(spend_date), 'both' as platform , 0 as total_amount, 0 as total_users
										from spending 
									)

SELECT spend_date, platform,
			   SUM(total_amount) AS total_amount,
			   SUM(total_users) AS total_users
FROM spending_order
GROUP BY spend_date, platform
ORDER BY spend_date, platform DESC;



--10-Jan-2026---11---------------------Day 15- ----------------------------
--calcuate year wise sale for product ids,

with recursiveCTE as (
			select 1 as num

			union all

			Select num+1 as num
			from recursiveCTE
			where num <6)

select * from recursiveCTE

create table sales ( product_id int, period_start date, period_end date, average_daily_sales int ); 
insert into sales values(1,'2019-01-25','2019-02-28',100),(2,'2018-12-01','2020-01-01',10),(3,'2019-12-01','2020-01-31',1);

Select * from sales

Select min(period_start), max(period_start)  from sales
Select min(period_end), max(period_end)  from sales;


Select * from sales;

WITH dateLimts as (
							Select min(period_start) as stDate, max(period_end) as enDate  from sales),

			recursiveDateCTE AS (
							  SELECT  stDate as dt FROM dateLimts

							  UNION ALL

							  SELECT DATEADD(DAY, 1, dt) AS dt
							  FROM recursiveDateCTE
							  WHERE DATEADD(DAY, 1, dt) <= (SELECT  enDate as dt FROM dateLimts)
							),
			yearCTE as (
						SELECT DatePart(year, rdc.dt) as report_year, s.product_id, SUM(s.average_daily_sales) as total_amount
						FROM recursiveDateCTE as rdc
						inner Join sales s on (rdc.dt >= cast(s.period_start as date)  AND rdc.dt <=cast(s.period_end as date))
						Group by DatePart(year, rdc.dt), s.product_id
						)

Select product_id, report_year, total_amount from yearCTE
order by product_id
OPTION (MAXRECURSION 0)



--11-Jan-2026---12---------------------Day 16- ----------------------------
--Prime Subscription rate by product action
--Given the following two tables, return the fraction of users, rounded to two decimal places,
--who accessed amozon music and upgraded to prime membership within the first 30 days of signing up

create table users16
							(
							user_id integer,
							name varchar(20),
							join_date date
							);
insert into users16
values (1, 'Jon', CAST('2-14-20' AS date)), 
(2, 'Jane', CAST('2-14-20' AS date)), 
(3, 'Jill', CAST('2-15-20' AS date)), 
(4, 'Josh', CAST('2-15-20' AS date)), 
(5, 'Jean', CAST('2-16-20' AS date)), 
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

create table events16
(
user_id integer,
type varchar(10),
access_date date
);

insert into events16 values
(1, 'Pay', CAST('3-1-20' AS date)), 
(2, 'Music', CAST('3-2-20' AS date)), 
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)), 
(4, 'Music', CAST('3-15-20' AS date)), 
(1, 'P', CAST('3-16-20' AS date)), 
(3, 'P', CAST('3-22-20' AS date));

Select * from users16
Select * from events16;

 
with event_details as (
								Select e.user_id, e.type,  u.join_date, e.access_date,
											DATEDIFF(day, u.join_date, e.access_date) as diff_days
								from events16 e
								join users16 u
										on (e.user_id = u.user_id)),

		music_prime_finding as (
							Select user_id,
										Sum(Case when type = 'Music' then 1 else 0 end) as music_accessed,
										Sum(Case when type = 'P' then 1 else 0 end) as prime_upgrade
							from event_details
							where diff_days <=30
							Group by user_id)

Select sum(music_accessed) as total_users,
			sum(prime_upgrade) as prime_users,
			Round((sum(prime_upgrade) *1.0 /sum(music_accessed)) * 100,2)  as primesubscriptionPercentage
from music_prime_finding



--11-Jan-2026---12---------------------Day 17- ----------------------------
--Recommendation system based on - products pairs most commonly purchased together

create table orders17
						(
						order_id int,
						customer_id int,
						product_id int,
						);

insert into orders17 VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products17 (
						id int,
						name varchar(10));

insert into products17 VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

Select * from orders17
Select * from products17;

----------------------------My Solution----------------------------------------

with productDetails as (
						Select o.*, p.name 
						from orders17 o 
						left join products17 p
								on (o.product_id = p.id))

Select concat(a.name, ' ', b.name) as pair, count(*) as purchase_freq
from productDetails a, productDetails b
where a.order_id = b.order_id and a.name < b.name
Group by concat(a.name, ' ', b.name);

----------------------------------Ankit Bansal's Solution
Select * from orders17
Select * from products17;

With product_table17 as (
				Select a.product_id as p1, b.product_id as p2
				from orders17 a, orders17 b
				where a.order_id = b.order_id and a.product_id < b.product_id
				)

select pr1.name + ' ' + pr2.name as pairs, count(*) as purchase_freq
from product_table17 pt
join products17 pr1 on (pt.p1 = pr1.id)
join products17 pr2 on (pt.p2 = pr2.id)
Group by pr1.name + ' ' + pr2.name


--11-Jan-2026---13---------------------Day 18-----------------------------
--Customer Retention and customer churn metrices

--Customer retention defenition
/* Customer retention refers to a company's ability to turn customer into repeat buyers
and prevent them from switching to a competitor.
It indicates whether your product and the quality of your service please your existing customer
Reward program (cc companies)
Wallet cash back (paytm/gpay)
zomato pro / swiggy super

retention period*/


create table transactions(
						order_id int,
						cust_id int,
						order_date date,
						amount int
						);
delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150);


Select * from transactions;

Select  MONTH(t1.order_date) as month_date, Count(distinct t2.cust_id) as total_retained_Cust
from transactions t1
left Join transactions t2
on t1.cust_id = t2.cust_id and Datediff(month, t2.order_date, t1.order_date) = 1
Group by MONTH(t1.order_date)

--12-Jan-2026---14---------------------Day 19-----------------------------
--Customer churn metrices
Select * from transactions;

Select  1+MONTH(last_month.order_date) as month_date, Count(distinct last_month.cust_id) as total_Churn
from transactions last_month
left Join transactions this_month
on last_month.cust_id = this_month.cust_id and Datediff(month, last_month.order_date, this_month.order_date) = 1
where this_month.cust_id is Null
Group by MONTH(last_month.order_date);


--18-Jan-2026---15---------------------Day 20-----------------------------
--Get the second most activity, if there is only one activity then return the first one

Create table UserActivity(
						username      varchar(20) ,
						activity      varchar(20),
						startDate     Date   ,
						endDate      Date
						);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');

With uniqueCount as (Select username, count(username) as userCount 
										from UserActivity
										Group by username),
		userActivityCTE as (
							Select ua.*, 
							ROW_NUMBER() over (Partition by ua.username order by ua.startDate) as rnk,
							uc.userCount
							from UserActivity ua
							Join uniqueCount uc
							on (ua.username = uc.username))
		
Select *
from userActivityCTE
where userCount <2 or rnk=2


------Ankit Bansal's Solution-----------------------------
Select * from userActivity;

With UA_Cte as (
							Select *,
									Count(1) over (Partition by username) as cnt,
									ROW_NUMBER() over (Partition by username order by startDate) as rnk
							from UserActivity)

Select username,  activity, startDate, endDate
from UA_Cte
where cnt = 1 or rnk =2



--18-Jan-2026---15---------------------Day 21-----------------------------
--Get the second most activity, if there is only one activity then return the first one

create table billings 
				(
				emp_name varchar(10),
				bill_date date,
				bill_rate int
				);
delete from billings;
insert into billings values
('Sachin','01-JAN-1990',25)
,('Sehwag' ,'01-JAN-1989', 15)
,('Dhoni' ,'01-JAN-1989', 20)
,('Sachin' ,'05-Feb-1991', 30)
;

create table HoursWorked 
							(
							emp_name varchar(20),
							work_date date,
							bill_hrs int
							);
insert into HoursWorked values
('Sachin', '01-JUL-1990' ,3)
,('Sachin', '01-AUG-1990', 5)
,('Sehwag','01-JUL-1990', 2)
,('Sachin','01-JUL-1991', 4);


-----------------------My Try with Failure-------------------------------
Select * from billings
Select * from HoursWorked

Select hw.*, b.* 
from HoursWorked hw
left Join billings b
on (b.emp_name = hw.emp_name and Cast(hw.work_date as date) > cast(b.bill_date as date))
where b.emp_name = 'Sachin'

-----------------------Ankit Bansal Solution-------------------------------

with billingCTE as (
					Select *, LEAD(Dateadd(day, -1, bill_date), 1, '9999-12-31') over (Partition by emp_name order by bill_date asc) as bill_end_date
					from billings)

Select hw.emp_name, Sum(hw.bill_hrs * b.bill_rate) as total_billing
from HoursWorked hw
left Join billingCTE b
on (b.emp_name = hw.emp_name and hw.work_date between b.bill_date and b.bill_end_date)
Group by hw.emp_name


--19-Jan-2026---15---------------------Day 22-----------------------------
--The activity table shows the app-installed and app purchase activities for spotify app along with country details

CREATE table activity22
				(
				user_id varchar(20),
				event_name varchar(20),
				event_date date,
				country varchar(20)
				);
delete from activity22;
insert into activity22 values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');

Select * from activity22;

--Q1 Find Active users each day
Select event_date, count(distinct user_id) as total_active_users
from activity22
Group by event_date

--Q2 Find Active users each day
Select DATEPART(week,event_date) as Week, count(distinct user_id) as total_active_users
from activity22
Group by DATEPART(week,event_date)

--Q3  Date wise total number of users who made the purchase same day they installed the app
Select * from activity22;

with initialCTE as (
		Select a1.event_date, count(1) as no_of_users_same_day_purchase
		from activity22 a1
		left join activity22 a2
				on (a1.user_id= a2.user_id and a1.event_date= a2.event_date)
		where a1.event_name = 'app-installed' and a2.event_name= 'app-purchase'
		Group by a1.event_date)



Select a3.event_date, COALESCE (ic.no_of_users_same_day_purchase,0) as no_of_users_same_day_purchase
from activity22 a3
left Join initialCTE ic
		on (a3.event_date = ic.event_date)
Group by a3.event_date, ic.no_of_users_same_day_purchase

-- Ankit Bansals' Solution
Select * from activity22;

Select event_date, count(new_user) as user_purchase_same_day from (
					Select event_date, user_id,
								case when Count(distinct event_name) = 2 then user_id else Null end as new_user 
					from activity22
					Group by event_date, user_id) as ua
Group by event_date


--Q4  Percentage of paid users in india, USA and any other country should be tagged as others.


Select count(*) from activity22
where event_name = 'app-purchase'

Select case when country in ('India', 'USA') then country else 'others' end as country_n,
			100.0 * count(distinct user_id)/(Select count(*) from activity22
																where event_name = 'app-purchase') as paid_user_count
from activity22
where event_name = 'app-purchase'
Group by case when country in ('India', 'USA') then country else 'others' end
Order by case when country in ('India', 'USA') then country else 'others' end ASC

---------------------------Ankit's Solution-----------------------------------

With country_users as (
									Select case when country in ('India', 'USA') then country else 'others' end as new_country,
												count(distinct user_id) as  user_cnt
									from activity22
									where event_name = 'app-purchase'
									Group by case when country in ('India', 'USA') then country else 'others' end),
		total_user as (
									Select count(*) as total_users from activity22
									where event_name = 'app-purchase')

Select *, 100 * cu.user_cnt/tu.total_users as percentage_users
from country_users cu, total_user tu
order by cu.new_country

--Q5  Among all the users who installed the app on a given day, how many did in app purchased on the very next day
--	day wise result

with user_activity as (
					Select *,
							LAG(event_name, 1) over (Partition by user_id order by event_date ) as previous_event_name,
							LAG(event_date, 1) over (Partition by user_id order by event_date ) as previous_event_date
					from activity22)

Select event_date, count(distinct user_id) as total_user_who_purchase_the_very_next_day
from user_activity
where datediff(day, previous_event_date, event_date) =1
and event_name = 'app-purchase'
and previous_event_name = 'app-installed'
Group by event_date

--20-Jan-2026---16---------------------Day 23 -  Consecutive empty sheets-----------------------------
--Get the second most activity, if there is only one activity then return the first one

create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');

Select * from (
					Select *,
							LAG(is_empty, 1) over (order by seat_no) as prev_1,
							LAG(is_empty, 2) over (order by seat_no) as prev_2,
							LEAD(is_empty, 1) over (order by seat_no) as next_1,
							LEAD(is_empty, 2) over (order by seat_no) as next_2
					from bms) as A
where is_empty = 'Y' and prev_1 = 'Y' and prev_2 = 'Y'
	    or (is_empty = 'Y' and prev_1 = 'Y' and next_1 = 'Y')
	    or (is_empty = 'Y' and next_1 = 'Y' and next_2 = 'Y')






