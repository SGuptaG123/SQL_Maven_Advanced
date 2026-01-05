-- Connect to database (MySQL)
USE maven_advanced_sql;

-- 1. Subqueries in the SELECT clause
SELECT * FROM happiness_scores;

-- Average happiness score
SELECT AVG(happiness_score) FROM happiness_scores;

-- Happiness score deviation from the average
SELECT  year, country, happiness_score, (Select AVG(happiness_score) from happiness_scores) as AVG_happiness, 
		happiness_score - (Select AVG(happiness_score) from happiness_scores) as AVG_Difference
FROM	happiness_scores;


----------------------------Excercise----------------------------------------------------------
Select * from products

Select AVG(unit_price) from products

Select	product_name, unit_price,
		(Select Min(unit_price) from products) as Min_UnitPrice,
		(Select Max(unit_price) from products) as Max_UnitPrice,
		(Select AVG(unit_price) from products) as Avg_UnitPrice,
		unit_price - (Select AVG(unit_price) from products) as Diff_UnitPrice
from products

Select	product_id ,product_name, unit_price,
		(Select AVG(unit_price) from products) as Avg_UnitPrice,
		unit_price - (Select AVG(unit_price) from products) as Diff_UnitPrice
from	products
Where	unit_price is not Null
order by unit_price Desc

-- 2. Subqueries in the FROM clause
Use Maven_Advanced_SQL;

Select * from happiness_scores

-- Average happiness score for each country
Select country, AVG(happiness_score) as country_hs
from happiness_scores
Group by country


/* Return a country's happiness score for the year as well as
the average happiness score for the country across years */

Select hs.year, hs.country, hs.region, hs.happiness_score, country_hs_table.avg_country_hs
from happiness_scores hs
join (Select country, AVG(happiness_score) as avg_country_hs
		from happiness_scores
		Group by country) as country_hs_table
on hs.country = country_hs_table.country
            
-- View one country
Select hs.year, hs.country, hs.region, hs.happiness_score, country_hs_table.avg_country_hs
from happiness_scores hs
join (Select country, AVG(happiness_score) as avg_country_hs
		from happiness_scores
		Group by country) as country_hs_table
on hs.country = country_hs_table.country
Where hs.country = 'Australia'


-- 3. Multiple subqueries
-- Return happiness scores for 2015 - 2024
Select year, country, happiness_score from happiness_scores
union all
select 2024, country, ladder_score from happiness_scores_current
		
            
/* Return a country's happiness score for the year as well as
the average happiness score for the country across years */

Select	*
from	(Select year, country, happiness_score from happiness_scores
		union all
		select 2024, country, ladder_score from happiness_scores_current) as hs
		join
		(Select country, AVG(happiness_score) as avg_hs
		from happiness_scores
		group by country) as chs
		on hs.country = chs.country

       
/* Return years where the happiness score is a whole point
greater than the country's average happiness score */

Select	*
from	(Select year, country, happiness_score from happiness_scores
		union all
		select 2024, country, ladder_score from happiness_scores_current) as hs
		join
		(Select country, AVG(happiness_score) as avg_hs
		from happiness_scores
		group by country) as chs
		on hs.country = chs.country
Where happiness_score > avg_hs +1


----------------------------Excercise 2 ----------------------------------------------------------
Select * from products

Select factory, count(product_name) as num_products
from products
group by factory


----------------Final Query-----------------------------
Select p.factory, p.product_name, np.num_products
from products p
	Join (Select factory, count(product_name) as num_products
			from products
			group by factory) as np
	on p.factory = np.factory
order by p.factory, p.product_name

-- 4. Subqueries in the WHERE and HAVING clauses

-- Average happiness score
Use Maven_Advanced_SQL;
Select * from happiness_scores


Select AVG(happiness_score) avg_hs
from happiness_scores

-- Above average happiness scores (WHERE)
Select *
from happiness_scores
Where happiness_score > (Select AVG(happiness_score) avg_hs
								from happiness_scores)


-- Above average happiness scores for each region (HAVING)
Select region, AVG(happiness_score) avg_hs
from happiness_scores
Group by region
Having AVG(happiness_score) > (Select AVG(happiness_score) avg_hs
								from happiness_scores)


-- 5. ANY vs ALL
-- Scores that are greater than ANY 2024 scores
Select year, country, region, happiness_score 
from happiness_scores
where happiness_score > ANY (Select ladder_score from happiness_scores_current)


-- Scores that are greater than ALL 2024 scores
Select year, country, region, happiness_score 
from happiness_scores
where happiness_score > All (Select ladder_score from happiness_scores_current)

Select min(ladder_score), max(ladder_score) from happiness_scores_current

