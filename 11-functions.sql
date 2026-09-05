-- sql functions
-- a comprehensive demonstration of various sql functions

-- string functions

-- create and use database for string function examples
create database stringfunctionsdb;
use stringfunctionsdb;

-- create employees table for string function demonstrations
create table employees (
    emp_id int auto_increment primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    department varchar(50)
);

-- insert sample employee data
insert into employees (first_name, last_name, email, department) values
    ('john', 'doe', 'john.doe@example.com', 'marketing'),
    ('jane', 'smith', 'jane.smith@example.com', 'sales'),
    ('michael', 'johnson', 'michael.johnson@example.com', 'it'),
    ('emily', 'davis', 'emily.davis@example.com', 'hr'),
    ('chris', 'brown', 'chris.brown@example.com', 'finance');

select * from employees;

-- concat: combine first and last names into full name
select concat(first_name, ' ', last_name) as full_name
from employees;

-- length: get the length of the first name
select first_name, length(first_name) as name_length
from employees;

-- upper and lower: convert first names to uppercase and lowercase
select first_name,
       upper(first_name) as uppercase,
       lower(first_name) as lowercase
from employees;

-- trim: remove leading and trailing spaces
select trim(upper('      ok   ')) as trimmed_sample;
select ltrim(upper('      ok   ')) as trimmed_sample;
select rtrim(upper('      ok   ')) as trimmed_sample;

-- in sql, string indexing is 1-based.
-- substring: extract the first three characters of first names
select first_name,
       substring(first_name, 1, 3) as first_three_chars
from employees;

-- locate: find the position of character 'a' in first names
select first_name,
       locate('a', first_name) as position_of_a
from employees;

-- locate: find the position of characters 'ch' in first names
select first_name,
       locate('ch', first_name) as position_of_ch
from employees;

-- replace: replace domain in email addresses
select first_name,
       replace(email, 'example.com', 'yahoo.com') as new_email
from employees;

-- reverse: reverse the characters in first names
select first_name,
       reverse(first_name) as reversed_name
from employees;

-- left and right: get the first two and last two characters of first names
select first_name,
       left(first_name, 2) as first_two,
       right(first_name, 2) as last_two
from employees;

-- ascii: get ascii value of the first character in first names
-- (regular and lowercase)
select first_name,
       ascii(first_name) as ascii_value,
       ascii(lower(first_name)) as ascii_lowercase_value
from employees;

-- field: order employees by department in custom order
select *,
       field(department, 'it', 'sales', 'marketing', 'hr', 'finance')
           as custom_department_order
from employees
order by field(department, 'it', 'sales', 'marketing', 'hr', 'finance');

-- length vs char_length: demonstrate difference with ascii and multibyte characters
select length('hello') as length_in_bytes;          -- returns 5 (bytes)
select length('こんにちは') as multibyte_length;      -- returns 15 because each character is 3 bytes in japanese
select char_length('hello') as char_count;          -- returns 5 (characters)
select char_length('こんにちは') as multibyte_char_count; -- returns 5 (characters)

-- soundex: compare phonetically similar strings
select soundex('smith') as smith_soundex;   -- returns 's530'
select soundex('smyth') as smyth_soundex;   -- also returns 's530'
select soundex('robert') as robert_soundex; -- returns 'r163'
select soundex('rupert') as rupert_soundex; -- also returns 'r163'

-- find employees with names that sound like "jane"
select *
from employees
where soundex('jane') = soundex(first_name);

-- numeric functions

create database numericfunctionsdb;

use numericfunctionsdb;

create table numbers (
    id int auto_increment primary key,
    num_value decimal(10,5)
);

insert into numbers (num_value) values
    (25.6789),
    (-17.5432),
    (100.999),
    (-0.4567),
    (9.5),
    (1234.56789),
    (0);

-- basic display of all values
select * from numbers;

-- absolute value function
select num_value,
       abs(num_value) as absolute_value
from numbers;

-- rounding functions
select num_value,
       ceil(num_value) as rounded_up,
       floor(num_value) as rounded_down
from numbers;

select num_value,
       round(num_value, 2) as rounded_2_decimals
from numbers;

select num_value,
       truncate(num_value, 2) as truncated_2_decimals
from numbers;

-- mathematical operations
select num_value,
       power(num_value, 2) as squared
from numbers;

select num_value,
       mod(num_value, 3) as remainder
from numbers;

select num_value,
       sqrt(abs(num_value)) as sqrt_value
from numbers;

-- exponential functions with handling for out-of-range values
select num_value,
       case
           when num_value > 709 then 'value too large for exp()'
           else exp(num_value)
       end as exp_value
from numbers;

-- exp() return set is in double precision, so very large positive values can cause an out-of-range error.
-- so values greater than 709 are handled using case

