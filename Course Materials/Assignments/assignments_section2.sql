-- Connect to database
Use Maven_Advanced_SQL;


-- ASSIGNMENT 1: Basic Joins
-- Looking at the orders and products tables, which products exist in one table, but not the other?

-- View the orders and products tables
Select * from orders;
Select * from products;

-- Join the tables using various join types & note the number of rows in the output
-- View the products that exist in one table, but not the other
-- Pick a final JOIN type to join products and orders

Select p.product_id, p.product_name,  o.product_id
from orders o
right join products p
on o.product_id = p.product_id
where o.product_id is null
order by p.product_id, p.product_name

        


-- ASSIGNMENT 2: Self Joins
-- Which products are within 25 cents of each other in terms of unit price?

-- View the products table


-- Join the products table with itself so each candy is paired with a different candy

        
-- Calculate the price difference, do a self join, and then return only price differences under 25 cents


