-- sql inner join
-- an inner join returns only the rows where there is a match in both tables
-- based on the specified join condition.
-- if there is no match, the rows from both tables are excluded from the result set.
-- join equiavalent to inner join


-- create database
create database db_inner_join;
use db_inner_join;


-- create authors table
create table authors (
    author_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    birth_year int
);


-- create books table
create table books (
    book_id int primary key,
    title varchar(100),
    author_id int,
    publication_year int,
    price decimal(6, 2)
);


-- insert data into authors table
insert into authors (author_id, first_name, last_name, birth_year)
values
    (1, 'Jane', 'Austen', 1775),
    (2, 'George', 'Orwell', 1903),
    (3, 'Ernest', 'Hemingway', 1899),
    (4, 'Agatha', 'Christie', 1890),
    (5, 'J.K.', 'Rowling', 1965);


-- insert data into books table
insert into books (book_id, title, author_id, publication_year, price)
values
    (101, 'Pride and Prejudice', 1, 1813, 12.99),
    (102, '1984', 2, 1949, 14.50),
    (103, 'Animal Farm', 2, 1945, 11.75),
    (104, 'The Old Man and the Sea', 3, 1952, 10.99),
    (105, 'Murder on the Orient Express', 4, 1934, 13.25),
    (106, 'Death on the Nile', 4, 1937, 12.50),
    (107, 'Emma', 1, 1815, 11.99),
    (108, 'For Whom the Bell Tolls', 3, 1940, 15.75);


-- display table contents
select * from authors;
select * from books;


-- basic inner join syntax:
/*
select columns
from table1
join_type table2
on table1.column = table2.column;
*/

select *
from books b
join authors a
    on b.author_id = a.author_id;


-- retrieve books with their author's information with conditions and ordering
select b.title, a.first_name, a.last_name, a.birth_year
from books as b
inner join authors as a
    on a.author_id = b.author_id
where b.publication_year > 1940
order by birth_year;


-- count how many books each author has written
select concat(a.first_name, ' ', a.last_name) as author_name,
       count(*) as book_count
from books b
join authors a
    on b.author_id = a.author_id
group by a.author_id;


-- create categories table for many-to-many relationship example
create table categories (
    category_id int primary key,
    category_name varchar(50)
);

show tables;


-- insert category data
insert into categories (category_id, category_name)
values
    (1, 'Fiction'),
    (2, 'Classic'),
    (3, 'Romance'),
    (4, 'Political'),
    (5, 'Mystery'),
    (6, 'Adventure');


-- create junction table for book-category many-to-many relationship
create table book_categories (
    book_id int,
    category_id int,
    primary key (book_id, category_id)
);


-- insert book-category relationships
insert into book_categories (book_id, category_id)
values
    (101, 1), (101, 2), (101, 3), -- pride and prejudice: fiction, classic, romance
    (102, 1), (102, 2), (102, 4), -- 1984: fiction, classic, political
    (103, 1), (103, 2), (103, 4), -- animal farm: fiction, classic, political
    (104, 1), (104, 2), (104, 6), -- the old man and the sea: fiction, classic, adventure
    (105, 1), (105, 5), -- murder on the orient express: fiction, mystery
    (106, 1), (106, 5), -- death on the nile: fiction, mystery
    (107, 1), (107, 2), (107, 3), -- emma: fiction, classic, romance
    (108, 1), (108, 2), (108, 6); -- for whom the bell tolls: fiction, classic, adventure


-- get books with their authors and categories using group_concat
select b.title,
       a.first_name,
       a.last_name,
       group_concat(c.category_name separator ', ') as categories
from books b
join authors a
    on b.author_id = a.author_id
join book_categories bc
    on b.book_id = bc.book_id
join categories c
    on bc.category_id = c.category_id
group by b.book_id;


-- example with join condition in on clause
-- return books published before 1950 by authors born before 1900
select b.title, a.first_name, a.last_name
from books b
inner join authors a
    on b.author_id = a.author_id
    and b.publication_year < 1950
    and a.birth_year < 1900;


-- equivalent example with join condition in where clause
select b.title, a.first_name, a.last_name
from books b
inner join authors a
    on b.author_id = a.author_id
where b.publication_year < 1950
  and a.birth_year < 1900;


-- example with date functions - books published more than 70 years ago
select b.title, a.last_name
from books b
inner join authors a
    on b.author_id = a.author_id
where year(curdate()) - b.publication_year > 70;


/*
note:
inner join returns only rows where the join condition finds a match.
if a join column contains null, the equality condition does not match that row.
to include unmatched rows, use left join or right join.
*/


-- find authors who have written more than one book using having clause
select a.first_name,
       a.last_name,
       count(b.book_id) as book_count
from authors a
join books b
    on a.author_id = b.author_id
group by a.author_id
having count(b.book_id) > 1;