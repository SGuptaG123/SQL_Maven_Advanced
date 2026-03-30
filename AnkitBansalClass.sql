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

Select * from empDept;

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
--Get the consecutive empty sheets

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

---------------------------------Approach 2

Select * from (
				Select *,
							SUM(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between 2 preceding and current row) as prev_2,
							SUM(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between 1 preceding and 1 following) as cur_row,
							SUM(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between current row and 2 following) as next_2
				from bms) as A
Where prev_2 = 3 or cur_row = 3 or next_2 = 3


--21-Jan-2026---17---------------------Day 24 -  Missing Quarter with 3 methods-----------------------------
CREATE TABLE STORES (
			Store varchar(10),
			Quarter varchar(10),
			Amount int);

INSERT INTO STORES (Store, Quarter, Amount)
			VALUES ('S1', 'Q1', 200),
			('S1', 'Q2', 300),
			('S1', 'Q4', 400),
			('S2', 'Q1', 500),
			('S2', 'Q3', 600),
			('S2', 'Q4', 700),
			('S3', 'Q1', 800),
			('S3', 'Q2', 750),
			('S3', 'Q3', 900);

Select * from STORES;


-- My Solution try to find the missing quarters
with storename as (Select distinct Quarter from STORES),
		quatername as (Select distinct store from STORES),
		helpertable as (select * from quatername, storename)

Select ht.Store, ht.Quarter, s.Amount from helpertable ht
left Join STORES s
		on (ht.Store=s.Store and ht.Quarter= s.Quarter)
where s.Amount is Null


---Ankit Bansals approach - 1st solution
Select * from STORES

Select Store, 'Q' + Cast(10 - SUM(Cast(RIGHT(Quarter, 1) as int)) as varchar) as missing_qtr
from STORES
Group by Store

---Ankit Bansals approach - 2nd solution -- using recursive CTE----------------------------
Select * from STORES;

with rCTE as (
									Select distinct Store, 1 as q_num from STORES
									Union All
									Select store, 1+q_num  as q_num from rCTE
									where q_num <4),
		dummyTable as (Select store, 'Q' + cast(q_num as varchar)  as qtr from rCTE)

Select ht.Store, ht.qtr, s.Amount from dummyTable ht
left Join STORES s
		on (ht.Store=s.Store and ht.qtr= s.Quarter)
where s.Amount is Null;

---Ankit Bansals approach - 3rd solution -- using Cross Join----------------------------
with storename as (Select distinct s1.Store, s2.Quarter
									from STORES s1, STORES s2)

Select ht.Store, ht.Quarter as q_no from storename ht
left Join STORES s
		on (ht.Store=s.Store and ht.Quarter= s.Quarter)
where s.Amount is Null


--22-Jan-2026---17---------------------Day 27 -  Google SQL Interview Question-----------------------------
-- Find companies who have atleast 2 users who speaks English and German both the language

create table company_users 
			(company_id int,
			user_id int,
			language varchar(20));

insert into company_users values (1,1,'English')
		,(1,1,'German')
		,(1,2,'English')
		,(1,3,'German')
		,(1,3,'English')
		,(1,4,'English')
		,(2,5,'English')
		,(2,5,'German')
		,(2,5,'Spanish')
		,(2,6,'German')
		,(2,6,'Spanish')
		,(2,7,'English');

-- My Solution----------------
with user_idCTE as (
		Select user_id
		from company_users
		where language in ('English', 'German')
		Group by user_id
		having count(distinct language) = 2)

Select company_id 
from company_users 
where user_id in (Select * from user_idCTE)
Group by company_id
Having count(distinct user_id) = 2

-- Ankit Bansal's Solution----------------
Select company_id from (
					Select distinct company_id, user_id, count(1) as cnt
					from company_users
					where language in ('English', 'German')
					Group by company_id, user_id
					having count(1)  = 2) as a 
Group by company_id
having count(distinct user_id) >= 2

--22-Jan-2026---17---------------------Day 28 -  Meesho HackerRank SQL Test-----------------------------
-- Find how many product falls into customer budget along with list of products
-- In case of clash chose the less costly product

create table products28 (product_id varchar(20) , cost int);
insert into products28 values ('P1',200),('P2',300),('P3',500),('P4',800);

create table customer_budget28 (customer_id int, budget int);
insert into customer_budget28 values (100,400),(200,800),(300,1500);

Select * from products28;
Select * from customer_budget28;

-- My Solution---------------------------------
with analysisCTE as(
			Select *,
					SUM(cost) over (Partition by customer_id  order by budget, cost) as rolling_cost,
					case when (SUM(cost) over (Partition by customer_id  order by budget, cost)  < budget) then 'Y' else 'N' end as in_budget
			from customer_budget28 cb, products28 p)

Select customer_id, budget, count(1) as no_products, STRING_AGG(product_id, ', ') as list_of_products
from analysisCTE
Where in_budget = 'Y'
Group by customer_id, budget
order by customer_id

-- Ankits Solution---------------------------------
With productCTE as (
				Select *,
							sum(cost) over (order by cost) as rc
				from products28)

Select cb.customer_id, cb.budget, count(1) as no_products, STRING_AGG(pc.product_id, ', ') as list_of_products
from customer_budget28 cb
Left Join productCTE pc
		on (cb.budget > pc.rc)
Group by cb.customer_id, cb.budget


--23-Jan-2026------------------------Day 29 -  Horizontal Sorting in SQL-----------------------------
--Amazon SQL Interview Question for BIE position
--Find total no. of message exchanged between each person per day

CREATE TABLE subscriber (
					 sms_date date ,
					 sender varchar(20) ,
					 receiver varchar(20) ,
					 sms_no int
					);
-- insert some values
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Vibhor',10);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Pawan',30);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Pawan',5);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Vibhor',8);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Deepak',50);

Select * from subscriber;

-- Total message recieved or sent by each person
with exchangerCTE as (
				Select sms_date, sender as exchanger, sms_no from subscriber
				Union All
				Select sms_date, receiver as exchanger, sms_no from subscriber)

Select sms_date, exchanger, sum(sms_no) as total_messges
from exchangerCTE
Group by sms_date, exchanger
order by sms_date, exchanger;

--Ankit's Solution-----------------------------

Select sms_date, p1, p2, sum(sms_no) as total_sms from (
Select *,
			Case when sender<receiver then sender else receiver end as p1,
			Case when sender>receiver then sender else receiver end as p2
from subscriber) as a
Group by sms_date, p1, p2

--23-Jan-2026------------------------Day 30 -  Tricky SQL Problems-----------------------------
--SQL set with 4 medium to high complexity problems

CREATE TABLE Students30(
		 [studentid] [int] NULL,
		 [studentname] [nvarchar](255) NULL,
		 [subject] [nvarchar](255) NULL,
		 [marks] [int] NULL,
		 [testid] [int] NULL,
		 [testdate] [date] NULL
		)

insert into Students30 values (2,'Max Ruin','Subject1',63,1,'2022-01-02');
insert into Students30 values (3,'Arnold','Subject1',95,1,'2022-01-02');
insert into Students30 values (4,'Krish Star','Subject1',61,1,'2022-01-02');
insert into Students30 values (5,'John Mike','Subject1',91,1,'2022-01-02');
insert into Students30 values (4,'Krish Star','Subject2',71,1,'2022-01-02');
insert into Students30 values (3,'Arnold','Subject2',32,1,'2022-01-02');
insert into Students30 values (5,'John Mike','Subject2',61,2,'2022-11-02');
insert into Students30 values (1,'John Deo','Subject2',60,1,'2022-01-02');
insert into Students30 values (2,'Max Ruin','Subject2',84,1,'2022-01-02');
insert into Students30 values (2,'Max Ruin','Subject3',29,3,'2022-01-03');
insert into Students30 values (5,'John Mike','Subject3',98,2,'2022-11-02');

Select * from Students30;

--Q1 -- Write a SQL query to get the list of students who scored above the subject in each subject;

with subject_average as (
			Select subject, AVG(marks) avg_marks 
			from Students30
			Group by subject)

Select * 
from Students30 s
Left join subject_average sa
		on (s.subject = sa.subject)
where s.marks > sa.avg_marks;

--Q2 -- Write a SQL query to get the percentage of students who scored more than 90 in any subject amongest the total student;

--My Solution-----
DECLARE @TotalStudent INT
DECLARE @StudentWithAbove90 INT
Set @TotalStudent = (Select count(distinct a.studentid) total_student from Students30 as a)
Set @StudentWithAbove90 = (
													Select count(distinct b.studentid) total_student from Students30 b
													where b.marks > 90)

Select 100.0 * @StudentWithAbove90 / @TotalStudent as PercentageStudentWithAbove90

--Ankit's Solution

Select Count(distinct case when b.marks > 90 then studentid else Null end) as with90,
			Count(distinct b.studentid) as totalStudent,
			Count(distinct case when b.marks > 90 then studentid else Null end)  * 100.0 / Count(distinct b.studentid)  as percentage
from Students30 b

--Q3 -- Write a SQL query to get the second highest and second-lowest marks for each subject
--My Solution
Select Subject, max(shm) as second_highest_marks, max(slm)  as second_lowest_marks from (
		Select *,
					Case when ROW_NUMBER() over (Partition by subject order by marks DESC) = 2 then marks else Null end as shm,
					Case when ROW_NUMBER() over (Partition by subject order by marks ASC) =2 then marks else Null end  as slm
		from Students30 s) as a
Group by Subject


--Q4 -- For each student and test, identify if their marks increased or decreased from the previous test
Select *,
			LAG(marks, 1) over (Partition by studentid order by subject) as prev_marks,
			case when marks - LAG(marks, 1) over (Partition by studentid order by subject) > 0 then 'inc'
					 when LAG(marks, 1) over (Partition by studentid order by subject) is Null then Null else 'dec' end  as Status
from Students30
order by studentid


--24-Jan-2026------------------------Day 31 -  Brilliant SQL Interview Question-----------------------------

CREATE TABLE [dbo].[int_orders](
						 [order_number] [int] NOT NULL,
						 [order_date] [date] NOT NULL,
						 [cust_id] [int] NOT NULL,
						 [salesperson_id] [int] NOT NULL,
						 [amount] [float] NOT NULL
						) ON [PRIMARY];

