-- user-defined functions in mysql

-- 1. create database

drop database if exists sample;

create database sample;

use sample;

-- 2. create customers table

create table customers (
    customerid int primary key auto_increment,
    customername varchar(50) not null,
    age int,
    custemail varchar(100),
    dob date
);

-- 3. insert sample customer data

insert into customers (customername, age, custemail, dob)
values
('devansh', 20, 'devansh@gmail.com', '2005-05-15'),
('aman', 22, 'aman@gmail.com', '2003-08-20'),
('priya', 17, 'priya@gmail.com', '2008-02-10'),
('rohit', 61, 'rohit@gmail.com', '1965-01-25'),
('varun', 25, 'varunexample.com', '2001-11-12'),
('dheeraj', 20, 'dheeraj@gmail.com', '2005-07-18');

-- check customer data

select *
from customers;

-- 4. create employees table

create table employees (
    id int primary key auto_increment,
    name varchar(50) not null,
    salary decimal(10,2) not null
);

-- 5. insert sample employee data

insert into employees (name, salary)
values
('rahul', 25000),
('neha', 35000),
('amit', 50000),
('simran', 65000),
('karan', 80000),
('pooja', 95000);

-- check employee data

select *
from employees;

-- 6. what is a user-defined function?

-- a user-defined function is a function created by the
-- developer to perform reusable logic.

-- a function can:
-- 1. accept parameters
-- 2. perform calculations or logic
-- 3. return a single value
-- 4. be used inside select, where, order by, etc.

-- important:
-- mysql stored functions return one scalar value.
-- they cannot directly return a table or multiple rows.

-- 7. delimiter

-- mysql normally uses ";" to identify the end of a statement.
-- functions can contain multiple statements ending with ";"
-- so the delimiter is temporarily changed.

-- delimiter $$ changes the statement delimiter to "$$".
-- delimiter ; changes it back to the normal delimiter.

-- 8. scalar function

-- a scalar function returns one value.
-- example:
-- check whether a person is a minor or adult.

drop function if exists minororadult;

delimiter $$

create function minororadult(person_age int)
returns varchar(10)
deterministic
begin
    return case
        when person_age is null then 'unknown'
        when person_age < 18 then 'minor'
        else 'adult'
    end;
end $$

delimiter ;

-- call the function directly

select minororadult(19);

-- use the function with table data

select
    customername,
    age,
    minororadult(age) as status
from customers;

-- 9. scalar function with multiple parameters

-- a function can accept more than one parameter.

drop function if exists add_num;

delimiter $$

create function add_num(a int, b int)
returns int
deterministic
begin
    return a + b;
end $$

delimiter ;

select add_num(10, 112) as result;

-- 10. function using if

drop function if exists get_discount;

delimiter $$

create function get_discount(person_age int)
returns int
deterministic
begin
    if person_age is null then
        return 0;
    elseif person_age < 18 then
        return 20;
    elseif person_age >= 60 then
        return 30;
    else
        return 0;
    end if;
end $$

delimiter ;

-- test the function

select get_discount(16) as discount_percentage;

-- use it with table data

select
    customername,
    age,
    get_discount(age) as discount_percentage
from customers;


-- 11. function using case

drop function if exists age_category;

delimiter $$

create function age_category(person_age int)
returns varchar(20)
deterministic
begin
    return case
        when person_age is null then 'unknown'
        when person_age < 18 then 'minor'
        when person_age < 60 then 'adult'
        else 'senior citizen'
    end;
end $$

delimiter ;

-- use the function

select
    customername,
    age,
    age_category(age) as category
from customers;

-- 12. function using date values

-- calculate age from date of birth.

-- this function uses curdate(), so its result can change
-- as the current date changes.
-- therefore it is not marked as deterministic.

drop function if exists calculate_age_from_dob;

delimiter $$

create function calculate_age_from_dob(person_dob date)
returns int
no sql
begin
    return timestampdiff(year, person_dob, curdate());
