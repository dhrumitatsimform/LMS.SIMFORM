--Section - 1
--Query Data

--SELECT Statement

--A) SQL Server SELECT - retrive some columns of a table

SELECT 
	first_name,
	last_name
FROM 
	sales.customers;

--B) SQL Server SELECT - retrive all columns from a table

SELECT 
	*
FROM
	sales.customers;

--C) SQl Server SELECT - sort the result set

SELECT	
	* 
FROM
	sales.customers
WHERE
	state = 'CA';

--To sort the result set based on one or more columns, use the 'ORDER BY' clause.

SELECT 
	* 
FROM
	sales.customers
WHERE 
	state = 'CA'
ORDER BY
	first_name;

--D) SQL Serve SELECT - group rows into groups

SELECT 
	city,
	COUNT(*)
FROM
	sales.customers
WHERE 
	state = 'CA'
GROUP BY
	city
ORDER BY
	city;

--E) SQL Server SELECT - filter Groups

SELECT 
	city,
	COUNT(*) 
FROM
	sales.customers
WHERE
	state = 'CA'
GROUP BY
	city
HAVING
	COUNT(*) > 10
ORDER BY
	COUNT(*) DESC,
	city;

--Section 2
--Sorting data

--ORDER BY

--A) Sort a result set by one column in ascending order

SELECT 
	first_name,
	last_name
FROM
	sales.customers
ORDER BY
	first_name;

--B) Sort a result set by one column is descending order.

SELECT 
	first_name,
	last_name
FROM
	sales.customers
ORDER BY
	first_name DESC;

--C) Sort a result set by multiple columns.

SELECT 
	city,
	first_name,
	last_name
FROM
	sales.customers
ORDER BY
	city,
	first_name;

--D) Sort a result set by multiple columns but in diffrent orders

SELECT 
	city,
	first_name,
	last_name
FROM
	sales.customers
ORDER BY
	city DESC,
	first_name ASC;

--E) Sort a result set by a column that is not in select list

SELECT 
	city,
	first_name,
	last_name
FROM
	sales.customers
ORDER BY
	state;

--F) Sort a result set by an expression

SELECT 
	first_name,
	last_name
FROM 
	sales.customers
ORDER BY
	LEN(first_name) DESC;

--G) Sort by ordinal Positions of columns

SELECT 
	first_name,
	last_name
FROM 
	sales.customers
ORDER BY
	1,
	2;

--Section 3
--Limiting rows

--OFFSET FETCH

--The following query return all products from "products" table and sort them by list_price and names

SELECT 
	product_name,
	list_price
FROM 
	production.products
ORDER BY
	list_price,
	product_name;

--A) TO skip the first 10 products and return the rest

SELECT 
	product_name,
	list_price
FROM 
	production.products
ORDER BY
	list_price,
	product_name
OFFSET 10 ROWS;

--B) Top 10 most expensive products

SELECT 
	product_name,
	list_price
FROM 
	production.products
ORDER BY
	list_price DESC, 
	product_name
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

-- SELECT TOP

--A) Using TOP with a constant value

SELECT TOP 10
	product_name,
	list_price
FROM 
	production.products
ORDER BY 
	list_price DESC;

--B) Using TOP to return a percentage of rows.

SELECT TOP 1 PERCENT 
	product_name,
	list_price
FROM 
	production.products
ORDER BY 
	list_price DESC;

--C) Using TOP with TIES to include row that match the values in the row

SELECT TOP 3 WITH TIES
	product_name,
	list_price
FROM 
	production.products
ORDER BY 
	list_price DESC;

--Section 4
--Filtering data

--DISTINCT Clause

--A) DISTINCT one column

SELECT DISTINCT
	city
FROM
	sales.customers
ORDER BY 
	city;

--B) DISTINCT muliple columns 

SELECT DISTINCT
	city,
	state
FROM
	sales.customers
ORDER BY 
	city, 
	state;

--D) DISTINCT with null values

SELECT DISTINCT	
	phone	
FROM
	sales.customers
ORDER BY
	phone;

--WHERE

--A) Finding rows by using a simple quality

SELECT
	product_id,
	product_name,
	category_id,
	model_year,
	list_price
FROM
	production.products
WHERE 
	category_id = 1
ORDER BY
	list_price DESC;