INSERT INTO [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (30, CAST('1995-07-14' AS Date), 9, 1, 460);
INSERT into [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (10, CAST('1996-08-02' AS Date), 4, 2, 540);
INSERT INTO [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (40, CAST('1998-01-29' AS Date), 7, 2, 2400);
INSERT INTO [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (50, CAST('1998-02-03' AS Date), 6, 7, 600);
INSERT into [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (60, CAST('1998-03-02' AS Date), 6, 7, 720);
INSERT into [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (70, CAST('1998-05-06' AS Date), 9, 7, 150);
INSERT into [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (20, CAST('1999-01-30' AS Date), 4, 8, 1800);


Select * from int_orders;
--Find the largest order by value for each salesperson and display order details.
--Get the result without using sub query, CTE, window functions, temp tables

Select a.order_number, a.order_date, a.salesperson_id, a.amount
from int_orders a
left Join int_orders b
		on (a.salesperson_id = b.salesperson_id)
Group by a.order_number, a.order_date, a.salesperson_id, a.amount
having a.amount>=max(b.amount)
order by a.salesperson_id asc, a.amount desc


--24-Jan-2026------------------------Day 32 -  SQL On Off Problem-----------------------------
create table event_status
	(event_time varchar(10),
	status varchar(10));

insert into event_status values
('10:01','on'),('10:02','on'),('10:03','on'),('10:04','off'),('10:07','on'),('10:08','on'),('10:09','off')
,('10:11','on'),('10:12','off');

Select * from event_status

--My Try ---Failed
Select *,
		case when status = 'on' then event_time else Null end as login,
		LEAD(case when status = 'off' then event_time else Null end, 1) over (order by event_time)as logout
from event_status;

--Ankit Bansal's Solution----------------------------
With statusCTE as (
					Select *,
							Sum(case when status = 'on' and prev_status='off' then 1 else 0 end) over (order by event_time) as group_key
					from (
							Select *, LAG(status, 1, status) over (order by event_time) as prev_status
							from event_status) as A)

Select min(event_time) as login, max(event_time) as logout, count(1)-1 as cnt 
from statusCTE
Group by group_key


--25-Jan-2026------------------------Day 33 -  Leetcode - Players/Students Reports-----------------------------

create table players_location
		(name varchar(20),
		city varchar(20));

delete from players_location;
insert into players_location
values ('Sachin','Mumbai'),('Virat','Delhi') , ('Rahul','Bangalore'),('Rohit','Mumbai'),('Mayank','Bangalore');


Select * from players_location;

--My try with failure-----------------
with pl as (
		Select *,
				case when city = 'Bangalore' then name else 'z' end as 'Bangalore',
				case when city = 'Delhi' then name else 'z' end as 'Delhi',
				case when city = 'Mumbai' then name else 'z' end as 'Mumbai'
		from players_location)

Select distinct Bangalore, Delhi, Mumbai
from pl
order by Bangalore, Delhi, Mumbai


--Ankit Bansals' Solution-----------------

Select rn,
		MAX(case when city = 'Bangalore' then name else Null end) as 'Bangalore',
		MAX(case when city = 'Delhi' then name else Null end) as 'Delhi',
		MAX(case when city = 'Mumbai' then name else Null end) as 'Mumbai'
from (
			Select *,
				ROW_NUMBER() over (Partition by city order by name asc) as rn
			from players_location) as pl
Group by rn

--26-Jan-2026------------------------Day 34 -  Employee Median Salary-----------------------------

create table employee34
		(emp_id int,
		company varchar(10),
		salary int);

insert into employee34 values (1,'A',2341)
insert into employee34 values (2,'A',341)
insert into employee34 values (3,'A',15)
insert into employee34 values (4,'A',15314)
insert into employee34 values (5,'A',451)
insert into employee34 values (6,'A',513)
insert into employee34 values (7,'B',15)
insert into employee34 values (8,'B',13)
insert into employee34 values (9,'B',1154)
insert into employee34 values (10,'B',1345)
insert into employee34 values (11,'B',1221)
insert into employee34 values (12,'B',234)
insert into employee34 values (13,'C',2345)
insert into employee34 values (14,'C',2645)
insert into employee34 values (15,'C',2645)
insert into employee34 values (16,'C',2652)
insert into employee34 values (17,'C',65);

Select * from employee34;

--Write a SQL query to find the median salary of each company
--Bonus point if you can solve it without using built-in SQL functions.

with salary_rn as (
		Select *,
			ROW_NUMBER() over (Partition by company order by salary asc) as rn1,
			ROW_NUMBER() over (Partition by company order by salary desc) as rn2
		from employee34)

Select company, AVG(salary) as median
from salary_rn
where ABS(rn1-rn2) <=1
Group by company

-- method #2 -- median using percentile_cont
Select distinct company,
		PERCENTILE_CONT(0.5) within group (order by salary) over (Partition by company) as median_salary
from employee34



--26-Jan-2026------------------------Day 35 -  Amazon SQL interview quetion-----------------------------

CREATE TABLE [emp35](
	 [emp_id] [int] NULL,
	 [emp_name] [varchar](50) NULL,
	 [salary] [int] NULL,
	 [manager_id] [int] NULL,
	 [emp_age] [int] NULL,
	 [dep_id] [int] NULL,
	 [dep_name] [varchar](20) NULL,
	 [gender] [varchar](10) NULL
	) ;

insert into emp35 values(1,'Ankit',14300,4,39,100,'Analytics','Female')
insert into emp35 values(2,'Mohit',14000,5,48,200,'IT','Male')
insert into emp35 values(3,'Vikas',12100,4,37,100,'Analytics','Female')
insert into emp35 values(4,'Rohit',7260,2,16,100,'Analytics','Female')
insert into emp35 values(5,'Mudit',15000,6,55,200,'IT','Male')
insert into emp35 values(6,'Agam',15600,2,14,200,'IT','Male')
insert into emp35 values(7,'Sanjay',12000,2,13,200,'IT','Male')
insert into emp35 values(8,'Ashish',7200,2,12,200,'IT','Male')
insert into emp35 values(9,'Mukesh',7000,6,51,300,'HR','Male')
insert into emp35 values(10,'Rakesh',8000,6,50,300,'HR','Male')
insert into emp35 values(11,'Akhil',4000,1,31,500,'Ops','Male');

Select * from emp35;

--Write a sql to find details of employees with 3rd highest salary in each department
--in case there are less than 3 employees in a department than return employee details with lowest salary in that department

with employee_details as (
									Select *,
											ROW_NUMBER() over (Partition by dep_id order by salary desc) as rn1
									from emp35),
		prior_query as (Select *,
											ROW_NUMBER() over (Partition by dep_id order by rn1 desc) as rn2
									from employee_details
									where rn1<=3)

Select * from prior_query
Where rn2 = 1;


--27-Jan-2026------------------------Day 36 -  Human Traffic of stadium-----------------------------

create table stadium (
		id int,
		visit_date date,
		no_of_people int);

insert into stadium
values (1,'2017-07-01',10)
,(2,'2017-07-02',109)
,(3,'2017-07-03',150)
,(4,'2017-07-04',99)
,(5,'2017-07-05',145)
,(6,'2017-07-06',1455)
,(7,'2017-07-07',199)
,(8,'2017-07-08',188);

--Write a query to display the records which have 3 or more consecutive rows
--with the amount of people more than 100(inclusive) each day

With stadium_group as (
		Select *,
				ROW_NUMBER() over (order by visit_date) as rw_no,
				Datepart(day, visit_date) as prev_date_no,
				Datepart(day, visit_date) - ROW_NUMBER() over (order by visit_date) as grp
		from stadium
		where no_of_people > 100)

Select * 
from stadium_group 
where grp in (Select grp from stadium_group group by grp having count(*) >= 3)



--28-Jan-2026------------------------Day 37 - Udaan Power of self Join  -----------------------------
--Business_city table has data from the day udaan has started operation
--write a sql to identify yearwise count of new cities where udaan started their operation

create table business_city (
		business_date date,
		city_id int
		);
delete from business_city;
insert into business_city
values(cast('2020-01-02' as date),3),(cast('2020-07-01' as date),7),(cast('2021-01-01' as date),3),(cast('2021-02-03' as date),19)
,(cast('2022-12-01' as date),3),(cast('2022-12-15' as date),3),(cast('2022-02-28' as date),12);

Select * from business_city
order by business_date

-- My solution using window function and sub-query
Select YEAR(business_date) as year, count(*) as #_new_cities
from (
		Select *,
				ROW_NUMBER() over (partition by city_id order by business_date) as rn
		from business_city) as a
where rn = 1
group by YEAR(business_date);

-- Ankit Bansal's solution using CTE and self join
With yearwiseCTE as (
		Select DATEPART(year, business_date) as year, city_id from business_city)

Select a.year, count(a.city_id) as #_of_new_cities
from yearwiseCTE a
left join yearwiseCTE b
		on (a.year> b.year and a.city_id=b.city_id)
where b.year is Null
Group by a.year;


-- Ankit Bansal's solution using CTE and self join and case when
With yearwiseCTE as (
		Select DATEPART(year, business_date) as year, city_id from business_city)

Select a.year, count( distinct case when b.city_id is Null then a.city_id end) as #_of_new_cities
from yearwiseCTE a
left join yearwiseCTE b
		on (a.year> b.year and a.city_id=b.city_id)
Group by a.year

--29-Jan-2026------------------------Day 38 - Pharmeasy SQL interview Question  -----------------------------
--There are 3 rows in a movie hall each with 10 seats in each row
--Write a SQL to find 4 consecutive empty seats

create table movie(
seat varchar(50),occupancy int
);
insert into movie values('a1',1),('a2',1),('a3',0),('a4',0),('a5',0),('a6',0),('a7',1),('a8',1),('a9',0),('a10',0),
('b1',0),('b2',0),('b3',0),('b4',1),('b5',1),('b6',1),('b7',1),('b8',0),('b9',0),('b10',0),
('c1',0),('c2',1),('c3',0),('c4',1),('c5',1),('c6',0),('c7',1),('c8',0),('c9',0),('c10',1);
Select * from movie;

--My solution
with cteMovietable as (
			Select *, left(seat,1) as seat_rw, cast(replace(seat, left(seat,1), '') as int) as seat_no
			from movie)

Select seat, occupancy from (
	Select *,
		SUM(case when occupancy = 0 then 1 else 0 end) over (Partition by seat_rw order by seat_no rows between 3 preceding and current row) as prev_3,
		SUM(case when occupancy = 0 then 1 else 0 end) over (Partition by seat_rw order by seat_no rows between 2 preceding and 1 following) as p2n1,
		SUM(case when occupancy = 0 then 1 else 0 end) over (Partition by seat_rw order by seat_no rows between 1 preceding and 2 following) as p1n2,
		SUM(case when occupancy = 0 then 1 else 0 end) over (Partition by seat_rw order by seat_no rows between current row and 3 following) as next_3
	from cteMovietable) as A
where prev_3 = 4 or p2n1 = 4 or p1n2 = 4 or next_3=4;

--Ankit Bansal's Solution

with cteMovietable as (
						Select *, left(seat,1) as seat_rw, cast(replace(seat, left(seat,1), '') as int) as seat_no
						from movie),
			case1 as (
						Select *,
								max(occupancy) over (Partition by seat_rw order by seat_no rows between current row and 3 following) as mx,
								count(occupancy) over (Partition by seat_rw order by seat_no rows between current row and 3 following) as cnt
						from cteMovietable),
			case2 as (Select * from case1 Where mx = 0 and cnt=4)

Select a.* 
from case1 a
inner join case2 b
		on (a.seat_rw = b.seat_rw) and (a.seat_no between b.seat_no and b.seat_no+3)



--30 Jan-2026------------------------Day 39 - Bosch scenario based SQL interview Question  -----------------------------
/*
Write a SQL to determine phone numbers that satisfy below conditions:
	1- The number have both incoming and outgoing calls
	2- The number of duration of outgoing calls should be greater than sum of duration of incoming calls
*/

create table call_details  (
	call_type varchar(10),
	call_number varchar(12),
	call_duration int
	);

insert into call_details
values ('OUT','181868',13),('OUT','2159010',8)
,('OUT','2159010',178),('SMS','4153810',1),('OUT','2159010',152),('OUT','9140152',18),('SMS','4162672',1)
,('SMS','9168204',1),('OUT','9168204',576),('INC','2159010',5),('INC','2159010',4),('SMS','2159010',1)
,('SMS','4535614',1),('OUT','181868',20),('INC','181868',54),('INC','218748',20),('INC','2159010',9)
,('INC','197432',66),('SMS','2159010',1),('SMS','4535614',1);

--My Solution
Select * from (
			Select call_number,
				SUM(case when call_type = 'OUT' then call_duration else Null end) as outgoing,
				SUM(case when call_type = 'INC' then call_duration else Null end) as incoming
			from call_details
			where call_type in ('OUT', 'INC')
			Group by call_number) as A
where outgoing is not null and  incoming is not null
and outgoing > incoming;

--Ankit Bansal Solution
--With CTE and Filter clause
with cte_calldetails as (
					Select call_number,
						SUM(case when call_type = 'OUT' then call_duration else Null end) as outgoing,
						SUM(case when call_type = 'INC' then call_duration else Null end) as incoming
					from call_details
					where call_type in ('OUT', 'INC')
					Group by call_number)

Select * from cte_calldetails
where outgoing is not null and  incoming is not null
and outgoing > incoming;

--Using having clause

Select call_number,
	SUM(case when call_type = 'OUT' then call_duration else Null end) as outgoing,
	SUM(case when call_type = 'INC' then call_duration else Null end) as incoming
from call_details
where call_type in ('OUT', 'INC')
Group by call_number
Having SUM(case when call_type = 'OUT' then call_duration else Null end) > 
			 SUM(case when call_type = 'INC' then call_duration else Null end);

--Using CTE and Joins
with call_out as (
					Select call_number, sum(call_duration) as outgoing 
					from call_details
					where call_type='Out'
					Group by call_number),
		call_in as (
					Select call_number, sum(call_duration) as incoming 
					from call_details
					where call_type='INC'
					Group by call_number)
Select co.call_number, co.outgoing as outgoing, ci.incoming
from call_out co
inner join call_in ci
		on (co.call_number = ci.call_number and co.outgoing > ci.incoming)

--31 Jan-2026------------------------Day 40 - Delloite SQL interview Question  -----------------------------
/*
Write a SQL to determine phone numbers that satisfy below conditions:
	1- The number have both incoming and outgoing calls
	2- The number of duration of outgoing calls should be greater than sum of duration of incoming calls
*/


create table brands 
		(category varchar(20),
		brand_name varchar(20));

insert into brands values
	('chocolates','5-star')
	,(null,'dairy milk')
	,(null,'perk')
	,(null,'eclair')
	,('Biscuits','britannia')
	,(null,'good day')
	,(null,'boost');

	Select * from brands
	

	--My failed approach
	Select *,
		--case when category is null then lag(category, 1) over (order by brand_name) end as new_col,
		coalesce(category, brand_name) as addicol
	from brands;

--Ankit Bansal's approach
Select * from brands;

with c1 as (
				Select *,
					ROW_NUMBER() over (order by (Select null)) as rn
				from brands),
		c2 as (
				Select *,
					LEAD(rn, 1) over (Partition by null order by rn) as rn2
				from c1
				where category is not null)

Select c2.category, c1.brand_name 
from c1
left join c2 
			on c1.rn >= c2.rn and (c1.rn <=c2.rn2 -1 or c2.rn2 is Null)

--01 Feb-2026------------------------Day 41 - Find the quite student in all exams -----------------------------
/*
Write a SQL to report the students (student_id, student_name) being "quiet" in all exams.
	1- A "quiet" student is the one who took at least one exam and didn't score neither the high score nor the low score in any of the exam.
	2- Don't return the student who has never taken any exam. Return the result table ordered by student_id
*/


create table students41
	(student_id int,
	student_name varchar(20));

insert into students41 values
	(1,'Daniel'),(2,'Jade'),(3,'Stella'),(4,'Jonathan'),(5,'Will');

create table exams41
	(exam_id int,
	student_id int,
	score int);

insert into exams41 values
	(10,1,70),(10,2,80),(10,3,90),(20,1,80),(30,1,70),(30,3,80),(30,4,90),(40,1,60)
	,(40,2,70),(40,4,80);

--My Solution
Select * from students41;
Select * from exams41;

With min_maxCTE as (
		Select *,
			Min(score) over (Partition by student_id order by student_id) as min_scoreStudent,
			Max(score) over (Partition by student_id order by student_id) as max_scoreStudent,
			Min(score) over (order by (Select Null)) as min_score,
			Max(score) over (order by (Select Null)) as max_score
		from exams41),
	
	uniquestudent as (
		Select distinct student_id
		from min_maxCTE
		where min_scoreStudent > min_score and  max_scoreStudent < max_score)

Select s.* 
from students41 s
Join uniquestudent e
on (s.student_id = e.student_id);

--Ankit Bansals solution

with examCTE as (
	Select exam_id,
	MIN(score) as min_score, MAX(score) as max_score 
	from exams41
	Group by exam_id)

Select student_id
from exams41 e
join examCTE ec
		on (e.exam_id = ec.exam_id)
Group by student_id
having max(case when score = min_score or score = max_score then 1 else 0 end) = 0


--02 Feb-2026------------------------Day 42 - Walmart Labs SQL Interview Question -----------------------------
/*
There is a phone log table that has information about callers call history
Write a SQL to find out callers whose first and last call was to the same person on a given day.
*/

create table phonelog(
    Callerid int, 
    Recipientid int,
    Datecalled datetime
);

insert into phonelog(Callerid, Recipientid, Datecalled)
values(1, 2, '2019-01-01 09:00:00.000'),
       (1, 3, '2019-01-01 17:00:00.000'),
       (1, 4, '2019-01-01 23:00:00.000'),
       (2, 5, '2019-07-05 09:00:00.000'),
       (2, 3, '2019-07-05 17:00:00.000'),
       (2, 3, '2019-07-05 17:20:00.000'),
       (2, 5, '2019-07-05 23:00:00.000'),
       (2, 3, '2019-08-01 09:00:00.000'),
       (2, 3, '2019-08-01 17:00:00.000'),
       (2, 5, '2019-08-01 19:30:00.000'),
       (2, 4, '2019-08-02 09:00:00.000'),
       (2, 5, '2019-08-02 10:00:00.000'),
       (2, 5, '2019-08-02 10:45:00.000'),
       (2, 4, '2019-08-02 11:00:00.000');

Select * from phonelog;

with callertable as (
	Select Callerid, cast(Datecalled as date) as c_date, min(Datecalled) firstCall, max(DateCalled) lastCall
	from phonelog
	Group by Callerid, cast(Datecalled as date))

Select ct.*, p1.Recipientid
from callertable ct
join phonelog p1 on p1.Callerid = ct.Callerid and ct.firstCall = p1.Datecalled
join phonelog p2 on p2.Callerid = ct.Callerid and ct.lastCall = p2.Datecalled
where p1.Recipientid = p2.Recipientid;


--03 Feb-2026------------------------Day 43 - Microsoft SQL Interview Question -----------------------------
/*
A company wants to hire new employees, The budget of the company for the salaries is $70000. The company's criteria for hiring are:
Keep hiring the senior with the smallest salary until you cannot hire any more seniors.
Use the remaining budget to hire the junior with the smallest salary.
Keep hiring the junior with the smallest salary until you cannot hire any more juniors.
Write an SQL to find out the seniors and juniors hired under the mentioned criteria.
*/

create table candidates (
		emp_id int,
		experience varchar(20),
		salary int);

delete from candidates;
insert into candidates values
(1,'Junior',10000),(2,'Junior',15000),(3,'Junior',40000),(4,'Senior',16000),(5,'Senior',20000),(6,'Senior',50000);


Select * from candidates;

With candidateCTE as (
		Select *,
			Sum(salary) over (Partition by experience order by salary rows between unbounded preceding and current row) as running_sum
		from candidates),
	senior_hired as (
		Select * from candidateCTE
		Where experience = 'Senior' and  running_sum <=70000)

Select * from candidateCTE
		Where experience = 'Junior' and  running_sum <=70000 - (Select sum(salary) from senior_hired)
Union all
Select * from senior_hired;


--03 Feb-2026------------------------Day 44 - Double Self Join in SQL -----------------------------
/*
Write a SQL to list emp name along with their manager name and senior Manager name
--Senior manager is manager's manager
*/

create table emp44(
	emp_id int,
	emp_name varchar(20),
	department_id int,
	salary int,
	manager_id int,
	emp_age int);

insert into emp44
values (1, 'Ankit', 100,10000, 4, 39),
			(2, 'Mohit', 100, 15000, 5, 48),
			(3, 'Vikas', 100, 12000,4,37),
			(4, 'Rohit', 100, 14000, 2, 16),
			(5, 'Mudit', 200, 20000, 6,55),
			(6, 'Agam', 200, 12000,2, 14),
			(7, 'Sanjay', 200, 9000, 2,13),
			(8, 'Ashish', 200,5000,2,12),
			(9, 'Mukesh',300,6000,6,51),
			(10, 'Rakesh',500,7000,6,50);

Select * from emp44;

Select e.emp_id, e.emp_name, m.emp_name, sm.emp_name
from emp44 e
join emp44 m on (e.manager_id = m.emp_id)
join emp44 sm on (m.manager_id = sm.emp_id)


--04 Feb-2026------------------------Day 45 - SQL Screening Test -----------------------------
/*


*/


create table tbl_orders (
	order_id integer,
	order_date date
	);
insert into tbl_orders
values (1,'2022-10-21'),(2,'2022-10-22'),
(3,'2022-10-25'),(4,'2022-10-25');

Select * from tbl_orders;

select * into tbl_orders_copy from  tbl_orders;

--select * from tbl_orders;
insert into tbl_orders
values (5,'2022-10-26'),(6,'2022-10-26');
delete from tbl_orders where order_id=1;

Select * from tbl_orders_copy;
Select * from tbl_orders;

--My Solution--------------

Select * from (
	Select case when o.order_id is Null then toc.order_id else o.order_id end as order_id,
				case when o.order_date is Null then toc.order_date else o.order_date end as order_date,
				case when o.order_id is Null then 'D'
					when toc.order_id is Null then 'I'
					else Null end as record_status
	from tbl_orders_copy toc
	full outer join tbl_orders o
		on (toc.order_id = o.order_id)) as s1
where record_status is not Null
	
--Ankit Bansal's Approach--------------------------

Select Coalesce(o.order_id, toc.order_id) as order_id,
			Coalesce(o.order_date , toc.order_date) as order_date,
			case when o.order_id is Null then 'D'
				when toc.order_id is Null then 'I'
				else Null end as record_status
from tbl_orders_copy toc
full outer join tbl_orders o
	on (toc.order_id = o.order_id)
where toc.order_id is Null or o.order_id is Null




--04 Feb-2026------------------------Day 46 - Uber SQL Interview Problem -----------------------------
/*
	Write a query to print total rides and profit rides for each driver
	Profit ride is when the end location is of the current ride is same as start location on next ride
*/

create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');

--My Approach using lag function
Select id, count(id) as total_rides, sum(profit_ride) as profit_rides
from (
	Select *,
		case when start_loc =  lag(end_loc) over (Partition by id order by start_time) then 1 else 0 end as profit_ride
	from drivers) as a
Group by id

--My Approach using Self Join
Select d1.id, count(1) as total_rides,
		SUM(case when d2.id is not null then 1 else 0 end) as profit_rides
from drivers d1
left join drivers d2
	on (d1.id = d2.id  and d1.end_loc = d2.start_loc and d1.end_time = d2.start_time)
Group by d1.id


--AB's Approach using Lead function
Select id, count(id) as total_rides, sum(profit_ride) as profit_rides
from (
	Select *,
		Lead(start_loc) over (Partition by id order by start_time)  as next_starting_loc, 
		case when end_loc =  Lead(start_loc) over (Partition by id order by start_time) then 1 else 0 end as profit_ride
	from drivers) as a
Group by id;


--AB's Approach using Self Join

With rides as (
	Select *,
		ROW_NUMBER() over (Partition by id order by start_time asc) as rn
	from drivers)

Select d1.id, count(1) as total_rides, Count(d2.id) as profit_rides
from rides d1
left join rides d2
	on (d1.id = d2.id  and d1.end_loc = d2.start_loc and d2.rn-d1.rn = 1)
Group by d1.id


--05 Feb-2026------------------------Day 47 - Tricky SQL Interview Problem asked in Amazon-----------------------------
/*
	Write a sql query to find users who purchased different products on different dates
	i.e. Products purchased on any given day are not repeated on any other day
*/

create table purchase_history
	(userid int
	,productid int
	,purchasedate date
	);
SET DATEFORMAT dmy;
insert into purchase_history values
(1,1,'23-01-2012')
,(1,2,'23-01-2012')
,(1,3,'25-01-2012')
,(2,1,'23-01-2012')
,(2,2,'23-01-2012')
,(2,2,'25-01-2012')
,(2,4,'25-01-2012')
,(3,4,'23-01-2012')
,(3,1,'23-01-2012')
,(4,1,'23-01-2012')
,(4,2,'25-01-2012');

--My Approach

With case1 as (
		Select userid, Count(distinct purchasedate)  as cntuniquedate
		from purchase_history
		Group by userid
		having Count(distinct purchasedate) >=2),
		
		case2 as (
			Select userid,
				case when productid =  LAG(productid) over (Partition by userid order by purchasedate, productid)  then 'no' else 'yes' end as flag
			from purchase_history),

		case3 as (select distinct(userid) from case2 where flag = 'no')

		Select userid from case1
		where userid not in (select * from case3)

--AB's Approach---------------------------

--Using Having Clause
Select userid, Count(distinct purchasedate)  as pdate, count(productid) as pcount, count(distinct productid) as dpcount 
from purchase_history
Group by userid
Having Count(distinct purchasedate) >=2
			and count(productid) =count(distinct productid)

--Using CTE
With phCTE as (
	Select userid, Count(distinct purchasedate)  as pdate, count(productid) as pcount, count(distinct productid) as dpcount 
	from purchase_history
	Group by userid)

Select * from phCTE
where pdate >=2 and pcount = dpcount



--06 Feb-2026------------------------Day 48 - Market Campaign Success SQL Advanced Problem -----------------------------
/*
	**Market Campaign Sucess**
	*You have a table of in-app purchases by user. Users that make their first in-app purchases are placed in a market campaign where they see
	Call-to-actions for app-in purchases.
	*Find a number of users that made additional in-app purchases due to the success of the marketing campaign.

	*The marketing campaign doesn't start until one day after the initial in-app purchase so users that only made one or multiple purchases
	on the first day do not count, nor do we count users that over time purchase only the products they purchased on the first day.
*/

CREATE TABLE [marketing_campaign](
	 [user_id] [int] NULL,
	 [created_at] [date] NULL,
	 [product_id] [int] NULL,
	 [quantity] [int] NULL,
	 [price] [int] NULL
	);
insert into marketing_campaign values (10,'2019-01-01',101,3,55),
(10,'2019-01-02',119,5,29),
(10,'2019-03-31',111,2,149),
(11,'2019-01-02',105,3,234),
(11,'2019-03-31',120,3,99),
(12,'2019-01-02',112,2,200),
(12,'2019-03-31',110,2,299),
(13,'2019-01-05',113,1,67),
(13,'2019-03-31',118,3,35),
(14,'2019-01-06',109,5,199),
(14,'2019-01-06',107,2,27),
(14,'2019-03-31',112,3,200),
(15,'2019-01-08',105,4,234),
(15,'2019-01-09',110,4,299),
(15,'2019-03-31',116,2,499),
(16,'2019-01-10',113,2,67),
(16,'2019-03-31',107,4,27),
(17,'2019-01-11',116,2,499),
(17,'2019-03-31',104,1,154),
(18,'2019-01-12',114,2,248),
(18,'2019-01-12',113,4,67),
(19,'2019-01-12',114,3,248),
(20,'2019-01-15',117,2,999),
(21,'2019-01-16',105,3,234),
(21,'2019-01-17',114,4,248),
(22,'2019-01-18',113,3,67),
(22,'2019-01-19',118,4,35),
(23,'2019-01-20',119,3,29),
(24,'2019-01-21',114,2,248),
(25,'2019-01-22',114,2,248),
(25,'2019-01-22',115,2,72),
(25,'2019-01-24',114,5,248),
(25,'2019-01-27',115,1,72),
(26,'2019-01-25',115,1,72),
(27,'2019-01-26',104,3,154),
(28,'2019-01-27',101,4,55),
(29,'2019-01-27',111,3,149),
(30,'2019-01-29',111,1,149),
(31,'2019-01-30',104,3,154),
(32,'2019-01-31',117,1,999),
(33,'2019-01-31',117,2,999),
(34,'2019-01-31',110,3,299),
(35,'2019-02-03',117,2,999),
(36,'2019-02-04',102,4,82),
(37,'2019-02-05',102,2,82),
(38,'2019-02-06',113,2,67),
(39,'2019-02-07',120,5,99),
(40,'2019-02-08',115,2,72),
(41,'2019-02-08',114,1,248),
(42,'2019-02-10',105,5,234),
(43,'2019-02-11',102,1,82),
(43,'2019-03-05',104,3,154),
(44,'2019-02-12',105,3,234),
(44,'2019-03-05',102,4,82),
(45,'2019-02-13',119,5,29),
(45,'2019-03-05',105,3,234),
(46,'2019-02-14',102,4,82),
(46,'2019-02-14',102,5,29),
(46,'2019-03-09',102,2,35),
(46,'2019-03-10',103,1,199),
(46,'2019-03-11',103,1,199),
(47,'2019-02-14',110,2,299),
(47,'2019-03-11',105,5,234),
(48,'2019-02-14',115,4,72),
(48,'2019-03-12',105,3,234),
(49,'2019-02-18',106,2,123),
(49,'2019-02-18',114,1,248),
(49,'2019-02-18',112,4,200),
(49,'2019-02-18',116,1,499),
(50,'2019-02-20',118,4,35),
(50,'2019-02-21',118,4,29),
(50,'2019-03-13',118,5,299),
(50,'2019-03-14',118,2,199),
(51,'2019-02-21',120,2,99),
(51,'2019-03-13',108,4,120),
(52,'2019-02-23',117,2,999),
(52,'2019-03-18',112,5,200),
(53,'2019-02-24',120,4,99),
(53,'2019-03-19',105,5,234),
(54,'2019-02-25',119,4,29),
(54,'2019-03-20',110,1,299),
(55,'2019-02-26',117,2,999),
(55,'2019-03-20',117,5,999),
(56,'2019-02-27',115,2,72),
(56,'2019-03-20',116,2,499),
(57,'2019-02-28',105,4,234),
(57,'2019-02-28',106,1,123),
(57,'2019-03-20',108,1,120),
(57,'2019-03-20',103,1,79),
(58,'2019-02-28',104,1,154),
(58,'2019-03-01',101,3,55),
(58,'2019-03-02',119,2,29),
(58,'2019-03-25',102,2,82),
(59,'2019-03-04',117,4,999),
(60,'2019-03-05',114,3,248),
(61,'2019-03-26',120,2,99),
(62,'2019-03-27',106,1,123),
(63,'2019-03-27',120,5,99),
(64,'2019-03-27',105,3,234),
(65,'2019-03-27',103,4,79),
(66,'2019-03-31',107,2,27),
(67,'2019-03-31',102,5,82);


Select * from marketing_campaign mc
Where user_id in (11,14,25)

--My failed approach
Select user_id, count(created_at) as cdate, count(distinct created_at) as udate,
			count(product_id) as p, count(distinct product_id) as up
from marketing_campaign mc
--Where user_id in (11,14,25)
Group by user_id
Having count(distinct created_at) =2 and count(product_id) = count(distinct product_id);

--AB's Approach
with rnk_data as (
			Select user_id, created_at, product_id,
				RANk() over (Partition by user_id order by created_at) as rnk
			from marketing_campaign mc
			--Where user_id in (11,14,25)
			),
	first_time_purchase as (
			Select * from rnk_data where rnk =1),
	except_first_time_purchase as (
			Select * from rnk_data where rnk >1)

select distinct eftp.user_id
from except_first_time_purchase as eftp
left join first_time_purchase ftp
		on (eftp.user_id = ftp.user_id and eftp.product_id = ftp.product_id)
where ftp.user_id is Null


--08 Feb-2026------------------------Day 49 - Fintech Startup SQL Interview Question -----------------------------
/*
	Write a SQL to find all couples of trade for same stock that happend in the range of 10 seconds and having price difference by more than 10%
	Output result should also list the percentage of price difference between 2 trades.
*/

Create Table Trade_tbl(
	TRADE_ID varchar(20),
	Trade_Timestamp time,
	Trade_Stock varchar(20),
	Quantity int,
	Price Float
	)

Insert into Trade_tbl Values('TRADE1','10:01:05','ITJunction4All',100,20)
Insert into Trade_tbl Values('TRADE2','10:01:06','ITJunction4All',20,15)
Insert into Trade_tbl Values('TRADE3','10:01:08','ITJunction4All',150,30)
Insert into Trade_tbl Values('TRADE4','10:01:09','ITJunction4All',300,32)
Insert into Trade_tbl Values('TRADE5','10:10:00','ITJunction4All',-100,19)
Insert into Trade_tbl Values('TRADE6','10:10:01','ITJunction4All',-300,19);
Insert into Trade_tbl Values('TRADE1','10:10:01','Infosys',-300,19);
Insert into Trade_tbl Values('TRADE2','10:10:01','Infosys',-300,19);
Insert into Trade_tbl Values('TRADE3','10:01:05','Infosys',100,20)
Insert into Trade_tbl Values('TRADE4','10:01:06','Infosys',20,15)

Select * from Trade_tbl;

--My Approach-------------------------------------------------------------------
Select  t1.Trade_Stock, t1.TRADE_ID, t2.TRADE_ID,
			t1.Trade_Timestamp, t2.Trade_Timestamp,
			t1.Price, t2.Price,
			ABS((t1.Price-t2.Price)/t1.price*100) as diff_percentage
from Trade_tbl t1
left join Trade_tbl t2
			on datediff(second, t1.Trade_Timestamp, t2.Trade_Timestamp) <=10
			and t1.Trade_Timestamp < t2.Trade_Timestamp
			and t1.Trade_Stock = t2.Trade_Stock
			and t1.Price != t2.Price
Where ABS((t1.Price-t2.Price)/t1.price*100) > 10
order by t1.Trade_Stock, t1.TRADE_ID;


--AB's Approach-------------------------------------------------------------------

Select  t1.Trade_Stock, t1.TRADE_ID, t2.TRADE_ID,
			t1.Trade_Timestamp, t2.Trade_Timestamp,
			t1.Price, t2.Price,
			ABS((t1.Price-t2.Price)/t1.price*100) as diff_percentage
from Trade_tbl t1
inner join Trade_tbl t2
	on t1.Trade_Timestamp < t2.Trade_Timestamp and datediff(second, t1.Trade_Timestamp, t2.Trade_Timestamp) <=10
	and t1.trade_stock = t2.trade_Stock
Where ABS((t1.Price-t2.Price)/t1.price*100) > 10
order by t1.Trade_Stock, t1.TRADE_ID;


--08 Feb-2026------------------------Day 50 - Data Analyt case study -----------------------------
/*
	Write a SQL to find all couples of trade for same stock that happend in the range of 10 seconds and having price difference by more than 10%
	Output result should also list the percentage of price difference between 2 trades.
*/


CREATE TABLE booking_table(
   Booking_id       VARCHAR(3) NOT NULL 
  ,Booking_date     date NOT NULL
  ,User_id          VARCHAR(2) NOT NULL
  ,Line_of_business VARCHAR(6) NOT NULL
);
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');
;
CREATE TABLE user_table(
   User_id VARCHAR(3) NOT NULL
  ,Segment VARCHAR(2) NOT NULL
);
INSERT INTO user_table(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u10','s3');


Select * from booking_table;
Select * from user_table;

--Q1 --Write a sql query which gives segment, no_of_users and users who booked filght in apr 2022.

--My Approach-----------------------------------
With userCTE as (
	Select segment, count(*) as no_of_users
	from user_table
	Group by Segment),

	flightCTE as (
		Select u.Segment, count(distinct u.User_id) as users_who_booked_flight_in_apr2022
		from booking_table b
		inner join user_table u
			on (b.User_id= u.User_id)
		where MONTH(b.Booking_date) = 4 and year(b.Booking_date)=2022 and b.Line_of_business='Flight'
		Group by u.Segment),

	FinalCTE as (
		Select  u.*, f.users_who_booked_flight_in_apr2022 
		from userCTE u
		Join flightCTE f
				on (u.Segment = f.Segment))

Select * from FinalCTE

--AB's Approach-----------------------------------
Select * from booking_table;

Select u.Segment, count(distinct u.user_id) as no_of_users,
	count( distinct Case when b.Line_of_business = 'Flight' and b.Booking_date  between '2022-04-01' and '2022-04-30' then b.User_id  end ) as users_who_booked_flight_in_apr2022
from booking_table b
right join user_table u
	on (b.User_id= u.User_id)
Group by u.Segment

--Q2-Write a query to identify users whose first booking was a hotel booking--------------
Select * from (
	Select *,
		ROW_NUMBER() over (Partition by user_id order by Booking_date, Line_of_business) as rn
	from booking_table) as a
where rn = 1 and Line_of_business = 'Hotel'

--Another approach using first_value
Select distinct USER_ID from (
		Select *,
			first_value(Line_of_business) over (Partition by user_id order by Booking_date, Line_of_business) as first_booking
		from booking_table) as a
where first_booking = 'Hotel'

--Write a query to calculate the days between and first and last_booking of each user

---My Approach
Select User_id, min(first_booking) first_booking, min(last_booking) last_booking,
		datediff(day, min(first_booking), min(last_booking)) as days_between
from (
		Select *,
			first_value(Booking_date) over (Partition by user_id order by Booking_date asc) as first_booking,
			first_value(Booking_date) over (Partition by user_id order by Booking_date desc) as last_booking
		from booking_table
		) a
group by User_id

--Ab's Approach--------------

Select User_id, min(Booking_date) first_booking, max(Booking_date) last_booking,
	datediff(day, min(Booking_date), max(Booking_date)) as days_between
from booking_table
Group by User_id

--Q4-- Write a query to count the number of flight and hotel booking in each user segments for the year 2022
Select u.Segment,
	count(case when b.Line_of_business = 'Flight' then b.User_id end) as flight_bookings,
	Count(case when b.Line_of_business = 'Hotel' then b.User_id end) as hotel_bookings
from booking_table b
inner join user_table u
	on (b.User_id= u.User_id)
where year(Booking_date) = 2022
Group by u.Segment


--09 Feb-2026------------------------Day 51 - Amazon Data Engineer SQL Interview Problem-----------------------------
/*
	Leetcode Hard SQL: 2949: Merge Overlapping Events in the same Hall.
*/

create table hall_events
		(hall_id integer,
		start_date date,
		end_date date);

delete from hall_events

insert into hall_events values 
(1,'2023-01-13','2023-01-14')
,(1,'2023-01-14','2023-01-17')
,(1,'2023-01-15','2023-01-17')
,(1,'2023-01-18','2023-01-25')
,(2,'2022-12-09','2022-12-23')
,(2,'2022-12-13','2022-12-17')
,(3,'2022-12-01','2023-01-30');

Select * from hall_events;

-- My approach with failure----------------------------------
with 
	helperCTE as (Select min(start_date) sd, max(end_date) ed from hall_events),
	rCTE as (
	Select sd as list_date from helperCTE
	Union all
	Select dateadd(day, 1, list_date) from rCTE
	where list_date <= (Select ed as list_date from helperCTE))

Select *,
	case when LAG(start_date, 1, start_date) over (Partition by hall_id order by start_date, end_date) between start_date and end_date
						and LAG(hall_id, 1, hall_id) over (Partition by hall_id order by start_date, end_date) = hall_id then 0 else 1 end as flag
	--,DATEDIFF(day, h.start_date, h.end_date) as dt
from rCTE r
full outer Join hall_events h
	on(r.list_date>= h.start_date and r.list_date<= h.end_date);


-- AB's Approach----------------------------------

with case1 as (
	Select *,
		ROW_NUMBER() over (order by hall_id, start_date) as event_id
	from hall_events),
	
	case2 as (
		Select *, 1 as flag from case1 where event_id = 1
		Union All
		Select case1.*, 
			case when case1.hall_id = case2.hall_id and 
								(case1.start_date between case2.start_date and case2.end_date or case1.end_date between case2.start_date and case2.end_date)
								then 0 else 1 end + flag  as flag 
		from case2
		inner join case1 on case2.event_id+1 = case1.event_id)

--Select * from case2		

Select flag, min(hall_id) hall_id, min(start_date) start_date, max(end_date) end_date
from case2
group by flag;

---------------------------------------------------------
Select '------------------------------Input------------------------------------------------------' as input;
Select * from hall_events;

Select '------------------------------Output------------------------------------------------------' as output;
With case1 as (
	Select *,
		ROW_NUMBER() over (order by hall_id, start_date) as event_id
	from hall_events),

	case2 as (
		Select case1.*, 1 as flag from case1 where event_id=1
		union all
		Select case1.*,
				case when case2.hall_id = case1.hall_id and 
							(case2.start_date between case1.start_date and case2.end_date or case2.end_date between case1.start_date and case2.end_date)
							then 0 else 1 end + case2.flag as flag
		from case2
		Join case1 on (case2.event_id+1 = case1.event_id))


Select hall_id, min(start_date) start_date, max(end_date) end_date
from case2
group by flag, hall_id;


--10 Feb-2026------------------------Day 52 - Paypal SQL Interview Problem-----------------------------
/*
	Leetcode Hard SQL: 2949: Merge Overlapping Events in the same Hall.
*/

create table emp52(
	emp_id int,
	emp_name varchar(20),
	department_id int,
	salary int,
	manager_id int,
	emp_age int);

insert into emp52
values
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

--My Approach-------------------

Select department_id, AVG(salary) as avg_sal
from emp52 
Group by department_id

Select * from (
		Select e1.department_id, AVG(e1.salary) avg_sal,
			AVG(case when e1.department_id = e2.department_id then Null else e2.salary end) as avg2
		from emp52 e1
		join emp52 e2 on (e1.department_id!= e2.department_id) 
		Group by e1.department_id) as a
Where avg_sal < avg2;


--AB's Approach----------

with salary_case1 as (
	Select department_id, avg(salary) avg_salary, count(emp_id) emp_count, sum(Salary) total_salary
	from emp52
	Group by department_id)

Select s1.department_id, AVG(s1.avg_salary) avg_salary, sum(s2.total_salary)/Sum(s2.emp_count) as avg2
--Select *
from salary_case1 s1
join salary_case1 s2 
	on (s1.department_id !=s2.department_id)
Group by s1.department_id
Having AVG(s1.avg_salary) < sum(s2.total_salary)/Sum(s2.emp_count)


--11 Feb-2026------------------------Day 53 - Paypal Data Engineer SQL Interview Question (and a secret time saving trick)-----------------------------
/*
	Write a sql query to find the output as below
	employeeid, employee_default_Phone_number, total_entry, total_login, total_logout, latest_login, latest_logout
*/



CREATE TABLE employee_checkin_details53 (
    employeeid INT,
    entry_details VARCHAR(50),
    timestamp_details DATETIME
);

-- Insert Data into employee_checkin_details
INSERT INTO employee_checkin_details53 (employeeid, entry_details, timestamp_details) VALUES
(1000, 'login', '2023-06-16 01:00:15.340'),
(1000, 'login', '2023-06-16 02:00:15.340'),
(1000, 'login', '2023-06-16 03:00:15.340'),
(1000, 'logout', '2023-06-16 12:00:15.340'),
(1001, 'login', '2023-06-16 01:00:15.340'),
(1001, 'login', '2023-06-16 02:00:15.340'),
(1001, 'login', '2023-06-16 03:00:15.340'),
(1001, 'logout', '2023-06-16 12:00:15.340');

CREATE TABLE employee_details53 (
    employeeid INT,
    phone_number INT, -- Or BIGINT if phone numbers can be larger
    isdefault VARCHAR(512)
);

-- Insert Data into employee_details
INSERT INTO employee_details53(employeeid, phone_number, isdefault) VALUES
(1001, 9999, 'FALSE'),
(1001, 1111,'FALSE'),
(1001, 2222, 'TRUE'),
(1003, 3333, 'FALSE');

Select * from employee_checkin_details53
Select * from employee_details53;


/*
	Write a sql query to find the output as below
	employeeid, employee_default_Phone_number, total_entry, total_login, total_logout, latest_login, latest_logout
*/

---My Approach -------------------------

with empcountCTE as (
		Select employeeid, count(employeeid) empcount
		from employee_details53
		Group by employeeid),

	emp_def_phone as (
		Select ed.employeeid,
			case when ec.empcount> 1 and isdefault = 'False' then null else phone_number end as employee_default_Phone_number
		from employee_details53 ed
		left join empcountCTE ec on (ed.employeeid= ec.employeeid)
		where (case when ec.empcount> 1 and isdefault = 'False' then null else phone_number end) is not null),

	emp_login_logout_detail as (
		Select employeeid, count(entry_details) total_entry,
			count(case when entry_details = 'login' then 1 else null end) as total_login,
			count(case when entry_details = 'logout' then 1 else null end) as total_logout,
			max(case when entry_details = 'login' then timestamp_details else null end) as latest_login,
			max(case when entry_details = 'logout' then timestamp_details else null end) as latest_logout
		from employee_checkin_details53
		Group by employeeid)

Select coalesce(ed.employeeid, el.employeeid) as employeeid, ed.employee_default_Phone_number, 
			el.total_entry, el.total_login, el.total_logout, el.latest_login, el.latest_logout
from emp_login_logout_detail el
full outer join emp_def_phone ed
	on (el.employeeid=ed.employeeid);

--AB's Approach----------------------------------------------
Select * from employee_checkin_details53
Select * from employee_details53;

Select ec.employeeid, ed.phone_number, 
	count(entry_details) total_entry,
	count(case when entry_details = 'login' then 1 else null end) as total_login,
	count(case when entry_details = 'logout' then 1 else null end) as total_logout,
	max(case when entry_details = 'login' then timestamp_details else null end) as latest_login,
	max(case when entry_details = 'logout' then timestamp_details else null end) as latest_logout
from employee_checkin_details53 ec
left join employee_details53 ed
		on (ec.employeeid=ed.employeeid and ed.isdefault='true')
Group by ec.employeeid, ed.phone_number


--12 Feb-2026------------------------Day 54 - Uplers SQL Interview Problem (Senior Data Analyst)-----------------------------
/*
	An organisation is looking to hire employees/candidates for there junior and senior positions. They have a total quota/limit of $50000 in all,
	they have to fillup the senior positions and then fill up the junior positions, There are 3 test cases, write a SQL query to satisfy all the testcases.
	To check whether your sql query is correct or wrong you can try your own test cases too.
*/


Create table candidates54(
	id int primary key,
	positions varchar(10) not null,
	salary int not null);

--test case 1:

insert into candidates54 values
	(1,'junior',5000),
	(2,'junior',7000),
	(3,'junior',7000),
	(4,'senior',10000),
	(5,'senior',30000),
	(6,'senior',20000);

--test case 2:
truncate table candidates54;
insert into candidates54 values
	(20,'junior',10000),
	(30,'senior',15000),
	(40,'senior',30000);

--test case 3:
truncate table candidates54;
insert into candidates54 values
	(1,'junior',15000),
	(2,'junior',15000),
	(3,'junior',20000),
	(4,'senior',60000);

--test case 4:
truncate table candidates54;
insert into candidates54 values
	(10,'junior',10000),
	(40,'junior',10000),
	(20,'senior',15000),
	(30,'senior',30000),
	(50,'senior',15000);

--My  Approach--------------------------
Select * from candidates54;

with seniorCTE as (
	Select positions, count(positions) as hiring_count, sum(salary) as used_budget 
	from (
		Select *,
			SUM(salary) over (partition by positions order by salary asc, id) as running_sum
		from candidates54
		Where positions = 'senior') a
	where running_sum <= 50000
	Group by positions),

juniorCTE as (
	Select positions, count(positions) as hiring_count, sum(salary) as used_budget 
		from (
			Select *,
				SUM(salary) over (partition by positions order by salary asc, id) as running_sum
			from candidates54
			Where positions = 'junior') a
	where running_sum <= 50000- (select used_budget from seniorCTE)
	Group by positions)

Select * from seniorCTE
union all 
Select * from juniorCTE;

--AB's Approach
Select * from candidates54;
with runningsumCTE as (
	Select *,
		SUM(salary) over (partition by positions order by salary asc, id) as running_sum
	from candidates54),
	
	seniorCTE as (
		Select count(positions) seniors, coalesce(sum(salary),0) used_budget
		from runningsumCTE
		where positions = 'senior' and running_sum <= 50000),

	juniorCTE as (
		Select count(positions) juniors, sum(salary) used_budget
		from runningsumCTE
		where positions = 'junior' and running_sum <= 50000 - (select used_budget from seniorCTE))

select juniors, seniors from juniorCTE, seniorCTE


--13 Feb-2026------------------------Day 55 - Uplers SQL Interview Problem (Senior Data Analyst)-----------------------------
/*
	Write a sql to find cities where not even a single order was returned.
*/

create table namaste_orders
	(order_id int,
	city varchar(10),
	sales int)

create table namaste_returns
	(order_id int,
	return_reason varchar(20))

insert into namaste_orders values
	(1, 'Mysore' , 100),
	(2, 'Mysore' , 200),
	(3, 'Bangalore' , 250),
	(4, 'Bangalore' , 150)
	,(5, 'Mumbai' , 300),
	(6, 'Mumbai' , 500),
	(7, 'Mumbai' , 800);

insert into namaste_returns values
	(3,'wrong item'),
	(6,'bad quality'),
	(7,'wrong item');

Select * from namaste_orders;
Select * from namaste_returns;

--My Approach before watching the video
Select no.city, count(no.order_id) total_orders,
	sum(case when nr.order_id is not null then 1 else 0 end) as no_of_returned_orders
from namaste_orders no
left Join namaste_returns nr
	On (no.order_id=nr.order_id)
Group by no.city
Having sum(case when nr.order_id is not null then 1 else 0 end) = 0

--AB's Approach----------------------
Select no.city, count(no.order_id) total_orders, count(nr.order_id) returned_order 
from namaste_orders no
left Join namaste_returns nr
	On (no.order_id=nr.order_id)
Group by no.city
Having count(nr.order_id) = 0


--14 Feb-2026------------------------Day 56 - Solving a Leetcode DSA Problem with DSA-----------------------------
/*
	Write a sql to find the customers starting_location and ending location of the travel----
*/

CREATE TABLE travel_data (
    customer VARCHAR(10),
    start_loc VARCHAR(50),
    end_loc VARCHAR(50)
);

INSERT INTO travel_data (customer, start_loc, end_loc) VALUES
    ('c1', 'New York', 'Lima'),
    ('c1', 'London', 'New York'),
    ('c1', 'Lima', 'Sao Paulo'),
    ('c1', 'Sao Paulo', 'New Delhi'),
    ('c2', 'Mumbai', 'Hyderabad'),
    ('c2', 'Surat', 'Pune'),
    ('c2', 'Hyderabad', 'Surat'),
    ('c3', 'Kochi', 'Kurnool'),
    ('c3', 'Lucknow', 'Agra'),
    ('c3', 'Agra', 'Jaipur'),
    ('c3', 'Jaipur', 'Kochi');

Select * from travel_data;

----My Approach-----------------------------------
With startLocCTE as (
		Select t1.customer, t1.start_loc
		from travel_data t1
		full outer Join travel_data t2
			on (t1.start_loc = t2.end_loc)
		where t2.customer is Null),

		endLocCTE as (
			Select t2.customer, t2.end_loc
			from travel_data t1
			full outer Join travel_data t2
				on (t1.start_loc = t2.end_loc)
			where t1.customer is Null)

Select s.*, e.end_loc from startLocCTE s
Join endLocCTE e on (s.customer=e.customer);

----AB's First Approach
with cte_1 as (
	Select customer, start_loc  as loc, 'start_location' as tbl from travel_data
	union all
	Select customer, end_loc as loc, 'end_location' as tbl from travel_data),

	cte_2 as (
		Select *,
			count(*) over (Partition by customer, loc order by customer, loc) as cnt
		from cte_1)

Select customer, start_location, end_location
From (Select * from cte_2 where cnt =1) a
Pivot(
	max(loc)
	for tbl in (start_location, end_location)
	) as pvt

--AB's menots Approach----------------------------

Select t1.customer,
		Max(case when t2.customer is null then t1.start_loc else null end) as starting_location,
		Max(case when t3.customer is null then t1.end_loc else null end) as starting_location
from travel_data t1
Left Join travel_data t2 on (t1.start_loc = t2.end_loc)
Left Join travel_data t3 on (t1.end_loc = t3.start_loc)
where t2.customer is null or t3.customer is null
Group by t1.customer


--15 Feb-2026------------------------Day 57 - ITC Infotech SQL Interview Question-----------------------------
/*
	Remove duplicate in case of source, destination, distance are same and keep the first value only
	First 2 solution i will not guarantee first row will come first.
*/


CREATE TABLE city_distance
(
    distance INT,
    source VARCHAR(512),
    destination VARCHAR(512)
);

delete from city_distance;
INSERT INTO city_distance(distance, source, destination) VALUES ('100', 'New Delhi', 'Panipat');
INSERT INTO city_distance(distance, source, destination) VALUES ('200', 'Ambala', 'New Delhi');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Bangalore', 'Mysore');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Mysore', 'Bangalore');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Mumbai', 'Pune');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Pune', 'Mumbai');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Chennai', 'Bhopal');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Bhopal', 'Chennai');
INSERT INTO city_distance(distance, source, destination) VALUES ('60', 'Tirupati', 'Tirumala');
INSERT INTO city_distance(distance, source, destination) VALUES ('80', 'Tirumala', 'Tirupati');


--My Approach---------------------------
Select * from city_distance;
with city_distanceCTE as (
	Select *,
		case when source < destination then source else destination end as source1,
		case when destination < source then source else destination end as destination1,
		ROW_Number() over (order by (select Null)) as sn
	from city_distance),

	partitionCTE as (
		select *,
			ROW_NUMBER() over (Partition by source1, destination1, distance order by sn) as rn
		from city_distanceCTE)

Select distance, source, destination
from partitionCTE
where rn =1
order by sn

-- AB's Approach --1st Approach
Select c1.*, c1.*
from city_distance c1
left join  city_distance c2
on (c1.source = c2.destination and c2.source = c1.destination)
where c2.source is null or c1.distance != c2.distance or c1.source < c2.source

-- AB's Approach --2nd Approach
 with city_distanceCTE as (
	Select *,
		case when source < destination then source else destination end as source1,
		case when destination < source then source else destination end as destination1
	from city_distance),

	cte2 as (
		Select *,
			count(*) over (Partition by source1, destination1, distance order by (Select Null)) as cnt
		from city_distanceCTE)
		
Select * from cte2 where cnt =1 or source<destination

-- AB's Approach --3rd Approach
With cte1 as (
	Select *,
		ROW_Number() over (order by (select Null)) as sn
	from city_distance)

Select * from cte1 c1
left join cte1 c2
	on (c1.source=c2.destination and c2.source=c1.destination)
where c2.destination is null or c1.distance != c2.distance or c1.sn< c2.sn


--16 Feb-2026------------------------Day 58 - Famous SQL Interview Question-----------------------------
/*
	Write SQL query to fetch first name, middle name and last name
*/


Create table customers58  (customer_name varchar(30))
insert into customers58 values ('Ankit Bansal')
	,('Vishal Pratap Singh')
	,('Michael'); 

Select * from customers58;

Select *,
	LEFT(customer_name, substring(' ', customer_name, 1) as first_name
from customers58;

with cte1 as (
	Select *,
	len(customer_name)-len(REPLACE(customer_name, ' ','')) total_spaces,
	CHARINDEX(' ', customer_name,1) first_space,
	CHARINDEX(' ', customer_name,CHARINDEX(' ', customer_name,1)+1) second_space
	from customers58)

Select *,
	case when total_spaces=0 then customer_name else SUBSTRING(customer_name, 1, first_space-1) end as first_name,
	case when total_spaces=2 then SUBSTRING(customer_name, first_space+1, second_space-first_space-1) else Null end as middle_name,
	case when total_spaces=2 then SUBSTRING(customer_name, second_space+1, len(customer_name)-second_space) 
		When total_spaces = 1 then SUBSTRING(customer_name, first_space+1, len(customer_name)-first_space) 
		else Null end as last_name 
from cte1


--17 Feb-2026------------------------Day 59 - Ludo King SQL Interview Question-----------------------------
/*
	Write SQL query to fetch first name, middle name and last name
*/

CREATE TABLE user_interactions (
    user_id varchar(10),
    event varchar(15),
    event_date DATE,
    interaction_type varchar(15),
    game_id varchar(10),
    event_time TIME
);

-- Insert the data
INSERT INTO user_interactions 
VALUES
('abc', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab0000', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab0000', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab0000', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab9999', '10:02:43'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab9999', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab1234', '10:02:43'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab1234', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab1234', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab1234', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00');

/*
	No Social Interaction
	One sided Interaction
	Both sided interaction with custom_typed_message
	Both sided interaction without custom_typed_message
*/
Select * from user_interactions;


With cte1 as (
Select game_id,
	Case when count(interaction_type) = 0 then 'No Social Interaction' 
			 when count(distinct case when interaction_type is not null then user_id end) = 1 then 'One side interaction'
			 when count(distinct case when interaction_type is not null then user_id end) = 2
						and count(distinct case when interaction_type = 'custom_typed' then user_id end)>=1
						then 'Both sided interaction with custom_typed_message'
			 when count(distinct case when interaction_type is not null then user_id end) = 2
						and count(distinct case when interaction_type = 'custom_typed' then user_id end)=0
						then 'Both sided interaction without custom_typed_message'

	end as interaction_type
from user_interactions
Group by game_id)

Select interaction_type, count(*) * 1.0 /count(*) over (order by (Select Null)) as distribution
from cte1
Group by interaction_type;


--18 Feb-2026------------------------Day 60 - Swiggy Data Analyst SQL Interview Question-----------------------------
/*
	Write SQL query to fetch supplier_id and product_id and starting_date of record_date for which stock quantity 
	is  less than 50 for two or more consecutive days.
*/


CREATE TABLE stock (
    supplier_id INT,
    product_id INT,
    stock_quantity INT,
    record_date DATE
);

-- Insert the data
delete from stock;
INSERT INTO stock (supplier_id, product_id, stock_quantity, record_date)
VALUES
    (1, 1, 60, '2022-01-01'),
    (1, 1, 40, '2022-01-02'),
    (1, 1, 35, '2022-01-03'),
    (1, 1, 45, '2022-01-04'),
 (1, 1, 51, '2022-01-06'),
 (1, 1, 55, '2022-01-09'),
 (1, 1, 25, '2022-01-10'),
    (1, 1, 48, '2022-01-11'),
 (1, 1, 45, '2022-01-15'),
    (1, 1, 38, '2022-01-16'),
    (1, 2, 45, '2022-01-08'),
    (1, 2, 40, '2022-01-09'),
    (2, 1, 45, '2022-01-06'),
    (2, 1, 55, '2022-01-07'),
    (2, 2, 45, '2022-01-08'),
 (2, 2, 48, '2022-01-09'),
    (2, 2, 35, '2022-01-10'),
 (2, 2, 52, '2022-01-15'),
    (2, 2, 23, '2022-01-16');

Select * from stock;


-----My failed attempt but closer to the AB's query
with cte1 as (
	Select * from stock
	where stock_quantity < 50),

	cte2 as (
		Select *,
			count(*) over (Partition by supplier_id, product_id order by record_date) as rc,
			Datediff(day, Lag(record_date,1, record_date) over (Partition by supplier_id, product_id order by record_date), record_date) pd,
			Datediff(day, record_date, Lead(record_date,1, record_date) over (Partition by supplier_id, product_id order by record_date)) nd
		from cte1)

	Select * from cte2 where (pd in (0,1) or nd in (0,1)) and (pd !=0 and nd!=0)

--- AB's Solution

with cte1 as (
		Select *,
			Lag(record_date,1, record_date) over (Partition by supplier_id, product_id order by record_date) as prev_date, 
			Datediff(day, Lag(record_date,1, record_date) over (Partition by supplier_id, product_id order by record_date), record_date) pd
		from stock
		where stock_quantity < 50),

		cte2 as (
			Select *,
				case when pd <=1 then 0 else 1 end as group_start_flag,
				sum(case when pd <=1 then 0 else 1 end) over (Partition by supplier_id, product_id order by record_date) as group_id
			from cte1)

Select supplier_id, product_id, count(*) no_of_days, min(record_date) as start_date
from cte2
group by supplier_id, product_id, group_id
Having count(*) >=2



--19 Feb-2026------------------------Day 61 - 15 days of learning SQL on Hacker Rank-----------------------------
/*
	Write SQL query to print total number of unique hackers who made atleast 1 submission each day (Starting on the first day of the contest)
	and find the hacker_id and name of the hacker who made maximum number of submissions each day.
	if more than one hacker has a maximum number of submission, print the lowest hacker_id.
	The query should print this information for each day of the contest, sorted by the date.
*/

CREATE TABLE Submissions (
    submission_date DATE,
    submission_id INT PRIMARY KEY,
    hacker_id INT,
    score INT
);

INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES
('2016-03-01', 8494, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30173, 36396, 70),
('2016-03-02', 34928, 20703, 0),
('2016-03-02', 38740, 15758, 60),
('2016-03-02', 42769, 79722, 25),
('2016-03-02', 44364, 79722, 60),
('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 36396, 70),
('2016-03-03', 50273, 79722, 5),
('2016-03-04', 50344, 20703, 0),
('2016-03-04', 51360, 44065, 90),
('2016-03-04', 54404, 53473, 65),
('2016-03-04', 61533, 79722, 15),
('2016-03-05', 72852, 20703, 0),
('2016-03-05', 74546, 38289, 0),
('2016-03-05', 76487, 62529, 0),
('2016-03-05', 82439, 36396, 10),
('2016-03-05', 90006, 36396, 40),
('2016-03-06', 90404, 20703, 0);


Select * from Submissions;

--------------------------My Failed Attempt
with cte1 as (
	Select submission_date, hacker_id, 
			count(hacker_id) over (partition by submission_date, hacker_id order by submission_date, hacker_id) cnt
	from Submissions),

	cte2 as (
		Select *,
			ROW_NUMBER() over (partition by submission_date order by cnt desc) rn
		from cte1)

Select *
from Submissions

Select submission_date, hacker_id, count(distinct hacker_id) as unique_count
from Submissions
Group by submission_date, hacker_id
order by submission_date, hacker_id


------------------------AB's Approach

Select * from Submissions;

with cte1 as (
		Select submission_date, hacker_id, 
			Count(*) as number_of_submission,
			DENSE_RANK() over (order by submission_date) as  day_number,
			Count(*) over (partition by hacker_id order by submission_date) as  running_count,
			Case when (
						DENSE_RANK() over (order by submission_date) = 
						Count(*) over (partition by hacker_id order by submission_date)
						) 
						then 1 else 0 end as unique_flag
		from Submissions
		Group by submission_date, hacker_id),

	cte2 as (
		Select submission_date, hacker_id,
			sum(unique_flag) over (Partition by submission_date order by submission_date) as sm,
			ROW_NUMBER() over (Partition by submission_date order by number_of_submission desc, hacker_id asc) as rnk
		From cte1
		)

Select submission_date, sm as unique_count, hacker_id from cte2 where rnk =1
order by submission_date



--20 Feb-2026------------------------Day 62 - Fractal Analytics SQL Interview Question-----------------------------
/*
	Write SQL query to get the resultset for each region find house which has won maximum no of battles. display region, house and no of wins
*/


-- Create the 'king' table
CREATE TABLE king (
    k_no INT PRIMARY KEY,
    king VARCHAR(50),
    house VARCHAR(50)
);

-- Create the 'battle' table
CREATE TABLE battle (
    battle_number INT PRIMARY KEY,
    name VARCHAR(100),
    attacker_king INT,
    defender_king INT,
    attacker_outcome INT,
    region VARCHAR(50),
    FOREIGN KEY (attacker_king) REFERENCES king(k_no),
    FOREIGN KEY (defender_king) REFERENCES king(k_no)
);

delete from king;
INSERT INTO king (k_no, king, house) VALUES
(1, 'Robb Stark', 'House Stark'),
(2, 'Joffrey Baratheon', 'House Lannister'),
(3, 'Stannis Baratheon', 'House Baratheon'),
(4, 'Balon Greyjoy', 'House Greyjoy'),
(5, 'Mace Tyrell', 'House Tyrell'),
(6, 'Doran Martell', 'House Martell');

delete from battle;
-- Insert data into the 'battle' table
INSERT INTO battle (battle_number, name, attacker_king, defender_king, attacker_outcome, region) VALUES
(1, 'Battle of Oxcross', 1, 2, 1, 'The North'),
(2, 'Battle of Blackwater', 3, 4, 0, 'The North'),
(3, 'Battle of the Fords', 1, 5, 1, 'The Reach'),
(4, 'Battle of the Green Fork', 2, 6, 0, 'The Reach'),
(5, 'Battle of the Ruby Ford', 1, 3, 1, 'The Riverlands'),
(6, 'Battle of the Golden Tooth', 2, 1, 0, 'The North'),
(7, 'Battle of Riverrun', 3, 4, 1, 'The Riverlands'),
(8, 'Battle of Riverrun', 1, 3, 0, 'The Riverlands');
--for each region find house which has won maximum no of battles. display region, house and no of wins
select * from battle;
select * from king;

with winnerCTE as (
	Select * from (
		select *,
			case when b.attacker_outcome = 1 then b.attacker_king else b.defender_king end as winner_id
		from battle b) a
	join king k on (k.k_no = a.winner_id)),

	cte2 as (
				Select region, house, count(*) as no_of_wins,
					ROW_NUMBER() over (Partition by house order by region) as rn
				from winnerCTE
				Group by region, house)

Select * from cte2 where rn =1 
order by region, no_of_wins desc;

--AB's Approach -- mentos zindagi
Select * from  (
	Select b.region, k.house, count(*) no_of_wins,
		RANK() over (Partition by b.region order by count(*) desc) as rn
	from battle b
	join king k on (k.k_no = (case when b.attacker_outcome = 1 then b.attacker_king else b.defender_king end))
	Group by b.region, k.house) a
where rn = 1



--21 Feb-2026------------------------Day 63 - Tredence Analytics SQL Interview Question-----------------------------
/*
	Several friends at a cinema ticket office would like to reserve consecutive available seats.
	Write SQL query to find all consecutive available seats order by the seat_id using the cinema table.
*/

CREATE TABLE cinema (
    seat_id INT PRIMARY KEY,
    free int
);
delete from cinema;
INSERT INTO cinema (seat_id, free) VALUES (1, 1);
INSERT INTO cinema (seat_id, free) VALUES (2, 0);
INSERT INTO cinema (seat_id, free) VALUES (3, 1);
INSERT INTO cinema (seat_id, free) VALUES (4, 1);
INSERT INTO cinema (seat_id, free) VALUES (5, 1);
INSERT INTO cinema (seat_id, free) VALUES (6, 0);
INSERT INTO cinema (seat_id, free) VALUES (7, 1);
INSERT INTO cinema (seat_id, free) VALUES (8, 1);
INSERT INTO cinema (seat_id, free) VALUES (9, 0);
INSERT INTO cinema (seat_id, free) VALUES (10, 1);
INSERT INTO cinema (seat_id, free) VALUES (11, 0);
INSERT INTO cinema (seat_id, free) VALUES (12, 1);
INSERT INTO cinema (seat_id, free) VALUES (13, 0);
INSERT INTO cinema (seat_id, free) VALUES (14, 1);
INSERT INTO cinema (seat_id, free) VALUES (15, 1);
INSERT INTO cinema (seat_id, free) VALUES (16, 0);
INSERT INTO cinema (seat_id, free) VALUES (17, 1);
INSERT INTO cinema (seat_id, free) VALUES (18, 1);
INSERT INTO cinema (seat_id, free) VALUES (19, 1);
INSERT INTO cinema (seat_id, free) VALUES (20, 1);

Select * from cinema;

--My Approach------------------------------

with cte1 as (
	Select *, 
		sum(free) over (order by seat_id rows between 1 preceding and 1 following) as sm,
		case when free !=0 and 
							sum(free) over (order by seat_id rows between 1 preceding and 1 following) >=2 
				then 'yes' else 'no' end as flag
	from cinema)

Select * 
from cte1
where flag = 'Yes';

-------------------AB's Approach --- Method 1---------------------
with cte1 as (
		Select *,
			seat_id - ROW_NUMBER() over (order by seat_id) as grp
		from cinema
		where free=1),

	cte2 as (
		Select *,
			count(grp) over (Partition by grp order by (Select null)) as cnt 
		from cte1)

Select * from cte2 where cnt >1;

---AB's Approach -method 2-------------------------

with cinemaCTE as (
		Select c1.seat_id as s1, c2.seat_id s2
		from cinema c1
		inner join cinema c2
		on (c1.seat_id+1 = c2.seat_id)
		where c1.free = 1 and c2.free = 1)

Select s1 from cinemaCTE
union
Select s2 from cinemaCTE

----AB's Approach - Method 3--------------------------------------
Select * from (
	Select *,
		LAG(free) over (order by seat_id) prev_seat,
		LEAD(free) over (order by seat_id) next_seat
	from cinema) A
Where free=1 and (prev_seat =1 or next_seat =1)



--22 Feb-2026------------------------Day 64 - American Express SQL Interview Question-----------------------------
/*
	Write SQL query to determine the user ids and corresponding page_ids of the pages liked by their friend but not by the user itself yet.
*/


CREATE TABLE friends (
    user_id INT,
    friend_id INT
);

-- Insert data into friends table
INSERT INTO friends VALUES
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(3, 1),
(3, 4),
(4, 1),
(4, 3);

-- Create likes table
CREATE TABLE likes (
    user_id INT,
    page_id CHAR(1)
);

-- Insert data into likes table
INSERT INTO likes VALUES
(1, 'A'),
(1, 'B'),
(1, 'C'),
(2, 'A'),
(3, 'B'),
(3, 'C'),
(4, 'B');



Select * from friends;
Select * from likes;

--AB's Approach - Solution 1
with user_pages as (
	Select distinct f.user_id, l.page_id
	from friends f
	inner join likes l on (f.user_id = l.user_id)),
	

	--Primary CTE
	user_friends_pages as ( 
		Select distinct f.user_id, f.friend_id, l.page_id
		from friends f
		inner join likes l on (f.friend_id = l.user_id))

Select * 
from user_friends_pages fp
left join user_pages as up
	on (fp.user_id = up.user_id and fp.page_id = up.page_id)
where up.user_id is null					-- which means user has not like the pages which his friend has liked


--AB's Approach - Solution 2

Select distinct f.user_id, fp.page_id
from friends f
inner join likes fp on (f.friend_id = fp.user_id)
left  join likes up on (f.user_id = up.user_id and fp.page_id = up.page_id)
where up.user_id is Null  
order by f.user_id;

--AB's Approach - Solution 3


with fp as (
	Select distinct concat(f.user_id, l.page_id) as col
	from friends f
	left  join likes l on (f.user_id = l.user_id))

Select distinct f.user_id, l.page_id
	from friends f
	left  join likes l on (f.friend_id = l.user_id)
	where concat(f.user_id, l.page_id) not in (
								Select * from fp)



--22 Feb-2026------------------------Day 65 - Solving an amazon SQL interview question on notepad-----------------------------
/*
	Write SQL query to find the number of active prime members at the end of 2020 in each market place.
*/


CREATE TABLE subscription_history (
    customer_id INT,
    marketplace VARCHAR(10),
    event_date DATE,
    event CHAR(1),
    subscription_period INT
);

INSERT INTO subscription_history VALUES (1, 'India', '2020-01-05', 'S', 6);
INSERT INTO subscription_history VALUES (1, 'India', '2020-12-05', 'R', 1);
INSERT INTO subscription_history VALUES (1, 'India', '2021-02-05', 'C', null);
INSERT INTO subscription_history VALUES (2, 'India', '2020-02-15', 'S', 12);
INSERT INTO subscription_history VALUES (2, 'India', '2020-11-20', 'C', null);
INSERT INTO subscription_history VALUES (3, 'USA', '2019-12-01', 'S', 12);
INSERT INTO subscription_history VALUES (3, 'USA', '2020-12-01', 'R', 12);
INSERT INTO subscription_history VALUES (4, 'USA', '2020-01-10', 'S', 6);
INSERT INTO subscription_history VALUES (4, 'USA', '2020-09-10', 'R', 3);
INSERT INTO subscription_history VALUES (4, 'USA', '2020-12-25', 'C', null);
INSERT INTO subscription_history VALUES (5, 'UK', '2020-06-20', 'S', 12);
INSERT INTO subscription_history VALUES (5, 'UK', '2020-11-20', 'C', null);
INSERT INTO subscription_history VALUES (6, 'UK', '2020-07-05', 'S', 6);
INSERT INTO subscription_history VALUES (6, 'UK', '2021-03-05', 'R', 6);
INSERT INTO subscription_history VALUES (7, 'Canada', '2020-08-15', 'S', 12);
INSERT INTO subscription_history VALUES (8, 'Canada', '2020-09-10', 'S', 12);
INSERT INTO subscription_history VALUES (8, 'Canada', '2020-12-10', 'C', null);
INSERT INTO subscription_history VALUES (9, 'Canada', '2020-11-10', 'S', 1);



with subscriptionCTE as (
	Select *,
		ROW_NUMBER() over (Partition by customer_id order by event_date desc) as rn
	from subscription_history
	where  event_date<='2020-12-31' )

Select *,
	dateadd(month, subscription_period, event_date) as valid_till
from subscriptionCTE where rn = 1 and event !='C' 
	and  dateadd(month, subscription_period, event_date) >= '2020-12-31'





--23 Feb-2026------------------------Day 66 - Zepto Product Analyst SQL interview question-----------------------------
/*
	Write SQL query to repeat each number in the table till its given number..
	Do not use recursive CTE
*/

create table numbers (n int);
insert into numbers values (1),(2),(3),(4),(5)
insert into numbers values (9);

Select * from numbers;

--My Approach-----------------------------
Select * 
from numbers n1
left Join numbers n2 on (n1.n >= n2.n);

--AB's Approach with recursive CTE------------------------

with cte as (
	Select n, 1 as num_counter from numbers
	union all
	Select n, num_counter +1 from cte
	where num_counter +1 <= n)

Select * from cte
order by n, num_counter

--AB's 2nd Approach without recursive CTE------------------------

Select * 
from numbers n1
left Join numbers n2 on (n1.n >= n2.n);

--AB's 3rd Approach with recursive CTE and self join------------------------

with cte as (
	Select max(n) as num_count from numbers
	union all
	select num_count - 1 from cte
	where num_count - 1 >= 1
)

Select * 
from numbers n1
inner join cte n2
	on (n1.n >= n2.num_count)
order by n, num_count;

--AB's 4th Approach with system table and self join------------------------

with sys_column as (
	select *,
		ROW_NUMBER() over (order by (select null)) as n
	from sys.all_columns),

	cte2 as (
		select n from sys_column where n <= (Select max(n) from numbers))

Select * 
from numbers n1
inner join cte2 n2
	on (n1.n >= n2.n)


--24 Feb-2026------------------------Day 67 - Probo  SQL interview question-----------------------------
/*
	Write SQL query to find winner, winners_proportion, amount to be distributed to the winner, winning amount.
	
*/

create table polls
(
user_id varchar(4),
poll_id varchar(3),
poll_option_id varchar(3),
amount int,
created_date date
)
-- Insert sample data into the investments table
INSERT INTO polls (user_id, poll_id, poll_option_id, amount, created_date) VALUES
('id1', 'p1', 'A', 200, '2021-12-01'),
('id2', 'p1', 'C', 250, '2021-12-01'),
('id3', 'p1', 'A', 200, '2021-12-01'),
('id4', 'p1', 'B', 500, '2021-12-01'),
('id5', 'p1', 'C', 50, '2021-12-01'),
('id6', 'p1', 'D', 500, '2021-12-01'),
('id7', 'p1', 'C', 200, '2021-12-01'),
('id8', 'p1', 'A', 100, '2021-12-01'),
('id9', 'p2', 'A', 300, '2023-01-10'),
('id10', 'p2', 'C', 400, '2023-01-11'),
('id11', 'p2', 'B', 250, '2023-01-12'),
('id12', 'p2', 'D', 600, '2023-01-13'),
('id13', 'p2', 'C', 150, '2023-01-14'),
('id14', 'p2', 'A', 100, '2023-01-15'),
('id15', 'p2', 'C', 200, '2023-01-16');

create table poll_answers
(
poll_id varchar(3),
correct_option_id varchar(3)
)

-- Insert sample data into the poll_answers table
INSERT INTO poll_answers (poll_id, correct_option_id) VALUES
('p1', 'C'),('p2', 'A');

Select * from polls;
Select * from poll_answers;

--My Successful Attemp-------------------------------

with cte1 as (
	Select p.poll_id,
		SUM(case when p.poll_option_id = pa.correct_option_id then p.amount end) as winner_distribution,
		SUM(case when p.poll_option_id != pa.correct_option_id then p.amount end) as loser_distribution
	from polls p
	left join poll_answers pa
		on (p.poll_id = pa.poll_id)
	Group by p.poll_id)

Select p.poll_id, p.user_id,
	p.amount *1.0 / winner_distribution as proportion,
	cte1.loser_distribution as amount_to_be_distributed,
	p.amount *1.0 / cte1.winner_distribution * cte1.loser_distribution as winning_amount
from polls p
join cte1 on (p.poll_id = cte1.poll_id)
join poll_answers pa on (p.poll_id = pa.poll_id and p.poll_option_id=pa.correct_option_id);

--AB's Approach--------------------------------------------------

with cte1 as (
				Select p.poll_id, Sum(p.amount) as amount_to_be_distributed
				from polls p
				left join poll_answers pa
					on (p.poll_id = pa.poll_id)
				where p.poll_option_id != pa.correct_option_id
				Group by p.poll_id),

		cte2 as (
				Select p.user_id, p.poll_id, p.amount, 
					Sum(p.amount) over  (Partition by p.poll_id order by (Select Null)) as poll_total,
					p.amount * 1.0 / Sum(p.amount) over  (Partition by p.poll_id order by (Select Null)) as user_proportion
				from polls p
				left join poll_answers pa
					on (p.poll_id = pa.poll_id)
				where p.poll_option_id = pa.correct_option_id)

		Select cte2.*, cte1.amount_to_be_distributed,
				cte2.user_proportion * cte1.amount_to_be_distributed as winning_amount
		from cte2
		join cte1 on (cte1.poll_id = cte2.poll_id)


	--25 Feb-2026------------------------Day 68 - Top Data Analyst SQL Interview question by a Startup-----------------------------
/*
	Write SQL query to find how  many sessions a user had which was more than 30 minutes, event count, session_start_time and session_end_time
	
*/


create table events 
	(userid int , 
	event_type varchar(20),
	event_time datetime);

insert into events VALUES (1, 'click', '2023-09-10 09:00:00');
insert into events VALUES (1, 'click', '2023-09-10 10:00:00');
insert into events VALUES (1, 'scroll', '2023-09-10 10:20:00');
insert into events VALUES (1, 'click', '2023-09-10 10:50:00');
insert into events VALUES (1, 'scroll', '2023-09-10 11:40:00');
insert into events VALUES (1, 'click', '2023-09-10 12:40:00');
insert into events VALUES (1, 'scroll', '2023-09-10 12:50:00');
insert into events VALUES (2, 'click', '2023-09-10 09:00:00');
insert into events VALUES (2, 'scroll', '2023-09-10 09:20:00');
insert into events VALUES (2, 'click', '2023-09-10 10:30:00');

Select * from events;


--My Approach Successful----- --AB's Approach --------First time my approach matches with  ABs-----------
with cte1 as (
		Select *,
			LAG(event_time, 1, event_time) over (Partition by userid order by event_time) as pet,
			DATEDIFF(MINUTE, LAG(event_time, 1, event_time) over (Partition by userid order by event_time), event_time) as diff,
			Case when DATEDIFF(MINUTE,  LAG(event_time, 1, event_time) over (Partition by userid order by event_time), event_time)  > 30 then 1 else 0 end as flag
		from events),

		cte2 as (
			Select *,
				Sum(cte1.flag) over (Partition by userid order by event_time) +1 as sessionid
			from cte1)

Select userid,  sessionid,  
	min(event_time) as session_start_time, 
	max(event_time) as session_end_time,
	count(event_time) as event_count,
	datediff(MINUTE,  min(event_time), max(event_time)) as session_duration
from cte2
Group by userid,  sessionid
order by userid,  sessionid


	--26 Feb-2026------------------------Day 69 - EPAM SQL Interview questions-----------------------------
/*
	Write a SQL query to find that, for each experience level count the total number of candidates
	and how many of them got a perfect score in each category which they requested to solve the task
	(a null means the candidate was not requested to solve task in that category )
*/

create table assessments
	(
		id int,
		experience int,
		sql int,
		algo int,
		bug_fixing int
	)

delete from assessments
insert into assessments values 
(1,3,100,null,50),
(2,5,null,100,100),
(3,1,100,100,100),
(4,5,100,50,null),
(5,5,100,100,100)



--My Solution---------------------------------------------
Select * from assessments;

with cte1 as (
		Select id, experience,  'sql' as task,  sql as score from assessments
		union all
		Select id, experience,  'algo' as task,  algo as score from assessments
		union all
		Select id, experience,  'bug_fixing' as task,  bug_fixing as score from assessments),

	cte2 as (
		Select id, experience,  AVG(score) as avg_score, 
			case when AVG(score) = 100 then 1 else 0 end as perfect_score
		from cte1 where score is not null
		Group by id, experience)

select experience, sum(perfect_score) as count_of_perfectScoreStudents, count(experience) as total_students
from cte2
Group by experience

----------AB's Solution --- 1st Approach----------------------------------
Select * from assessments;

Select experience, sum(perfect_score) total_perfect_score_candidate, count(experience) as total_candidate
from (
		Select * , 
			Case when 
				(case when sql is null or sql = 100 then 1 else 0 end +
				case when algo is null or algo = 100 then 1 else 0 end +
				case when bug_fixing is null or bug_fixing = 100 then 1 else 0 end) = 3 then 1 else 0 end as perfect_score
		from assessments) as A
Group by experience;

----------AB's Solution --- 2nd Approach-- is matching exactly with mine.--------------------------------



	--27 Feb-2026------------------------Day 70 - Real SQL Interview question by FAANG company -- Google-----------------------------
/*
	Write a SQL query to find that, for each experience level count the total number of candidates
	and how many of them got a perfect score in each category which they requested to solve the task
	(a null means the candidate was not requested to solve task in that category )
*/


CREATE TABLE transactions70 (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount INT,
    tran_Date datetime
);

delete from transactions70;
INSERT INTO transactions70 VALUES (1, 101, 500, '2025-01-01 10:00:01');
INSERT INTO transactions70 VALUES (2, 201, 500, '2025-01-01 10:00:01');
INSERT INTO transactions70 VALUES (3, 102, 300, '2025-01-02 00:50:01');
INSERT INTO transactions70 VALUES (4, 202, 300, '2025-01-02 00:50:01');
INSERT INTO transactions70 VALUES (5, 101, 700, '2025-01-03 06:00:01');
INSERT INTO transactions70 VALUES (6, 202, 700, '2025-01-03 06:00:01');
INSERT INTO transactions70 VALUES (7, 103, 200, '2025-01-04 03:00:01');
INSERT INTO transactions70 VALUES (8, 203, 200, '2025-01-04 03:00:01');
INSERT INTO transactions70 VALUES (9, 101, 400, '2025-01-05 00:10:01');
INSERT INTO transactions70 VALUES (10, 201, 400, '2025-01-05 00:10:01');
INSERT INTO transactions70 VALUES (11, 101, 500, '2025-01-07 10:10:01');
INSERT INTO transactions70 VALUES (12, 201, 500, '2025-01-07 10:10:01');
INSERT INTO transactions70 VALUES (13, 102, 200, '2025-01-03 10:50:01');
INSERT INTO transactions70 VALUES (14, 202, 200, '2025-01-03 10:50:01');
INSERT INTO transactions70 VALUES (15, 103, 500, '2025-01-01 11:00:01');
INSERT INTO transactions70 VALUES (16, 101, 500, '2025-01-01 11:00:01');
INSERT INTO transactions70 VALUES (17, 203, 200, '2025-11-01 11:00:01');
INSERT INTO transactions70 VALUES (18, 201, 200, '2025-11-01 11:00:01');

Select * from transactions70;


--------------My Approach -- Half Attempt-----------------------------------------------------------------------------------------------------------------------------------------------
Select * from transactions70;

Select seller_id, buyer_id, count(*) as cnt

from (
	Select *,
		FIRST_VALUE(customer_id) over (Partition by amount, tran_Date order by transaction_id) as seller_id,
		LAST_VALUE(customer_id) over (Partition by amount, tran_Date order by transaction_id) as buyer_id
	from transactions70
	) as A

where seller_id != buyer_id
Group by seller_id, buyer_id;

--------------AB's Approach-----------------------------------------------------------------------------------------------------------------------------------------------
with cte1 as (
			Select *,
				LEAD(customer_id, 1) over (order by transaction_id) as buyer_id
			from transactions70),

		cte2 as (
			Select customer_id as seller_id, buyer_id from cte1
			where transaction_id%2=1),

		cte3 as (
			Select seller_id, buyer_id, count(*) as number_of_transactions
			from cte2
			Group by seller_id, buyer_id),

		fraud_cte as (
			Select seller_id as fraud_id from cte3
			intersect
			Select buyer_id as fraud_id from cte3),

		final_cte as (
			select * from cte3
			where seller_id not in (Select * from fraud_cte)
			and buyer_id not in (Select * from fraud_cte))

Select * from final_cte;


	--4 March-2026------------------------Day 71 - SQL Project for Data Analytics (Level-Advanced)-----------------------------
/*
	Problem Statement: 
		Noon Launched Food in Dubai on 1st of Jan and your line manager has aked you to share key performance metrics to guage the performance of the verticles.
		All the data of orders is being stored in the below table, kindly use this orders table to write queries to find the insights.

		Write a SQL query to find the below:
			a) Top 3 outlets by cuisine type without using limit and top function
			b) Find the daily new customer count from the table from the launch date (everyday how many new customers are we acquiring)
			c) Count of all the users who were acquired in Jan 2025 and only placed one order in Jan and did not	place any other order
			d) List all the customers with no orders in the last 7 days but acquired one month ago with their first order on promo.
			e) Growth team is planning to create a trigger that will target customers after their every third order with personalized communication 
			     and they have asked you to create a query for this.
			f) List customers who placed more than 1 order and all their orders on a promo only
			g) what percentage of customers were organically acquired in Jan 2025. (Placed there order without promo code)

*/

CREATE TABLE orders71 (
    Order_id VARCHAR(20),
    Customer_code VARCHAR(20),
    Placed_at DATETIME,
    Restaurant_id VARCHAR(10),
    Cuisine VARCHAR(20),
    Order_status VARCHAR(20),
    Promo_code_Name VARCHAR(20)
);

-- Insert data with multiple restaurants per cuisine
INSERT INTO orders71 Values ('OF1900191801','UFDDN1991918XUY1','2025-01-01 15:30:20','KMKMH6787','Lebanese','Delivered','Tasty50');
INSERT INTO orders71 Values ('OF1900191802','UFDDN1991918XUY1','2025-01-02 12:15:45','LEBANESE2','Lebanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191803','UFDDN1991918XUY1','2025-01-10 18:45:30','PIZZA123','Italian','Cancelled','HUNGRY20');
INSERT INTO orders71 Values ('OF1900191804','UFDDN1991918XUY1','2025-01-15 19:20:15','ITALIAN2','Italian','Delivered',null);
INSERT INTO orders71 Values ('OF1900191805','UFDDN1991918XUY1','2025-01-20 11:30:00','BURGER99','American','Delivered',null);
INSERT INTO orders71 Values ('OF1900191806','ABC1234567890XYZ','2025-01-01 08:45:00','AMERICAN2','American','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191807','ABC1234567890XYZ','2025-01-05 13:20:00','TACO789','Mexican','Delivered',null);
INSERT INTO orders71 Values ('OF1900191808','DEF9876543210XYZ','2025-01-02 09:15:00','MEXICAN2','Mexican','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191809','GHI5678901234XYZ','2025-01-03 14:30:00','SUSHI456','Japanese','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191810','JKL3456789012XYZ','2025-01-04 12:00:00','JAPANESE2','Japanese','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191811','MNO7890123456XYZ','2025-01-05 19:45:00','KMKMH6787','Lebanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191812','PQR1234567890ABC','2025-01-06 11:30:00','LEBANESE2','Lebanese','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191813','STU9876543210ABC','2025-01-07 13:15:00','PIZZA123','Italian','Delivered',null);
INSERT INTO orders71 Values ('OF1900191814','VWX5678901234ABC','2025-01-08 18:00:00','ITALIAN2','Italian','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191815','YZA3456789012ABC','2025-01-09 12:45:00','BURGER99','American','Delivered',null);
INSERT INTO orders71 Values ('OF1900191816','BCD7890123456ABC','2025-01-10 20:15:00','AMERICAN2','American','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191817','EFG1234567890DEF','2025-01-11 09:30:00','TACO789','Mexican','Delivered',null);
INSERT INTO orders71 Values ('OF1900191818','HIJ9876543210DEF','2025-01-12 14:45:00','MEXICAN2','Mexican','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191819','KLM5678901234DEF','2025-01-13 17:30:00','SUSHI456','Japanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191820','NOP3456789012DEF','2025-01-14 12:15:00','JAPANESE2','Japanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191821','QRS7890123456DEF','2025-01-15 19:00:00','KMKMH6787','Lebanese','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191822','TUV1234567890GHI','2025-01-16 10:45:00','LEBANESE2','Lebanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191823','WXY9876543210GHI','2025-01-17 15:30:00','PIZZA123','Italian','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191824','ZAB5678901234GHI','2025-01-18 18:15:00','ITALIAN2','Italian','Delivered',null);
INSERT INTO orders71 Values ('OF1900191825','CDE3456789012GHI','2025-01-19 11:00:00','BURGER99','American','Delivered',null);
INSERT INTO orders71 Values ('OF1900191826','FGH7890123456GHI','2025-01-20 20:45:00','AMERICAN2','American','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191827','IJK1234567890JKL','2025-01-21 09:15:00','TACO789','Mexican','Delivered',null);
INSERT INTO orders71 Values ('OF1900191828','LMN9876543210JKL','2025-01-22 14:30:00','MEXICAN2','Mexican','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191829','OPQ5678901234JKL','2025-01-23 17:45:00','SUSHI456','Japanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191830','RST3456789012JKL','2025-01-24 12:30:00','JAPANESE2','Japanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191831','UVW7890123456JKL','2025-01-25 19:15:00','KMKMH6787','Lebanese','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191832','XYZ1234567890MNO','2025-01-26 10:00:00','LEBANESE2','Lebanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191833','ABC9876543210MNO','2025-01-27 15:15:00','PIZZA123','Italian','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191834','DEF5678901234MNO','2025-01-28 18:30:00','ITALIAN2','Italian','Delivered',null);
INSERT INTO orders71 Values ('OF1900191835','GHI3456789012MNO','2025-01-29 11:45:00','BURGER99','American','Delivered',null);
INSERT INTO orders71 Values ('OF1900191836','JKL7890123456MNO','2025-01-30 20:00:00','AMERICAN2','American','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191837','MNO1234567890PQR','2025-01-31 09:45:00','TACO789','Mexican','Delivered',null);
INSERT INTO orders71 Values ('OF1900191838','PQR9876543210PQR','2025-01-31 14:00:00','MEXICAN2','Mexican','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191839','STU5678901234PQR','2025-01-31 17:15:00','SUSHI456','Japanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191840','VWX3456789012PQR','2025-01-31 12:00:00','JAPANESE2','Japanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191841','JAN_ONLY_ORDER1','2025-01-15 13:30:00','KMKMH6787','Lebanese','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191842','JAN_ONLY_ORDER2','2025-01-20 18:45:00','LEBANESE2','Lebanese','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191843','NO_ORDER_LAST7_1','2025-02-01 12:15:00','PIZZA123','Italian','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191844','NO_ORDER_LAST7_2','2025-02-05 19:30:00','ITALIAN2','Italian','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191845','THIRD_ORDER_CUST1','2025-01-05 11:45:00','BURGER99','American','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191846','THIRD_ORDER_CUST1','2025-01-10 14:15:00','AMERICAN2','American','Delivered',null);
INSERT INTO orders71 Values ('OF1900191847','THIRD_ORDER_CUST1','2025-01-15 17:45:00','BURGER99','American','Delivered',null);
INSERT INTO orders71 Values ('OF1900191848','THIRD_ORDER_CUST2','2025-01-10 10:30:00','TACO789','Mexican','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191849','THIRD_ORDER_CUST2','2025-01-15 13:45:00','MEXICAN2','Mexican','Delivered',null);
INSERT INTO orders71 Values ('OF1900191850','THIRD_ORDER_CUST2','2025-01-20 16:30:00','TACO789','Mexican','Delivered',null);
INSERT INTO orders71 Values ('OF1900191851','MULTI_CUISINE_CUST','2025-01-05 12:00:00','KMKMH6787','Lebanese','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191852','MULTI_CUISINE_CUST','2025-01-10 15:30:00','LEBANESE2','Lebanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191853','MULTI_CUISINE_CUST','2025-01-15 18:45:00','PIZZA123','Italian','Delivered',null);
INSERT INTO orders71 Values ('OF1900191854','MULTI_CUISINE_CUST','2025-01-20 11:15:00','ITALIAN2','Italian','Delivered',null);
INSERT INTO orders71 Values ('OF1900191855','MULTI_CUISINE_CUST','2025-01-25 14:45:00','BURGER99','American','Delivered',null);
INSERT INTO orders71 Values ('OF1900191856','SINGLE_ORDER_JAN','2025-01-10 19:00:00','AMERICAN2','American','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191857','NO_ORDER_RECENT','2025-02-10 12:30:00','TACO789','Mexican','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191858','NO_ORDER_RECENT','2025-02-15 18:00:00','MEXICAN2','Mexican','Delivered',null);
INSERT INTO orders71 Values ('OF1900191859','PROMO_FIRST_ONLY','2025-02-01 11:45:00','SUSHI456','Japanese','Delivered','WELCOME50');
INSERT INTO orders71 Values ('OF1900191860','PROMO_FIRST_ONLY','2025-02-05 14:15:00','JAPANESE2','Japanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191861','PROMO_FIRST_ONLY','2025-02-10 17:30:00','SUSHI456','Japanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191862','LAST_ORDER_7DAYS','2025-03-20 10:00:00','KMKMH6787','Lebanese','Delivered','FIRSTORDER');
INSERT INTO orders71 Values ('OF1900191863','LAST_ORDER_7DAYS','2025-03-25 13:15:00','LEBANESE2','Lebanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191864','LAST_ORDER_7DAYS','2025-03-31 16:30:00','KMKMH6787','Lebanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191865','ABC9876543210MNO','2025-02-27 15:15:00','PIZZA123','Italian','Delivered',null);
INSERT INTO orders71 Values ('OF1900191866','CDE3456789012GHI','2025-03-27 15:15:00','PIZZA123','Italian','Delivered',null);
INSERT INTO orders71 Values ('OF1900191867','ABC9876543210MNO','2025-03-15 15:15:00','LEBANESE2','Lebanese','Delivered',null);
INSERT INTO orders71 Values ('OF1900191868','ZZZ9876543210MNO','2025-03-20 15:15:00','LEBANESE2','Lebanese','Delivered','NEWUSER');
INSERT INTO orders71 Values ('OF1900191869','UFDDN1991918XUY1','2025-03-28 11:30:00','BURGER99','American','Delivered',null);
INSERT INTO orders71 Values ('OF1900191870','MULTI_CUISINE_CUST','2025-03-31 14:45:00','PIZZA123','Italian','Delivered',null);
INSERT INTO orders71 Values ('OF1900191871','DEF9876543210XYZ','2025-03-02 09:15:00','KMKMH6787','Lebanese','Delivered','TASTY50');
INSERT INTO orders71 Values ('OF1900191872','UVW7890123456JKL','2025-02-25 19:15:00','KMKMH6787','Lebanese','Delivered','TASTY25');
INSERT INTO orders71 Values ('OF1900191873','UVW7890123456JKL','2025-03-25 19:15:00','PIZZA123','Italian','Delivered','TASTY50');

Select * from orders71;

--a) Top 1 outlets by cuisine type without using limit and top function

Select * from
	(Select cuisine, Restaurant_id, count(*) as total_orders,
	ROW_NUMBER() over (Partition by cuisine order by count(*) desc) as rn
	from orders71
	Group by cuisine, Restaurant_id) as a
where rn = 1;

--b) Find the daily new customer count from the table from the launch date (everyday how many new customers are we acquiring)
Select * from orders71;

--My Failed Attempt
with customerCTE as (
	Select FORMAT(placed_at, 'yyyy-MM-dd') as dt, Customer_code
	from orders71)

Select * 
from customerCTE c1
join customerCTE c2
	on (c1.dt<c2.dt and c1.Customer_code!=c2.Customer_code)

--AB's Approach

with customerDetailCTE as (
	Select Customer_code, cast(min(Placed_at) as Date) as dt
	from orders71
	Group by Customer_code)

Select dt as date, count(*) as new_customer_count
from customerDetailCTE
Group by dt
order by dt;

--c) Count of all the users who were acquired in Jan 2025 and only placed one order in Jan and did not	place any other order
--My attempt
with customerDetailCTE as (
	Select Customer_code, cast(min(Placed_at) as Date) as dt,
			count(*) as total_orders
	from orders71
	Group by Customer_code)

Select * from customerDetailCTE
where MONTH(dt) = 1 and Year(dt) = 2025 and total_orders =1
order by Customer_code;

---AB's Approach

with cte1 as (
	Select distinct Customer_code from orders71
	where Not (month(Placed_at) = 1 and year(Placed_at) = 2025)
	)

Select Customer_code, count(*) as order_count from orders71
where month(Placed_at) = 1 and year(Placed_at) = 2025
and Customer_code not in (Select * from cte1)
Group by Customer_code
Having count(*) = 1;

--d) List all the customers with no orders in the last 7 days but acquired one month ago with their first order on promo.

With cte1 as (
	Select Customer_code, 
				cast(min(placed_at) as date) first_order_date, 
				Cast(max(Placed_at) as date) last_order_date,
				min(Promo_code_Name) Promo_code_Name
	from orders71
	Group by Customer_code)

Select * from cte1
where last_order_date < DATEADD(DAY, -7, GETDATE())
and first_order_date < DATEADD(MONTH, -1, GETDATE())
and Promo_code_Name is not Null;


-- e) Growth team is planning to create a trigger that will target customers after their every third order with personalized communication 
--      and they have asked you to create a query for this.

with cte1 as (
	Select customer_code, placed_at,
		ROW_NUMBER() over (Partition by customer_code order by placed_at) as rn,
		case when ROW_NUMBER() over (Partition by customer_code order by placed_at asc) % 3 = 0 then 'Customized_text' end as custom_text 
	from orders71)

Select * 
from cte1 
where custom_text is not Null
and cast(Placed_at as date) = cast(getdate() as date)


-- f) List customers who placed more than 1 order and all their orders on a promo only

--My Solution -- Failed Attempt-- result is not accurate-----
Select Customer_code, count(*) as order_count, count(Promo_code_Name) as promo_count
from orders71
where Promo_code_Name is not null
Group by Customer_code
Having count(*) > 1

--AB's Approach
Select Customer_code, count(*) as order_count, count(Promo_code_Name) as promo_count
from orders71
Group by Customer_code
Having count(*) > 1 and count(*) = count(Promo_code_Name);

--g) what percentage of customers were organically acquired in Jan 2025. (Placed there order without promo code)
--My failed attempt
with cte1 as (
	Select month(Placed_at) month_num, year(Placed_at) as year_num, count(*) as order_count, count(Promo_code_Name) as promo_count
	from orders71
	Group by month(Placed_at), year(Placed_at))

