Use Maven_Advanced_SQL;

SELECT * 
FROM information_schema.tables
WHERE table_type = 'BASE TABLE';


Select Count(*) From happiness_scores;
Select Round(happiness_score, 2) From happiness_scores;
Select CURRENT_DATE
Select Count(distinct country) from happiness_scores

----Aggregate, Window, General--------------------
Select AVG(happiness_score) From happiness_scores;

Select country, AVG(happiness_score) as avg_hs
From happiness_scores
Group by country


--Happiest countries each year
Select	year, country, happiness_score,
		ROW_NUMBER() over (Partition by year order by happiness_score DESC) as rn
From	happiness_scores;

Select	year, country, happiness_score,
		UPPER(Country) as CountryInCaps, Round(happiness_score, 1) as hs_rounded
From	happiness_scores


-- 1. NUMERIC FUNCTIONS
-- Math and rounding functions

Select	country, population,
		log(population) as log_pop1,
		Round(log(population), 2) as log_pop2
from	country_stats;


-- Pro tip: FLOOR function for binning
with pop_mn as (Select	country, population,
						Floor(population /1000000) as population_in_mn
				From	country_stats),
	
	pre_prior_query as (
					Select	population_in_mn, count(*) as country_count
					from	pop_mn
					where	population_in_mn is not null
					Group by population_in_mn),
	
	prior_query as (
					Select Case when population_in_mn >= 0 and population_in_mn <= 10 then '0 - 10'
								when population_in_mn >= 11 and population_in_mn <= 20 then '11 - 20'
								when population_in_mn >= 21 and population_in_mn <= 30 then '21 - 30'
								else '11 - 20' end as bucket,
							country_count
					from pre_prior_query)

Select	bucket, sum(country_count) as total_country_count
From	prior_query
group by bucket


-- Max of a column vs max of a row: Least & greatest

-- Create a miles run table
CREATE TABLE miles_run (
    name VARCHAR(50),
    q1 INT,
    q2 INT,
    q3 INT,
    q4 INT
);

INSERT INTO miles_run (name, q1, q2, q3, q4) VALUES
	('Ali', 100, 200, 150, NULL),
	('Bolt', 350, 400, 380, 300),
	('Jordan', 200, 250, 300, 320);

SELECT * FROM miles_run;

-- Return the greatest value of each column
SELECT	MAX(q1), MAX(q2), MAX(q3), MAX(q4)
FROM	miles_run;

-- Return the highest and lowest value of each row
SELECT * FROM miles_run;
Select name, Greatest(q1, q2, q3, q4) as highest_val_Quarters from miles_run;
Select name, Least(q1, q2, q3, q4) as lowest_val_Quarters from miles_run;


-- Create a sample table
CREATE TABLE sample_table (
    id INT,
    str_value CHAR(50)
);

INSERT INTO sample_table (id, str_value) VALUES
	(1, '100.2'),
	(2, '200.4'),
	(3, '300.6');

SELECT * FROM sample_table;


-- Try to do a math calculation on the string column
Select id, str_value*2 from sample_table

SELECT * FROM sample_table;
Select id, Cast(str_value as float)*2 as multi2 from sample_table
Select id, Cast(str_value as decimal(5,2))*2 as multi2 from sample_table

-- Turn an integer into a float
Select country,  Round(population/5.0, 2) from country_stats


----------------------------Exercise---------------------------
Select * from products;
Select * from orders;

With customer_detail as (
										Select customer_id, Sum(units * unit_price) as total_spend,
													Floor(Sum(units * unit_price) / 10 ) * 10 as rounded_val
										from orders o 
										join products p 
										on (o.product_id = p.product_id)
										group by customer_id)

Select	rounded_val as total_spend_bin, count(customer_id) as num_customer
from customer_detail
Group by rounded_val

-- 3. DATETIME FUNCTIONS

-- Get the current date and time
SELECT	CURRENT_DATE, CURRENT_TIMESTAMP;

-- Create a my events table
CREATE TABLE my_events (
    event_name VARCHAR(50),
    event_date DATE,
    event_datetime DATETIME,
    event_type VARCHAR(20),
    event_desc TEXT);