end $$

delimiter ;

-- call the function

select calculate_age_from_dob('2005-08-15') as age;

-- use the function with table data

select
    customername,
    dob,
    calculate_age_from_dob(dob) as age
from customers;


-- 13. function using string logic

-- simple email pattern check.
-- this is not complete email validation.

drop function if exists is_valid_email;

delimiter $$

create function is_valid_email(email varchar(255))
returns boolean
deterministic
begin
    return case
        when email like '%@%.%' then true
        else false
    end;
end $$

delimiter ;

-- test email validation

select
    customername,
    custemail,
    is_valid_email(custemail) as valid_email
from customers;


-- 14. function using local variables

-- declare is used to create local variables.

drop function if exists mask_email;

delimiter $$

create function mask_email(email varchar(255))
returns varchar(255)
deterministic
begin
    declare at_pos int;
    declare name_part varchar(255);
    declare domain_part varchar(255);
    declare masked_name varchar(255);

    set at_pos = locate('@', email);

    if at_pos = 0 then
        return email;
    end if;

    set name_part = left(email, at_pos - 1);
    set domain_part = substring(email, at_pos);

    if length(name_part) <= 2 then
        set masked_name = concat(left(name_part, 1), '*');
    else
        set masked_name = concat(
            left(name_part, 1),
            repeat('*', greatest(length(name_part) - 2, 1)),
            right(name_part, 1)
        );
    end if;

    return concat(masked_name, domain_part);
end $$

delimiter ;

-- use the function

select
    customername,
    custemail,
    mask_email(custemail) as masked_email
from customers;


-- 15. function reading data from a table

-- a stored function can read data from a table.

-- reads sql data indicates that the function reads
-- database data.

drop function if exists demoavg;

delimiter $$

create function demoavg()
returns decimal(10,2)
reads sql data
begin
    declare result decimal(10,2);

    select avg(salary)
    into result
    from employees;

    return result;
end $$

delimiter ;

-- call the function

select demoavg() as average_salary;

-- 16. select ... into

-- select ... into stores a query result inside
-- a local variable.

drop function if exists highest_salary;

delimiter $$

create function highest_salary()
returns decimal(10,2)
reads sql data
begin
    declare result decimal(10,2);

    select max(salary)
    into result
    from employees;

    return result;
end $$

delimiter ;

select highest_salary() as highest_salary;

-- 17. function using a table column as input

-- a scalar function can receive a column value from
-- each row.

drop function if exists salary_category;

delimiter $$

create function salary_category(salary_amount decimal(10,2))
returns varchar(20)
deterministic
begin
    return case
        when salary_amount is null then 'unknown'
        when salary_amount < 30000 then 'low'
        when salary_amount < 70000 then 'medium'
        else 'high'
    end;
end $$

delimiter ;

-- apply the function to every employee

select
    id,
    name,
    salary,
    salary_category(salary) as salary_category
from employees;


-- 18. deterministic

-- deterministic means the function is expected to return
-- the same result for the same input values.
-- example:
-- add_num(10, 20) always returns 30.

select add_num(10, 20) sumof_10_20;

-- functions depending only on their input values can
-- commonly be marked as deterministic.

-- 19. reads sql data

-- reads sql data indicates that the function reads
-- data from tables.

-- demoavg() and highest_salary() use reads sql data
-- because they read values from employees.

-- 20. scalar function

-- mysql stored functions return a single scalar value.

select minororadult(19);

select add_num(10, 20);

select demoavg();

select highest_salary();

-- 21. table-valued function concept

-- some database systems support table-valued functions
-- that directly return multiple rows and columns.

-- mysql does not support table-valued functions.

-- for reusable table-shaped output in mysql,
-- a view is a suitable alternative.

-- 22. view as table-valued alternative

create or replace view employee_salary_details as
select
    id,
    name,
    salary,
    salary_category(salary) as salary_category
from employees;

-- query the view

select *
from employee_salary_details;

