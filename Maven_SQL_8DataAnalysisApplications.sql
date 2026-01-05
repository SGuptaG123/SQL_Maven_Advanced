Use Maven_Advanced_SQL

CREATE TABLE employee_details (
    region VARCHAR(50),
    employee_name VARCHAR(50),
    salary INTEGER
);

INSERT INTO employee_details (region, employee_name, salary) VALUES
	('East', 'Ava', 85000),
	('East', 'Ava', 85000),
	('East', 'Bob', 72000),
	('East', 'Cat', 59000),
	('West', 'Cat', 63000),
	('West', 'Dan', 85000),
	('West', 'Eve', 72000),
	('West', 'Eve', 75000);

-- View the employee details table
SELECT * FROM employee_details;

-- View duplicate rows
-- 1. View duplicate employees
Select employee_name, count(*) as dup_count
from employee_details
group by employee_name
having  count(*) >1;

-- 2. View duplicate region + employee combos
Select region, employee_name, count(*) as dup_count
from employee_details
group by region, employee_name
having  count(*) >1;

-- 3. View fully duplicate rows
Select region, employee_name, salary, count(*) as dup_count
from employee_details
group by region, employee_name, salary
having  count(*) >1;

-- Exclude duplicate rows
-- 1. Exclude fully duplicate rows
Select Distinct region, employee_name, salary
from employee_details;

-- 2. Exclude partially duplicate rows (unique employee name for each row)
With emp_CTE as (Select *,
											ROW_NUMBER() over (Partition by employee_name order by salary Desc) as rnk
								From employee_details)
Select * from emp_CTE where rnk =1;


-- 3. Exclude partially duplicate rows (unique region + employee name for each row)
With emp_CTE as (Select *,
											ROW_NUMBER() over (Partition by region, employee_name order by salary Desc) as rnk
								From employee_details)
Select * from emp_CTE where rnk =1

---------------------------------------------------------Exercise--------------------------------------------------------------------
Select * from 
(Select Student_name, email,
			ROW_NUMBER() over (Partition by Student_name order by email) as rnk
from students) as rnktbl
where rnk =1

-- 2. MIN / MAX VALUE FILTERING
CREATE TABLE sales (
								id INT PRIMARY KEY,
								sales_rep VARCHAR(50),
								date DATE,
								sales INT);

INSERT INTO sales (id, sales_rep, date, sales) VALUES 
									(1, 'Emma', '2024-08-01', 6),
									(2, 'Emma', '2024-08-02', 17),
									(3, 'Jack', '2024-08-02', 14),
									(4, 'Emma', '2024-08-04', 20),
									(5, 'Jack', '2024-08-05', 5),
									(6, 'Emma', '2024-08-07', 1);


-- View the sales table
SELECT * FROM sales;

--Return the most recent sales for each sales rep ------ using Join----------------------------

with MRD as (SELECT sales_rep, max(date) as most_recent_date 
						FROM sales
						group by sales_rep)

SELECT sales.*
FROM sales join MRD
on sales.date = MRD.most_recent_date
and sales.sales_rep = MRD.sales_rep

--Return the most recent sales for each sales rep ------ using ROW_NUMBER()----------------------------

SELECT * FROM sales;

With salesCTE as (SELECT id, sales_rep, date, sales,
												ROW_NUMBER() over (Partition by sales_rep order by date desc) as rnk
								FROM sales)
Select * from salesCTE where rnk =1;

--------------------------------------------------------Exercise - ----------------------------------------------------

Select * from student_grades
order by student_id
Select * from students


Select student_id, student_name, final_grade, class_name
from (	Select sg.student_id, s.student_name, sg.final_grade, sg.class_name,
						ROW_NUMBER() over (Partition by s.student_name order by final_grade desc) as rn
			from student_grades as sg
			left Join students as s
					on (sg.student_id = s.id)) as sg_grade
where rn = 1
order by student_id


Select student_id, student_name, final_grade, class_name
from (	Select sg.student_id, s.student_name, sg.final_grade, sg.class_name,
						DENSE_RANK() over (Partition by s.student_name order by final_grade desc) as rn
			from student_grades as sg
			left Join students as s
					on (sg.student_id = s.id)) as sg_grade
where rn = 1
order by student_id


-- 3. PIVOTING