Select *, promo_count * 100.0/order_count as percentage
from cte1;

--AB's Approach
with cte1 as (
	Select *,
		ROW_NUMBER() over (Partition by Customer_code order by Placed_at) as rn
	from orders71
	where month(Placed_at) =1)

Select count(case when rn =1 and Promo_code_Name is null then Customer_code end)*100.0 / Count(distinct Customer_code) as percentage
from cte1


	--7 March-2026------------------------Day 72 - Microsoft SQL Interview question-----------------------------
/*
	Problem Statement : Possible Flight Routes

*/

CREATE TABLE airports (
    port_code VARCHAR(10) PRIMARY KEY,
    city_name VARCHAR(100)
);

CREATE TABLE flights (
    flight_id varchar (10),
    start_port VARCHAR(10),
    end_port VARCHAR(10),
    start_time datetime,
    end_time datetime
);

delete from airports;
INSERT INTO airports (port_code, city_name) VALUES
('JFK', 'New York'),
('LGA', 'New York'),
('EWR', 'New York'),
('LAX', 'Los Angeles'),
('ORD', 'Chicago'),
('SFO', 'San Francisco'),
('HND', 'Tokyo'),
('NRT', 'Tokyo'),
('KIX', 'Osaka');

delete from flights;
INSERT INTO flights VALUES
(1, 'JFK', 'HND', '2025-06-15 06:00', '2025-06-15 18:00'),
(2, 'JFK', 'LAX', '2025-06-15 07:00', '2025-06-15 10:00'),
(3, 'LAX', 'NRT', '2025-06-15 10:00', '2025-06-15 22:00'),
(4, 'JFK', 'LAX', '2025-06-15 08:00', '2025-06-15 11:00'),
(5, 'LAX', 'KIX', '2025-06-15 11:30', '2025-06-15 22:00'),
(6, 'LGA', 'ORD', '2025-06-15 09:00', '2025-06-15 12:00'),
(7, 'ORD', 'HND', '2025-06-15 11:30', '2025-06-15 23:30'),
(8, 'EWR', 'SFO', '2025-06-15 09:00', '2025-06-15 12:00'),
(9, 'LAX', 'HND', '2025-06-15 13:00', '2025-06-15 23:00'),
(10, 'KIX', 'NRT', '2025-06-15 08:00', '2025-06-15 10:00');