INSERT INTO my_events (event_name, event_date, event_datetime, event_type, event_desc) VALUES
('New Year''s Day', '2025-01-01', '2025-01-01 00:00:00', 'Holiday', 'A global celebration to mark the beginning of the New Year. Festivities often include fireworks, parties, and various cultural traditions as people reflect on the past year and set resolutions for the upcoming one.'),
('Lunar New Year', '2025-01-29', '2025-01-29 10:00:00', 'Holiday', 'A significant cultural event in many Asian countries, the Lunar New Year, also known as the Spring Festival, involves family reunions, feasts, and various rituals to welcome good fortune and happiness for the year ahead.'),
('Persian New Year', '2025-03-20', '2025-03-20 12:00:00', 'Holiday', 'Known as Nowruz, this celebration marks the first day of spring and the beginning of the year in the Persian calendar. It is a time for family gatherings, traditional foods, and cultural rituals to symbolize renewal and rebirth.'),
('Birthday', '2025-05-13', '2025-05-13 18:00:00', ' Personal!', 'A personal celebration marking the anniversary of one''s birth. This special day often involves gatherings with family and friends, cake, gifts, and reflecting on personal growth and achievements over the past year.'),
('Last Day of School', '2025-06-12', '2025-06-12 15:30:00', ' Personal!', 'The final day of the academic year, celebrated by students and teachers alike. It often includes parties, awards, and a sense of excitement for the upcoming summer break, marking the end of a year of hard work and learning.'),
('Vacation', '2025-08-01', '2025-08-01 08:00:00', ' Personal!', 'A much-anticipated break from daily routines, this vacation period allows individuals and families to relax, travel, and create memories. It is a time for adventure and exploration, often enjoyed with loved ones.'),
('First Day of School', '2025-08-18', '2025-08-18 08:30:00', ' Personal!', 'An exciting and sometimes nerve-wracking day for students, marking the beginning of a new academic year. This day typically involves meeting new teachers, reconnecting with friends, and setting goals for the year ahead.'),
('Halloween', '2025-10-31', '2025-10-31 18:00:00', 'Holiday', 'A festive occasion celebrated with costumes, trick-or-treating, and various spooky activities. Halloween is a time for fun and creativity, where people of all ages dress up and participate in themed events, parties, and community gatherings.'),
('Thanksgiving', '2025-11-27', '2025-11-27 12:00:00', 'Holiday', 'A holiday rooted in gratitude and family, Thanksgiving is celebrated with a large feast that typically includes turkey, stuffing, and various side dishes. It is a time to reflect on the blessings of the year and spend quality time with loved ones.'),
('Christmas', '2025-12-25', '2025-12-25 09:00:00', 'Holiday', 'A major holiday celebrated around the world, Christmas commemorates the birth of Jesus Christ. It is marked by traditions such as gift-giving, festive decorations, and family gatherings, creating a warm and joyous atmosphere during the holiday season.');

SELECT * FROM my_events;

-- Extract info about datetime values
Select	event_name, event_date, event_datetime,
			Year(event_date) as yoe,
			Month(event_date) as moe,
			DatePart(Weekday,  event_date) as doe,
			DateName(Weekday,  event_date) as event_dow_name
from my_events;

-- Calculate an interval between datetime values
Select	event_name, event_date, event_datetime, CURRENT_DATE as todays_date,
			DATEDIFF(day, event_date, CURRENT_DATE ) as days_until,
			DATEDIFF(month, event_date, CURRENT_DATE ) as month_until,
			DATEDIFF(YEAR, event_date, CURRENT_DATE ) as year_until 	
from my_events;

-- Add / subtract an interval from a datetime value
Select	event_name, event_date, event_datetime, CURRENT_DATE as todays_date,
			DateAdd(day, 15, event_date) as future_15_date_event,
			DateAdd(MONTH, 1, event_date) as future_1month_date_event,
			DateAdd(Hour, 1, event_datetime) as Next_hour
from my_events;

-------------------------------------Exercise Datetime Function--------------------------------------------
Select * from orders


Select *, DateAdd(day, 2, order_date) as Next_Ship_date
from orders
where Datepart(quarter, order_date) = 2
			and DATEPART(year, order_date) = 2024

-- 4. STRING FUNCTIONS
-- Change the case

Select * from my_events
Select event_name, UPPER(event_name) as U_eventname, LOWER(event_name) as L_eventname 
from my_events;

-- Clean up event type and find the length of the description
Select *, Replace(TRIM(event_type), '!', '') as clean_type,
			len(CAST(event_desc AS VARCHAR(MAX))) as length_of_desc
