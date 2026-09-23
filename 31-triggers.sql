-- triggers in mysql

-- 1. create database

drop database if exists triggerdb;

create database triggerdb;

use triggerdb;

-- 2. create customers table

create table customers (
    custid int primary key auto_increment,
    customername varchar(50) not null,
    phone varchar(20),
    address varchar(100),
    city varchar(50),
    state varchar(50),
    postalcode varchar(10),
    country varchar(50),
    custemail varchar(100),
    dob date
);

-- 3. insert sample customers

insert into customers
(customername, phone, address, city, state, postalcode, country, custemail, dob)
values
('devansh', '9876543210', 'main road', 'kanpur', 'uttar pradesh', '208001', 'india', 'devansh@gmail.com', '2005-05-15'),
('aman', '9876543211', 'station road', 'delhi', 'delhi', '110001', 'india', 'aman@gmail.com', '2003-08-20'),
('priya', '9876543212', 'mg road', 'lucknow', 'uttar pradesh', '226001', 'india', 'priya@gmail.com', '2005-02-10');

select *
from customers;

-- 4. what is a trigger?

-- a trigger is a database object that automatically executes
-- when a specified event occurs on a table.

-- common events: 1. insert 2. update 3. delete

-- common trigger timings: 1. before 2. after

-- basic structure:

/*
create trigger trigger_name
before | after
insert | update | delete
on table_name
for each row
begin
    -- trigger logic
end;
*/

-- 5. before vs after trigger

-- before: executes before the insert, update or delete operation.

-- commonly used for:
-- validation
-- modifying new values
-- preventing invalid data

-- after: executes after the insert, update or delete operation.

-- commonly used for:
-- audit logs
-- maintaining related tables
-- recording changes

-- 6. new and old

-- new: represents the new row value.
-- old: represents the existing row value before the change.

-- insert:
-- new is available
-- old is not available

-- update:
-- new is available
-- old is available

-- delete:
-- old is available
-- new is not available

-- 7. audit table

-- this table stores information whenever a new customer is inserted.

create table customer_audits (
    auditid int primary key auto_increment,
    custid int,
    customername varchar(50),
    custemail varchar(100),
    actiontype varchar(20),
    actiontime timestamp default current_timestamp
);

select *
from customer_audits;

-- 8. after insert trigger - audit log

-- automatically log every newly inserted customer.

drop trigger if exists after_customer_insert;

delimiter $$

create trigger after_customer_insert
after insert on customers
for each row
begin
    insert into customer_audits
    (custid, customername, custemail, actiontype)
    values
    (new.custid, new.customername, new.custemail, 'insert');
end $$

delimiter ;

-- insert a new customer

insert into customers
(customername, phone, address, city, state, postalcode, country, custemail, dob)
values
('lakshya', '1231313', 'd', 'new delhi', 'new delhi', '110012', 'india', 'lakshya@gmail.com', '1998-06-30');

-- check customer table

select *
from customers;

-- check audit table

select *
from customer_audits;

-- new.customername means the customername from the newly inserted row.

-- 9. create products table

create table products (
    productid int primary key auto_increment,
    productname varchar(100) not null,
    stock int not null,
    price decimal(10,2) not null
);

-- 10. insert sample products

insert into products
(productname, stock, price)
values
('keyboard', 50, 1200.00),
('mouse', 100, 700.00),
('monitor', 25, 12000.00),
('headphones', 40, 2500.00);

select *
from products;

-- 11. create stock log table

create table stock_log (
    logid int primary key auto_increment,
    productid int,
    old_stock int,
    new_stock int,
    changed_at timestamp default current_timestamp
);

-- 12. after update trigger - stock log

-- automatically record old and new stock values
-- whenever product stock is updated.

drop trigger if exists after_stock_update;

delimiter $$

create trigger after_stock_update
after update on products
for each row
begin
    if old.stock <> new.stock then
        insert into stock_log
        (productid, old_stock, new_stock)
        values
        (old.productid, old.stock, new.stock);
    end if;
end $$

delimiter ;

-- update stock

update products
set stock = 45
where productid = 1;

-- check stock

select *
from products;

-- check stock log

select *
from stock_log;

-- old.stock = stock before update
-- new.stock = stock after update

-- 13. customers archive table

-- create a copy of customers structure.

create table customers_archive like customers;

-- add archive information

alter table customers_archive
add column deleted_at timestamp default current_timestamp;

-- 14. before delete trigger - archive customer

-- before deleting a customer, store a copy of the
-- customer information in the archive table.

drop trigger if exists before_customer_delete;

delimiter $$

create trigger before_customer_delete
before delete on customers
for each row
begin
    insert into customers_archive
    (
        custid,
        customername,
        phone,
        address,
        city,
        state,
        postalcode,
        country,
        custemail,
        dob
    )
    values
    (
        old.custid,
        old.customername,
        old.phone,
        old.address,
        old.city,
        old.state,
        old.postalcode,
        old.country,
        old.custemail,
        old.dob
    );
