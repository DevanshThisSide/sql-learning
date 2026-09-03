-- create database
create database storedb;
use storedb;

-- create products table
create table products (
    product_id int auto_increment primary key,
    product_name varchar(50),
    category varchar(50),
    price decimal(10,2),
    stock int
);

-- insert sample products
insert into products (product_name, category, price, stock) values
('laptop', 'electronics', 1200.00, 10),
('phone', 'electronics', 800.00, 15),
('tablet', 'electronics', 600.00, 20),
('headphones', 'accessories', 150.00, 50),
('mouse', 'accessories', 30.00, 100),
('keyboard', 'accessories', 45.00, 80);

-- create orders table
create table orders (
    order_id int auto_increment primary key,
    order_date date,
    customer_name varchar(50)
);

-- insert sample orders
insert into orders (order_date, customer_name) values
('2024-02-01', 'alice'),
('2024-02-05', 'bob'),
('2024-02-10', 'charlie'),
('2024-02-15', 'david');

-- comparison operators

-- products with price exactly 600
select *
from products
where price = 600;

-- products with price not equal to 800
select *
from products
where price <> 800;

-- alternative not-equal operator
select *
from products
where price != 800;

-- products priced below 500
select *
from products
where price < 500;

-- products priced above 700
select *
from products
where price > 700;

-- products priced at or below 150
select *
from products
where price <= 150;

-- products priced at or above 800
select *
from products
where price >= 800;

-- products belonging to electronics category
select *
from products
where category = 'electronics';

-- orders placed before february 10, 2024
select *
from orders
where order_date < '2024-02-10';

-- string comparison
-- strings are compared lexicographically
-- characters are compared from left to 
-- character by character based on their ASCII values
select *
from products
where product_name > 'mouse';

-- string comparison
-- '100' is compared with '2' as strings
-- '1' comes before '2', so the result is 1 (true)
select '100' < '2';

-- force numeric comparison using + 0
-- '100' is converted to 100 and '2' to 2
select '100' + 0 > '2';

-- mixed numeric and string comparison
-- '25' is converted to a number and compared with 100
select 100 > '25';

-- mixed comparison with non-numeric characters
-- '211fcfc' is converted to the numeric value 211
select 100 < '211fcfc';