--B) Finding rows that meet two conditions

SELECT
	product_id,
	product_name,
	category_id,
	model_year,
	list_price
FROM
	production.products
WHERE 
	category_id = 1 AND model_year = 2018
ORDER BY
	list_price DESC;

--C) Finding rows by using a comparison operatr

SELECT
	product_id,
	product_name,
	category_id,
	model_year,
	list_price
FROM
	production.products
WHERE 
	list_price > 300 AND model_year = 2018
ORDER BY
	list_price DESC;

--D) Finding rows that meet any of two conditions

SELECT
	product_id,
	product_name,
	category_id,
	model_year,
	list_price
FROM
	production.products
WHERE 
	list_price > 3000 OR model_year = 2018
ORDER BY
	list_price DESC


--E) Finding rows with the values between two values

SELECT
	product_id,
	product_name,
	category_id,
	model_year,
	list_price
FROM
	production.products
WHERE 
	list_price BETWEEN 1899.00 AND 1999.99
ORDER BY
	list_price DESC

--F) finding rows that have a values in a list of values

SELECT
	product_id,
	product_name,
	category_id,
	model_year,
	list_price
FROM
	production.products
WHERE 
	list_price IN (299.99, 369.99, 489.99)
ORDER BY
	list_price DESC

--G) Finding rows whoes values contains a strig "cruiser"

SELECT
	product_id,
	product_name,
	category_id,
	model_year,
	list_price
FROM
	production.products
WHERE 
	product_name LIKE '%Cruiser%'
ORDER BY
	list_price;

-- AND Operator

--A) Using AND operator

SELECT	
	* 
FROM
	production.products
WHERE
	category_id = 1 AND list_price > 400
ORDER BY
	list_price DESC;

--B) Using multiple AND operator 

SELECT	
	* 
FROM
	production.products
WHERE
	category_id = 1 AND list_price > 400 AND brand_id = 1
ORDER BY
	list_price DESC;

--C) Using AND operator with other logical Ooperators

SELECT	
	* 
FROM
	production.products
WHERE
	brand_id = 1 OR brand_id = 2 AND list_price > 1000
ORDER BY
	brand_id DESC;

	
--*) Use of Parentheses 
SELECT	
	* 
FROM
	production.products
WHERE
	(brand_id = 1 OR brand_id = 2) AND list_price > 1000
ORDER BY
	brand_id DESC;

-- OR operator
--A) Using OR operator

SELECT	
	product_name,
	list_price
FROM
	production.products
WHERE
	list_price < 200 OR list_price > 6000
ORDER BY
	list_price DESC;

--B) Using multiple OR operators

SELECT	
	product_name,
	brand_id
FROM
	production.products
WHERE
	brand_id = 1 OR brand_id = 2 OR brand_id = 4
ORDER BY
	brand_id DESC;

--*) Can replace multiple OR with IN 

SELECT	
	product_name,
	brand_id
FROM
	production.products
WHERE
	brand_id IN (1, 2, 4)
ORDER BY
	brand_id DESC;

--C) Using OR operator with AND operator 

SELECT 
	product_name,
	brand_id,
	list_price
FROM
	production.products
WHERE 
	(brand_id = 1 OR brand_id = 2) AND list_price > 1000
ORDER BY
	brand_id DESC,
	list_price DESC;

-- IN Operator
--A) Using  SQL Server In with a list of values

SELECT 
	product_name,
	list_price
FROM
	production.products
WHERE 
	list_price IN (89.99, 109.99, 159.99)
ORDER BY
	list_price

--B) Using NOT IN operator

SELECT 
	product_name,
	list_price
FROM
	production.products
WHERE 
	list_price  NOT IN (89.99, 109.99, 159.99)
ORDER BY
	list_price;

--c) Using IN with sub queroes
--SubQuery
SELECT 
	product_id
FROM 
	production.stocks
WHERE
	store_id = 1 AND quantity >= 30

-- IN with SubQuery

SELECT 
	product_name,
	list_price
FROM
	production.products
WHERE	
	product_id IN (
			SELECT 
				product_id
			FROM 
				production.stocks
			WHERE
				store_id = 1 AND quantity >= 30
				)
ORDER BY 
	product_name;

--BETWEEN
-- Query to finds the products whoes list prices are between 149.99 and 199.99
SELECT 
	product_id,
	product_name,
	list_price
