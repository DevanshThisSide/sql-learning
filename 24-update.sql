-- mysql update

-- the update statement is used to modify existing rows in a table.
-- syntax:
-- update table_name
-- set column1 = value1, column2 = value2
-- where condition;

-- create the database
create database store_inventory;

-- switch to the new database
use store_inventory;

-- create products table
create table products (
    product_id int primary key,
    product_name varchar(50) not null,
    category varchar(20),
    price decimal(10, 2),
    stock_quantity int,
    last_updated timestamp default current_timestamp
);

-- insert initial data
insert into products (product_id, product_name, category, price, stock_quantity)
values 
    (1, 'Laptop', 'Electronics', 899.99, 25),
    (2, 'Desk Chair', 'Furniture', 149.50, 40),
    (3, 'Coffee Maker', 'Appliances', 79.99, 15),
    (4, 'Headphones', 'Electronics', 129.99, 30),
    (5, 'Desk Lamp', 'Furniture', 24.99, 50);

-- view all products
select * from products;

-- apply a 10% discount to all products
-- where product_id > 0 is used here to provide a where condition.
-- this can also satisfy mysql workbench safe update mode when updating
-- rows based on a key column.
update products
set price = price * 0.9
where product_id > 0;

-- update the price of a specific product
update products
set price = 999.99
where product_id = 1;

-- update multiple columns of a specific product
update products
set
    price = 89.99,
    stock_quantity = 20
where product_id = 3;

-- modify last_updated so it automatically changes whenever the row is updated
-- default current_timestamp sets the initial timestamp during insertion.
-- on update current_timestamp automatically updates the timestamp
-- whenever any value in the row is changed.
alter table products
modify last_updated timestamp
default current_timestamp
on update current_timestamp;

-- view updated products
select * from products;

-- update laptop price and quantity
update products
set
    price = 199,
    stock_quantity = 1
where product_id = 1;

-- view products after update
select * from products;

-- apply a 90% discount to the first two rows returned by the update
-- limit restricts the number of rows affected by the update.
-- without order by, which two rows are selected is not guaranteed.
update products
set price = price * 0.1
where product_id > 0
limit 2;

-- view products after discount
select * from products;

-- updating a primary key to an existing value causes a duplicate-key error.
-- attempt to update product_id
-- this causes a primary key constraint violation because product_id = 1
-- already exists in the table.
update products
set product_id = 1
where product_id = 2;

-- view final state of products table
select * from products;