-- 6. EXISTS

/* Return happiness scores of countries that exist in the inflation rates table */
Select distinct country_name from inflation_rates;

Select * 
from	happiness_scores hs
where	Exists (Select country_name 
				from inflation_rates i
				where  i.country_name = hs.country)


-- Alternative to EXISTS: INNER JOIN
Select	*
From	happiness_scores as hs
		inner join inflation_rates as ir
		on (hs.country = ir.country_name
			and hs.year = ir.year)
   
   
-------------------------------------------------Exercise 3------------------------------------------------
Use Maven_Advanced_SQL;
Select	*
From	products


Select unit_price from products
where factory = 'Wicked Choccy''s'


Select	*
From	products
where unit_price < All(
				Select unit_price from products
				where factory like 'Wicked Choccy''s')


-- 7. CTEs: Readability

/* SUBQUERY: Return the happiness scores along with the average happiness score for each country */
Select * from happiness_scores

Select country, AVG(happiness_score) avg_hs
from happiness_scores
group by country


Select hs.year, hs.country, hs.happiness_score, avg_hs_table.avg_hs
from happiness_scores hs
	join (Select country, AVG(happiness_score) avg_hs
		from happiness_scores
		group by country) avg_hs_table
	On hs.country = avg_hs_table.country


/* CTE: Return the happiness scores along with the average happiness score for each country */

with c_hs as (
		Select country, AVG(happiness_score) avg_hs
		from happiness_scores
		group by country)

Select hs.year, hs.country, hs.happiness_score, c_hs.avg_hs
from happiness_scores hs
	join c_hs
	On hs.country = c_hs.country

   
-- 8. CTEs: Reusability
-- SUBQUERY: Compare the happiness scores within each region in 2023
-- For each country, return countries from the same region with a lower happiness score in 2023.
 
Select	hs1.region, hs1.country, hs1.happiness_score,
		hs2.country, hs2.happiness_score 
From	happiness_scores hs1 left join happiness_scores hs2
		on hs1.region = hs2.region and hs1.happiness_score > hs2.happiness_score
Where	hs1.year = 2023 and hs2.year = 2023



-- CTE: Compare the happiness scores within each region in 2023
With hs as (
		Select region, country, happiness_score 
		from happiness_scores 
		where year = 2023)

Select h1.*, h2.country, h2.happiness_score 
from hs h1 left join hs h2
on (h1.region = h2.region and h1.happiness_score > h2.happiness_score)

---------------------------------------------------Exercise 4-------------------------------------------------------------
Select * from orders
select * from products

-- 1st way-------
Select o.order_id, Sum((o.units * p.unit_price)) as total_amount_spent
from orders o inner join products p
	on (o.product_id = p.product_id)
Group by o.order_id
Having Sum((o.units * p.unit_price)) > 200
order by Sum((o.units * p.unit_price)) desc

-- 2nd way using CTE------
Use Maven_Advanced_SQL;
With TMS as (Select o.order_id, Sum((o.units * p.unit_price)) as total_amount_spent
			from orders o inner join products p
				on (o.product_id = p.product_id)
			Group by o.order_id
			Having Sum((o.units * p.unit_price)) > 200)

Select count(*) from TMS;

-- 9. Multiple CTEs
-- Step 1: Compare 2023 vs 2024 happiness scores side by side
with hs23 as (Select country, happiness_score from happiness_scores where year = 2023),
	 hs24 as (Select country, ladder_score from happiness_scores_current)

Select * from hs23 join hs24 on hs23.country = hs24.country

-- Step 2: Return the countries where the score increased
With	hs23 as (Select country, happiness_score from happiness_scores where year = 2023),
		hs24 as (Select country, ladder_score from happiness_scores_current)

Select	hs23.country, hs23.happiness_score, hs24.ladder_score 
from	hs23 inner join hs24 
		on hs23.country = hs24.country 
		and hs23.happiness_score < hs24.ladder_score

-- Alternative: CTEs only
With	hs23 as (Select country, happiness_score from happiness_scores where year = 2023),
		hs24 as (Select country, ladder_score from happiness_scores_current),
		hs23_24 as (Select	hs23.country, hs23.happiness_score, hs24.ladder_score 
					from	hs23 inner join hs24 
							on hs23.country = hs24.country 
							and hs23.happiness_score < hs24.ladder_score)

Select * from hs23_24


-------------------------------------------------Exercise
Use Maven_Advanced_SQL;

Select * from products;


With pcount as (Select factory, count(*) as product_count from products group by factory),
	 factorynumbers as (select p.factory, p.product_name, pc.product_count
					from products p join pcount pc
									 on p.factory = pc.factory)

