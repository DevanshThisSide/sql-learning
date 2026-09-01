-- sql fundamentals

-- database
create database if not exists collegedb;
show databases;
show create database collegedb;
use collegedb;
select database();


-- create table
create table if not exists student (
    student_id int primary key,
    name varchar(50) not null,
    age int,
    course varchar(50)
);

show tables;
show columns from student;
desc student;
show create table student;


-- data types
create table datatype_demo (
    id int,
    name varchar(50),
    description text,
    birth_date date,
    login_time time,
    created_at datetime,
    updated_at timestamp,
    fees decimal(10,2),
    rating float,
    is_active boolean
);

desc datatype_demo;


-- insert basic datatype values
insert into datatype_demo
values (
    1,
    'aman',
    'student record',
    '2004-05-15',
    '10:30:00',
    '2026-09-01 10:30:00',
    current_timestamp,
    45000.50,
    4.5,
    true
);

select * from datatype_demo;


-- null
create table null_demo (
    id int,
    name varchar(50),
    phone varchar(15)
);

insert into null_demo values
(1, 'aman', null),
(2, 'priya', '9876543210');

select * from null_demo;


-- primary key
create table primary_key_demo (
    student_id int primary key,
    name varchar(50)
);

insert into primary_key_demo values
(1, 'aman'),
(2, 'priya');

select * from primary_key_demo;


-- alter table
alter table student add email varchar(100);

alter table student add phone varchar(15);

alter table student modify name varchar(100);

alter table student rename column phone to mobile;

alter table student drop column mobile;

desc student;


-- rename table
create table rename_demo (
    id int,
    name varchar(50)
);

rename table rename_demo to renamed_demo;

show tables;


-- truncate
create table truncate_demo (
    id int,
    name varchar(50)
);

insert into truncate_demo values
(1, 'aman'),
(2, 'priya');

select * from truncate_demo;

truncate table truncate_demo;

select * from truncate_demo;


-- drop
drop table primary_key_demo;
drop table null_demo;
drop table datatype_demo;
drop table truncate_demo;
drop table renamed_demo;


-- drop database
-- drop database if exists collegedb;