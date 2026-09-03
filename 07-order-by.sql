/*
This SQL script demonstrates various techniques for sorting data using ORDER BY
and includes examples ranging from basic to advanced sorting concepts.
*/

-- Section 1: Database and Table Setup

create database multistore;

use multistore;

-- Create a products table with various data types

create table products (
    product_id int primary key,
    product_name varchar(100),
    category varchar(50),
    price decimal(10,2),
    stock_quantity int,
    last_updated timestamp
);

-- Insert initial sample data

insert into products values
(1, 'Laptop Pro', 'Electronics', 1299.99, 50, '2024-01-15 10:00:00'),
(2, 'Desk Chair', 'Furniture', 199.99, 30, '2024-01-16 11:30:00'),
(3, 'Coffee Maker', 'Appliances', 79.99, 100, '2024-01-14 09:15:00'),
(4, 'Gaming Mouse', 'Electronics', 59.99, 200, '2024-01-17 14:20:00'),
(5, 'Bookshelf', 'Furniture', 149.99, 25, '2024-01-13 16:45:00');

-- Section 2: Basic Sorting Operations

-- Display all records (unsorted)

select *
from products;

-- Sort by price in ascending order (ASC is optional as it's the default)

select *
from products
order by price asc;

-- Sort by last updated timestamp

select *
from products
order by last_updated;

-- Section 3: Advanced Sorting Techniques

-- Multiple column sorting (sort by category descending, then price descending)

select *
from products
order by category desc, price desc;

-- Sort using column position (4 represents the price column)

select *
from products
order by 4;

-- Combining WHERE clause with ORDER BY

select *
from products
where category = 'Electronics'
order by price;

-- Case-sensitive sorting using BINARY

select *
from products
order by binary category;

-- Section 4: Function-Based Sorting

-- Sort by product name length

select *
from products
order by length(product_name);

-- Sort by day of the month from timestamp

select *
from products
order by day(last_updated);

-- Using LIMIT with ORDER BY to find highest stock quantity

select *
from products
order by stock_quantity desc
limit 1;

-- Section 5: Custom Sorting Orders

-- Default category sorting

select *
from products
order by category;

-- Custom category order using FIELD function

-- from Electronics to Appliances to Furniture and then by price descending

select *
from products
order by field(category, 'Electronics', 'Appliances', 'Furniture'), price desc;

-- Section 6: Complex Sorting with Conditions

-- Simple conditional sorting for low stock and high price items\

select *,
 stock_quantity <= 50 and price >= 200 as match_item
from 
 where stock_quantity <= 50 and price >= 200;


select *,
       stock_quantity <= 50 and price >= 200 as priority_flag
from products
order by (stock_quantity <= 50 and price >= 200) desc;

-- Advanced priority-based sorting using CASE

select *,
       case
           when stock_quantity <= 50 and price >= 200 then 1
           when stock_quantity <= 50 then 2
           else 3
       end as priority
from products
order by priority;

-- Section 7: Handling NULL Values

-- Add records with NULL values for demonstration

insert into products values
(6, 'Desk Lamp', 'Furniture', null, 45, '2024-01-18 13:25:00'),
(7, 'Keyboard', 'Electronics', 89.99, null, '2024-01-19 15:10:00');

-- Basic NULL handling in ORDER BY

-- null values at the beginning (top) of the result set when using ASC

-- null values at the end (bottom) of the result set when using DESC

select *
from products
order by price;

-- Explicit NULL handling

-- null values at the end of the result set when using ASC

-- null values at the beginning of the result set when using DESC

select *,
       price is null as is_price_null
from products
order by price is null;

-- Section 8: Working with Calculated Columns

-- Sort by total value (price * quantity)

select *,
       price * stock_quantity as total_value
from products
order by total_value desc;

-- Section 9: Query Performance Analysis

-- Examine query execution plan for multi-column sort

-- sorting done using indexes if available, otherwise a filesort is performed

explain select *
from products
order by category, price; -- using filesort

-- Compare with primary key sort performance

-- primary keys are indexed by default, so sorting by product_id should be efficient

explain select *
from products
order by product_id; -- using index