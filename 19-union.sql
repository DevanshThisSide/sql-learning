-- mysql union

-- introduction to union and union all
-- union allows us to combine result sets from multiple select queries into a single result set.
-- key points:
-- - combines rows from multiple queries into a single result set
-- - appends rows vertically (stacks them on top of each other)
-- - requires that all queries have the same number of columns
-- - column data types must be compatible across all queries
-- - eliminates duplicate rows by default (use union all to keep duplicates)
-- - uses the column names from the first select statement for the final result set
-- - ignores column names from subsequent queries


-- database setup
create database sql_union_db;
use sql_union_db;


-- create tables for our demonstration
create table headquarters_employees (
    employee_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    hire_date date,
    department varchar(50),
    salary decimal(10, 2)
);

create table branch_employees (
    employee_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    hire_date date,
    department varchar(50),
    salary decimal(10, 2)
);

create table customers (
    customer_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    signup_date date,
    status varchar(20)
);


-- sample data

-- insert data into headquarters_employees
insert into headquarters_employees
values
    (101, 'John', 'Smith', 'john.smith@company.com', '2018-03-15', 'IT', 75000.00),
    (102, 'Mary', 'Johnson', 'mary.johnson@company.com', '2019-06-22', 'HR', 65000.00),
    (103, 'Robert', 'Williams', 'robert.williams@company.com', '2017-11-08', 'Finance', 82000.00),
    (104, 'Susan', 'Brown', 'susan.brown@company.com', '2020-01-30', 'Marketing', 68000.00),
    (105, 'Michael', 'Davis', 'michael.davis@company.com', '2018-09-12', 'IT', 78000.00);


-- insert data into branch_employees
insert into branch_employees
values
    (201, 'James', 'Wilson', 'james.wilson@company.com', '2019-04-18', 'Sales', 62000.00),
    (202, 'Patricia', 'Moore', 'patricia.moore@company.com', '2020-07-25', 'Marketing', 59000.00),
    (203, 'Linda', 'Taylor', 'linda.taylor@company.com', '2018-08-15', 'HR', 61000.00),
    (204, 'Robert', 'Williams', 'robert.williams@company.com', '2017-11-08', 'Finance', 82000.00),
    (205, 'Elizabeth', 'Anderson', 'elizabeth.anderson@company.com', '2019-12-03', 'Sales', 64000.00);


-- insert data into customers
insert into customers
values
    (1001, 'David', 'Miller', 'david.miller@email.com', '2019-02-14', 'Active'),
    (1002, 'Sarah', 'Wilson', 'sarah.wilson@email.com', '2020-05-20', 'Active'),
    (1003, 'Michael', 'Davis', 'michael.davis@email.com', '2018-11-30', 'Inactive'),
    (1004, 'Jennifer', 'Garcia', 'jennifer.garcia@email.com', '2021-01-05', 'Active'),
    (1005, 'Robert', 'Martinez', 'robert.martinez@email.com', '2019-08-22', 'Active');


-- view table data
select * from headquarters_employees;
select * from branch_employees;
select * from customers;


-- basic union examples

-- example 1: union vs union all
-- get a list of all employees from both locations (without duplicates)
select first_name, last_name, email
from headquarters_employees
union
select first_name, last_name, email
from branch_employees;


-- get a list of all employees from both locations (including duplicates)
select first_name, last_name, email
from headquarters_employees
union all
select first_name, last_name, email
from branch_employees;


-- example 2: combining full tables
select *
from headquarters_employees
union all
select *
from branch_employees;


-- advanced union examples

-- example 3: adding a descriptor column
-- combine employee and customer contact information with a type indicator
select first_name, last_name, email, 'Employee' as contact_type
from headquarters_employees
union
select first_name, last_name, email, 'Customer' as contact_type
from customers;


-- example 4: ordering results after union
-- get all employees sorted by last name
select employee_id, first_name, last_name, department
from headquarters_employees
union
select employee_id, first_name, last_name, department
from branch_employees
order by last_name;


-- example 5: filtering before union
-- get employees with salary over 70000
select employee_id, first_name, last_name, department, salary
from headquarters_employees
where salary > 70000
union
select employee_id, first_name, last_name, department, salary
from branch_employees
where salary > 70000
order by salary desc;


-- handling different column structures

-- example 6: handling different table structures with null values
select employee_id, first_name, last_name, department, salary, null as status
from headquarters_employees
union
select customer_id, first_name, last_name, null, null, status
from customers
order by first_name, last_name;


-- practical use cases

-- example 7: finding all unique departments across locations
select department
from headquarters_employees
union
select department
from branch_employees;


-- example 8: finding common departments
-- departments that exist in both headquarters and branch offices
select department
from (
    select distinct department
    from headquarters_employees

    union all

    select distinct department
    from branch_employees
) as combined
group by department
having count(*) = 2;