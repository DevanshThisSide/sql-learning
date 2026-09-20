-- set operations : except / minus and intersect

-- except (also called minus in some databases) returns rows
-- that exist in the first result set but not in the second.

-- intersect returns rows that are common to both result sets.

-- mysql versions before 8.0.31 did not support except and intersect
-- directly, so they were commonly simulated using joins and subqueries.

-- this file demonstrates both the direct set operators and
-- their commonly used alternatives.

-- create database and tables

create database set_operations_db;

use set_operations_db;

create table employees_2025 (
    employee_id int primary key,
    first_name varchar(50),
    department varchar(50)
);

create table employees_2026 (
    employee_id int primary key,
    first_name varchar(50),
    department varchar(50)
);


insert into employees_2025
    (employee_id, first_name, department)
values
    (101, 'devansh', 'development'),
    (102, 'aman', 'testing'),
    (103, 'priya', 'hr'),
    (104, 'rohit', 'sales'),
    (105, 'varun', 'development');


insert into employees_2026
    (employee_id, first_name, department)
values
    (101, 'devansh', 'development'),
    (102, 'aman', 'testing'),
    (104, 'rohit', 'sales'),
    (106, 'dheeraj', 'finance'),
    (107, 'neha', 'hr');


select *
from employees_2025;

select *
from employees_2026;


-- except / minus

-- except returns rows from the first query
-- that do not exist in the second query.

-- mysql supports except in newer versions.
-- older mysql versions can achieve the same result using
-- left join, not in, or not exists.

-- using except

-- employees present in 2025 but not in 2026.

select employee_id, first_name
from employees_2025
except
select employee_id, first_name
from employees_2026;

-- using left join + where is null

-- keep all rows from employees_2025.
-- if no matching employee exists in employees_2026,
-- columns from the second table become null.
-- where is null keeps only those unmatched rows (i.e., the rows only from the first table and not the ones common with second table).

select
    e1.employee_id,
    e1.first_name
from employees_2025 as e1
left join employees_2026 as e2
    on e1.employee_id = e2.employee_id
where e2.employee_id is null;

-- using not in

-- return employees whose employee_id does not exist in employees_2026.

select
    employee_id,
    first_name
from employees_2025
where employee_id not in (
    select employee_id
    from employees_2026
);


-- important:
-- not in can behave unexpectedly when the subquery contains null.
-- therefore, not exists is often safer when null values are possible.


-- using not exists

-- for every employee in employees_2025,
-- check whether a matching employee exists in employees_2026.
-- not exists keeps only employees for which no match exists.

select
    e1.employee_id,
    e1.first_name
from employees_2025 as e1
where not exists (
    select 1
    from employees_2026 as e2
    where e1.employee_id = e2.employee_id
);

-- It filters out any 2025 employee who is also found in the 2026 table.

-- intersect

-- intersect returns rows that are common between both result sets.


-- using intersect

-- employees present in both 2025 and 2026.

select employee_id, first_name
from employees_2025
intersect
select employee_id, first_name
from employees_2026;


-- using inner join

-- inner join returns rows where a matching employee exists in both tables.

select
    e1.employee_id,
    e1.first_name
from employees_2025 as e1
inner join employees_2026 as e2
    on e1.employee_id = e2.employee_id;


-- using exists

-- for every employee in employees_2025,
-- check whether the same employee exists in employees_2026.
-- exists keeps the row when a match is found.

select
    e1.employee_id,
    e1.first_name
from employees_2025 as e1
where exists (
    select 1
    from employees_2026 as e2
    where e1.employee_id = e2.employee_id
);

-- It keeps only the 2025 employees who are also employed in 2026.

-- important points

-- select 1 is commonly used with exists/not exists
--    because exists only checks whether a matching row exists.
--    the actual selected value does not matter.

-- except and intersect work on complete result rows,
--     so the selected columns and their compatible data types
--     must match between the two queries.

-- except and intersect normally remove duplicate rows
--     from their result.

-- except all and intersect all, where supported, preserve
--     duplicate occurrences according to multiset rules.


-- accessing tables from different databases in mysql
--
-- syntax:
-- database_name.table_name
--
-- you do not need to use both databases at the same time.
-- you can directly specify the database name before the table name.

-- example databases:
-- collegedb -> student
-- companydb -> employees

-- access a table from another database

select *
from collegedb.student;

select *
from companydb.employees;

-- if you are currently using collegedb,
-- you can access its table without specifying the database name.

use collegedb;

select *
from student;

-- but you can still access a table from companydb
-- by using the database.table syntax.

select *
from companydb.employees;

-- joining tables from different databases
-- works just like joining tables from the same database.

select
    s.name,
    s.course,
    e.first_name,
    e.department
from collegedb.student as s
join companydb.employees as e
    on s.name = e.first_name;

-- mysql allows this as long as your user has permission
-- to access both databases.