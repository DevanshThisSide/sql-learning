-- mysql cross join

-- a cross join produces the cartesian product of two tables.
-- it combines every row from the first table with every row from the second table.
-- therefore, it produces all possible combinations of rows.
--
-- if table1 has m rows and table2 has n rows:
-- total rows = m * n


-- create and use database
create database cross_join_db;
use cross_join_db;


-- create products table
create table products (
    product_id int primary key,
    product_name varchar(50) not null
);


-- create colors table
create table colors (
    color_id int primary key,
    color_name varchar(30) not null
);


-- insert product data
insert into products (product_id, product_name)
values
    (1, 'T-shirt'),
    (2, 'Jeans'),
    (3, 'Sweater'),
    (4, 'Jacket');


-- insert color data
insert into colors (color_id, color_name)
values
    (1, 'Red'),
    (2, 'Blue'),
    (3, 'Green'),
    (4, 'Black'),
    (5, 'White');


-- basic cross join
-- every product is combined with every color
-- 4 products * 5 colors = 20 combinations
select
    p.product_name,
    c.color_name
from products p
cross join colors c;


-- create sizes table
create table sizes (
    size_id int primary key,
    size_name varchar(10) not null
);


-- insert size data
insert into sizes (size_id, size_name)
values
    (1, 'S'),
    (2, 'M'),
    (3, 'L'),
    (4, 'XL');


-- generate all possible product variations
-- 4 products * 5 colors * 4 sizes = 80 combinations
select
    p.product_name,
    c.color_name,
    s.size_name,
    concat(
        p.product_name,
        ' - ',
        c.color_name,
        ' - size ',
        s.size_name
    ) as full_product_description
from products p
cross join colors c
cross join sizes s;


-- count the total number of combinations
select count(*) as total_rows
from products p
cross join colors c
cross join sizes s;


-- filter the cross join result
-- only generate variations for the t-shirt
-- the cross join still creates combinations, but the where clause
-- limits the final result to rows where the product is a t-shirt
select
    p.product_name,
    c.color_name,
    s.size_name,
    concat(
        p.product_name,
        ' - ',
        c.color_name,
        ' - size ',
        s.size_name
    ) as full_product_description
from products p
cross join colors c
cross join sizes s
where p.product_name = 'T-shirt';


-- explain query execution
-- explain shows how mysql plans to execute the query.
-- it can provide information about table access, indexes, joins,
-- filtering, and the estimated number of rows examined.
explain
select
    p.product_name,
    c.color_name,
    s.size_name,
    concat(
        p.product_name,
        ' - ',
        c.color_name,
        ' - size ',
        s.size_name
    ) as full_product_description
from products p
cross join colors c
cross join sizes s
where p.product_name = 'T-shirt';


-- note:
-- the where condition allows mysql to filter the products table
-- for 'T-shirt' before producing the final cross join result,
-- depending on the execution plan chosen by the optimizer.
--
-- explain should be used to inspect the actual execution plan
-- rather than assuming a fixed internal execution order.


-- key takeaway:
-- cross join = every row from table1 combined with every row from table2.
-- unlike inner/left/right joins, it does not require an on condition.
-- cross joins are useful for generating combinations such as
-- products + colors + sizes, but can produce a very large number of rows.