Select * from airports;
Select * from flights;

with flight_details as (
	Select f.*, a.city_name as start_city, b.city_name as end_city
	from flights f
	left join airports a on (f.start_port = a.port_code)
	left join airports b on (f.end_port = b.port_code)),

	new_york as (
		Select * from flight_details where start_city = 'New York'),

	tokyo as (
		Select * from flight_details where end_city = 'Tokyo')

Select n.start_city as trip_start_city,
			t.start_city as middle_city,
			coalesce(t.end_city, n.end_city) as trip_end_city,
			concat(n.flight_id, '; ', t.flight_id) as flight_id,
			datediff(minute, n.start_time, coalesce(t.end_time, n.end_time) ) as total_trip_duration
from new_york n
left Join tokyo t 
	on (n.end_city = t.start_city) 
			and (t.start_time >= n.end_time)
Where n.end_city = 'Tokyo' or t.end_city = 'Tokyo'



	--7 March-2026------------------------Day 73 - Olympic Gold medals problem-----------------------------

/*
		Write a query to find no of gold medal per swimmer for swimmer who won only gold medals
*/


CREATE TABLE events73 (
	ID int,
	event varchar(255),
	YEAR INt,
	GOLD varchar(255),
	SILVER varchar(255),
	BRONZE varchar(255)
	);

