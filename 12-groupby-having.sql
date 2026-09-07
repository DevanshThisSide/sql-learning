-- group by & having in sql

-- this file demonstrates various examples of using group by in sql queries
-- for data summarization and aggregation operations.

-- database setup
create database db_for_group_by;
use db_for_group_by;

-- table creation
create table employees (
    id int auto_increment primary key,
    name varchar(50),
    department varchar(50),
    salary decimal(10,2),
    joining_date date
);

-- initial data insertion
insert into employees (name, department, salary, joining_date) values
    ('alice', 'hr', 50000, '2020-06-15'),
    ('bob', 'hr', 55000, '2019-08-20'),
    ('charlie', 'it', 70000, '2018-03-25'),
    ('david', 'it', 72000, '2017-07-10'),
    ('eve', 'it', 73000, '2021-02-15'),
    ('frank', 'finance', 60000, '2020-11-05'),
    ('grace', 'finance', 65000, '2019-05-30'),
    ('hannah', 'finance', 62000, '2021-01-12');

-- additional data insertion
insert into employees (name, department, salary, joining_date) values
    ('tim', 'hr', 65000, '2019-05-30'),
    ('tom', 'it', 62000, '2021-01-12');

-- view all employee data
select * from employees;

-- example 1: count employees in each department
select department,
       count(*) as employee_count
from employees
group by department;

-- example 2: get the average salary per department
select department,
       round(avg(salary), 2) as average_salary
from employees
group by department;

-- example 3: get the highest and lowest salary per department
select department,
       min(salary) as lowest_salary,
       max(salary) as highest_salary
from employees
group by department;

-- example 4: count employees per department and joining year
select department,
       year(joining_date) as joining_year,
       count(*) as employee_count
from employees
group by joining_year, department;

-- group for the combinations of department and joining_year

-- example 5: order departments by the highest average salary
select department,
       avg(salary) as avg_salary
from employees
group by department
order by avg_salary desc;

-- example 6: group by calculated salary range
select
    case
        when salary < 60000 then 'low salary'
        when salary between 60000 and 70000 then 'medium salary'
        else 'high salary'
    end as salary_range,
    count(*) as employee_count
from employees
group by salary_range;

-- example 7: find department with the maximum number of employees
select department,
       count(*) as total_employees
from employees
group by department
order by total_employees desc
limit 1;

-- example 8: find departments with more than 2 employees (with conditions)
select
    department,
    avg(salary) as average_salary,
    count(*) as total_employees
from employees
where joining_date > '2017-07-10'
group by department
having total_employees > 2
   and average_salary > 55000;