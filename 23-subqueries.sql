-- mysql subqueries

-- this script demonstrates different types of subqueries using an online store database.
-- subqueries can be used inside where, select, having, and from clauses.
-- they are useful when the result of one query is required by another query.

-- create database and set it as the active database
create database online_store;
use online_store;

-- table creation

-- create customers table
create table customers (
    customer_id int primary key auto_increment,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email varchar(100) unique not null,
    city varchar(50),
    state varchar(2),
    signup_date date
);

-- create products table
create table products (
    product_id int primary key auto_increment,
    product_name varchar(100) not null,
    category varchar(50) not null,
    price decimal(10, 2) not null,
    stock_quantity int not null
);

-- create orders table
create table orders (
    order_id int primary key auto_increment,
    customer_id int not null,
    order_date datetime not null,
    total_amount decimal(10, 2) not null,
    foreign key (customer_id) references customers(customer_id)
);

-- create order_items table
create table order_items (
    item_id int primary key auto_increment,
    order_id int not null,
    product_id int not null,
    quantity int not null,
    item_price decimal(10, 2) not null,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

-- sample data insertion

-- insert data into customers
insert into customers (first_name, last_name, email, city, state, signup_date) values
('John', 'Smith', 'john.smith@example.com', 'New York', 'NY', '2023-01-15'),
('Sarah', 'Johnson', 'sarah.j@example.com', 'Los Angeles', 'CA', '2023-02-20'),
('Michael', 'Brown', 'michael.b@example.com', 'Chicago', 'IL', '2023-03-05'),
('Emily', 'Davis', 'emily.d@example.com', 'Houston', 'TX', '2023-01-30'),
('Robert', 'Wilson', 'robert.w@example.com', 'Phoenix', 'AZ', '2023-02-10'),
('Jennifer', 'Martinez', 'jennifer.m@example.com', 'Philadelphia', 'PA', '2023-03-15'),
('David', 'Anderson', 'david.a@example.com', 'San Antonio', 'TX', '2023-01-25'),
('Lisa', 'Thomas', 'lisa.t@example.com', 'San Diego', 'CA', '2023-02-28'),
('James', 'Jackson', 'james.j@example.com', 'Dallas', 'TX', '2023-03-12'),
('Mary', 'White', 'mary.w@example.com', 'San Jose', 'CA', '2023-01-18');

-- insert data into products
insert into products (product_name, category, price, stock_quantity) values
('Laptop Pro', 'Electronics', 1299.99, 25),
('Smartphone X', 'Electronics', 899.99, 50),
('Wireless Headphones', 'Electronics', 199.99, 100),
('Coffee Maker', 'Home Appliances', 79.99, 30),
('Blender', 'Home Appliances', 49.99, 40),
('Running Shoes', 'Sports', 129.99, 75),
('Yoga Mat', 'Sports', 29.99, 120),
('Mystery Novel', 'Books', 14.99, 200),
('Cookbook', 'Books', 24.99, 150),
('Desk Chair', 'Furniture', 149.99, 15);

-- insert data into orders
insert into orders (customer_id, order_date, total_amount) values
(1, '2023-04-10 14:30:00', 1499.98),
(2, '2023-04-11 10:15:00', 249.98),
(3, '2023-04-12 16:45:00', 899.99),
(4, '2023-04-13 13:20:00', 1329.98),
(2, '2023-04-14 09:30:00', 49.99),
(5, '2023-04-15 15:10:00', 179.98),
(6, '2023-04-16 11:05:00', 159.98),
(7, '2023-04-17 14:55:00', 39.98),
(8, '2023-04-18 12:40:00', 899.99),
(9, '2023-04-19 16:25:00', 229.98),
(10, '2023-04-20 10:50:00', 279.97),
(1, '2023-04-21 13:35:00', 24.99),
(3, '2023-04-22 15:15:00', 129.99);

-- insert data into order_items
insert into order_items (order_id, product_id, quantity, item_price) values
(1, 1, 1, 1299.99),
(1, 3, 1, 199.99),
(2, 5, 1, 49.99),
(2, 7, 1, 29.99),
(2, 9, 1, 24.99),
(3, 2, 1, 899.99),
(4, 1, 1, 1299.99),
(4, 6, 1, 129.99),
(5, 5, 1, 49.99),
(6, 4, 1, 79.99),
(6, 8, 1, 14.99),
(6, 9, 1, 24.99),
(7, 6, 1, 129.99),
(7, 8, 2, 14.99),
(8, 8, 1, 14.99),
(8, 9, 1, 24.99),
(9, 2, 1, 899.99),
(10, 3, 1, 199.99),
(10, 6, 1, 129.99),
(11, 5, 1, 49.99),
(11, 7, 1, 29.99),
(11, 8, 1, 14.99),
(12, 9, 1, 24.99),
(13, 6, 1, 129.99);

select * from customers;
select * from products;
select * from orders;
select * from order_items;

-- basic subqueries

-- a subquery is a query written inside another query.
-- the inner query produces a result that is used by the outer query.

-- find all customers who have placed at least one order
-- the subquery returns customer ids from the orders table.
-- the outer query then finds customers whose ids are present in that result.
select *
from customers
where customer_id in (
    select distinct customer_id
    from orders
);

-- find customers who haven't placed any orders
-- not in excludes customer ids that appear in the subquery result.
select *
from customers
where customer_id not in (
    select distinct customer_id
    from orders
);

-- find products with a price higher than the average product price
-- avg(price) returns a single value, so this is a scalar subquery.
select *
from products
where price > (
    select avg(price)
    from products
);

-- group by with having

-- this is not a subquery example, but demonstrates aggregation
-- before moving to more advanced subquery examples.
-- find categories that have more than 2 products
select
    category,
    count(*) as product_count
from products
group by category
having count(*) > 2;

-- subqueries in the where clause

-- find all orders made by customers from texas
-- the subquery first finds customer ids belonging to texas customers.
select *
from orders
where customer_id in (
    select customer_id
    from customers
    where state = 'TX'
);

-- alternative using join
-- joins can often solve the same problem as a subquery.
select *
from customers c
join orders o
    on c.customer_id = o.customer_id
where c.state = 'TX';

-- join queries vs subqueries

-- find all customers who ordered electronics products
-- using joins
select *
from customers c
join orders o
    on c.customer_id = o.customer_id
join order_items oi
    on o.order_id = oi.order_id
join products p
    on p.product_id = oi.product_id
where p.category = 'Electronics';

-- using a subquery
-- the subquery first returns product ids belonging to the electronics category.
-- the outer query then finds order items containing those product ids.
select *
from customers c
join orders o
    on c.customer_id = o.customer_id
join order_items oi
    on o.order_id = oi.order_id
where oi.product_id in (
    select product_id
    from products
    where category = 'Electronics'
);

-- subqueries with average calculation

-- find customers who spent more than average
-- steps:
-- 1. calculate the total amount spent by each customer.
-- 2. calculate the average spending across those customers.
-- 3. find customers whose total spending is greater than that average.

-- first attempt
-- this fails because every derived table in the from clause must have an alias.
select avg(total_spent) as average_customer_spending
from (
    select
        customer_id,
        sum(total_amount) as total_spent
    from orders
    group by customer_id
);

-- error code: 1248
-- every derived table must have its own alias

-- correct version with alias
-- a subquery in the from clause is called a derived table.
-- mysql requires a derived table to have an alias.
select avg(total_spent) as average_customer_spending
from (
    select
        customer_id,
        sum(total_amount) as total_spent
    from orders
    group by customer_id
) as customer_total;

-- final query: find customers who spent more than average
-- the correlated subquery calculates the total spent for the current customer.
-- the second subquery calculates the average spending across all customers who placed orders.
select
    *,
    (
        select sum(total_amount)
        from orders
        where customer_id = customers.customer_id
    ) as total_spent
from customers
where (
    select sum(total_amount)
    from orders
    where customer_id = customers.customer_id
) > (
    select avg(total_spent)
    from (
        select
            customer_id,
            sum(total_amount) as total_spent
        from orders
        group by customer_id
    ) as customer_total
);

-- complex subqueries

-- find customers who have ordered all products in the electronics category
-- count(distinct p.product_id) counts how many different electronics products
-- each customer has purchased.
-- the subquery counts how many electronics products exist in total.
-- if both counts are equal, the customer has ordered every electronics product.
select c.email
from customers c
join orders o
    on c.customer_id = o.customer_id
join order_items oi
    on o.order_id = oi.order_id
join products p
    on oi.product_id = p.product_id
where p.category = 'Electronics'
group by c.customer_id
having count(distinct p.product_id) = (
    select count(*)
    from products
    where category = 'Electronics'
);

-- find non-california customers who purchased the same product-quantity
-- combinations as california customers
-- the subquery returns product_id and quantity pairs from california customers.
-- row-value comparison checks both values together.
select
    c.email,
    c.state,
    p.product_name,
    oi.quantity
from customers c
join orders o
    on c.customer_id = o.customer_id
join order_items oi
    on oi.order_id = o.order_id
join products p
    on oi.product_id = p.product_id
where c.state != 'CA'
and (oi.product_id, oi.quantity) in (
    select
        oi.product_id,
        oi.quantity
    from customers c
    join orders o
        on c.customer_id = o.customer_id
    join order_items oi
        on oi.order_id = o.order_id
    where c.state = 'CA'
);

-- correlated subqueries and exists

-- a correlated subquery is a subquery that uses values from the outer query.
-- unlike an independent subquery, it depends on the current row of the outer query.
-- conceptually, the subquery is evaluated in relation to each outer-row candidate.

-- correlated subqueries can appear in different sql clauses,
-- including select, where, and having.

-- scalar subquery
-- a scalar subquery returns exactly one value.
-- it can be independent or correlated.
-- scalar subqueries can be used where a single value is expected.

-- find customers who have placed at least one order

-- using join
-- distinct is required because a customer can have multiple orders.
select distinct
    c.customer_id,
    c.email
from customers c
join orders o
    on c.customer_id = o.customer_id
order by c.customer_id;

-- using exists
-- exists checks whether the subquery returns at least one row.
-- select 1 is commonly used because exists only cares whether a row exists,
-- not about the actual value returned.
select *
from customers c
where exists (
    select 1
    from orders o
    where c.customer_id = o.customer_id
);

-- find customers who haven't placed any orders
-- not exists returns true when the correlated subquery finds no matching row.
select *
from customers c
where not exists (
    select 1
    from orders o
    where c.customer_id = o.customer_id
);

-- find products that have never been ordered
-- the subquery checks whether the current product has any matching order item.
select *
from products p
where not exists (
    select 1
    from order_items oi
    where oi.product_id = p.product_id
);

-- find customers who have ordered electronics products

-- using joins
select distinct
    c.customer_id,
    c.first_name,
    c.last_name
from customers c
join orders o
    on c.customer_id = o.customer_id
join order_items oi
    on o.order_id = oi.order_id
join products p
    on oi.product_id = p.product_id
where p.category = 'Electronics';

-- using exists
-- the correlated condition connects the subquery to the current customer.
-- exists stops being concerned with duplicate matching orders;
-- it only checks whether at least one matching electronics order exists.
select *
from customers c
where exists (
    select 1
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    join products p
        on oi.product_id = p.product_id
    where c.customer_id = o.customer_id
    and p.category = 'Electronics'
);

-- select 1 with exists
-- select 1 is commonly used with exists because exists only checks whether
-- at least one matching row exists; the actual selected value does not matter.

-- short-circuit evaluation
-- exists can stop checking once it finds the first matching row because
-- finding one row is enough to make exists true.

-- important notes for subqueries:
-- 1. an independent subquery can be executed without depending on the outer query.
-- 2. a correlated subquery depends on values from the outer query.
-- 3. a scalar subquery returns a single value and can be used where one value is expected.
-- 4. in is useful when the subquery returns multiple values.
-- 5. exists checks whether the subquery returns at least one row.
-- 6. not exists checks whether the subquery returns no matching rows.
-- 7. a subquery in the from clause is called a derived table and must have an alias in mysql.
-- 8. joins and subqueries can sometimes solve the same problem; choose the approach
--    that makes the query clear and appropriate for the situation.
-- 9. correlated subqueries can be more expensive on large datasets because their
--    logic depends on rows from the outer query, so query performance should be considered.