-- logarithmic functions
select num_value,
       log(2, abs(num_value) + 1) as log_base2,
       log10(abs(num_value) + 1) as log_base10
from numbers;

-- logarithm is defined only for positive values
-- log() returns null when its input is zero or negative

-- trigonometric functions
-- values given in radians
select num_value,
       sin(num_value) as sin_value,
       cos(num_value) as cos_value,
       tan(num_value) as tan_value
from numbers;

-- pi constant and angle conversions
select pi() as pi_value;

select num_value,
       radians(num_value) as radians_value,
       degrees(num_value) as degrees_value
from numbers;

-- bitwise operations
select bit_and(num_value)
from numbers;

select bit_or(num_value)
from numbers;

select bit_xor(num_value)
from numbers;

-- date functions

-- date and time data types:
-- date        yyyy-mm-dd           stores only date without time
-- datetime    yyyy-mm-dd hh:mi:ss  stores date and time
-- timestamp   yyyy-mm-dd hh:mi:ss  stores date/time with automatic utc conversion
-- time        hh:mi:ss             stores only time
-- year        yyyy                 stores only a four-digit year

-- current date and time functions
select now() as current_datetime;
select curdate() as current_date;
select curtime() as current_time;

-- date part extraction
select year(now()) as current_year;
select month(now()) as current_month;
select day(now()) as current_day;
select hour(now()) as current_hour;
select minute(now()) as current_minute;
select second(now()) as current_second;

-- date formatting
select date_format('2026-03-13', '%w, %m %e, %y') as formatted_date_long;
select date_format('2026-08-23', '%e/%m/%y') as formatted_date_short;

-- date arithmetic
select date_add('2026-07-23', interval 7 day) as date_plus_7_days;
select date_sub('2026-08-08', interval 7 month) as date_minus_7_months;

-- date difference
select datediff('2026-08-10', '2026-08-03') as days_between;

-- unix timestamp functions (seconds since january 1, 1970, at 00:00:00 utc)
select unix_timestamp('2026-08-23') as unix_time;
select from_unixtime(1741392000) as readable_date;

-- date function examples with a database
create database dateexamplesdb;
use dateexamplesdb;

create table orders (
    order_id int auto_increment primary key,
    customer_name varchar(100),
    order_date datetime
);

insert into orders (customer_name, order_date) values
    ('alice', '2026-03-01 10:15:00'),
    ('bob', '2026-03-02 14:45:30'),
    ('charlie', '2026-03-03 09:30:15'),
    ('akshay', '2026-08-31 10:15:00');

-- querying orders in the last 7 days
select now() as system_current_time,
       date_sub(now(), interval 7 day) as threshold_date;

select *
from orders
where date(order_date) >= date_sub(now(), interval 7 day);

-- aggregate functions

-- used to perform calculations on multiple rows of data and return a single summarized value
-- count() – returns the number of rows
-- sum() – returns the sum of a numeric column
-- avg() – returns the average value of a numeric column
-- min() – returns the minimum value
-- max() – returns the maximum value

create database aggregateexamplesdb;
use aggregateexamplesdb;

create table employees (
    id int auto_increment primary key,
    name varchar(50),
    department varchar(50),
    salary decimal(10,2),
    hire_date date
);

insert into employees (name, department, salary, hire_date) values
    ('alice', 'hr', 50000, '2018-06-23'),
    ('bob', 'it', 70000, '2019-08-01'),
    ('charlie', 'finance', 80000, '2017-04-15'),
    ('david', 'hr', 55000, '2020-11-30'),
    ('eve', 'it', 75000, '2021-01-25'),
    ('frank', 'finance', 72000, '2019-07-10'),
    ('grace', 'it', 68000, '2018-09-22'),
    ('hank', 'finance', 90000, '2016-12-05'),
    ('ivy', 'hr', 53000, '2022-03-19'),
    ('jack', 'it', 72000, '2017-05-12');

-- count employees in hr department
select count(*) as hr_employee_count
from employees
where department = 'hr';

-- sum of salaries in hr department
select sum(salary) as total_hr_salary
from employees
where department = 'hr';

-- average salary in hr department
select avg(salary) as avg_hr_salary
from employees
where department = 'hr';

-- minimum salary in hr department
select min(salary) as min_hr_salary
from employees
where department = 'hr';

-- maximum salary in hr department
select max(salary) as max_hr_salary
from employees
where department = 'hr';

-- comprehensive statistics for all employees
select count(*) as num_employees,
       sum(salary) as total_salary,
       avg(salary) as average_salary,
       min(salary) as lowest_salary,
       max(salary) as highest_salary
from employees;

-- group by department to get statistics per department
select department,
       count(*) as employee_count,
       sum(salary) as department_total_salary,
       round(avg(salary), 2) as department_avg_salary,
       min(salary) as department_min_salary,
       max(salary) as department_max_salary
from employees
group by department
order by department_avg_salary desc;