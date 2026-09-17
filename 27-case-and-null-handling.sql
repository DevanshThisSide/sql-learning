-- sql case statements and null handling

-- case is used to return different values based on conditions.

-- coalesce() returns the first non-null value while evaluating expressions left to right.
-- example : 
/*
SELECT 
    first_name,
    COALESCE(nickname, middle_name, 'No Nickname or Middle Name') AS display_name
FROM Employees;

If nickname exists, it uses it. If nickname is NULL, it looks at middle_name. If both are NULL, it falls back to the string 'No Nickname or Middle Name'.
*/

-- nullif() returns null when two expressions are equal.
-- example : 
/*
SELECT 
    product_name, 
    total_revenue / NULLIF(units_sold, 0) AS revenue_per_unit
FROM Sales;

If units_sold is 5, NULLIF(5, 0) returns 5. The calculation works normally. If units_sold is 0, NULLIF(0, 0) returns NULL. In SQL, any number divided by NULL safely results in NULL, avoiding a crash.
*/

-- case is useful for conditional logic inside sql queries.
-- coalesce() and nullif() are useful for handling missing or special values.

create database case_null_db;

use case_null_db;

-- employees table for practicing case statements and null handling
create table employees (
    employee_id int primary key,
    first_name varchar(50),
    salary decimal(10, 2),
    reports_to varchar(50),
    department varchar(50),
    level varchar(20),
    salary_status varchar(20)
);

insert into employees
    (employee_id, first_name, salary, reports_to, department, level, salary_status)
values
    (101, 'devansh', 30000, 'rahul', 'development', null, null),
    (102, 'aman', 18000, 'rahul', 'development', null, null),
    (103, 'priya', 9000, 'neha', 'hr', null, null),
    (104, 'rohit', 25000, 'vikas', 'sales', null, null),
    (105, 'varun', 12000, null, 'testing', null, null),
    (106, 'dheeraj', 0, null, 'internship', null, null),
    (107, 'neha', 40000, null, 'management', null, null),
    (108, 'rahul', 35000, null, 'management', null, null);

select *
from employees;

-- case statements

-- basic case statement
-- case checks conditions from top to bottom.
-- when the first true condition is found, its result is returned.
-- if no condition is true, the else result is returned.

select
    salary,
    case
        when salary > 25000 then 'high'
        when salary > 10000 then 'medium'
        else 'low'
    end as salary_level
from employees;

-- case conditions are checked in order.
-- therefore, more specific or higher-priority conditions
-- should normally be placed before broader conditions.

select
    first_name,
    salary,
    case
        when salary >= 30000 then 'senior salary'
        when salary >= 15000 then 'average salary'
        else 'low salary'
    end as salary_category
from employees;

-- case can also be used with other columns and conditions.

select
    first_name,
    department,
    salary,
    case
        when department = 'development' and salary > 25000 then 'senior developer'
        when department = 'development' then 'developer'
        when department = 'management' then 'manager'
        else 'other employee'
    end as role_category
from employees;

-- case with update

-- case can be used inside update to store a calculated category.
-- here, the level column is populated according to salary.

update employees
set level = case
    when salary > 25000 then 'high'
    when salary > 10000 then 'medium'
    else 'low'
end where employee_id > 100;

select
    employee_id,
    first_name,
    salary,
    level
from employees;

-- case with null values

-- reports_to contains the name of the employee's manager.
-- null means that the employee does not have a manager.

select
    salary,
    case
        when reports_to is null then 'no manager'
        else reports_to
    end as reporting_manager,
    level as salary_level
from employees;

-- coalesce()

-- coalesce() returns the first non-null expression.
-- syntax:
-- coalesce(value1, value2, value3, ...)
--
-- if value1 is not null, value1 is returned.
-- otherwise, mysql checks value2, then value3, and so on.

select
    first_name,
    coalesce(reports_to, 'company owner') as reporting_manager
from employees;

-- multiple fallback values can be provided.
-- mysql returns the first value that is not null.

select
    first_name,
    coalesce(reports_to, department, 'company owner') as position -- "Give me reports_to if available; otherwise give me department; otherwise give me 'company owner'."
from employees;

-- coalesce() can also be used with numeric columns.

select
    first_name,
    coalesce(salary, 0) as salary
from employees;


-- important:
-- coalesce(reports_to, null, 'isadmin') is equivalent to
-- coalesce(reports_to, 'isadmin')
-- because null can never be the first non-null value.

select
    first_name,
    coalesce(reports_to, null, 'isadmin') as reporting_manager
from employees;


-- nullif()

-- nullif() compares two expressions.
-- if they are equal, it returns null.
-- otherwise, it returns the first expression.
-- syntax:
-- nullif(expression1, expression2)

select
    first_name,
    salary,
    nullif(salary, 0) as salary_without_zero
from employees;


-- here:
-- if salary = 0  -> nullif() returns null
-- if salary != 0 -> nullif() returns the actual salary

-- coalesce() + nullif()

-- nullif() can first convert a special value such as 0 into null.
-- coalesce() can then replace that null with a meaningful value.

select
    first_name,
    coalesce(nullif(salary, 0), 'no salary') as salary
from employees;


-- for a text status, it is better to use a separate expression
-- instead of mixing numeric salary values with text.

select
    first_name,
    case
        when nullif(salary, 0) is null then 'is intern'
        else 'has salary'
    end as salary_status
from employees;


-- the same logic can be stored in the salary_status column.

update employees
set salary_status = case
    when nullif(salary, 0) is null then 'is intern'
    else 'has salary'
end where employee_id > 100;

select
    first_name,
    salary,
    salary_status
from employees;

-- case vs coalesce

-- case is useful when the result depends on conditions.

-- coalesce() is mainly used to replace null values with
-- the first available non-null value.

select
    first_name,
    case
        when reports_to is null then 'no manager'
        else reports_to
    end as using_case,
    coalesce(reports_to, 'no manager') as using_coalesce
from employees;


-- both expressions above produce the same logical result.
-- coalesce() is shorter when the only requirement is
-- replacing a null value.


-- case with order by

-- case can create custom sorting priorities.

select
    first_name,
    department,
    salary
from employees
order by case
    when department = 'management' then 1
    when department = 'development' then 2
    when department = 'testing' then 3
    else 4
end;

-- case with aggregate functions

-- case can be combined with aggregate functions
-- to count rows conditionally.

select
    count(*) as total_employees,
    sum(case when salary > 25000 then 1 else 0 end) as high_salary_employees,
    sum(case when salary between 10001 and 25000 then 1 else 0 end) as medium_salary_employees,
    sum(case when salary <= 10000 then 1 else 0 end) as low_salary_employees
from employees;


-- important points

-- 1. case checks when conditions from top to bottom.
-- 2. the first matching when condition is returned.
-- 3. else handles cases where no when condition matches.
-- 4. else is optional; without it, case returns null when no condition matches.
-- 5. coalesce() returns the first non-null value.
-- 6. nullif(a, b) returns null when a = b; otherwise it returns a.
-- 7. is null and is not null should be used to check for null values.
-- 8. null is not equal to 0, an empty string, or another null.
-- 9. case can be used in select, update, order by, group by, and other sql expressions.
-- 10. case is useful for creating categories and conditional calculations.
-- 11. coalesce() is useful for replacing missing values with fallback values.
-- 12. nullif() is useful for converting unwanted/special values into null.
-- 13. coalesce() and nullif() are often combined for practical null handling.


-- final view of the practice table

select
    employee_id,
    first_name,
    salary,
    reports_to,
    department,
    level,
    salary_status
from employees
order by employee_id;