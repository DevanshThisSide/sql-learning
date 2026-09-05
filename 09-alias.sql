-- mysql aliases
-- aliases are temporary names assigned to tables, columns, or expressions
-- to make them more readable and manageable

-- create and use database
create database db16;
use db16;

-- create employees table
create table employees (
    emp_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    salary decimal(10,2),
    hire_date date
);

-- insert initial employee data
insert into employees values
    (1, 'john', 'doe', 60000.00, '2020-01-15'),
    (2, 'jane', 'smith', 65000.00, '2019-11-20'),
    (3, 'mike', 'johnson', 55000.00, '2021-03-10');

-- view all employees
select *
from employees;

-- basic column alias
-- create a full name using concatenation
select concat(first_name, ' ', last_name) as full_name
from employees;

-- create departments table
create table departments (
    dept_id int primary key,
    dept_name varchar(50),
    location varchar(50)
);

-- insert department data
insert into departments values
    (1, 'engineering', 'new york'),
    (2, 'marketing', 'los angeles'),
    (3, 'finance', 'chicago');

-- add department reference to employees
alter table employees
add column department_id int;

-- use table aliases in join
select
    e.first_name,
    e.last_name,
    d.dept_name
from employees as e
join departments as d
    on e.department_id = d.dept_id;

-- use alias for a subquery
select avg_salary.average_salary
from (
    select avg(salary) as average_salary
    from employees
) as avg_salary;