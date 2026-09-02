-- logical operators
-- and → both conditions must be true
-- or  → at least one condition must be true
-- not → reverses a condition

-- create database
create database company_db;
use company_db;

-- create employees table
create table employees (
    emp_id int primary key auto_increment,
    name varchar(50),
    age int,
    department varchar(50),
    salary decimal(10,2),
    city varchar(50)
);

-- view table structure
show tables;
desc employees;

-- insert employee records
insert into employees (name, age, department, salary, city) values
('alice johnson', 30, 'hr', 50000, 'new york'),
('bob smith', 25, 'it', 70000, 'los angeles'),
('charlie brown', 35, 'it', 80000, 'new york'),
('david wilson', 40, 'finance', 90000, 'chicago'),
('emily davis', 28, 'hr', 48000, 'san francisco'),
('franklin moore', 32, 'it', 75000, 'los angeles'),
('grace adams', 45, 'finance', 95000, 'chicago');

-- view all employees
select *
from employees;

-- and: it department and salary above 70000
select *
from employees
where department = 'it'
and salary > 70000;

-- or: hr department or employees living in new york
select *
from employees
where department = 'hr'
or city = 'new york';

-- not: employees who are not in finance
select *
from employees
where department <> 'finance';

-- not operator with equality
select *
from employees
where not department = 'finance';

-- alternative not-equal operator
select *
from employees
where department != 'finance';

-- combined and/or conditions
-- finance employees or it employees earning above 70000
select *
from employees
where department = 'finance'
or (salary > 70000 and department = 'it');

-- not with multiple conditions
-- employees not in it and not living in chicago
select *
from employees
where not department = 'it'
and not city = 'chicago';