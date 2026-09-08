-- left join (left outer join)
-- it returns all records from the left table and only the matching records from the right table.
-- if no match exists in the right table, null values will be returned for the right table's columns.

-- basic left join syntax
select columns
from table1
left join table2
    on table1.column = table2.column;


-- create and set up database
create database left_join_db;
use left_join_db;


-- create customers table
create table customers (
    customer_id int primary key,
    customer_name varchar(100) not null,
    email varchar(100),
    city varchar(50)
);


-- create orders table with foreign key
create table orders (
    order_id int primary key,
    customer_id int,
    order_date date not null,
    total_amount decimal(10, 2),
    foreign key (customer_id) references customers(customer_id)
);


-- insert sample customer data
insert into customers (customer_id, customer_name, email, city)
values
    (1, 'John Smith', 'john@example.com', 'New York'),
    (2, 'Jane Doe', 'jane@example.com', 'Los Angeles'),
    (3, 'Robert Johnson', 'robert@example.com', 'Chicago'),
    (4, 'Emily Davis', 'emily@example.com', 'Houston'),
    (5, 'Michael Brown', 'michael@example.com', 'Phoenix');


-- insert sample order data
insert into orders (order_id, customer_id, order_date, total_amount)
values
    (101, 1, '2023-01-15', 150.75),
    (102, 3, '2023-01-16', 89.50),
    (103, 1, '2023-01-20', 45.25),
    (104, 2, '2023-01-25', 210.30),
    (105, 3, '2023-02-01', 75.00);


select * from customers;
select * from orders;


-- example 1: basic left join
-- get all customers and their orders (if any)
select
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.total_amount
from customers c
left join orders o
    on c.customer_id = o.customer_id;


-- example 2: finding customers with no orders
-- note the use of is null in the where clause
select
    c.customer_id,
    c.customer_name
from customers c
left join orders o
    on c.customer_id = o.customer_id
where o.order_id is null;


-- example 3: using aggregate functions with left join
-- get customer order counts and total spending
select
    c.customer_id,
    c.customer_name,
    count(o.order_id) as order_count,
    ifnull(sum(o.total_amount), 0) as total_spent
from customers c
left join orders o
    on c.customer_id = o.customer_id
group by c.customer_id;


-- create shipping table for multiple joins example
create table shipping (
    shipping_id int primary key,
    order_id int,
    shipping_date date,
    carrier varchar(50),
    tracking_number varchar(50),
    foreign key (order_id) references orders(order_id)
);


-- insert sample shipping data
insert into shipping (shipping_id, order_id, shipping_date, carrier, tracking_number)
values
    (1001, 101, '2023-01-16', 'FedEx', 'FDX123456789'),
    (1002, 104, '2023-01-26', 'UPS', 'UPS987654321'),
    (1003, 105, '2023-02-02', 'USPS', 'USPS456789123');


-- example 4: multiple left joins
-- get customers, their orders, and shipping information
select
    c.customer_name,
    o.order_id,
    o.order_date,
    o.total_amount,
    s.carrier,
    s.tracking_number
from customers c
left join orders o
    on c.customer_id = o.customer_id
left join shipping s
    on o.order_id = s.order_id;


-- example 5: filtering with where vs on clause

-- method 1: filter in where clause (filters after join)
select
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date,
    o.total_amount
from customers c
left join orders o
    on c.customer_id = o.customer_id
where c.city = 'New York';


-- method 2: filter in on clause (maintains all left table rows)
select
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date,
    o.total_amount
from customers c
left join orders o
    on c.customer_id = o.customer_id
    and c.city = 'New York';

-- note:
-- the condition c.city = 'New York' is part of the join condition, not a filter on the left table.
-- therefore, all customers are still returned.
-- for non-new-york customers, the join condition fails, so their order columns contain null.
-- this demonstrates the key difference between putting a condition in the on clause vs the where clause.

-- to resolve this, you can use a subquery to filter the left table first, then perform the left join.

-- method 3: using subquery to filter left table first
select
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date,
    o.total_amount
from (
    select *
    from customers
    where city = 'New York'
) c
left join orders o
    on c.customer_id = o.customer_id;


-- example 6: advanced filtering with aggregation
-- find customers who haven't ordered in the past 30 days
select
    c.customer_id,
    c.customer_name,
    max(o.order_date) as last_order_date
from customers c
left join orders o
    on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having max(o.order_date) is null
    or max(o.order_date) < date_sub(curdate(), interval 30 day);