-- self join in sql
-- this script demonstrates how to use self joins to query hierarchical
-- and relational data within the same table, using an employee management system example.

-- create and use database
create database self_join_db;
use self_join_db;

-- create employees table with manager_id referencing the same table
-- manager_id stores the employee_id of the employee's manager
-- this creates a hierarchical relationship within the same table
create table employees (
    employee_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    job_title varchar(100),
    salary decimal(10, 2),
    department varchar(50),
    manager_id int,
    hire_date date
);

-- insert sample employee data with hierarchical management structure
insert into employees values
(1, 'James', 'Smith', 'CEO', 150000.00, 'Executive', null, '2010-01-15'),
(2, 'Sarah', 'Johnson', 'CTO', 140000.00, 'Technology', 1, '2011-03-10'),
(3, 'Michael', 'Williams', 'CFO', 140000.00, 'Finance', 1, '2012-07-22'),
(4, 'Jessica', 'Brown', 'HR Director', 110000.00, 'Human Resources', 1, '2013-05-18'),
(5, 'David', 'Miller', 'Senior Developer', 95000.00, 'Technology', 2, '2014-11-05'),
(6, 'Emily', 'Davis', 'Developer', 80000.00, 'Technology', 5, '2016-08-12'),
(7, 'Robert', 'Wilson', 'Junior Developer', 65000.00, 'Technology', 5, '2019-02-28'),
(8, 'Jennifer', 'Taylor', 'Accountant', 75000.00, 'Finance', 3, '2015-09-17'),
(9, 'Thomas', 'Anderson', 'Accountant', 72000.00, 'Finance', 3, '2017-06-24'),
(10, 'Lisa', 'Martinez', 'HR Specialist', 68000.00, 'Human Resources', 4, '2018-04-30');

-- example 1: basic self join to show employees with their managers
-- the employees table is used twice with different aliases:
-- emp represents the employee and mgr represents the manager
select *
from employees emp
join employees mgr
    on emp.manager_id = mgr.employee_id;

-- example 2: self join with left join to include all employees
-- left join also includes employees who do not have a manager, such as the ceo
-- manager columns will contain null for employees without a matching manager
select *
from employees emp
left join employees mgr
    on emp.manager_id = mgr.employee_id;

-- example 3: group employees by department
-- this is not a self join, but is useful for understanding the employee data
select
    department,
    count(*) as employee_count,
    group_concat(
        concat(first_name, ' ', last_name)
        order by employee_id
        separator ', '
    ) as employees
from employees
group by department;

-- example 4: find employees who work in the same department
-- self join is used to compare employees within the same table

-- this query matches each employee with itself because both employee ids are equal
-- it is included only to demonstrate why a self-match is usually not desired
select *
from employees e1
join employees e2
    on e1.department = e2.department
    and e1.employee_id = e2.employee_id;

-- this query finds different employees in the same department
-- however, each pair appears twice because e1/e2 and e2/e1 are both returned
select *
from employees e1
join employees e2
    on e1.department = e2.department
    and e1.employee_id != e2.employee_id;

-- using < ensures that each employee pair appears only once
-- it also prevents an employee from being matched with itself
select *
from employees e1
join employees e2
    on e1.department = e2.department
    and e1.employee_id < e2.employee_id;

-- example 5: find employees who make less than their managers
-- self join allows us to compare the employee's salary with the manager's salary
select *
from employees emp
join employees mgr
    on emp.manager_id = mgr.employee_id
where emp.salary < mgr.salary;

-- example 6: calculate average salary difference between employees and managers by department
-- this demonstrates how aggregate functions can be combined with self joins
select
    emp.department,
    count(emp.employee_id) as num_employees,
    round(avg(mgr.salary), 2) as avg_manager_salary,
    round(avg(emp.salary), 2) as avg_employee_salary,
    round(avg(mgr.salary) - avg(emp.salary), 2) as avg_salary_difference
from employees emp
join employees mgr
    on emp.manager_id = mgr.employee_id
group by emp.department
order by avg_salary_difference desc;

-- important notes for self joins:
-- 1. always use different aliases for each instance of the table.
-- 2. self joins are useful when rows in the same table are related to each other.
-- 3. when looking for unique pairs, use conditions like a.id < b.id
--    to avoid matching rows with themselves and avoid duplicate pairs.
-- 4. use left join when you need to include records without a matching row,
--    such as employees who do not have a manager.
-- 5. self joins can be resource-intensive on large tables, so indexes on
--    columns used in join conditions can improve performance.