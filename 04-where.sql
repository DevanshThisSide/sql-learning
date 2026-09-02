-- create database
create database bookstore;
use bookstore;

-- create books table
create table books (
    book_id int primary key,
    title varchar(100),
    author varchar(50),
    price decimal(10,2),
    publication_date date,
    category varchar(30),
    in_stock int
);

-- insert book records
insert into books values
(1, 'the mysql guide', 'john smith', 29.99, '2023-01-15', 'technology', 50),
(2, 'data science basics', 'sarah johnson', 34.99, '2023-03-20', 'technology', 30),
(3, 'mystery at midnight', 'michael brown', 19.99, '2023-02-10', 'mystery', 100),
(4, 'cooking essentials', 'lisa anderson', 24.99, '2023-04-05', 'cooking', 75);

-- insert record with null author
insert into books values
(5, 'Genius Makers', null, 24.99, '2023-04-05', 'cooking', 75);

-- insert another book
insert into books values
(6, 'Clean Code', 'cohn smith', 25.99, '2023-04-05', 'coding', 69);

-- filtering with where
select *
from books
where category = 'technology';

select title, price
from books
where price < 30.00;

select title, publication_date
from books
where publication_date >= '2023-03-01';

-- logical operators
select *
from books
where category = 'technology'
and price < 30;

select *
from books
where category = 'technology'
or price < 30;

-- combine and/or using parentheses
select *
from books
where (category = 'technology' or category = 'mystery')
and price < 25;

select *
from books
where not category = 'technology';

-- finding null values
select *
from books
where author is null;

select *
from books
where author is not null;

-- pattern matching with like
select *
from books
where title like '%sql%';

select *
from books
where title like 'the%';

-- binary makes the pattern match case-sensitive
select *
from books
where title like binary '%sql%';

-- underscore matches a single character
select *
from books
where author like '_ohn%';

-- range operators
select *
from books
where price between 20 and 30;

-- filter using multiple possible categories
select *
from books
where category in ('technology', 'mystery', 'science');

-- combine between with another condition
select *
from books
where price between 20.00 and 40.00
and publication_date >= '2023-01-01';

-- subquery: books costing more than average price
select *
from books
where price > (
    select avg(price)
    from books
);

-- subquery with in
select *
from books
where category in (
    select category
    from books
    where in_stock > 70
);

-- books published in 2023 below average price
select title, price, publication_date
from books
where year(publication_date) = 2023
and price < (
    select avg(price)
    from books
);

-- technology books containing "data" with less than 50 copies
select title, category, in_stock
from books
where category = 'technology'
and title like '%data%'
and in_stock < 50;

-- technology books above $30 or mystery books below $20
select title, category, price
from books
where (category = 'technology' and price > 30.00)
or (category = 'mystery' and price < 20.00);

-- books whose author contains "son" or "th"
-- and were published after march 2023
select title, author, publication_date
from books
where (author like '%son%' or author like '%th%')
and publication_date > '2023-03-31';
