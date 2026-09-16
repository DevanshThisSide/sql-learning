-- sql delete

-- demonstrates how to remove records from a database table
-- syntax:
-- delete from table_name where condition;

-- create a database for our examples
create database delete_demo;

-- use the database
use delete_demo;

-- create a simple product inventory table
create table products (
    product_id int primary key,
    product_name varchar(100),
    price decimal(10, 2),
    stock_quantity int
);

-- insert sample data
insert into products values
(1, 'Laptop', 999.99, 10),
(2, 'Smartphone', 499.99, 25),
(3, 'Headphones', 89.99, 50),
(4, 'Tablet', 349.99, 15),
(5, 'Keyboard', 59.99, 30),
(6, 'Mouse', 29.99, 45),
(7, 'Monitor', 249.99, 12),
(8, 'Printer', 179.99, 8),
(9, 'External Hard Drive', 129.99, 20),
(10, 'USB Drive', 19.99, 100);

-- verify the data
select * from products;

-- delete a specific record by id
delete from products
where product_id = 10;

-- check the result
select * from products;

-- delete records based on a condition
delete from products
where price < 50.00;

-- note:
-- in mysql workbench safe update mode, this may generate an error
-- because the where clause does not use a key column.

-- delete all records from a table
delete from products;

-- check the empty table
select * from products;

-- reinsert sample data
insert into products values
(1, 'Laptop', 999.99, 10),
(2, 'Smartphone', 499.99, 25),
(3, 'Headphones', 89.99, 50),
(4, 'Tablet', 349.99, 15),
(5, 'Keyboard', 59.99, 30),
(6, 'Mouse', 29.99, 45),
(7, 'Monitor', 249.99, 12),
(8, 'Printer', 179.99, 8),
(9, 'External Hard Drive', 129.99, 20),
(10, 'USB Drive', 19.99, 100);

-- select expensive products
select * from products
where price > 300;

-- delete expensive products
delete from products
where price > 300;

-- create a table with a foreign key reference
create table orders (
    order_id int primary key,
    product_id int,
    quantity int,
    foreign key (product_id) references products(product_id)
);

-- insert an order
insert into orders values (1, 2, 3);

-- this succeeds because product_id 2 exists in the products table

-- delete the referenced product
delete from products
where product_id = 2;

-- this fails because product_id 2 is referenced by an order
-- a referenced parent row cannot be deleted while the default
-- foreign key behavior restricts the deletion.

-- check the constraint name
show create table orders;

-- remove the default foreign key constraint
alter table orders
drop foreign key orders_ibfk_1;

-- add a new foreign key constraint with cascade delete behavior
alter table orders
add constraint orders_ibfk_1
foreign key (product_id) references products(product_id)
on delete cascade;

-- now deleting the product will also delete related orders
delete from products
where product_id = 2;

-- check the results
select * from products;
select * from orders;

-- insert a new order
insert into orders values (1, 3, 2);

-- change the foreign key behavior
alter table orders
drop foreign key orders_ibfk_1;

-- add a constraint with set null behavior
alter table orders
add constraint orders_ibfk_1
foreign key (product_id) references products(product_id)
on delete set null;

-- now deleting the product will set the related order product_id to null
delete from products
where product_id = 3;

-- check the results
select * from products;
select * from orders;

-- auto-increment behavior with delete
create table auto_example (
    id int auto_increment primary key,
    name varchar(50)
);

-- insert some data
insert into auto_example (name) values
('Item 1'),
('Item 2'),
('Item 3');

-- delete all records
delete from auto_example
where id > 0;

-- insert a new record
-- the auto_increment counter continues from its previous value
insert into auto_example (name)
values ('New Item');

-- check the result
select * from auto_example;

-- note:
-- delete removes rows but normally does not reset the auto_increment counter.
-- truncate resets the auto_increment counter in mysql.

-- truncate table demonstration
create table employees (
    id int auto_increment primary key,
    name varchar(100) not null,
    email varchar(100) unique,
    hire_date date not null,
    salary decimal(10, 2)
);

-- insert some employee data
insert into employees (name, email, hire_date, salary) values
('John Doe', 'john.doe@example.com', '2023-01-15', 65000.00),
('Jane Smith', 'jane.smith@example.com', '2023-02-20', 72000.00),
('Michael Brown', 'michael.brown@example.com', '2023-03-10', 58000.00);

-- check the employee data
select * from employees;

-- remove all employees using truncate
-- truncate is generally faster than deleting rows individually
truncate table employees;

-- alternative syntax:
-- truncate employees;

-- check the result
select * from employees;

-- delete can also remove all rows
-- this is valid even though the table is already empty
delete from employees;

-- key differences between truncate and delete:
-- speed: truncate is generally faster for removing all rows because it
--        deallocates the table's data pages rather than deleting rows individually.
-- where clause: delete supports where conditions; truncate always removes all rows.
-- auto-increment: truncate resets the auto_increment counter; delete normally preserves it.
-- triggers: delete activates applicable delete triggers; truncate does not fire delete triggers.
-- rollback: delete can be rolled back when executed within a transaction;
--           truncate has different transaction behavior and should not be treated
--           like a row-by-row delete.
-- sql category: delete is a dml command, while truncate is generally classified
--                as a ddl command in mysql.

-- important notes for delete:
-- 1. delete removes existing rows; it does not remove the table itself.
-- 2. use where when you want to delete specific rows.
-- 3. without where, delete removes all rows from the table.
-- 4. truncate is used when you want to remove all rows quickly.
-- 5. foreign key constraints can prevent deletion of referenced parent rows.
-- 6. on delete cascade automatically removes related child rows.
-- 7. on delete set null sets the child foreign key to null when the parent row is deleted.
-- 8. delete normally does not reset the auto_increment counter, while truncate does.