delete from events73;

INSERT INTO events73 VALUES (1,'100m',2016, 'Amthhew Mcgarray','donald','barbara');
INSERT INTO events73 VALUES (2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith');
INSERT INTO events73 VALUES (3,'500m',2016, 'Charles','Nichole','Susana');
INSERT INTO events73 VALUES (4,'100m',2016, 'Ronald','maria','paula');
INSERT INTO events73 VALUES (5,'200m',2016, 'Alfred','carol','Steven');
INSERT INTO events73 VALUES (6,'500m',2016, 'Nichole','Alfred','Brandon');
INSERT INTO events73 VALUES (7,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events73 VALUES (8,'200m',2016, 'Thomas','Dawn','catherine');
INSERT INTO events73 VALUES (9,'500m',2016, 'Thomas','Dennis','paula');
INSERT INTO events73 VALUES (10,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events73 VALUES (11,'200m',2016, 'jessica','Donald','Stefeney');
INSERT INTO events73 VALUES (12,'500m',2016,'Thomas','Steven','Catherine');

-- My Solution---------------------------------
Select * from events73;

with gold as (Select ID, event, Year, GOLD as winner, 'GOLD' as medal from events73),
		 silver as (Select ID, event, Year, SILVER as winner, 'SILVER' as medal from events73),
		 bronze as (Select ID, event, Year, BRONZE as winner, 'BRONZE' as medal from events73)

Select winner, count(*) as no_of_gold 
from (
	Select g.* 
	from gold g
	left join silver s  on (g.winner = s.winner)
	left join bronze b  on (g.winner = b.winner)
	where s.ID is null and b.ID is null) as a
Group by winner


---AB's Solution -- 1st Approach

Select GOLD as winner, count(1) as no_of_gold
from events73
Where GOLD not in 
					(Select Silver as winner from events73
					Union  Select BRONZE as winner from events73
         				)
Group by GOLD;

---AB's Solution -- 2nd Approach

With cte as (
	Select Gold as winner, 'Gold' as medal from events73
	Union All
	Select Silver as winner, 'Silver' as medal from events73
	Union All
	Select BRONZE as winner, 'Bronze' as medal from events73)

Select winner, count(*) as no_of_gold 
from cte
Group by winner
Having count(Distinct medal) =1 and max(medal) = 'gold'



	--7 March-2026------------------------Day 74 - Solving a real business use case using sql-----------------------------

/*
		Write a SQL query to find business day between create date and resolved date by excluding weekends and public holidays
*/

create table tickets
	(
	ticket_id varchar(10),
	create_date date,
	resolved_date date
	);
delete from tickets;
insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');
create table holidays
(
holiday_date date
,reason varchar(100)
);
delete from holidays;
insert into holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day');

Select * from tickets;
Select * from holidays;

-- My Solution---------------------------------
with cte as (
		Select ticket_id, create_date, resolved_date, sum(holiday_fall) as public_holidays
		from (
			Select *,
				case when t.create_date<=h.holiday_date and h.holiday_date<= t.resolved_date then 1 else 0 end as holiday_fall
			from tickets t, holidays h) as a
		Group by ticket_id, create_date, resolved_date),

	cte2 as (
		Select *, DATEDIFF(day, create_date, resolved_date) as no_of_days,
			2* DATEDIFF(WEEK, create_date, resolved_date) as no_of_weekend_days
		from cte)

Select ticket_id, create_date, resolved_date, 
			no_of_days, no_of_weekend_days, public_holidays,
			no_of_days-no_of_weekend_days-public_holidays as final_days_bw_create_resolved 
from cte2;

-- AB's Approach---------------------------------
Select *,
	DATEDIFF(day, create_date, resolved_date) as actual_days,
	2* DATEDIFF(WEEK, create_date, resolved_date) as no_of_weekend_days,
	DATEDIFF(day, create_date, resolved_date)  - 2* DATEDIFF(WEEK, create_date, resolved_date) - no_of_public_holidays as business_days

from (
	Select ticket_id, create_date, resolved_date, count(holiday_date) as no_of_public_holidays
	from tickets t
	left join holidays h 
		on holiday_date between create_date and resolved_date
	Group by ticket_id, create_date, resolved_date) a

--Assignment to solve - Suppose if the public holiday falls on weekend, then write a query to resolve this



--21 March-2026------------------------Day 75 - Amazon SQL Interview Question-----------------------------

/*
		Write a SQL query to find total number of people present inside the hospital
*/

Create table hospital ( emp_id int
, action varchar(10)
, time datetime);

insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');


Select * from hospital;

-------------My Solution------------------------------------

with latest_time as (
	Select emp_id, max(time) as latest_time
	from hospital
	group by emp_id)

Select * 
from latest_time lt
join hospital h
on lt.emp_id = h.emp_id and lt.latest_time = h.time
and action = 'in';

-------------AB's 1st Solution-----using CTE-------------------------------
with emp_in_hospital_details as (
	Select emp_id,
	max(Case when action = 'in' then time end) as in_time,
	max(Case when action = 'out' then time end) as out_time
	from hospital
	Group by emp_id)

Select * from emp_in_hospital_details
where in_time > out_time or out_time is null


-------------AB's 2nd Solution------------------------------------
-- by using Having Clause
Select emp_id,
max(Case when action = 'in' then time end) as in_time,
max(Case when action = 'out' then time end) as out_time
from hospital
Group by emp_id
having max(Case when action = 'in' then time end)  > max(Case when action = 'out' then time end)
			or max(Case when action = 'out' then time end) is null


-------------AB's 3rd Solution------------------------------------
with in_time as (
			Select emp_id, max(time) as time 
			from hospital
			where action = 'in'
			Group by emp_id),

		out_time as (
			Select emp_id, max(time) as time 
			from hospital
			where action = 'out'
			Group by emp_id)

Select * 
from in_time i
left join out_time o 
on i.emp_id = o.emp_id 
where i.time > o.time or o.time is null;


-------------AB's 4th Solution------------------------------------
with latest_time as (
		Select emp_id, max(time) as last_activity_time
		from hospital
		Group by emp_id),

		last_in_time as (
			Select emp_id, max(time) as last_activity_time
			from hospital
			where action = 'in'
			Group by emp_id)

Select * from latest_time lt
join last_in_time lit
on (lt.emp_id = lit.emp_id and lt.last_activity_time = lit.last_activity_time)


--23 March-2026------------------------Day 76 - Airbnb SQL Interview Question-----------------------------

/*
		Find the room types that are searched most no. of time.
		Output the room types alongside the number of searches for it.
		If the filter for room types has more than one room type, consider each unique room type as a separate room.
		Sort the result based on the number of searches in descending order
*/

create table airbnb_searches 
	(user_id int,
	date_searched date,
	filter_room_types varchar(200));

delete from airbnb_searches;
insert into airbnb_searches values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room');

Select * from airbnb_searches;

Select value from string_split('entire home, private room', ',')


Select * from airbnb_searches
cross apply string_split(filter_room_types, ',')

Select value as room_type, count(1) as no_of_searches
from airbnb_searches
cross apply string_split(filter_room_types, ',')
Group by value
order by no_of_searches desc


--24 March-2026------------------------Day 77 - SQL Interview Question-----------------------------

/*
		Write a SQL to return all employee whose salary is same with other his/her colleagues in same department
*/



CREATE TABLE [emp_salary]
(
    [emp_id] INTEGER  NOT NULL,
    [name] NVARCHAR(20)  NOT NULL,
    [salary] NVARCHAR(30),
    [dept_id] INTEGER
);


INSERT INTO emp_salary
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');

Select es1.* 
from emp_salary es1
inner join emp_salary es2
on (es1.salary = es2.salary and es1.dept_id = es2.dept_id and es1.emp_id !=es2.emp_id)
order by es1.salary, es1.emp_id



--30 March-2026------------------------Day 78 - L&T SQL Interview Question-----------------------------

/*
		Write a SQL to  Print Highest and Lowest Salary Employees
*/

create table employee 
(
emp_name varchar(10),
dep_id int,
salary int
);
delete from employee;
insert into employee values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000)



--30 March-2026------------------------Day 79 - Data Analyst SQL Interview Question-----------------------------

/*
		Data Analyst SQL Interview Question Asked in a Startup _ Data Analytics
		Write a SQL to  Print Highest and Lowest Salary Employees
*/


create table call_start_logs
(
phone_number varchar(10),
start_time datetime
);
insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00')
create table call_end_logs
(
phone_number varchar(10),
end_time datetime
);
insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
;



--30 March-2026------------------------Day 80 - Infosys SQL Interview Question-----------------------------

/*
		 Solving a SQL Puzzle _ Infosys SQL Interview Question
		Write a SQL to  Print Highest and Lowest Salary Employees
*/

create table input (
id int,
formula varchar(10),
value int
)
insert into input values (1,'1+4',10),(2,'2+1',5),(3,'3-2',40),(4,'4-1',20);



--30 March-2026------------------------Day 81 - Ameriprise LLC Compnay SQL Interview Question-----------------------------

/*
		 Solving a SQL Puzzle _ Infosys SQL Interview Question
		Write a SQL to  Print Highest and Lowest Salary Employees
*/


create table Ameriprise_LLC
(
teamID varchar(2),
memberID varchar(10),
Criteria1 varchar(1),
Criteria2 varchar(1)
);
insert into Ameriprise_LLC values 
('T1','T1_mbr1','Y','Y'),
('T1','T1_mbr2','Y','Y'),
('T1','T1_mbr3','Y','Y'),
('T1','T1_mbr4','Y','Y'),
('T1','T1_mbr5','Y','N'),
('T2','T2_mbr1','Y','Y'),
('T2','T2_mbr2','Y','N'),
('T2','T2_mbr3','N','Y'),
('T2','T2_mbr4','N','N'),
('T2','T2_mbr5','N','N'),
('T3','T3_mbr1','Y','Y'),
('T3','T3_mbr2','Y','Y'),
('T3','T3_mbr3','N','Y'),
('T3','T3_mbr4','N','Y'),
('T3','T3_mbr5','Y','N');


--30 March-2026------------------------Day 82 - Tiger Analytics SQL Interview Question-----------------------------

/*
		 Solving a SQL Puzzle _ Infosys SQL Interview Question
		Write a SQL to  Print Highest and Lowest Salary Employees
*/

create table family 
(
person varchar(5),
type varchar(10),
age int
);
delete from family ;
insert into family values ('A1','Adult',54)
,('A2','Adult',53),('A3','Adult',52),('A4','Adult',58),('A5','Adult',54),('C1','Child',20),('C2','Child',19),('C3','Child',22),('C4','Child',15);