FROM
	production.products
WHERE 
	list_price BETWEEN 149.99 AND 199.99
ORDER BY 
	list_price;

--Query to finds the products whoes list prices are not between 149.99 and 199.99
		
SELECT 
	product_id,
	product_name,
	list_price
FROM
	production.products
WHERE 
	list_price NOT BETWEEN 149.99 AND 199.99
ORDER BY 
	list_price;

-- Using BETWEEN with dates

SELECT 
	order_id,
	customer_id,
	order_date,
	order_status
FROM
	sales.orders
WHERE 
	order_date  BETWEEN '20170115' AND '20170117'
ORDER BY
	order_date;

--LIKE operator
-- A) The % (percent) wildcard

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE 'z%' --starting with z % means one or more preceding charecters.
ORDER BY
    first_name;

--Query customers whose last name ends with the string 'er'

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '%er' --ending with 'er', % means zero or more succeeding charecters.
ORDER BY
    first_name;

-- Retrieve the customers whose last name starts with the letter t and ends with the letter s

SELECT 
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE 
	last_name LIKE 't%s'
ORDER BY
	first_name;

--The _ (underscore) wildcard example

--customers where the second character is the letter u

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '_u%'
ORDER BY
    first_name; 

--The [list of characters] wildcard example
-- the following query returns the customers where the first character in the last name is Y or Z
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '[YZ]%'
ORDER BY
    last_name;

--The [character-character] wildcard example
-- the following query finds the customers where the first character in the last name is the letter in the range A through C:

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '[A-C]%'
ORDER BY
    first_name;

--The [^Character List or Range] wildcard example
-- the following query returns the customers where the first character in the last name is not the letter in the range A through X:

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '[^A-X]%'
ORDER BY
    last_name;

--The NOT LIKE operator
--The following example uses the NOT LIKE operator to find customers where the first character in the first name is not the letter A:
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    first_name NOT LIKE 'A%'
ORDER BY
    first_name;

--SQL Server LIKE with ESCAPE example

--CREATE TABLE sales.feedbacks (
--   feedback_id INT IDENTITY(1, 1) PRIMARY KEY, 
--    comment     VARCHAR(255) NOT NULL
--);
--INSERT INTO sales.feedbacks(comment)
--VALUES('Can you give me 30% discount?'),
--      ('May I get me 30USD off?'),
--      ('Is this having 20% discount today?');

SELECT * FROM sales.feedbacks;

SELECT 
   feedback_id,
   comment
FROM 
   sales.feedbacks
WHERE 
   comment LIKE '%30%';


SELECT 
   feedback_id, 
   comment
FROM 
   sales.feedbacks
WHERE 
   comment LIKE '%30!%%' ESCAPE '!';

--SQL Server column alias
-- concatenation

SELECT
    first_name + ' ' + last_name
FROM
    sales.customers
ORDER BY
    first_name;

--AS keyword

SELECT
    first_name + ' ' + last_name AS full_name
FROM
    sales.customers
ORDER BY
    first_name;

--JOINS 
--CREATE SCHEMA hr;
--GO
--CREATE TABLE hr.candidates(
--    id INT PRIMARY KEY IDENTITY,
--    fullname VARCHAR(100) NOT NULL
--);
--CREATE TABLE hr.employees(
--    id INT PRIMARY KEY IDENTITY,
--    fullname VARCHAR(100) NOT NULL
--);
--INSERT INTO 
--    hr.candidates(fullname)
--VALUES
--    ('John Doe'),
--    ('Lily Bush'),
--    ('Peter Drucker'),
--    ('Jane Doe');


--INSERT INTO 
--    hr.employees(fullname)
--VALUES
--    ('John Doe'),
--    ('Jane Doe'),
--    ('Michael Scott'),
--    ('Jack Sparrow');


-- A) LEFT_ TABLE == candidate   B) RIGHT_TABLE == employee

-- INER JOIN (intersecion)

SELECT
	c.id candidate_id,
	c.fullname candidate_name,
	e.id employee_id,
	e.fullname employee_name
FROM
	hr.candidates c
	INNER JOIN 
	hr.employees e
	ON
	e.fullname = c.fullname;

--LEFT JOIN

