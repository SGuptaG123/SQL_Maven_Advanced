-- Connect to database (SQL Server)
USE maven_advanced_sql;

-- 1. Basic joins
Select * from happiness_scores
Select * from country_stats

Select	hs.year, hs.country, hs.happiness_score, cs.country, cs.continent 
from	happiness_scores hs
		inner join country_stats cs
		on hs.country = cs.country

-- 2. Join types - inner, left, right, full outer
Select	hs.year, hs.country, hs.happiness_score, cs.country, cs.continent 
from	happiness_scores hs
		inner join country_stats cs
		on hs.country = cs.country

Select	hs.year, hs.country, hs.happiness_score, cs.country, cs.continent 
from	happiness_scores hs
		left join country_stats cs
		on hs.country = cs.country

Select	hs.year, hs.country, hs.happiness_score, cs.country, cs.continent 
from	happiness_scores hs
		right join country_stats cs
		on hs.country = cs.country

Select	hs.year, hs.country, hs.happiness_score, cs.country, cs.continent 
from	happiness_scores hs
		full outer join country_stats cs
		on hs.country = cs.country


-- 3. Joining on multiple columns
Select * from happiness_scores
Select * from country_stats
Select * from inflation_rates

Select	hs.*, ir.inflation_rate
From	happiness_scores hs
		Inner join inflation_rates ir
		on hs.year = ir.year and hs.country = ir.country_name

        
-- 4. Joining multiple tables
Select top 2 * from happiness_scores
Select top 2 * from country_stats
Select top 2 * from inflation_rates

Select	hs.year, hs.country, hs.happiness_score,
		cs.continent, cs.population, ir.inflation_rate
From	happiness_scores hs
		Inner Join country_stats cs
			On hs.country = cs.country
		Inner join inflation_rates ir
			on hs.country = ir.country_name and hs.year = ir.year;

-- 5. Self joins
Create Table employees (
	employee_id int primary key,
	employee_name varchar(100),
	salary int,
	manager_id int
)

Truncate table employees;
Select * From employees;

Insert into employees (employee_id, employee_name, salary, manager_id) Values
	(1, 'AVA', 85000, Null),
	(2, 'Bob', 72000, 1),
	(3, 'Cat', 59000, 1),
	(4, 'Dan', 85000, 2),
	(5, 'Rohan', 59000, 2);

	
Select * From employees
-- Employees with the same salary
Select	e1.employee_id, e1.employee_name, e1.salary, e2.employee_name, e2.salary
From	employees e1
		Left Join employees e2
		on e1.salary = e2.salary and e1.employee_id < e2.employee_id
		Where e2.employee_id is not Null

Select	e1.employee_id, e1.employee_name, e1.salary, e2.employee_name, e2.salary
From	employees e1
		inner Join employees e2
		on e1.salary = e2.salary
Where	e1.employee_id > e2.employee_id


-- Employees that have a greater salary
Select	e1.employee_id, e1.employee_name, e1.salary, e2.employee_name, e2.salary
From	employees e1
		inner Join employees e2
		on e1.salary > e2.salary
order by e1.employee_id




-- Employees and their managers
Select	e1.employee_id, e1.employee_name, 
		e2.employee_name as manager_name
From	employees e1
		Left Join employees e2
		on e1.manager_id = e2.employee_id

-- 6. Cross joins
Create table tops(id int, item varchar(50))
Create table sizes(id int, size varchar(50))
Create table outerwear(id int, item varchar(50))

Insert into tops(id, item) values
	(1, 'T-shirt'),
	(2, 'Hoodie');

Insert into sizes(id, size) values
	(101, 'Small'),
	(102, 'Medium'),
	(103, 'Large');

Insert into outerwear(id, item) values
	(2, 'Hoodie'),
	(4, 'Coat'),
	(3, 'Jacket');

-- View the tables
Select * from tops;
Select * from sizes;
Select * from outerwear;

-- Cross join the tables
Select * from tops cross join sizes

-- From the self join assignment:
-- Which products are within 25 cents of each other in terms of unit price?
SELECT	p1.product_name, p1.unit_price,
		p2.product_name, p2.unit_price,
        p1.unit_price - p2.unit_price AS price_diff
FROM	products p1 INNER JOIN products p2
		ON p1.product_id <> p2.product_id
WHERE	ABS(p1.unit_price - p2.unit_price) < .25
		AND p1.product_name < p2.product_name
ORDER BY price_diff DESC;

        
-- Rewritten with a CROSS JOIN
Select p1.product_name, p1.unit_price, p2.product_name, p2.unit_price,
	p1.unit_price - p2.unit_price as price_diff
from products p1 cross join products p2
where p1.product_name < p2.product_name
and p1.product_id <> p2.product_id
and ABS(p1.unit_price - p2.unit_price) < 0.25
ORDER BY price_diff DESC;

-- 7. Union vs union all
Select * from tops;
Select * from sizes;
Select * from outerwear;

-- Union
Select * from tops
Union
Select * from outerwear;

-- Union all
Select * from tops
Union all
Select * from outerwear;

-- Union with different column names
Select * from tops
Union
Select * from outerwear
union
Select * from sizes


Select top 2 * from happiness_scores
Select top 2 * from happiness_scores_current

Select hs.year, hs.country, hs.happiness_score from happiness_scores hs
Union all
Select 2024, hsc.country, hsc.ladder_score from happiness_scores_current hsc