from my_events;

-- Combine the type and description columns
With my_event_clean as (
										Select *, Replace(TRIM(event_type), '!', '') as clean_type,
													len(CAST(event_desc AS VARCHAR(MAX))) as length_of_desc
										from my_events)

Select *, CONCAT(clean_type, ' | ', event_desc)  as combo
from my_event_clean


----------------------------------------------------Exercise--------------------------------------------------
--We're updating our product_ids to include the factory name and product name, write a sql code to produce this.
select * from products

select factory,  product_id, 
			concat(replace(trim(replace(factory, '''', '')), ' ', '-'), '-', product_id) as factory_product_id
from products
 

 -- Return the first word of each event
 Select * from my_events

SELECT event_name,
             CASE WHEN CHARINDEX(' ', event_name) > 0  THEN SUBSTRING(event_name, 1, CHARINDEX(' ', event_name) - 1)
					   ELSE event_name END AS FirstWord
FROM my_events;

-- Return descriptions that contain 'family'
 Select *  from my_events
 where event_desc like '%family%'

-- Return descriptions that start with 'A'
 Select *  from my_events
 where event_desc like 'A%'

-- Return students with three letter first names
Select * from students
where student_name like '___ %'

-- Note any celebration word in the sentence
Select * from my_events
where event_desc like '%holiday%'
			or event_desc like '%festival%'
			or event_desc like '%celebration%'	
			
-- It's not working in ssms 2022
Select event_desc, 
			REGEXP_SUBSTR(event_desc, 'holiday|festival|celebration') as celebration_word
from my_events
where event_desc like '%holiday%'
			or event_desc like '%festival%'
			or event_desc like '%celebration%'	

-- Return words with hyphens in them
-- It's not working in ssms 2022
Select event_desc, 
			REGEXP_SUBSTR(event_desc, '[A-Z][a-z]+(-[A-Za-z]+)+') as celebration_word
from my_events

-----------------------------------------Exercise-----------------------------------------
Select product_name, replace(product_name, 'Wonka Bar - ', '') from products

Select product_name, 
			case when CHARINDEX('-', product_name) > 0 then SUBSTRING(product_name, CHARINDEX('-', product_name)+2)
					else product_name end as new_product_name
from products

-- 5. NULL FUNCTIONS

-- Create a contacts table
CREATE TABLE contacts (
    name VARCHAR(50),
    email VARCHAR(100),
    alt_email VARCHAR(100));

INSERT INTO contacts (name, email, alt_email) VALUES
	('Anna', 'anna@example.com', NULL),
	('Bob', NULL, 'bob.alt@example.com'),
	('Charlie', NULL, NULL),
	('David', 'david@example.com', 'david.alt@example.com');

SELECT * FROM contacts;

-- Return null values
SELECT * FROM contacts
where email is null

-- Return non-null values
SELECT * FROM contacts
where email is not null

-- Return non-NULL values using a CASE statement
Select name, email,
			case when email is not null then email
					else 'no email' end as new_email_col
from contacts

-- Return non-NULL values using IF NULL
Select name, email,
			Isnull(email, 'no email') as new_email_col
from contacts

-- Return an alternative field using IF NULL
Select name, email,
			coalesce(email, 'no email') as new_email_col
from contacts

-- Return an alternative field after multiple checks
Select name, email, alt_email,
			coalesce(email, alt_email, 'no email') as new_email_col
from contacts;


---------------------------------Exercise------------------------------------------

--Replace null value with other
Select product_name, factory, division,
			coalesce(division, 'Other') as division_other
from products;


--Find the most common division for each factory
Select factory, division, count(*) as common_factory
from products
where division is not null
Group by factory, division
order by factory, division;

-- ----------------Exercise Solution-------------------------------
with cf as (Select factory, division, count(*) as common_factory,
								DENSE_RANK() over (Partition by factory order by count(*) Desc) as rnk
					from products
					where division is not null
					Group by factory, division
					),
		next_query as (Select * from cf  where rnk = 1),
		prior_query as (Select product_name, factory, division,
											coalesce(division, 'Other') as division_other
									from products)

Select prior_query.*,  next_query.division as division_top
from prior_query Left	Join next_query 
			On (prior_query.factory = next_query.factory)





















