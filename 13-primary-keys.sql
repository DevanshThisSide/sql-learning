-- primary keys

-- key benefits:
-- they uniquely identify each record in a table
-- they ensure no duplicate records exist
-- they provide a reference point for relationships between tables
-- they optimize database performance for record retrieval

-- section 1: basic primary key implementation
-- creating a table with a simple primary key
create table students (
    student_id int primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email varchar(100)
);

-- inserting records with valid primary keys
insert into students (student_id, first_name, last_name, email)
values
(1, 'John', 'Smith', 'john.smith@example.com'),
(2, 'Maria', 'Garcia', 'maria.garcia@example.com'),
(3, 'Ahmed', 'Khan', 'ahmed.khan@example.com');

-- demonstrating primary key constraint - this will fail
insert into students (student_id, first_name, last_name, email)
values (1, 'Jane', 'Doe', 'jane.doe@example.com');
-- error code: 1062. duplicate entry '1' for key 'PRIMARY'

-- section 2: auto-increment primary keys
-- creating a table with an auto-increment primary key
create table products (
    product_id int auto_increment primary key,
    product_name varchar(100) not null,
    price decimal(10, 2) not null,
    description text
);

-- with auto-increment, we don't need to specify the primary key value
insert into products (product_name, price, description)
values
('Laptop', 1299.99, 'High-performance laptop'),
('Smartphone', 799.99, 'Latest model smartphone'),
('Headphones', 199.99, 'Noise-cancelling headphones');

-- view the auto-generated ids
select * from products;

-- section 3: adding primary keys to existing tables
-- creating a table with a primary key defined separately
create table orders (
    order_id int,
    customer_id int,
    order_date date not null,
    total_amount decimal(10, 2) not null,
    primary key (order_id)
);

-- create table without primary key
create table suppliers (
    supplier_id int,
    supplier_name varchar(100) not null,
    contact_person varchar(100)
);

-- adding a primary key to an existing table
alter table suppliers
add primary key (supplier_id);

-- section 4: composite primary keys
-- creating a table with a composite primary key (multiple columns)
create table enrollments (
    student_id int,
    course_id int,
    enrollment_date date not null,
    grade varchar(2),
    primary key (student_id, course_id)
);

-- insert records with unique combinations of the composite key
insert into enrollments (student_id, course_id, enrollment_date, grade)
values
(1, 101, '2023-01-15', 'A'),
(1, 102, '2023-01-15', 'B+'),  -- same student, different course - ok
(2, 101, '2023-01-16', 'A-'),  -- different student, same course - ok
(3, 103, '2023-01-17', 'B');

-- this will fail - duplicate composite key (student_id + course_id)
insert into enrollments (student_id, course_id, enrollment_date, grade)
values (1, 101, '2023-02-01', 'C');
-- error: duplicate entry '1-101' for key 'PRIMARY'

-- primary key best practices:
-- 1. always include a primary key in every table
-- 2. use auto-increment unless you have a specific reason not to
-- 3. keep primary keys simple - use int or bigint for numeric ids

-- INTERNAL MECHANICS OF PRIMARY KEYS & STORAGE (Clustered Index / B+ Tree)

--    Internally, SQL databases store values through primary keys by leveraging physical storage structures called indexes,
--    most notably Clustered Indexes arranged in a B+ Tree data structure.

--    When you define a primary key, you are defining a logical rule (uniqueness and no NULLs),
--    but the database engine automatically implements a physical mechanism to store and fetch that data.

-- 1. PHYSICAL STORAGE: 

--    In engines like MySQL (InnoDB) or SQL Server, the primary key is the table itself.

--    Clustered Index: When you declare a primary key, the database automatically builds a clustered index around it.

--    Physical Ordering: Instead of storing rows haphazardly in a file,
--    the database engine forces the actual rows of your data to be physically sorted 
--    and stored on disk in the order of the primary key values.
--
-- 2. THE B+ TREE STRUCTURE:

--    To organize this data, SQL uses a self balanced tree structure called a B+ Tree.
--    This tree is broken down into fixed-size blocks of memory called Pages (typically 8KB or 16KB).

--    The tree consists of three layers:
/*
                  [ Root Node Page ]
                     /          \
        [ Internal Node ]     [ Internal Node ]
           /         \           /         \
    [Leaf Page]  [Leaf Page] [Leaf Page] [Leaf Page]
    (Row Data)   (Row Data)  (Row Data)  (Row Data)
*/
--    [Root Node and Internal Nodes]   -> These store only the primary key values and pointers to the next child page.
--                                        They act like a GPS, guiding the database engine down the tree.
 
--    [Leaf Pages]                      -> The bottom-most layer of the tree. In a clustered index,
--                                        the leaf nodes do not contain pointers to the data—they contain the actual row data itself.
--
-- 3. HOW OPERATIONS WORK INTERNALLY:
--    • SELECT (id = 450): Traverses Root -> Internal -> Leaf in O(log N) time. 
--      Finds a specific row out of billions in just 3-4 page reads.
--
--    • INSERT (New ID): Finds the correct Leaf Page to maintain sorted order.
--      * If page is full, a costly "Page Split" occurs (moves 50% data to a new page).
--      * Performance Tip: Use auto-incrementing/sequential IDs to ensure data 
--        is always appended to the end, completely avoiding page splits.
--
-- 4. THE POSTGRES EXCEPTION (Heap Tables):
--    PostgreSQL stores rows in unordered "Heaps". The Primary Key creates a 
--    separate B-Tree index. Its leaf nodes hold physical pointers (Tuple IDs) 
--    to the heap file, rather than the raw data itself.