-- alter, insert and drop practice

-- database
create database if not exists employeedb;
show databases;
use employeedb;

-- create departments table
create table departments (
    department_id int primary key auto_increment,
    department_name varchar(100) not null,
    location varchar(100),
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp on update current_timestamp
);

-- create employees table
create table employees (
    employee_id int primary key auto_increment,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    hire_date date default (current_date()),
    email varchar(100) unique,
    phone_num varchar(100) unique,
    salary decimal(10,2) check (salary > 0.0),
    employment_status enum('active','on leave','terminated') default 'active',
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp on update current_timestamp
);

-- insert departments
insert into departments (department_name, location) values
('it', 'building a'),
('it', 'building b'),
('hr', 'building c');

-- insert employees
insert into employees
(first_name, last_name, hire_date, email, phone_num, salary, employment_status)
values
('devansh', 'bhatt', '2026-08-30', 'work.devansh23@yahoo.com', '+91-9335399674', 75000.00, 'on leave');

insert into employees
(first_name, last_name, email, phone_num, salary)
values
('aman', 'gupta', 'amangupta223@hotmail.com', '+91-9775399624', 65000.00);

insert into employees
(first_name, last_name, email, phone_num, salary)
values
('subhi', 'singh', 'subhisingh22@gmail.com', '+91-8756836916', 69000.00);

-- view data
select * from employees;
select * from departments;

-- alter table: add columns
alter table employees add column description text;
alter table employees add column test int;

-- alter table: modify column
alter table employees modify phone_num varchar(150) not null;

-- alter table: rename column
alter table employees change phone_num phone_number varchar(100);
alter table employees rename column phone_number to contact_number;

-- alter table: add column at a specific position
alter table employees add column emergency_contact varchar(100) after contact_number;

-- alter table: add check constraint
alter table employees
add check (emergency_contact regexp '^\+[1-9]\d{0,3}-\d{4,14}$');

-- add department relationship
alter table employees add column department_id int;

update employees set department_id = 1 where employee_id = 1;
update employees set department_id = 2 where employee_id = 2;
update employees set department_id = 3 where employee_id = 3;

alter table employees modify department_id int not null;

alter table employees
add foreign key (department_id) references departments(department_id);

-- update data after altering the table
update employees
set description = 'admin'
where employee_id = 1;

-- view altered table
desc employees;
select * from employees;

-- alter table: drop columns
alter table employees drop column test;
alter table employees drop column emergency_contact;

-- view table after dropping columns
desc employees;

-- drop table practice
create table drop_demo (
    id int,
    name varchar(50)
);

insert into drop_demo values
(1, 'demo'),
(2, 'test');

select * from drop_demo;

drop table if exists drop_demo;

show tables;

-- final data
select * from employees;
select * from departments;