SELECT  
	c.id candidate_id,
	c.fullname candidate_name,
	e.id employee_id,
	e.fullname employee_name
FROM 
	hr.candidates c
	LEFT JOIN hr.employees e 
		ON e.fullname = c.fullname;

--To get the rows that are available only in the left table but not in the right table, you add a WHERE clause

SELECT  
    c.id candidate_id,
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM 
    hr.candidates c
    LEFT JOIN hr.employees e 
        ON e.fullname = c.fullname
WHERE 
    e.id IS NULL;

-- Right Join

SELECT  
    c.id candidate_id,
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM 
    hr.candidates c
    RIGHT JOIN hr.employees e 
        ON e.fullname = c.fullname;

--you can get rows that are available only in the right table by adding a WHERE clause 

SELECT  
    c.id candidate_id,
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM 
    hr.candidates c
    RIGHT JOIN hr.employees e 
        ON e.fullname = c.fullname
WHERE
    c.id IS NULL;

--full join

SELECT  
    c.id candidate_id,
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM 
    hr.candidates c
    FULL JOIN hr.employees e 
        ON e.fullname = c.fullname;

--To select rows that exist either left or right table, you exclude rows that are common to both tables by adding a WHERE clause

SELECT  
    c.id candidate_id,
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM 
    hr.candidates c
    FULL JOIN hr.employees e 
        ON e.fullname = c.fullname
WHERE
    c.id IS NULL OR
    e.id IS NULL;

-- INNER JOINS

SELECT 
	p.product_name, 
	c.category_name,
	p.list_price
FROM 
	production.products p
	INNER JOIN
	production.categories c
	ON
	c.category_id = p.category_id
ORDER BY
	product_name;

--

SELECT
    product_name,
    category_name,
    brand_name,
    list_price
FROM
    production.products p
INNER JOIN production.categories c ON c.category_id = p.category_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
ORDER BY
    product_name DESC;

-- LEFT JOIN

SELECT
    product_name,
    order_id
FROM
    production.products p
LEFT JOIN sales.order_items o ON o.product_id = p.product_id
ORDER BY
    order_id;

--NULL

SELECT
    product_name,
    order_id
FROM
    production.products p
LEFT JOIN sales.order_items o ON o.product_id = p.product_id
WHERE order_id IS NULL
ORDER BY
    order_id;

--Multiple Left Join

SELECT
    p.product_name,
    o.order_id,
    i.item_id,
    o.order_date
FROM
    production.products p
	LEFT JOIN sales.order_items i
		ON i.product_id = p.product_id
	LEFT JOIN sales.orders o
		ON o.order_id = i.order_id
ORDER BY
    order_id;

-- Left Join with WHERE clause

SELECT
    product_name,
    order_id
FROM
    production.products p
LEFT JOIN sales.order_items o 
   ON o.product_id = p.product_id
WHERE order_id = 100
ORDER BY
    order_id;

-- LEFT JOIN with AND Operator

SELECT
    p.product_id,
    product_name,
    order_id
FROM
    production.products p
    LEFT JOIN sales.order_items o 
         ON o.product_id = p.product_id AND 
            o.order_id = 100
ORDER BY
    order_id DESC;

-- RIGHT JOIN

SELECT
    product_name,
    order_id
FROM
    sales.order_items o
    RIGHT JOIN production.products p 
        ON o.product_id = p.product_id
ORDER BY
    order_id;

-- NULL

SELECT
    product_name,
    order_id
FROM
    sales.order_items o
    RIGHT JOIN production.products p 
        ON o.product_id = p.product_id
WHERE 
    order_id IS NULL
ORDER BY
    product_name;

-- CROSS JOIN

SELECT
    product_id,
    product_name,
    store_id,
    0 AS quantity
FROM
    production.products
CROSS JOIN sales.stores
ORDER BY
    product_name,
    store_id;

--CREATE TRIGGER example
--1) Create a table for logging the changes

--CREATE TABLE production.product_audits(
--    change_id INT IDENTITY PRIMARY KEY,
--    product_id INT NOT NULL,
--    product_name VARCHAR(255) NOT NULL,
--    brand_id INT NOT NULL,
--    category_id INT NOT NULL,
--    model_year SMALLINT NOT NULL,
--    list_price DEC(10,2) NOT NULL,
--    updated_at DATETIME NOT NULL,
--    operation CHAR(3) NOT NULL,
--    CHECK(operation = 'INS' or operation='DEL')
--);