Select * from factorynumbers



-- 10. Recursive CTEs

-- Create a stock prices table
Use Maven_Advanced_SQL;
Drop TABLE stock_prices


CREATE TABLE stock_prices (
    date DATE PRIMARY KEY,
    price DECIMAL(10, 2)
);

INSERT INTO stock_prices (date, price) VALUES
	('2024-11-01', 678.27),
	('2024-11-03', 688.83),
	('2024-11-04', 645.40),
	('2024-11-06', 591.01);
    
/* Employee table was created in prior section:
   This is the code if you need to create it again */
    
/*
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    salary INT,
    manager_id INT
);

INSERT INTO employees (employee_id, employee_name, salary, manager_id) VALUES
	(1, 'Ava', 85000, NULL),
	(2, 'Bob', 72000, 1),
	(3, 'Cat', 59000, 1),
	(4, 'Dan', 85000, 2);
*/

-- Example 1: Generating sequences in SQL Server
SELECT * FROM stock_prices;

-- Generate a column of dates
WITH my_dates AS (
    SELECT CAST('2024-11-01' AS DATE) AS dt
    UNION ALL
    SELECT DATEADD(DAY, 1, dt)
    FROM my_dates
    WHERE dt < '2024-12-31'
)
SELECT dt
FROM my_dates
OPTION (MAXRECURSION 100);


-- Include the original prices
WITH my_dates AS
	(SELECT CAST('2024-11-01' AS DATE) AS dt
    UNION ALL
    SELECT DATEADD(DAY, 1, dt)
    FROM my_dates
    WHERE dt < '2024-11-10')
     
SELECT	md.dt, sp.price
FROM	my_dates md
		LEFT JOIN stock_prices sp
        ON md.dt = sp.date;

-- Example 2: Working with hierachical data
SELECT * FROM employees;

-- Return the reporting chain for each employee in SQL Server
SELECT * FROM employees;

WITH employee_hierarchy AS (
    -- Anchor member: top-level employees (no manager)
    SELECT employee_id, employee_name, manager_id,
			CAST(employee_name AS VARCHAR(MAX)) AS hierarchy
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member: attach subordinates
    SELECT e.employee_id, e.employee_name, e.manager_id,
        eh.hierarchy + ' > ' + e.employee_name AS hierarchy
    FROM employees e
		INNER JOIN employee_hierarchy eh
        ON e.manager_id = eh.employee_id
)

SELECT * FROM employee_hierarchy
ORDER BY employee_id
OPTION (MAXRECURSION 100);




-- Return the reporting chain with hierarchy levels in SQL Server
SELECT * FROM employees;

WITH employee_hierarchy AS (
    -- Anchor member: top-level employees (no manager)
    SELECT 
        employee_id, 
        employee_name, 
        manager_id,
        CAST(employee_name AS VARCHAR(MAX)) AS hierarchy,
        1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member: attach subordinates
    SELECT 
        e.employee_id, 
        e.employee_name, 
        e.manager_id,
        eh.hierarchy + ' > ' + e.employee_name AS hierarchy,
        eh.level + 1 AS level
    FROM employees e
    INNER JOIN employee_hierarchy eh
        ON e.manager_id = eh.employee_id
)
SELECT 
    employee_id, 
    employee_name,
    manager_id, 
    hierarchy,
    level
FROM employee_hierarchy
ORDER BY level, employee_id
OPTION (MAXRECURSION 100);


-- 11. Subquery vs CTE vs Temp Table vs View
-- Subquery

Select * from (
	Select year, country, happiness_score from happiness_scores
	union All
	select 2024, country, ladder_score from happiness_scores_current) as my_sub_query;

-- CTEs
With myCTEs as (Select year, country, happiness_score from happiness_scores
			union All
			select 2024, country, ladder_score from happiness_scores_current)

Select * from myCTEs


-- Temporary table

-- Clean up if rerunning
IF OBJECT_ID('tempdb..#myTempTable') IS NOT NULL
    DROP TABLE #myTempTable;

SELECT CAST(year AS INT) AS year, country,
    CAST(happiness_score AS DECIMAL(10,4)) AS happiness_score
INTO #myTempTable
FROM happiness_scores

UNION ALL

SELECT
    CAST(2024 AS INT) AS year,
    country,
    CAST(ladder_score AS DECIMAL(10,4)) AS happiness_score
FROM happiness_scores_current;

-- Verify
SELECT * FROM #myTempTable;


-- View
Drop View myView

Create View myView AS 
		(Select year, country, happiness_score from happiness_scores
		union All
		select 2024, country, ladder_score from happiness_scores_current)

Select * from myView



