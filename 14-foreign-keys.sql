-- foreign keys in sql: database relationships

-- introduction to foreign keys
-- a foreign key is a column or set of columns in one table that refers to
-- the primary key in another table.
-- it creates a link between two tables, establishing a parent-child relationship.
-- parent table: contains the primary key that is referenced
-- child table: contains the foreign key that references the primary key of the parent table
-- purpose of foreign keys:

-- referential integrity:
-- ensures that relationships between linked tables remain valid.
-- it prevents orphaned records by requiring a foreign key to match an existing
-- primary key or be null when the column allows null.
-- for example: if you try to delete customer alice (id 101) while her order
-- (id 9001) still exists, the database can block the deletion.
-- this prevents order 9001 from losing its owner and becoming an orphaned record.

-- data validation:
-- foreign keys act as a database-level validation mechanism.
-- they reject data that refers to a non-existent record.
-- for example: if customer_id = 555 does not exist in the customers table,
-- inserting an order with customer_id = 555 will fail.

-- structured relationships:
-- foreign keys define relationships between tables.
-- for example: one customer can have many orders.
-- the tables can then be connected using a join:
-- select *
-- from customers
-- join orders
--     on customers.customer_id = orders.customer_id;


-- types of table relationships

-- 1. one-to-one (1:1):
-- each record in table a relates to at most one record in table b.
-- the primary key of the child table is also a foreign key.

-- example:
-- create employee_details after employees has been created
-- primary key + foreign key ensures one detail record per employee
create table employee_details (
    employee_id int not null,
    passport_number varchar(20),
    marital_status varchar(20),
    emergency_contact varchar(100),
    primary key (employee_id),
    foreign key (employee_id) references employees(employee_id)
);


-- 2. one-to-many (1:n):
-- one record in table a can relate to multiple records in table b.
-- for example: one department can have many employees.

create table employees (
    employee_id int not null,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    department_id int,
    primary key (employee_id),
    foreign key (department_id) references departments(department_id)
);

-- multiple employee records can reference the same department_id.


-- 3. many-to-many (n:m):
-- multiple records in table a can relate to multiple records in table b.
-- a junction table is used to represent the relationship.

-- create students table
create table students (
    student_id int primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null
);

-- create courses table
create table courses (
    course_id int primary key,
    course_name varchar(100) not null,
    instructor varchar(100) not null
);

-- create enrollments junction table with foreign keys
create table enrollments (
    enroll_id int primary key,
    student_id int not null,
    course_id int not null,
    grade varchar(5),
    foreign key (student_id) references students(student_id),
    foreign key (course_id) references courses(course_id)
);


-- practical implementation

-- create a database
create database business_db;
use business_db;

-- create the parent table (departments)
create table departments (
    department_id int not null,
    department_name varchar(100) not null,
    location varchar(100),
    primary key (department_id)
);

-- create the child table with a foreign key (employees)
create table employees (
    employee_id int not null,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email varchar(100),
    hire_date date,
    salary decimal(10, 2),
    department_id int,
    primary key (employee_id),
    foreign key (department_id) references departments(department_id)
);

-- insert sample data

-- insert department data
insert into departments (department_id, department_name, location)
values
    (1, 'Human Resources', 'Floor 1'),
    (2, 'Marketing', 'Floor 2'),
    (3, 'Engineering', 'Floor 3'),
    (4, 'Finance', 'Floor 1');

-- insert employee data
insert into employees (
    employee_id,
    first_name,
    last_name,
    email,
    hire_date,
    salary,
    department_id
)
values
    (101, 'John', 'Smith', 'john.smith@company.com', '2018-06-20', 55000.00, 1),
    (102, 'Sarah', 'Johnson', 'sarah.johnson@company.com', '2019-03-15', 62000.00, 2),
    (103, 'Michael', 'Williams', 'michael.williams@company.com', '2020-01-10', 75000.00, 3),
    (104, 'Emily', 'Brown', 'emily.brown@company.com', '2019-11-05', 68000.00, 3),
    (105, 'David', 'Jones', 'david.jones@company.com', '2021-02-28', 58000.00, 4),
    (106, 'Jessica', 'Davis', 'jessica.davis@company.com', '2020-07-16', 61000.00, 2),
    (107, 'Robert', 'Miller', 'robert.miller@company.com', '2018-09-12', 72000.00, 3);

-- view employee and department data
select * from employees;
select * from departments;


-- demonstrating foreign key constraint

-- attempt to insert an employee with a non-existent department_id
-- this will fail because department_id 69 does not exist
insert into employees (
    employee_id,
    first_name,
    last_name,
    email,
    hire_date,
    salary,
    department_id
)
values
    (145, 'John', 'Smith', 'john.smith@company.com', '2018-06-20', 55000.00, 69);

-- error: cannot add or update a child row:
-- a foreign key constraint fails

-- insert an employee with null department_id
-- this is allowed because the foreign key column permits null
insert into employees (
    employee_id,
    first_name,
    last_name,
    email,
    hire_date,
    salary,
    department_id
)
values
    (108, 'Thomas', 'Wilson', 'thomas.wilson@company.com', '2022-04-10', 65000.00, null);


-- adding and removing foreign keys

-- create a projects table
create table projects (
    project_id int not null,
    project_name varchar(100) not null,
    start_date date,
    end_date date,
    manager_id int,
    primary key (project_id)
);

-- add a foreign key constraint after table creation
alter table projects
add constraint fk_project_manager
foreign key (manager_id) references employees(employee_id);

-- view the table structure including the foreign key
show create table projects;

-- remove a foreign key constraint
alter table projects
drop foreign key fk_project_manager;

-- verify the foreign key was removed
show create table projects;


-- foreign key actions

-- on delete / on update define what happens to child records
-- when the referenced parent record is deleted or updated.

-- common options:
-- cascade: automatically apply the change to child records
-- set null: set the foreign key value to null
-- restrict: prevent the change when related child records exist

-- example:
-- foreign key (manager_id)
-- references employees(employee_id)
-- on delete set null
-- on update cascade


-- exercise: implementing employee skills table

-- create a table for employee skills with a named foreign key constraint
create table employee_skills (
    skill_id int not null,
    employee_id int not null,
    skill_name varchar(50) not null,
    proficiency_level enum(
        'Beginner',
        'Intermediate',
        'Advanced',
        'Expert'
    ) not null,
    primary key (skill_id),
    constraint fk_employee_skill
        foreign key (employee_id)
        references employees(employee_id)
);

-- insert some skills
insert into employee_skills (
    skill_id,
    employee_id,
    skill_name,
    proficiency_level
)
values
    (1, 103, 'Python', 'Expert'),
    (2, 103, 'SQL', 'Advanced'),
    (3, 104, 'Java', 'Intermediate'),
    (4, 107, 'C++', 'Advanced'),
    (5, 107, 'SQL', 'Expert'),
    (6, 102, 'Graphic Design', 'Advanced');

select * from employee_skills;