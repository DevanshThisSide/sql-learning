-- views and temporary tables

-- a view is a virtual table based on the result of a select query.
-- a view normally does not store the actual result data permanently.
-- instead, mysql stores the query definition and executes it when the view is used.

-- a temporary table is an actual temporary table created for the current session.
-- it stores data temporarily and is automatically removed when the session ends.

-- views are useful for reusable queries and abstraction.
-- temporary tables are useful for storing intermediate results during complex operations.

-- create database and tables

create database views_temp_db;

use views_temp_db;

create table employees (
    employee_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    department varchar(50),
    salary decimal(10, 2),
    city varchar(50),
    joining_date date
);

create table departments (
    department_id int primary key,
    department_name varchar(50),
    location varchar(50)
);

insert into employees
    (employee_id, first_name, last_name, department, salary, city, joining_date)
values
    (101, 'devansh', 'bhatt', 'development', 35000, 'kanpur', '2024-01-15'),
    (102, 'aman', 'sharma', 'development', 28000, 'delhi', '2024-03-10'),
    (103, 'priya', 'singh', 'hr', 22000, 'lucknow', '2023-07-20'),
    (104, 'rohit', 'verma', 'sales', 18000, 'kanpur', '2024-05-12'),
    (105, 'varun', 'gupta', 'testing', 30000, 'delhi', '2023-11-05'),
    (106, 'dheeraj', 'yadav', 'development', 15000, 'lucknow', '2025-01-10'),
    (107, 'neha', 'mehta', 'hr', 40000, 'delhi', '2022-08-18'),
    (108, 'rahul', 'joshi', 'management', 50000, 'mumbai', '2021-04-25');

insert into departments
    (department_id, department_name, location)
values
    (1, 'development', 'bangalore'),
    (2, 'testing', 'pune'),
    (3, 'hr', 'delhi'),
    (4, 'sales', 'mumbai'),
    (5, 'management', 'mumbai');

select *
from employees;

select *
from departments;

-- views

-- a view is a virtual table created using a select statement.
-- syntax:
-- create view view_name as
-- select ...
-- the view does not normally store a separate copy of the result.
-- it stores the query definition.

-- create a simple view

create view employee_basic_info as
select
    employee_id,
    first_name,
    last_name,
    department
from employees;

-- use the view just like a table.

select *
from employee_basic_info;

-- select specific columns from a view.

select
    first_name,
    department
from employee_basic_info;

-- use where with a view.

select *
from employee_basic_info
where department = 'development';

-- use order by with a view.

select *
from employee_basic_info
order by first_name;

-- view with calculated columns

create view employee_salary_info as
select
    employee_id,
    first_name,
    department,
    salary,
    salary * 12 as annual_salary
from employees;

select *
from employee_salary_info;

-- a view can contain expressions and calculated columns.

-- view with case

create view employee_salary_level as
select
    employee_id,
    first_name,
    salary,
    case
        when salary > 30000 then 'high'
        when salary > 20000 then 'medium'
        else 'low'
    end as salary_level
from employees;

select *
from employee_salary_level;

-- view with where

-- this view contains only hr employees.

create view hr_employees as
select
    employee_id,
    first_name,
    last_name,
    salary
from employees
where department = 'hr';

select *
from hr_employees;

-- the where condition is part of the view definition.
-- whenever the view is queried, only hr employees
-- are returned through this view.


-- view with join

create view employee_department_info as
select
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name,
    d.location
from employees as e
join departments as d
    on e.department = d.department_name;

select *
from employee_department_info;

-- views can hide complex joins behind a simple table-like interface.
-- this is useful when the same join is needed repeatedly.

-- view with aggregate functions

create view department_salary_summary as
select
    department,
    count(*) as total_employees,
    round(avg(salary), 2) as average_salary,
    min(salary) as minimum_salary,
    max(salary) as maximum_salary,
    sum(salary) as total_salary
from employees
group by department;

select *
from department_salary_summary;

-- views can contain group by and aggregate functions.
-- however, views containing aggregation are generally not directly updatable like simple views.

-- view definition

-- show the sql used to create the view.

show create view employee_basic_info;


-- replace an existing view

-- create or replace view modifies the view definition
-- without requiring the old view to be dropped first.

create or replace view employee_basic_info as
select
    employee_id,
    first_name,
    last_name,
    department,
    city
from employees;

select *
from employee_basic_info;

-- dropping a view

-- drop view permanently removes the view definition.
-- it does not delete the underlying employees table.

drop view if exists employee_salary_info;

-- updating data through a view

-- simple views may be updatable when mysql can map the change
-- directly to the underlying table.

update hr_employees
set salary = salary + 1000
where employee_id = 101;

select *
from hr_employees;

