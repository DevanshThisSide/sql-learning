-- mysql limit, offset clause

-- 1. setup and sample data

create database electronics_db;

use electronics_db;

-- create products table

create table products (
    id int auto_increment primary key,
    name varchar(100),
    price decimal(10,2),
    category varchar(50),
    created_at timestamp default current_timestamp
);

-- insert sample data

insert into products (name, price, category) values
('laptop', 999.99, 'electronics'),
('smartphone', 499.99, 'electronics'),
('coffee maker', 79.99, 'appliances'),
('headphones', 149.99, 'electronics'),
('blender', 59.99, 'appliances'),
('tablet', 299.99, 'electronics'),
('microwave', 199.99, 'appliances'),
('smart watch', 249.99, 'electronics'),
('toaster', 39.99, 'appliances'),
('speaker', 89.99, 'electronics');

-- 2. basic limit usage

-- return first 2 products

select *
from products
order by id
limit 2;

-- 3. limit with offset

-- limit specifies the maximum number of rows a query returns
-- offset specifies how many rows to skip before returning records

-- syntax 1: limit [row_count] offset [offset]

select *
from products
order by id
limit 2 offset 2;

-- syntax 2: limit [offset], [row_count]

select *
from products
order by id
limit 2, 2;

-- 4. pagination implementation

-- page size: 3 items per page

-- page 1 using offset syntax
select *
from products
order by id
limit 3 offset 0;

-- page 2
select *
from products
order by id
limit 3 offset 3;

-- page 3
select *
from products
order by id
limit 3 offset 6;

-- alternative syntax using limit offset, count

-- page 1
select *
from products
order by id
limit 0, 3;

-- page 2
select *
from products
order by id
limit 3, 3;

-- page 3
select *
from products
order by id
limit 6, 3;

-- generic formula for pagination
-- limit (page_number - 1) * items_per_page, items_per_page

-- 5. common use cases

-- top 3 most expensive products

select *
from products
order by price desc
limit 3;

-- get 5 random products

select *
from products
order by rand()
limit 5;

-- 6. performance considerations

-- example of potentially slow query with large offset

select *
from products
-- note: in real scenario, this would be a much larger table
order by created_at
limit 1000000, 10;

-- better alternative using where clause

select *
from products
where created_at > '2025-01-01 00:00:00'
order by created_at
limit 10;

-- key takeaways

/*
limit helps in retrieving a specific number of rows.

limit offset, count is used for pagination.

combining order by with limit is essential for meaningful result sets.

be cautious about performance impacts when using high offset values.
*/