CREATE TABLE pizza_table (
										category VARCHAR(50),
										crust_type VARCHAR(50),
										pizza_name VARCHAR(100),
										price DECIMAL(5, 2)
									);

INSERT INTO pizza_table (category, crust_type, pizza_name, price) VALUES
											('Chicken', 'Gluten-Free Crust', 'California Chicken', 21.75),
											('Chicken', 'Thin Crust', 'Chicken Pesto', 20.75),
											('Classic', 'Standard Crust', 'Greek', 21.50),
											('Classic', 'Standard Crust', 'Hawaiian', 19.50),
											('Classic', 'Standard Crust', 'Pepperoni', 18.75),
											('Supreme', 'Standard Crust', 'Spicy Italian', 22.75),
											('Veggie', 'Thin Crust', 'Five Cheese', 18.50),
											('Veggie', 'Thin Crust', 'Margherita', 19.50),
											('Veggie', 'Gluten-Free Crust', 'Garden Delight', 21.50);

-- View the pizza table
SELECT * FROM pizza_table;

-- Create 1/0 column
Select category,
			Case when crust_type like 'Standard%' then 1 else 0 end as standard_crust,
			Case when crust_type like 'Thin%' then 1 else 0 end as thin_crust,
			Case when crust_type like 'Gluten%' then 1 else 0 end as gluten_free_crust
from pizza_table

-- Create a summary table of categories & pizza types
Select category,
			Sum(Case when crust_type like 'Standard%' then 1 else 0 end) as standard_crust,
			Sum(Case when crust_type like 'Thin%' then 1 else 0 end) as thin_crust,
			Sum(Case when crust_type like 'Gluten%' then 1 else 0 end) as gluten_free_crust
from pizza_table
Group by category
Order by category

-------------------------------------------------------Exercise-------------------------------------------
--Update the values to be final grades
Select department,
				case when grade_level = 9 then final_grade else Null end as freshman,
				case when grade_level = 10 then final_grade else Null end as sophomore,
				case when grade_level = 11 then final_grade else Null end as junior,
				case when grade_level = 12 then final_grade else Null end as senior
from student_grades as sg
left Join students as s
		on (sg.student_id = s.id)

--Create the final summary table
Select department,
			AVG(case when grade_level = 9 then final_grade else Null end) as freshman,
			AVG(case when grade_level = 10 then final_grade else Null end) as sophomore,
			AVG(case when grade_level = 11 then final_grade else Null end) as junior,
			AVG(case when grade_level = 12 then final_grade else Null end) as senior
from student_grades as sg
left Join students as s
		on (sg.student_id = s.id)
Group by department


----------------------------------------Rolling Calculations---------------------------------------------------------
-- Create a pizza orders table
CREATE TABLE pizza_orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATE,
    pizza_name VARCHAR(100),
    price DECIMAL(5, 2)
);

INSERT INTO pizza_orders (order_id, customer_name, order_date, pizza_name, price) VALUES
    (1, 'Jack', '2024-12-01', 'Pepperoni', 18.75),
    (2, 'Jack', '2024-12-02', 'Pepperoni', 18.75),
    (3, 'Jack', '2024-12-03', 'Pepperoni', 18.75),
    (4, 'Jack', '2024-12-04', 'Pepperoni', 18.75),
    (5, 'Jack', '2024-12-05', 'Spicy Italian', 22.75),
    (6, 'Jill', '2024-12-01', 'Five Cheese', 18.50),
    (7, 'Jill', '2024-12-03', 'Margherita', 19.50),
    (8, 'Jill', '2024-12-05', 'Garden Delight', 21.50),
    (9, 'Jill', '2024-12-05', 'Greek', 21.50),
    (10, 'Tom', '2024-12-02', 'Hawaiian', 19.50),
    (11, 'Tom', '2024-12-04', 'Chicken Pesto', 20.75),
    (12, 'Tom', '2024-12-05', 'Spicy Italian', 22.75),
    (13, 'Jerry', '2024-12-01', 'California Chicken', 21.75),
    (14, 'Jerry', '2024-12-02', 'Margherita', 19.50),
    (15, 'Jerry', '2024-12-04', 'Greek', 21.50);
    
-- View the table
SELECT * FROM pizza_orders;

-- 1. Calculate the sales subtotals for each customer
-- View the total sales for each customer on each date
SELECT customer_name, order_date, sum(price) as total_sales
FROM pizza_orders
Group by customer_name, order_date with rollup

