-- database normalization: 1nf, 2nf, 3nf, 4nf, and 5nf demonstration
-- this sql script demonstrates the process of normalizing a database
-- through first, second, third, fourth, and fifth normal forms.


-- create and use bookstore database
create database bookshop;
use bookshop;


-- original denormalized table
create table book_orders (
    order_id int,
    customer_name varchar(100),
    customer_email varchar(100),
    customer_address varchar(255),
    book_isbn varchar(20),
    book_title varchar(200),
    book_author varchar(100),
    book_price decimal(10, 2),
    order_date date,
    quantity int,
    total_price decimal(10, 2)
);

-- sample data for denormalized table
insert into book_orders values
(1, 'John Smith', 'john@example.com', '123 Main St, Anytown', '978-0141439518', 'Pride and Prejudice', 'Jane Austen', 9.99, '2023-01-15', 1, 9.99),
(2, 'John Smith', 'john@example.com', '123 Main St, Anytown', '978-0451524935', '1984', 'George Orwell', 12.99, '2023-01-15', 2, 25.98),
(3, 'Mary Johnson', 'mary@example.com', '456 Oak Ave, Somewhere', '978-0061120084', 'To Kill a Mockingbird', 'Harper Lee', 14.99, '2023-01-20', 1, 14.99),
(4, 'Robert Brown', 'robert@example.com', '789 Pine Rd, Nowhere', '978-0141439518', 'Pride and Prejudice', 'Jane Austen', 9.99, '2023-01-25', 1, 9.99);

-- view the denormalized data
select * from book_orders;


-- first normal form (1nf)
-- requirements:
-- 1. each column contains atomic (indivisible) values
-- 2. each column contains values of the same type
-- 3. each row is uniquely identifiable (ensured by primary key)
-- 4. there are no repeating groups of columns (same kind of attribute repeated as multiple columns.)

create table book_orders_1nf (
    order_id int,
    book_isbn varchar(20),
    customer_name varchar(100),
    customer_email varchar(100),
    customer_address varchar(255),
    book_title varchar(200),
    book_author varchar(100),
    book_price decimal(10, 2),
    order_date date,
    quantity int,
    total_price decimal(10, 2),
    primary key (order_id, book_isbn)
);


-- second normal form (2nf)
-- requirements:
-- 1. must be in 1nf
-- 2. all non-key attributes must be fully functionally dependent
--    on the entire primary key
-- 3. there must be no partial dependency on part of a composite key

create table orders_2nf (
    order_id int primary key,
    customer_name varchar(100),
    customer_email varchar(100),
    customer_address varchar(255),
    order_date date
);

create table books_2nf (
    isbn varchar(20) primary key,
    title varchar(200),
    author varchar(100),
    price decimal(10, 2)
);

create table order_items_2nf (
    order_id int,
    book_isbn varchar(20),
    quantity int,
    total_price decimal(10, 2),
    primary key (order_id, book_isbn),
    foreign key (order_id) references orders_2nf(order_id),
    foreign key (book_isbn) references books_2nf(isbn)
);

-- sample data for 2nf tables
insert into orders_2nf values
(1, 'John Smith', 'john@example.com', '123 Main St, Anytown', '2023-01-15'),
(2, 'Mary Johnson', 'mary@example.com', '456 Oak Ave, Somewhere', '2023-01-20'),
(3, 'Robert Brown', 'robert@example.com', '789 Pine Rd, Nowhere', '2023-01-25');

insert into books_2nf values
('978-0141439518', 'Pride and Prejudice', 'Jane Austen', 9.99),
('978-0451524935', '1984', 'George Orwell', 12.99),
('978-0061120084', 'To Kill a Mockingbird', 'Harper Lee', 14.99);

insert into order_items_2nf values
(1, '978-0141439518', 1, 9.99),
(1, '978-0451524935', 2, 25.98),
(2, '978-0061120084', 1, 14.99),
(3, '978-0141439518', 1, 9.99);


