use student;
 select * from sales.customers
 select first_name,last_name from sales.customers 
  --select with filter

  select * from sales.customers 
  where state = 'CA'
  SELECT * FROM sales.customers WHERE state = 'CA' ORDER BY first_name; -- FROM >> WHERE >> SELECT >> ORDER BY
SELECT city FROM sales.customers WHERE state = 'CA' GROUP BY city ORDER BY city; -- FROM >> WHERE >> GROUP BY >> SELECT >> ORDER BY
SELECT city, count(*) FROM sales.customers WHERE state = 'CA' GROUP BY city HAVING count(*) > 10 ORDER BY city; 

SELECT * FROM sales.customers ORDER BY 1, 2, 3;
SELECT first_name, last_name FROM sales.customers ORDER BY LEN(first_name) desc;

; 
SELECT * FROM sales.customers ORDER BY first_name, last_name DESC;

SELECT product_name, list_price FROM production.products ORDER BY list_price, product_name OFFSET 10 ROWS fetch next 10 ROWS only;
SELECT product_name, list_price FROM production.products ORDER BY list_price, product_name OFFSET 0 ROWS fetch NEXT 10 ROWS only;
SELECT TOP 3 WITH TIES  product_name, list_price FROM production.products ORDER BY list_price DESC;
SELECT TOP 3   product_name, list_price FROM production.products ORDER BY list_price DESC;
SELECT TOP 3 percent  product_name, list_price FROM production.products ORDER BY list_price DESC;
SELECT DISTINCT city FROM sales.customers ORDER BY city;
SELECT city, state, zip_code FROM sales.customers GROUP BY city, state, zip_code ORDER BY city, state, zip_code;
-- It is equivalent to the following query that uses the DISTINCT operator :
SELECT DISTINCT city, state, zip_code FROM sales.customers;
SELECT DISTINCT city, state FROM sales.customers;
SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE list_price IN (299.99, 369.99, 489.99) ORDER BY list_price DESC;






SELECT * FROM sales.stores WHERE phone LIKE '0';

CREATE SCHEMA hr;
go

CREATE TABLE hr.candidates(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fullname VARCHAR(100) NOT NULL
)

CREATE TABLE hr.employees(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fullname VARCHAR(100) NOT NULL
)

INSERT INTO hr.candidates(fullname)
VALUES
    ('John Doe'),
    ('Lily Bush'),
    ('Peter Drucker'),
    ('Jane Doe');

INSERT INTO hr.employees(fullname)
VALUES
    ('John Doe'),
    ('Jane Doe'),
    ('Michael Scott'),
    ('Jack Sparrow');

/*
Suppose,

1. candidates == LEFTTABLE
2. employees == RIGHT TABLE

*/

-- 5.1 SQL Server Inner Join
USE STUDENT;
SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
INNER JOIN hr.employees e
ON c.fullname = e.fullname;

-- 5.2 SQL Server Left Join

SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
LEFT JOIN hr.employees e
ON c.fullname = e.fullname;


SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
LEFT JOIN hr.employees e
ON c.fullname = e.fullname
WHERE e.id IS NULL;

-- 5.3 SQL Server Right Join

SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
RIGHT JOIN hr.employees e
ON c.fullname = e.fullname;

SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
RIGHT JOIN hr.employees e
ON c.fullname = e.fullname
WHERE c.id IS NULL;

-- 5.4 SQL Server FULL Join

SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
FULL JOIN hr.employees e
ON c.fullname = e.fullname;

SELECT 
	c.id, c.fullname,
	e.id, e.fullname
FROM hr.candidates c
FULL JOIN hr.employees e
ON c.fullname = e.fullname
WHERE c.id IS NULL or e.id IS NULL;

-- 5.4 SQL Server Cross Join

CREATE TABLE Meals(MealName VARCHAR(100));
CREATE TABLE Drinks(DrinkName VARCHAR(100));

INSERT INTO Drinks
VALUES('Orange Juice'), ('Tea'), ('Cofee');

INSERT INTO Meals
VALUES('Omlet'), ('Fried Egg'), ('Sausage');

SELECT *
FROM Meals;

SELECT *
FROM Drinks