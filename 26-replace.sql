-- replace into sql

-- replace into combines insert and delete operations.
-- if a row with the same primary key or unique key already exists,
-- mysql deletes the existing row and inserts the new row.
-- if no matching key exists, it works like a normal insert.
--
-- syntax:
-- replace into table_name (column1, column2, ...)
-- values (value1, value2, ...);

-- create and use database
create database replace_demo;
use replace_demo;

-- create products table
create table products (
    product_id int primary key,
    product_name varchar(100) not null,
    category varchar(50),
    price decimal(10, 2),
    stock_quantity int,
    last_updated timestamp default current_timestamp on update current_timestamp
);

-- insert initial product data
insert into products (product_id, product_name, category, price, stock_quantity)
values
    (1, 'Laptop', 'Electronics', 899.99, 25),
    (2, 'Smartphone', 'Electronics', 599.99, 50),
    (3, 'Coffee Maker', 'Kitchen', 79.99, 30),
    (4, 'Running Shoes', 'Sportswear', 129.99, 40),
    (5, 'Desk Chair', 'Furniture', 189.99, 15);

-- replace an existing product (id 5)
-- product_id 5 already exists.
-- replace into deletes the existing row and inserts the new row.
-- therefore, the old Desk Chair record is completely replaced by Mic.
replace into products (
    product_id,
    product_name,
    category,
    price,
    stock_quantity
)
values
    (5, 'Mic', 'Electronics', 500, 12);

-- add a new product (id 6) using replace
-- since product_id 6 does not exist, this works like a normal insert.
-- columns not included in the statement receive their default value
-- or null if no default is defined and null is allowed.
replace into products (
    product_id,
    product_name,
    category,
    price
)
values
    (6, 'Camera', 'Electronics', 5000);

-- view the updated products table
select * from products;

-- create a second products table with an additional supplier column
create table products2 (
    product_id int primary key,
    product_name varchar(100) not null,
    category varchar(50),
    price decimal(10, 2),
    stock_quantity int,
    supplier varchar(100)
);

-- insert data into products2
-- ids 2 and 4 already exist in products.
-- ids 7, 8, and 9 do not exist in products.
insert into products2 (
    product_id,
    product_name,
    category,
    price,
    stock_quantity,
    supplier
)
values
    (2, 'Ultra Smartphone', 'Electronics', 899.99, 40, 'TechCorp'),
    (4, 'Pro Running Shoes', 'Sportswear', 149.99, 35, 'SportMaster'),
    (7, 'Bluetooth Speaker', 'Electronics', 79.99, 60, 'SoundWave'),
    (8, 'Gaming Mouse', 'Computer Accessories', 49.99, 100, 'GamerZone'),
    (9, 'Portable Monitor', 'Electronics', 199.99, 25, 'DisplayTech');

-- view both product tables before the bulk replace operation
select * from products;
select * from products2;

-- use replace into with select for a bulk replace operation
-- ids 2 and 4 already exist in products, so their existing rows
-- are deleted and replaced with the rows selected from products2.
-- ids 7, 8, and 9 do not exist, so they are inserted as new rows.
--
-- supplier is not included because products does not have a supplier column.
replace into products (
    product_id,
    product_name,
    category,
    price,
    stock_quantity
)
select
    product_id,
    product_name,
    category,
    price,
    stock_quantity
from products2;

-- view the final products table
select * from products;

-- important notes about replace into:

-- columns omitted from the replace statement receive their default value
--  or null when allowed.
-- replace into can affect foreign key relationships because the existing row
--  is deleted before the new row is inserted.
-- if you only want to modify specific columns while keeping the existing row,
--  update is generally more appropriate.
--  replace into is useful when you intentionally want complete row replacement.