--Creating an after DML trigger

CREATE TRIGGER production.trg_product_audit
ON production.products
AFTER INSERT, DELETE
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO
    production.product_audits
        (
            product_id,
            product_name,
            brand_id,
            category_id,
            model_year,
            list_price,
            updated_at,
            operation
        )
SELECT
    i.product_id,
    product_name,
    brand_id,
    category_id,
    model_year,
    i.list_price,
    GETDATE(),
    'INS'
FROM
    inserted AS i
UNION ALL
    SELECT
        d.product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        d.list_price,
        getdate(),
        'DEL'
    FROM
        deleted AS d;
END

-- Testing the Trigger

INSERT INTO production.products(
    product_name, 
    brand_id, 
    category_id, 
    model_year, 
    list_price
)
VALUES (
    'Test product',
    1,
    1,
    2019,
    700
);

---

SELECT 
    * 
FROM 
    production.product_audits;

--

DELETE FROM 
    production.products
WHERE 
    product_id = 324;

--

SELECT 
    * 
FROM 
    production.product_audits;

--SQL Server AVG()
SELECT
    AVG(list_price)
FROM
    production.products;

--eturns the average list price for each product category
SELECT
    category_name,
    CAST(ROUND(AVG(list_price),2) AS DEC(10,2))
    avg_product_price
FROM
    production.products p
    INNER JOIN production.categories c 
        ON c.category_id = p.category_id
GROUP BY
    category_name
ORDER BY
    category_name;

--AVG() in HAVING clause
SELECT
    brand_name,
    CAST(ROUND(AVG(list_price),2) AS DEC(10,2))
    avg_product_price
FROM
    production.products p
    INNER JOIN production.brands c ON c.brand_id = p.brand_id
GROUP BY
    brand_name
HAVING
    AVG(list_price) > 500
ORDER BY
    avg_product_price;

--COUNT() function

SELECT 
   COUNT(*)
FROM 
    production.products
WHERE 
    model_year = 2016
    AND list_price > 999.99;

--COUNT() with GROUP BY clause 

SELECT 
    category_name,
    COUNT(*) product_count
FROM
    production.products p
    INNER JOIN production.categories c 
    ON c.category_id = p.category_id
GROUP BY 
    category_name
ORDER BY
    product_count DESC;

-- total stocks by store id


SELECT
    store_id,
    SUM(quantity) store_stocks
FROM
    production.stocks
GROUP BY
    store_id;

-- stocks for each product and returns only products whose stocks are greater than 100
SELECT
    product_name,
    SUM(quantity) total_stocks
FROM
    production.stocks s
    INNER JOIN production.products p
        ON p.product_id = s.product_id
GROUP BY
    product_name
HAVING
    SUM(quantity) > 100
ORDER BY
    total_stocks DESC;

-- brand name and the highest list price of products in each brand

SELECT
    brand_name,
    MAX(list_price) max_list_price
FROM
    production.products p
    INNER JOIN production.brands b
        ON b.brand_id = p.brand_id 
GROUP BY
    brand_name
ORDER BY
    brand_name;

--find the lowest list price for each product category

SELECT
    category_name,
    MIN(list_price) min_list_price
FROM
    production.products p
    INNER JOIN production.categories c 
        ON c.category_id = p.category_id 
GROUP BY
    category_name
ORDER BY
    category_name;

-- SQL Views

CREATE VIEW sales.daily_sales
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    product_name,
    quantity * i.list_price AS sales
FROM
    sales.orders AS o
INNER JOIN sales.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN production.products AS p
    ON p.product_id = i.product_id;

-- Query the view 

SELECT 
    * 
FROM 
    sales.daily_sales
ORDER BY
    y, m, d, product_name;

--Indexed View OR Materialized View

CREATE VIEW product_master
WITH SCHEMABINDING
AS 
SELECT
    product_id,
    product_name,
    model_year,
    list_price,
    brand_name,
    category_name
FROM
    production.products p
INNER JOIN production.brands b 
    ON b.brand_id = p.brand_id
INNER JOIN production.categories c 
    ON c.category_id = p.category_id;

--Query The materialized view

SELECT
	*
FROM
	product_master