-- basic select
select first_name, email
from employees;

-- create and use database
create database company;
use company;

-- create employees table
create table employees (
    id int auto_increment primary key,
    first_name varchar(50),
    last_name varchar(50),
    department varchar(50),
    salary decimal(10,2),
    hire_date date
);

-- insert employee records
insert into employees (first_name, last_name, department, salary, hire_date) values
('john', 'doe', 'hr', 60000.00, '2022-05-10'),
('jane', 'smith', 'it', 75000.00, '2021-08-15'),
('alice', 'johnson', 'finance', 82000.00, '2019-03-20'),
('bob', 'williams', 'it', 72000.00, '2020-11-25'),
('charlie', 'brown', 'marketing', 65000.00, '2023-01-05');

-- view all employees
select *
from employees;

-- select specific columns with alias
select first_name as 'first name', last_name, department
from employees;

-- highest paid employee in the it department
select *
from employees
where department = 'it'
order by salary desc
limit 1;

-- limit number of records
select *
from employees
limit 2;

-- get unique departments
select distinct department
from employees;

-- calculate salary after a 10% raise
select first_name, last_name, salary * 1.1 as 'salary after raise'
from employees;

-- use string, date and numeric functions
select concat(first_name, ' ', last_name) as 'full name',
       year(hire_date),
       round(salary, 1)
from employees
where salary > 70000;

-- calculate average salary
select avg(salary)
from employees;

-- employees earning more than the average salary
select *
from employees
where salary > (select avg(salary) from employees);

-- combine employees from it and hr departments
select first_name, last_name
from employees
where department = 'it'
union
select first_name, last_name
from employees
where department = 'hr';

-- count employees in each department
select count(*) as employee_count, department
from employees
group by department;

-- get current date and time
select now() as 'time';

-- basic arithmetic expression
select 5 * 2;

-- string length
select length('hello');

-- comparison expression
select 5 < 3;