select *
from employees
where employee_id = 107;

-- with check option

-- with check option is used with an updatable view.
-- it prevents insert or update operations through the view
-- when the resulting row would no longer satisfy the view's where condition.

-- example:
-- this view only shows hr employees.

create or replace view hr_employees as
select
    employee_id,
    first_name,
    last_name,
    salary,
    department
from employees
where department = 'hr'
with check option;

select *
from hr_employees;

-- this update is allowed because the employee still satisfies
-- the view condition: department = 'hr'.

update hr_employees
set salary = salary + 1000
where employee_id = 107;


-- this update is rejected because changing the department
-- would make the row no longer satisfy the view condition.

-- the view only allows rows where department = 'hr'.

update hr_employees
set department = 'sales'
where employee_id = 107;


-- without with check option, mysql may allow an update through
-- an updatable view that causes the row to disappear from the view.

-- with check option prevents this by ensuring that the modified
-- row still satisfies the view's where condition.

-- simple example of with check option

create or replace view high_salary_employees as
select
    employee_id,
    first_name,
    department,
    salary
from employees
where salary > 25000
with check option;

select *
from high_salary_employees;

-- allowed:
-- salary remains greater than 25000.

update high_salary_employees
set salary = 30000
where employee_id = 102;

-- rejected:
-- salary would become 20000, which violates the view condition.

 update high_salary_employees
 set salary = 20000
 where employee_id = 102;

-- view limitations
-- not every view is automatically updatable.

-- views containing features such as:
-- group by
-- aggregate functions
-- distinct
-- union
-- some joins
-- subqueries
-- may not be directly updatable.

-- therefore, a view should not automatically be treated
-- as a normal editable table.

-- temporary tables

-- a temporary table exists only during the current mysql session.
-- it is automatically removed when the session ends.
-- syntax:
-- create temporary table table_name (...);

create temporary table temp_employees (
    employee_id int,
    first_name varchar(50),
    department varchar(50),
    salary decimal(10, 2)
);

insert into temp_employees
    (employee_id, first_name, department, salary)
select
    employee_id,
    first_name,
    department,
    salary
from employees
where salary > 25000;

select *
from temp_employees;

-- temporary tables can be queried like normal tables.

select
    first_name,
    salary
from temp_employees
order by salary desc;


-- create temporary table using select

-- mysql allows a temporary table to be created directly
-- from the result of a select query.

create temporary table high_salary_employees as
select
    employee_id,
    first_name,
    department,
    salary
from employees
where salary > 30000;

select *
from high_salary_employees;


-- modifying temporary tables

-- temporary tables can be modified like regular tables.

update high_salary_employees
set salary = salary + 2000
where department = 'development';

select *
from high_salary_employees;

delete from high_salary_employees
where salary < 35000;

select *
from high_salary_employees;

-- adding columns to temporary tables

alter table temp_employees
add column salary_level varchar(20);

update temp_employees
set salary_level = case
    when salary > 30000 then 'high'
    when salary > 20000 then 'medium'
    else 'low'
end;

select *
from temp_employees;

-- temporary table with aggregation

create temporary table temp_department_summary as
select
    department,
    count(*) as total_employees,
    round(avg(salary), 2) as average_salary
from employees
group by department;

select *
from temp_department_summary;

-- the temporary table now stores the intermediate result.
-- this can be useful when the result needs to be reused
-- multiple times during the same session.

-- using a temporary table in another query

select
    department,
    total_employees,
    average_salary
from temp_department_summary
where average_salary > 25000
order by average_salary desc;

-- temporary tables can also be joined with permanent tables.

select
    t.department,
    t.total_employees,
    d.location
from temp_department_summary as t
join departments as d
    on t.department = d.department_name;

-- drop temporary table

-- a temporary table can be manually removed before the session ends.

drop temporary table if exists high_salary_employees;

-- view vs temporary table

-- view:
-- 1. stores a query definition.
-- 2. behaves like a virtual table.
-- 3. normally does not store a separate copy of the result.
-- 4. remains available until the view is dropped.
-- 5. useful for reusable queries and abstraction.
--
-- temporary table:
-- 1. stores temporary result data.
-- 2. exists only for the current session.
-- 3. is automatically removed when the session ends.
-- 4. can be modified like a regular table.
-- 5. useful for intermediate results in complex operations.

-- explain with views

-- explain shows how mysql plans to execute a query.
-- it can help analyze table access, indexes, joins,
-- filtering, and estimated rows.

explain
select *
from employee_department_info
where department_name = 'development';

-- a view should not be assumed to improve performance by itself.
-- mysql may merge a simple view into the surrounding query,
-- while some complex views may be materialized internally
-- depending on the query and optimizer.