end $$

delimiter ;

-- find customer

select *
from customers
where custid = 4;

-- delete customer

delete from customers
where custid = 4;

-- check archive

select *
from customers_archive
where custid = 4;

-- old is used because the row is being deleted.

-- 15. create orders table

create table orders (
    orderid int primary key auto_increment,
    productid int not null,
    quantity int not null,
    orderdate timestamp default current_timestamp,

    foreign key (productid)
        references products(productid)
);

-- 16. before insert trigger - prevent negative stock

-- check whether enough stock is available before
-- allowing an order to be inserted.

drop trigger if exists before_order_insert;

delimiter $$

create trigger before_order_insert
before insert on orders
for each row
begin
    declare current_stock int;

    select stock
    into current_stock
    from products
    where productid = new.productid;

    if current_stock is null then
        signal sqlstate '45000'
        set message_text = 'product does not exist';

    elseif new.quantity <= 0 then
        signal sqlstate '45000'
        set message_text = 'quantity must be greater than zero';

    elseif current_stock < new.quantity then
        signal sqlstate '45000'
        set message_text = 'insufficient stock for this order';
    end if;
end $$

delimiter ;

-- valid order

insert into orders
(productid, quantity)
values
(1, 5);

select *
from orders;

-- invalid order example:
-- product 1 currently has less than 1000 units,
-- so this should be rejected.

-- insert into orders
-- (productid, quantity)
-- values
-- (1, 1000);

-- 17. after order insert - decrease stock

-- once an order has successfully been inserted,
-- automatically decrease the product stock.

drop trigger if exists after_order_insert;

delimiter $$

create trigger after_order_insert
after insert on orders
for each row
begin
    update products
    set stock = stock - new.quantity
    where productid = new.productid;
end $$

delimiter ;

-- create another order

insert into orders
(productid, quantity)
values
(2, 10);

-- check orders

select *
from orders;


-- check updated stock

select *
from products;

-- 18. flow:

-- customer places order
--        |
--        v
-- before_order_insert
--        |
--        v
-- stock available?
--     /       \
--   no         yes
--   |           |
--   stop        v
--             insert order
--                |
--                v
--          after_order_insert
--                |
--                v
--          decrease stock

-- 19. update trigger - maintain updated information

-- create a customer profile table with updated timestamp.

create table customer_profiles (
    profileid int primary key auto_increment,
    custid int,
    customername varchar(50),
    city varchar(50),
    updated_at timestamp default current_timestamp
);

-- insert profile

insert into customer_profiles
(custid, customername, city)
values
(1, 'devansh', 'kanpur');

-- 20. before update trigger

-- automatically convert customer name to lowercase
-- before storing the updated value.

drop trigger if exists before_customer_profile_update;

delimiter $$

create trigger before_customer_profile_update
before update on customer_profiles
for each row
begin
    set new.customername = lower(new.customername);
    set new.updated_at = current_timestamp;
end $$

delimiter ;

-- update profile

update customer_profiles
set customername = 'devansh bhatt',
    city = 'delhi'
where profileid = 1;

select *
from customer_profiles;

-- 21. after delete trigger - delete audit

create table customer_delete_log (
    logid int primary key auto_increment,
    custid int,
    customername varchar(50),
    deleted_at timestamp default current_timestamp
);


drop trigger if exists after_customer_delete;

delimiter $$

create trigger after_customer_delete
after delete on customers
for each row
begin
    insert into customer_delete_log
    (custid, customername)
    values
    (old.custid, old.customername);
end $$

delimiter ;

-- old is available because the row has been deleted.

-- 22. trigger restrictions and important points

-- 1. triggers execute automatically.
-- 2. triggers are associated with a table.
-- 3. triggers execute for each affected row.
-- 4. new represents the new row.
-- 5. old represents the previous row.
-- 6. insert triggers can use new.
-- 7. delete triggers can use old.
-- 8. update triggers can use both old and new.
-- 9. before triggers execute before the event.
-- 10. after triggers execute after the event.
-- 11. trigger logic should be kept simple and focused.
-- 12. too many triggers can make database behavior harder
--     to understand and maintain.

-- 23. signal

-- signal is used to raise a custom database error.

-- example:

/*
signal sqlstate '45000'
set message_text = 'insufficient stock for this order';
*/

-- sqlstate '45000' is commonly used for a user-defined unhandled exception.

-- 23. view all triggers, for current database

show triggers;

show triggers
from triggerdb;

-- 24. trigger limitations

-- 1. triggers cannot be called manually like functions or
--    procedures; they execute automatically.

-- 2. triggers cannot return a value or directly return
--    a result set.

-- 3. transaction control statements such as commit and
--    rollback cannot be used inside triggers.

-- 4. triggers cannot be used for select or truncate operations,
--    and triggers cannot be defined on local or global temporary tables.