-- a view returns multiple rows and columns,
-- but it is not a user-defined function.

-- 23. derived table as table-shaped alternative

-- a derived table is a subquery used inside from.

select *
from (
    select
        id,
        name,
        salary,
        salary_category(salary) as salary_category
    from employees
    where salary > 50000
) as high_salary_employees;

-- a derived table can return multiple rows and columns.

-- 24. multi-row result using stored procedure

-- mysql functions cannot directly return multiple rows.

-- a stored procedure can return a result set containing
-- multiple rows and columns.

drop procedure if exists get_high_salary_employees;

delimiter $$

create procedure get_high_salary_employees()
begin
    select
        id,
        name,
        salary
    from employees
    where salary > 50000;
end $$

delimiter ;

-- call the procedure

call get_high_salary_employees();

-- 25. function vs view vs procedure

-- function:
-- returns a single value.

select minororadult(19);

-- view:
-- returns reusable table-shaped data.

select *
from employee_salary_details;

-- procedure:
-- can return multiple rows as a result set.

call get_high_salary_employees();

-- 26. using functions inside sql queries

-- function inside select

select
    customername,
    age,
    age_category(age) as category
from customers;

-- function inside where

select *
from customers
where minororadult(age) = 'adult';

-- function inside order by

select
    customername,
    age
from customers
order by age_category(age);

-- function inside a calculation

select
    name,
    salary,
    salary * 12 as annual_salary
from employees;

-- 27. practical function - days between dates

drop function if exists days_between_dates;

delimiter $$

create function days_between_dates(
    start_date date,
    end_date date
)
returns int
deterministic
begin
    return datediff(end_date, start_date);
end $$

delimiter ;

select days_between_dates(
    '2024-01-01',
    '2024-12-31'
) as days_diff;

-- 28. practical function - monthly installment

drop function if exists monthly_installment;

delimiter $$

create function monthly_installment(
    principal decimal(10,2),
    annual_rate decimal(5,2),
    months int
)
returns decimal(10,2)
deterministic
begin
    declare r decimal(10,8);
    declare emi decimal(10,2);

    if months <= 0 then
        return null;
    end if;

    if annual_rate = 0 then
        return round(principal / months, 2);
    end if;

    set r = annual_rate / (12 * 100);

    set emi =
        principal * r * pow(1 + r, months)
        / (pow(1 + r, months) - 1);

    return round(emi, 2);
end $$

delimiter ;

select monthly_installment(
    100000,
    7.5,
    60
) as monthly_emi;

-- 29. show user-defined functions

-- display functions available in the current database.

show function status
where db = database();

-- 30. show function definition

show create function minororadult;

-- show create function displays the sql definition
-- of the stored function.

-- 31. alter function

-- alter function can modify certain function characteristics,
-- but it cannot change the parameter list or return type.

-- example syntax:

/*
alter function minororadult
comment 'checks whether a person is a minor or adult';
*/

-- keep this example commented so that the learning file
-- does not modify the function accidentally.

-- 32. drop function

-- removes a stored function.

drop function if exists add_num;

-- 33. function return types summary

-- scalar:
-- mysql supports this directly.
-- example:
select minororadult(19);

-- table-valued:
-- mysql does not support a function directly returning
-- a table.
-- use a view or derived table instead.
select *
from employee_salary_details;

-- multi-row:
-- mysql stored functions cannot directly return
-- multiple rows.
-- use a stored procedure for a result set.
call get_high_salary_employees();

-- 34. final practice queries

-- customer age and category

select
    customername,
    age,
    minororadult(age) as status,
    age_category(age) as category
from customers;

-- customer email validation

select
    customername,
    custemail,
    is_valid_email(custemail) as valid_email,
    mask_email(custemail) as masked_email
from customers;

-- employee salary categories

select
    name,
    salary,
    salary_category(salary) as category
from employees;

-- employee salary details

select
    name,
    salary,
    salary_category(salary) as category
from employees
order by salary desc;