-- third normal form (3nf)
-- requirements:
-- 1. must be in 2nf
-- 2. must not have transitive dependencies (A non-key column depends on another non-key column,
--    instead of depending directly on the primary key.)
-- 3. non-key attributes should depend directly on the primary key

create table customers_3nf (
    customer_id int auto_increment primary key,
    name varchar(100),
    email varchar(100),
    address varchar(255)
);

create table orders_3nf (
    order_id int primary key,
    customer_id int,
    order_date date,
    foreign key (customer_id) references customers_3nf(customer_id)
);

create table books_3nf (
    isbn varchar(20) primary key,
    title varchar(200),
    author varchar(100),
    price decimal(10, 2)
);

create table order_items_3nf (
    order_id int,
    book_isbn varchar(20),
    quantity int,
    primary key (order_id, book_isbn),
    foreign key (order_id) references orders_3nf(order_id),
    foreign key (book_isbn) references books_3nf(isbn)
);

-- note:
-- the 3nf design removes customer details from the orders table
-- and stores them separately using customer_id.
-- it also removes the derived total_price column from order_items.
-- total price can be calculated using quantity * price.


-- fourth normal form (4nf)
-- requirements:
-- 1. must be in 3nf
-- 2. there should be no multi-valued dependencies (One entity has multiple independent values of two different attributes.)
-- 3. independent multi-valued facts about an entity should be stored separately

-- bad design:
-- an employee can have multiple skills and multiple languages.
-- storing both in one table creates unnecessary combinations.

create table employee_skills_languages_unnormalized (
    employee_id int,
    skill varchar(50),
    language varchar(50)
);

-- example:
-- employee 101 knows java and sql and speaks english and hindi.
-- storing these independently in one table creates combinations such as:
-- java + english
-- java + hindi
-- sql + english
-- sql + hindi

-- 4nf solution:
-- separate the independent multi-valued relationships.

create table employee_skills_4nf (
    employee_id int,
    skill varchar(50),
    primary key (employee_id, skill)
);

create table employee_languages_4nf (
    employee_id int,
    language varchar(50),
    primary key (employee_id, language)
);


-- fifth normal form (5nf)
-- requirements:
-- 1. must be in 4nf
-- 2. there should be no unnecessary join dependencies
-- 	(Don't keep a table containing a complex relationship if it can be 
-- 	 losslessly decomposed into smaller tables representing simpler relationships.)
-- 3. a table should not contain information that can be reconstructed
--    from smaller related tables without losing information

-- example:
-- a supplier can supply a product to a project.
-- the relationship can be represented using three independent relationships.

create table suppliers_5nf (
    supplier_id int primary key,
    supplier_name varchar(100) not null
);

create table products_5nf (
    product_id int primary key,
    product_name varchar(100) not null
);

create table projects_5nf (
    project_id int primary key,
    project_name varchar(100) not null
);

-- separate relationship tables
create table supplier_products_5nf (
    supplier_id int,
    product_id int,
    primary key (supplier_id, product_id),
    foreign key (supplier_id) references suppliers_5nf(supplier_id),
    foreign key (product_id) references products_5nf(product_id)
);

create table supplier_projects_5nf (
    supplier_id int,
    project_id int,
    primary key (supplier_id, project_id),
    foreign key (supplier_id) references suppliers_5nf(supplier_id),
    foreign key (project_id) references projects_5nf(project_id)
);

create table product_projects_5nf (
    product_id int,
    project_id int,
    primary key (product_id, project_id),
    foreign key (product_id) references products_5nf(product_id),
    foreign key (project_id) references projects_5nf(project_id)
);


-- normalization summary
-- 1nf: atomic values and no repeating groups
-- 2nf: no partial dependencies
-- 3nf: no transitive dependencies
-- 4nf: no independent multi-valued dependencies
-- 5nf: no unnecessary join dependencies