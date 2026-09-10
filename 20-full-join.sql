-- mysql full join

-- introduction to full join

-- full join
-- - it returns all matching rows from both tables where the join condition is met.
-- - it also returns all non-matching rows from the left table with null values for columns from the right table.
-- - it also returns all non-matching rows from the right table with null values for columns from the left table.
-- - it combines the results of both left join and right join, including all records from both tables and matching records from both sides where available.
--
-- note:
-- mysql does not natively support the full outer join keyword.
-- a full join can be simulated in mysql by combining a left join and a right join using union.
-- union removes duplicate rows from the combined result.
--
-- join types comparison:
-- - inner join: only returns matching rows between tables
-- - left join: returns all rows from the left table and matching rows from the right
-- - right join: returns all rows from the right table and matching rows from the left
-- - full join: returns all rows from both tables


-- database setup
create database characters_db;
use characters_db;


-- create tables for our demonstration
create table characters (
    character_id int primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    occupation varchar(100)
);

create table apartments (
    apartment_id int primary key,
    building_address varchar(100) not null,
    apartment_number varchar(10) not null,
    monthly_rent decimal(8, 2),
    current_tenant_id int
);


-- sample data

-- insert data into characters
insert into characters (character_id, first_name, last_name, occupation)
values
    (1, 'Ross', 'Geller', 'Paleontologist'),
    (2, 'Rachel', 'Green', 'Fashion Executive'),
    (3, 'Chandler', 'Bing', 'IT Procurement Manager'),
    (4, 'Monica', 'Geller', 'Chef'),
    (5, 'Joey', 'Tribbiani', 'Actor'),
    (6, 'Phoebe', 'Buffay', 'Massage Therapist'),
    (7, 'Gunther', 'Smith', 'Coffee Shop Manager'),
    (8, 'Janice', 'Hosenstein', 'Unknown');


-- insert data into apartments
insert into apartments (
    apartment_id,
    building_address,
    apartment_number,
    monthly_rent,
    current_tenant_id
)
values
    (101, '90 Bedford Street', '20', 3500.00, 3),
    (102, '90 Bedford Street', '19', 3500.00, 4),
    (103, '5 Morton Street', '14', 2800.00, 6),
    (104, '17 Grove Street', '3B', 2200.00, null),
    (105, '15 Yemen Road', 'Yemen', 900.00, null),
    (106, '495 Grove Street', '7', 2400.00, 1);


-- view table data
select * from characters;
select * from apartments;


-- join examples

-- inner join example
-- only returns characters who have apartments and apartments that have tenants
select
    c.character_id,
    c.first_name,
    c.last_name,
    c.occupation,
    a.apartment_id,
    a.building_address,
    a.apartment_number,
    a.monthly_rent
from characters c
inner join apartments a
    on c.character_id = a.current_tenant_id;


-- left join example
-- all characters, including those without apartments
select
    c.character_id,
    c.first_name,
    c.last_name,
    c.occupation,
    a.apartment_id,
    a.building_address,
    a.apartment_number,
    a.monthly_rent
from characters c
left join apartments a
    on c.character_id = a.current_tenant_id;


-- right join example
-- all apartments, including those without tenants
select
    c.character_id,
    c.first_name,
    c.last_name,
    c.occupation,
    a.apartment_id,
    a.building_address,
    a.apartment_number,
    a.monthly_rent
from characters c
right join apartments a
    on c.character_id = a.current_tenant_id;


-- full join example using union
-- all characters and all apartments, with matches where they exist
select
    c.character_id,
    c.first_name,
    c.last_name,
    c.occupation,
    a.apartment_id,
    a.building_address,
    a.apartment_number,
    a.monthly_rent
from characters c
left join apartments a
    on c.character_id = a.current_tenant_id

union

select
    c.character_id,
    c.first_name,
    c.last_name,
    c.occupation,
    a.apartment_id,
    a.building_address,
    a.apartment_number,
    a.monthly_rent
from characters c
right join apartments a
    on c.character_id = a.current_tenant_id;


-- note:
-- the first query keeps all characters and adds matching apartments.
-- the second query keeps all apartments and adds matching characters.
-- union combines both results and removes duplicate matching rows.
-- together, they simulate a full outer join in mysql.


-- postgres supports full outer joins natively.
-- unlike mysql, postgres does not require the union technique.
-- you can use full outer join or full join directly.


-- postgres native full join syntax (for reference)
/*
select
    c.character_id,
    c.first_name,
    c.last_name,
    c.occupation,
    a.apartment_id,
    a.building_address,
    a.apartment_number,
    a.monthly_rent
from characters c
full join apartments a
    on c.character_id = a.current_tenant_id;
*/


-- additional examples: employee/department context

-- create employee/department tables (commented out)
/*
create table departments (
    department_id int primary key,
    department_name varchar(100) not null,
    location varchar(100)
);

create table employees (
    employee_id int primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    department_id int,
    salary decimal(10, 2),
    hire_date date
);

-- full join example for employee/department context
select
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_id,
    d.department_name,
    d.location
from employees e
left join departments d
    on e.department_id = d.department_id

union

select
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_id,
    d.department_name,
    d.location
from employees e
right join departments d
    on e.department_id = d.department_id;
*/


-- full join filtering examples

-- finding only characters without apartments
select
    c.character_id,
    c.first_name,
    c.last_name
from characters c
left join apartments a
    on c.character_id = a.current_tenant_id
where a.apartment_id is null;


-- finding only apartments without tenants
select
    a.apartment_id,
    a.building_address,
    a.apartment_number
from apartments a
left join characters c
    on a.current_tenant_id = c.character_id
where c.character_id is null;


-- using the simulated full join result to find both unmatched cases
select
    c.character_id,
    c.first_name,
    c.last_name,
    a.apartment_id,
    a.building_address,
    a.apartment_number
from characters c
left join apartments a
    on c.character_id = a.current_tenant_id
where a.apartment_id is null

union

select
    c.character_id,
    c.first_name,
    c.last_name,
    a.apartment_id,
    a.building_address,
    a.apartment_number
from characters c
right join apartments a
    on c.character_id = a.current_tenant_id
where c.character_id is null;


-- key takeaway:
-- mysql does not have a native full join.
-- use left join union right join to simulate a full join.
-- full join is useful when you need unmatched records from both sides.