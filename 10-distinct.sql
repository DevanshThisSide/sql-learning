-- mysql distinct
-- the distinct clause eliminates duplicate rows from the result set
-- syntax: select distinct column1, column2 from table_name;

-- create and use the database
create database duplicatesdb;
show databases;
use duplicatesdb;

-- create employees table
create table employees (
    id int auto_increment primary key,
    name varchar(50),
    department varchar(50),
    salary decimal(10,2)
);

-- insert sample data including duplicates
insert into employees (name, department, salary) values
    ('alice', 'hr', 50000),
    ('bob', 'finance', 60000),
    ('charlie', 'it', 70000),
    ('alice', 'hr', 50000),      -- duplicate record
    ('david', 'finance', 55000),
    ('eve', 'it', 70000),        -- duplicate salary
    ('frank', 'hr', 50000);      -- duplicate department & salary

-- view all employees
select * from employees;

-- example 1: using distinct on a single column
-- get unique departments
select distinct department
from employees;

-- example 2: using distinct on multiple columns
-- get unique department-salary combinations
select distinct department, salary
from employees;

-- example 3: using distinct with aggregate functions
-- count number of unique departments
select count(distinct department) as unique_departments
from employees;

-- example 4: using distinct with string functions
-- get unique name-department pairs
select distinct concat(name, ' - ', department)
from employees;

-- example 5: using distinct with order by
-- get unique salaries in descending order
select distinct salary
from employees
order by salary desc;

-- example 6: using distinct with where clause
-- get unique departments where salary is greater than 50000
select distinct department
from employees
where salary > 50000;

-- display current data
select * from employees;

-- example 7: handling null values with distinct
-- insert records with null departments
insert into employees (name, department, salary) values
    ('grace', null, 48000),
    ('bobby', null, 58000);

-- show how distinct handles null values
-- distinct treats null as a unique value, so it will return one row for null
select distinct department
from employees;