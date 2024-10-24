create database employee_detail;
use employee_detail; 
create table employee
(
e_id int identity,
e_fname varchar(23),
emp_lname varchar(23)
);

create  table employee_log
(
e_id int,
e_fname varchar(23),
e_lname varchar(23),
log_action varchar(23),
log_timestamp datetime
);
create trigger hello
on employee
for insert
as
	declare @eid int;
	declare @efname varchar(23);
	declare @emplname varchar(23);
	declare @log varchar(23);

	select @eid = i.e_id from inserted i;
	select @efname = i.e_fname from inserted i;
	select @emplname = i.emp_lname from inserted i;
	select @log = 'insert record - after insert trigger';

insert into employee_log values (@eid,@efname,@emplname,@log,getdate());
print 'after insert trigger fired'


select* from employee;
select * from employee_log;
insert into employee
values ('uzair', 'ali');

create trigger happy
on employee
for update
as
	declare @eid int;
	declare @efname varchar(23);
	declare @emplname varchar(23);
	declare @log varchar(23);

	select @eid = i.e_id from inserted i;
	select @efname = i.e_fname from inserted i;
	select @emplname = i.emp_lname from inserted i;
	if update (e_fname)
	   set @log = 'fname update'
	if update (emp_lname)
	   set @log = 'lname update'

insert into employee_log values (@eid,@efname,@emplname,@log,getdate());
print 'after insert trigger fired'



update employee set e_fname = 'ali' where e_id = 1;

create trigger haply
on employee
after delete
as
	declare @eid int;
	declare @efname varchar(23);
	declare @emplname varchar(23);
	declare @log varchar(23);

	select @eid = i.e_id from deleted i;
	select @efname = i.e_fname from deleted i;
	select @emplname = i.emp_lname from deleted i;
	set @log = 'delete'

insert into employee_log values (@eid,@efname,@emplname,@log,getdate());
print 'after insert trigger fired'

delete from employee where e_id = 1;


create database free;

create table booksales
(
sales_id int primary key identity(1,1),
sales_amount float,
quality int,
book_id int,
FOREIGN KEY (book_id) REFERENCES book_star(book_id),
time_id int,
FOREIGN KEY (time_id) REFERENCES time_star(time_id),
store_id int,
FOREIGN KEY (store_id) REFERENCES store_star(store_id)
);
create table store_star
(
store_id int primary key identity(1,1),
store_address varchar(222),
city varchar(222),
state varchar(222),
country varchar(222),
);
create table book_star
(
book_id int primary key identity(1,1),
title varchar(222),
author varchar(222),
publisher varchar(222),
genre varchar(222)
);
 
create table time_star
(
time_id int primary key identity(1,1),
day int,
month int,
quarter int,
year int
);

INSERT INTO book_star (title, author, publisher, genre) VALUES
('Book A', 'Author A', 'Publisher A', 'Fiction'),
('Book B', 'Author B', 'Publisher B', 'Non-Fiction');

INSERT INTO store_star ( store_address, city, state, country) VALUES
('123 Main St', 'New York', 'NY', 'USA'),
('456 Oak St', 'Los Angeles', 'CA', 'USA');

INSERT INTO time_star (day, month, quarter, year) VALUES
(15, 6, 2, 2023),
(1, 7, 3, 2023);

INSERT INTO booksales ( book_id, time_id, store_id, sales_amount, quality) VALUES
(1, 1, 1, 100.00, 5),
(2, 2, 2, 150.00, 3);

SELECT 
    b.title AS book_title,
    SUM(f.sales_amount) AS total_sales
FROM 
    booksales f
JOIN 
    book_star b ON f.book_id = b.book_id
GROUP BY 
    b.title
ORDER BY 
    total_sales DESC;

	
	-- Author Dimension Table
CREATE TABLE dim_author_sf (
    author_id INT PRIMARY KEY,
    author VARCHAR(256)
);

-- Publisher Dimension Table
CREATE TABLE dim_publisher_sf (
    publisher_id INT PRIMARY KEY,
    publisher VARCHAR(256)
);

-- Genre Dimension Table
CREATE TABLE dim_genre_sf (
    genre_id INT PRIMARY KEY,
    genre VARCHAR(128)
);

-- Book Dimension Table
CREATE TABLE dim_book_sf (
    book_id INT PRIMARY KEY,
    title VARCHAR(256),
    author_id INT,
    publisher_id INT,
    genre_id INT,
    FOREIGN KEY (author_id) REFERENCES dim_author_sf(author_id),
    FOREIGN KEY (publisher_id) REFERENCES dim_publisher_sf(publisher_id),
    FOREIGN KEY (genre_id) REFERENCES dim_genre_sf(genre_id)
);

