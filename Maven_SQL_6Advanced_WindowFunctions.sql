--Connect to database
Use Maven_Advanced_SQL;

--Check how many tables are present in the maven database
Exec sp_tables

--Check how many tables are present in the maven database
SELECT * 
FROM information_schema.tables
WHERE table_type = 'BASE TABLE';

--Check all the column details available in the happiness scores table
EXEC sp_help 'happiness_scores'

--No partitioning, only generating the row numbers| order by year and country
Select	year, country, happiness_score,
		row_number() over(order by year, country) as row_num
from	happiness_scores


-- Return all row numbers within each window
-- where the rows are ordered by happiness score 
Select	year, country, happiness_score,
		row_number() over(partition by country order by happiness_score) as row_num
from	happiness_scores


-- Return all row numbers within each window
-- where the rows are ordered by happiness score descending
Select	year, country, happiness_score,
		row_number() over(partition by country order by happiness_score Desc) as row_num
from	happiness_scores


-----------------------------Exercise -
--We currently have an orders report with customer, order and transaction IDs, 
--and we would like to add an additional column that contains the transaction number for each customer as well.
--Could you help us do this using window functions?

Select	o.customer_id, o.order_id, o.order_date, o.transaction_id,
		ROW_NUMBER() OVER(Partition by o.customer_id Order by o.transaction_id) as tansaction_number 
from	orders o


-- 2. ROW_NUMBER vs RANK vs DENSE_RANK
CREATE TABLE baby_girl_names (
    name VARCHAR(50),
    babies INT);

INSERT INTO baby_girl_names (name, babies) VALUES
	('Olivia', 99),
	('Emma', 80),
	('Charlotte', 80),
	('Amelia', 75),
	('Sophia', 72),
	('Isabella', 70),
	('Ava', 70),
	('Mia', 64);
    
-- View the table
SELECT * FROM baby_girl_names;

-- Compare ROW_NUMBER vs RANK vs DENSE_RANK
Select	*,
		ROW_NUMBER() Over (order by babies desc) as b_row_num,
		RANK() Over (order by babies desc) as b_rank,
		DENSE_RANK() Over (order by babies desc) as b_dense_rank
from	baby_girl_names


----------------------------Exercise--------------------------

--View the column of interest
select o.order_id, o.product_id, o.units
From	orders o
Order by order_id ASC

--Try ROW_NUMBER to rank the units
Select	o.order_id, o.product_id, o.units,
		ROW_NUMBER() Over (Partition by order_id order by units desc) as product_rn
From	orders o
order by order_id, product_rn

--For each order, rank the products from most units to fewest units
--If there's a tie, keep the tie and don't skip the next number after
Select	o.order_id, o.product_id, o.units,
		DENSE_RANK() Over (Partition by order_id order by units desc) as product_rn
From	orders o
order by order_id, product_rn



--checking for order_id which ends with 44262
Select	o.order_id, o.product_id, o.units,
		DENSE_RANK() Over ( Partition by order_id order by units desc) as product_rn
From	orders o
Where order_id like '%44262'
Order by order_id ASC


-- 3. FIRST_VALUE, LAST VALUE & NTH_VALUE
DROP TABLE baby_names
CREATE TABLE baby_names (
    gender VARCHAR(10),
    name VARCHAR(50),
    babies INT);

INSERT INTO baby_names (gender, name, babies) VALUES
	('Female', 'Charlotte', 80),
	('Female', 'Emma', 82),
	('Female', 'Olivia', 99),
	('Male', 'James', 85),
	('Male', 'Liam', 110),
	('Male', 'Noah', 95);
    
-- View the table
SELECT * FROM baby_names;

-- Return the first name in each window
Select	*,
		FIRST_VALUE(name) over (Partition by gender order by babies desc) as top_name
From	baby_names 

-- Return the least popular name in each window
Select	*,
		FIRST_VALUE(name) over (Partition by gender order by babies Asc) as firstval
From	baby_names 

-- Return the Top/Most popular names in each gender
Select * from
	(Select	*,
			FIRST_VALUE(name) over (Partition by gender order by babies desc) as top_name
	From	baby_names) as top_name

where name = top_name

---Using CTEs--------------

with top_name as (
				Select	*, FIRST_VALUE(name) over (Partition by gender order by babies desc) as top_name
				From	baby_names) 

Select * from top_name
where name = top_name


-- Return the second name in each window
WITH ranked AS (
				SELECT gender, name, babies,
				ROW_NUMBER() OVER (PARTITION BY gender ORDER BY babies DESC, name ASC) AS rn
				FROM baby_names),
	 SecondName as (SELECT gender, name, babies,
							MAX(CASE WHEN rn = 2 THEN name END) OVER (PARTITION BY gender) AS second_name
					FROM ranked)


Select * from SecondName where name = second_name


-- Alternative using ROW_NUMBER
-- Number all the rows within each window

with babyNum as (SELECT	gender, name, babies,
						ROW_NUMBER() OVER(PARTITION BY gender ORDER BY babies DESC) AS popularity
				FROM	baby_names)

Select * 
from babyNum
Where popularity <= 2




----------------------------Exercise--------------------------
Select * from orders;

With product_CTE as (Select	order_id, product_id, units,
							DENSE_RANK() over (Partition by order_id order by units Desc) as rn
					from	orders)

Select order_id, product_id, units 
from product_CTE
where rn = 2

-- 4. LEAD & LAG

-- Return the prior year's happiness score

Select	year, country, happiness_score,
		LAG(happiness_score) over (Partition by country order by year asc) as p_hs
From	happiness_scores;

--Calculate the difference in happiness scores over time, by country
With prev_HS as (
				Select	country, year, happiness_score,
						LAG(happiness_score) over (Partition by country order by year asc) as p_hs
				From	happiness_scores
				where	year >=2020)

Select	country, year, happiness_score,
		(happiness_score - p_hs) as hs_change
from	prev_HS




----Excercise - Change in orders from time to time for each customer---------------------

Select * from orders;

With prior_order as (
					Select	customer_id, order_id, Sum(units) as total_units,
							LAG(Sum(units)) over (Partition by customer_id order by order_id ASC) as prior_units
					From	orders
					Group   by customer_id, order_id)

Select	*,
		total_units - prior_units as change_in_units 
from	prior_order


-- 5. NTILE
-- Add a percentile to each row of data
Select * from happiness_scores;

with myPercentileCTE as (
						Select	region, country, happiness_score,
								NTILE(4) over (Partition by region order by region ASC, happiness_score DESC) as percentile
						from	happiness_scores
						where year = 2023)

Select * from myPercentileCTE
where percentile =1



------------- Exercise Top 1% of Customer----------------------------------------
Select * from orders;

With CustomerTotal as (
						Select	orders.customer_id, Sum(orders.units * products.unit_price) as total_spend
						from	orders left join products
								on (orders.product_id = products.product_id)
						Group by orders.customer_id),
	 prior_query as (
						Select	customer_id, total_spend,
								NTILE(100) over (order by total_spend DESC) as spend_pct
						from	CustomerTotal)

Select * 
from prior_query
where spend_pct =1
order by total_spend DESC


-------------------------------Practical examples of moving average

Select	country, year, happiness_score,
		AVG(happiness_score) over (Partition by country order by year ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as three_year_ma 
from	happiness_scores









