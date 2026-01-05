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
Select * from orders13