SELECT customer_name, order_date, sum(price) as total_sales,
				count(price) as total_Count, AVG(price) as Avg_price,
				Min(price) as min_price, Max(price) as max_price
FROM pizza_orders
Group by customer_name, order_date with rollup


-- 2. Calculate the cumulative sum of sales over time
-- View the columns of interest
Use Maven_Advanced_SQL

Select order_date, price 
from pizza_orders

-- Calculate the total sales for each day
Select order_date, Sum(price) as total_sale 
from pizza_orders
group by order_date;

-- Calculate the cumulative sales over time
with totalpizzasale as (Select order_date, Sum(price) as total_sale 
								from pizza_orders
								group by order_date)
Select order_date, total_sale,
			SUM(total_sale) over (order by order_date) as cumulative_SUM
from totalpizzasale

-- 3. Calculate the 3 year moving average of happiness scores for each country
-- View the happiness score table
Select * from happiness_scores

-- View the happiness scores for each country, sorted by year
Select year, country, happiness_score 
from happiness_scores
order by year

-- Create a basic row number window function
Select year, country, happiness_score,
						ROW_NUMBER() over (Partition by country, year order by year asc, country) as rnk
from happiness_scores


-- Update the function to a moving average calculation
Select year, country, happiness_score,
						AVG(happiness_score) over (Partition by country, year order by year asc, country
																			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as Moving_Average
from happiness_scores

-- Final query of moving average calculation
Select year, country, happiness_score,
						Round(AVG(happiness_score) over (Partition by country, year order by year asc, country
																			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 3) as Moving_Average
from happiness_scores


------------------------------------------------------------------------Exercise--------------------------------------------------------------------------
Select * from orders
Select * from products;

with order_total as (
								Select o.order_date, (o.units * p.unit_price) as unit_val
								from orders o
								Join products p
										on (o.product_id = p.product_id)),
		yr_mnth_wise_sale as (
								Select YEAR(order_date) yr, MONTH(order_date) mnth,
											Sum(unit_Val) as total_sales
								from order_total
								Group by YEAR(order_date), MONTH(order_date)),
		cum_sum as (
								Select *,
											SUM(total_sales) over (order by yr, mnth) as cumulative_sum,
											AVG(total_sales) over (order by yr, mnth ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) as six_month_ma
								from yr_mnth_wise_sale)

Select * from cum_sum



-- 5. FINAL DEMO: Imputing NULL Values

/* Stock prices table was created in prior section:
   This is the code if you need to create it again */


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


SELECT CAST(DATEADD(DAY, value, '2024-11-01') as Date) AS dt 
FROM GENERATE_SERIES(0, DATEDIFF(DAY, '2024-11-01', '2024-11-10'), 1);



-- Include the original prices
WITH my_dates AS
								(SELECT CAST(DATEADD(DAY, value, '2024-11-01') as Date) AS dt 
								FROM GENERATE_SERIES(0, DATEDIFF(DAY, '2024-11-01', '2024-11-10'), 1)),
		   final_stock_tbl as (
								SELECT	md.dt, stock_prices.price
								FROM	my_dates md
										LEFT JOIN stock_prices
										ON md.dt = stock_prices.date);


-- Let's replace the NULL values in the price column 4 different ways (aka imputation)
-- 1. With a hard coded value
-- 2. With a subquery
-- 3. With one window function
-- 4. With two window functions

SELECT * FROM stock_prices;

WITH my_dates AS
								(SELECT CAST(DATEADD(DAY, value, '2024-11-01') as Date) AS dt 
								FROM GENERATE_SERIES(0, DATEDIFF(DAY, '2024-11-01', (select max(date) from stock_prices)), 1)),
		   final_stock_tbl as (
								SELECT	md.dt, stock_prices.price
								FROM	my_dates md
										LEFT JOIN stock_prices
										ON md.dt = stock_prices.date)

Select dt, price, coalesce(price, 600) as updated_price_600,
			 coalesce(price, (Select AVG(price) from final_stock_tbl)) as updated_AVG_price,
			 coalesce(price, LAG(price) over(order by dt)) as updated_LAG_price,
			 coalesce(price, (LAG(price) over(order by dt) + LEAD(price) over(order by dt))/2) as updated_smoothingApproach
from final_stock_tbl