-- Country Dimension Table
CREATE TABLE dim_country_sf (
    country_id INT PRIMARY KEY,
    country VARCHAR(128)
);

-- State Dimension Table
CREATE TABLE dim_state_sf (
    state_id INT PRIMARY KEY,
    state VARCHAR(128),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES dim_country_sf(country_id)
);

-- City Dimension Table
CREATE TABLE dim_city_sf (
    city_id INT PRIMARY KEY,
    city VARCHAR(128),
    state_id INT,
    FOREIGN KEY (state_id) REFERENCES dim_state_sf(state_id)
);

-- Store Dimension Table
CREATE TABLE dim_store_sf (
    store_id INT PRIMARY KEY,
    store_address VARCHAR(256),
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES dim_city_sf(city_id)
);

-- Year Dimension Table
CREATE TABLE dim_year_sf (
    year_id INT PRIMARY KEY,
    year INT
);

-- Quarter Dimension Table
CREATE TABLE dim_quarter_sf (
    quarter_id INT PRIMARY KEY,
    quarter INT,
    year_id INT,
    FOREIGN KEY (year_id) REFERENCES dim_year_sf(year_id)
);

-- Month Dimension Table
CREATE TABLE dim_month_sf (
    month_id INT PRIMARY KEY,
    month INT,
    quarter_id INT,
    FOREIGN KEY (quarter_id) REFERENCES dim_quarter_sf(quarter_id)
);

-- Time Dimension Table
CREATE TABLE dim_time_sf (
    time_id INT PRIMARY KEY,
    day INT,
    month_id INT,
    FOREIGN KEY (month_id) REFERENCES dim_month_sf(month_id)
);

-- Fact Table for Booksales
CREATE TABLE fact_booksales (
    sales_id INT PRIMARY KEY,
    book_id INT,
    time_id INT,
    store_id INT,
    sales_amount FLOAT,
    quantity INT,
    FOREIGN KEY (book_id) REFERENCES dim_book_sf(book_id),
    FOREIGN KEY (time_id) REFERENCES dim_time_sf(time_id),
    FOREIGN KEY (store_id) REFERENCES dim_store_sf(store_id)
);
INSERT INTO dim_author_sf (author_id, author)
VALUES
(1, 'George Orwell'),
(2, 'J.K. Rowling');

-- Insert into Publisher Dimension Table
INSERT INTO dim_publisher_sf (publisher_id, publisher)
VALUES
(1, 'Penguin Random House'),
(2, 'Bloomsbury Publishing');

-- Insert into Genre Dimension Table
INSERT INTO dim_genre_sf (genre_id, genre)
VALUES
(1, 'Dystopian Fiction'),
(2, 'Fantasy');

-- Insert into Book Dimension Table
INSERT INTO dim_book_sf (book_id, title, author_id, publisher_id, genre_id)
VALUES
(1, '1984', 1, 1, 1),
(2, 'Harry Potter and the Philosopher Stone', 2, 2, 2);

-- Insert into Country Dimension Table
INSERT INTO dim_country_sf (country_id, country)
VALUES
(1, 'United States'),
(2, 'United Kingdom');

-- Insert into State Dimension Table
INSERT INTO dim_state_sf (state_id, state, country_id)
VALUES
(1, 'California', 1),
(2, 'London', 2);

-- Insert into City Dimension Table
INSERT INTO dim_city_sf (city_id, city, state_id)
VALUES
(1, 'Los Angeles', 1),
(2, 'London', 2);

-- Insert into Store Dimension Table
INSERT INTO dim_store_sf (store_id, store_address, city_id)
VALUES
(1, '123 Book St, Los Angeles', 1),
(2, '456 Reading Rd, London', 2);

-- Insert into Year Dimension Table
INSERT INTO dim_year_sf (year_id, year)
VALUES
(1, 2024);

-- Insert into Quarter Dimension Table
INSERT INTO dim_quarter_sf (quarter_id, quarter, year_id)
VALUES
(1, 1, 1),
(2, 2, 1);

INSERT INTO dim_month_sf (month_id, month, quarter_id)
VALUES
(1, 1, 1),
(2, 2, 1);

-- Insert into Time Dimension Table
INSERT INTO dim_time_sf (time_id, day, month_id)
VALUES
(1, 15, 1),
(2, 20, 2);

-- Insert into Fact Table for Book Sales
INSERT INTO fact_booksales (sales_id, book_id, time_id, store_id, sales_amount, quantity)
VALUES
(1, 1, 1, 1, 19.84, 10),
(2, 2, 2, 2, 29.99, 5);
