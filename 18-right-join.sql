-- create and use the gokuldham society database
create database gokuldham_society;
use gokuldham_society;


-- create apartments table to store apartment information
create table apartments (
    apartment_id int primary key,
    apartment_number varchar(10) not null,
    floor_number int not null,
    wing_name char(1) not null
);


-- create residents table with foreign key to apartments
create table residents (
    resident_id int primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    occupation varchar(100),
    apartment_id int,
    foreign key (apartment_id) references apartments(apartment_id)
);


-- insert sample apartment data
insert into apartments (apartment_id, apartment_number, floor_number, wing_name)
values
    (1, '101', 1, 'A'),
    (2, '102', 1, 'A'),
    (3, '201', 2, 'A'),
    (4, '202', 2, 'A'),
    (5, '301', 3, 'A'),
    (6, '302', 3, 'A'),
    (7, '401', 4, 'A'),
    (8, '402', 4, 'A'),
    (9, '501', 5, 'B'),
    (10, '502', 5, 'B');


-- insert sample resident data
insert into residents (resident_id, first_name, last_name, occupation, apartment_id)
values
    (1, 'Jethalal', 'Gada', 'Electronics Shop Owner', 1),
    (2, 'Daya', 'Gada', 'Housewife', 1),
    (3, 'Taarak', 'Mehta', 'Writer', 2),
    (4, 'Anjali', 'Mehta', 'Teacher', 2),
    (5, 'Popatlal', 'Pandey', 'Reporter', 3),
    (6, 'Bhide', 'Aatmaram', 'School Teacher', 4),
    (7, 'Madhavi', 'Bhide', 'Housewife', 4),
    (8, 'Dr', 'Hathi', 'Doctor', 5),
    (9, 'Komal', 'Hathi', 'Housewife', 5);

-- note:
-- some apartments have been intentionally left without residents
-- so that left join and right join behavior with null values can be observed.


-- basic select queries to view table contents
select * from residents;
select * from apartments;


-- demo: left join to see all apartments and their residents (if any)
select
    a.apartment_number,
    a.floor_number,
    a.wing_name,
    r.first_name,
    r.last_name
from apartments a
left join residents r
    on r.apartment_id = a.apartment_id;


-- demo: right join to see all apartments and their residents (if any)
select
    a.apartment_number,
    a.floor_number,
    a.wing_name,
    r.first_name,
    r.last_name
from residents r
right join apartments a
    on r.apartment_id = a.apartment_id;


-- note:
-- the left join and right join queries above produce the same logical result
-- because both queries preserve all rows from the apartments table.
-- in the first query, apartments is the left table.
-- in the second query, apartments is the right table.


-- create maintenance_requests table with foreign key to apartments
create table maintenance_requests (
    request_id int primary key,
    apartment_id int,
    request_date date not null,
    description text not null,
    status enum('Pending', 'In Progress', 'Completed') default 'Pending',
    foreign key (apartment_id) references apartments(apartment_id)
);


-- insert sample maintenance request data
insert into maintenance_requests (request_id, apartment_id, request_date, description, status)
values
    (1, 1, '2023-01-15', 'Leaky faucet in kitchen', 'Completed'),
    (2, 1, '2023-02-20', 'Broken window handle', 'Completed'),
    (3, 2, '2023-03-10', 'Electricity fluctuation', 'In Progress'),
    (4, 4, '2023-03-15', 'Ceiling fan not working', 'Pending'),
    (5, 5, '2023-04-01', 'Bathroom door lock broken', 'Completed'),
    (6, 8, '2023-04-10', 'Water seepage in wall', 'In Progress');


-- exercise 1: finding unoccupied apartments
select
    a.apartment_id,
    a.apartment_number,
    a.floor_number,
    a.wing_name
from residents r
right join apartments a
    on a.apartment_id = r.apartment_id
where r.resident_id is null;


-- note:
-- right join keeps all apartments, including those without residents.
-- after the join, apartments without a matching resident have null values
-- in the residents columns, which allows is null to identify unoccupied apartments.


-- exercise 2: count the number of residents per apartment
select
    a.apartment_id,
    a.apartment_number,
    count(r.resident_id) as resident_count
from residents r
right join apartments a
    on r.apartment_id = a.apartment_id
group by a.apartment_id;


-- note:
-- count(r.resident_id) counts only non-null resident ids.
-- therefore, apartments with no residents correctly receive a count of 0.


-- exercise 3: list all apartments with their residents and maintenance request status
select
    a.wing_name,
    a.apartment_number,
    r.first_name,
    r.last_name,
    mr.description as request_description,
    mr.status as request_status
from maintenance_requests mr
right join apartments a
    on mr.apartment_id = a.apartment_id
left join residents r
    on a.apartment_id = r.apartment_id;


-- exercise 4: find the floor with the most unoccupied apartments
select
    a.floor_number,
    a.wing_name,
    count(*) as unoccupied_count
from residents r
right join apartments a
    on r.apartment_id = a.apartment_id
where r.resident_id is null
group by a.floor_number, a.wing_name
order by unoccupied_count desc
limit 1;


-- note:
-- the query first keeps all apartments using right join,
-- filters only apartments without residents,
-- groups them by floor and wing,
-- then returns the floor with the highest number of unoccupied apartments.


-- exercise 5: list all apartments along with the total number of maintenance requests
select
    a.apartment_id,
    a.apartment_number,
    a.floor_number,
    a.wing_name,
    count(mr.request_id) as maintenance_request_count
from apartments a
left join maintenance_requests mr
    on a.apartment_id = mr.apartment_id
group by a.apartment_id;


-- note:
-- left join ensures that even apartments with no maintenance requests are included.
-- count(mr.request_id) returns 0 for apartments without matching requests.