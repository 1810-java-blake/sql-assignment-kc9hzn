-- Part I – Working with an existing database

-- 1.0	Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.
SELECT * FROM employee;
-- Task – Select all records from the Employee table where last name is King.
SELECT * FROM employee WHERE lastname = 'King';
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM employee WHERE firstname = 'Andrew' AND reportsto ISNULL;
-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SELECT * FROM album ORDER BY title DESC;
-- Task – Select first name from Customer and sort result set in ascending order by city
SELECT firstname FROM customer ORDER BY city ASC;
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
INSERT INTO genre (genreid, name) VALUES (26, 'Ska'), (27, 'Folk');
-- Task – Insert two new records into Employee table
INSERT INTO employee 
(employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email)
VALUES
(9, 'Smith', 'John', 'Night Janitor', 2, '1989-5-14 00:00:00', '2018-10-30 00:00:00', '228 3 Ave E', 'Cardston', 'AB', 'Canada', 'T0K 0K0', '+1 (403) 555-0155', '+1 (403) 555-0156', 'john@chinookcorp.com'),
(10, 'Pederson', 'Ron', 'Sales Support Agent', 2, '1980-2-29 00:00:00', '2018-10-30 00:00:00', '9705 79 Ave NW', 'Edmonton', 'AB', 'Canada', 'T6E 1P9', '+1 (708) 555-0123', '+1 (708) 555-0124', 'ron@chinookcorp.com');
-- Task – Insert two new records into Customer table
INSERT INTO customer
(customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid)
VALUES
(60, 'Douglas', 'Adams', 'Alphabet, Inc.', '1600 Amphitheatre Pkwy', 'Mountain View', 'CA', 'USA', '94043', '+1 (650) 555-0155', NULL, 'douglas.adams@google.com', 10),
(61, 'Tom', 'Tomlin', NULL, '22 Mayflower Way', NULL, NULL, 'Singapore', NULL, '+60 2 8412 3456', NULL, 'tom_tomlin@tomlin.com', 10);
-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE customer SET firstname = 'Robert', lastname = 'Walter' WHERE firstname = 'Aaron' AND lastname = 'Mitchell';
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE artist SET name = 'CCR' WHERE name = 'Creedence Clearwater Revival';
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SELECT * FROM invoice WHERE billingaddress LIKE 'T%';
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SELECT * FROM invoice WHERE total BETWEEN 15 AND 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM employee WHERE hiredate BETWEEN '2003-6-1 00:00:00' AND '2004-3-1 00:00:00';
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
DELETE FROM invoiceline WHERE invoiceid = 50;
DELETE FROM invoiceline WHERE invoiceid = 61;
DELETE FROM invoiceline WHERE invoiceid = 116;
DELETE FROM invoiceline WHERE invoiceid = 245;
DELETE FROM invoiceline WHERE invoiceid = 268;
DELETE FROM invoiceline WHERE invoiceid = 290;
DELETE FROM invoiceline WHERE invoiceid = 342;
DELETE FROM invoice WHERE customerid = 32;
DELETE FROM customer WHERE firstname = 'Robert' AND lastname = 'Walter';

-- 3.0	SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
CREATE OR REPLACE FUNCTION my_now()
RETURNS TEXT AS $$
    BEGIN
        RETURN now();
    END;
$$ LANGUAGE plpgsql;
-- Task – create a function that returns the length of a mediatype from the mediatype table
CREATE OR REPLACE FUNCTION media_type_length(media_type_id INTEGER)
RETURNS INTEGER AS $$
	DECLARE
		media_type_name TEXT;
	BEGIN
		SELECT name INTO media_type_name FROM mediatype WHERE media_type_id = mediatypeid;
		RETURN length(media_type_name);
	END;
$$ LANGUAGE plpgsql;
-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION invoice_average()
RETURNS NUMERIC(10,2) AS $$
	BEGIN
		RETURN AVG(invoice.total) FROM invoice;
	END;
$$ LANGUAGE plpgsql;
-- Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION most_expensive_track()
RETURNS NUMERIC(10,2) AS $$
	BEGIN
		RETURN MAX(unitprice) FROM track;
	END;
$$ LANGUAGE plpgsql;
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION average_invoiceline_price()
RETURNS NUMERIC(10,2) AS $$
	BEGIN
		RETURN AVG(unitprice) FROM invoiceline;
	END;
$$ LANGUAGE plpgsql;
-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
CREATE OR REPLACE FUNCTION born_after_1968()
RETURNS TABLE(
	employeeid INTEGER,
	lastname VARCHAR(20),
	firstname VARCHAR(20),
	title VARCHAR(30),
	reportsto INTEGER,
	birthdate TIMESTAMP,
	hiredate TIMESTAMP,
	address VARCHAR(70),
	city VARCHAR(40),
	state VARCHAR(40),
	country VARCHAR(40),
	postalcode VARCHAR(10),
	phone VARCHAR(24),
	fax VARCHAR(24),
	email VARCHAR(60)
) AS $$
	BEGIN
		RETURN QUERY 
			SELECT employee.employeeid AS employeeid, employee.lastname AS lastname, employee.firstname AS firstname,
				employee.title AS title, employee.reportsto AS reportsto, employee.birthdate AS birthdate,
				employee.hiredate AS hiredate, employee.address AS address, employee.city AS city,
				employee.state AS state, employee.country AS country, employee.postalcode AS postalcode,
				employee.phone AS phone, employee.fax AS fax, employee.email AS email
				FROM employee WHERE (EXTRACT(YEAR FROM employee.birthdate)) > 1968;
	END;
$$ LANGUAGE plpgsql;
-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
CREATE OR REPLACE FUNCTION employee_names()
RETURNS TABLE(
	lastname VARCHAR(20),
	firstname VARCHAR(20)
) AS $$
	BEGIN
		RETURN QUERY 
			SELECT employee.lastname AS lastname, employee.firstname AS firstname
				FROM employee;
	END;
$$ LANGUAGE plpgsql;
-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
CREATE OR REPLACE FUNCTION update_employee(
	employee_id INTEGER,
	last_name VARCHAR(20),
	first_name VARCHAR(20),
	job_title VARCHAR(30),
	reports_to INTEGER,
	birth_date TIMESTAMP,
	hire_date TIMESTAMP,
	home_address VARCHAR(70),
	home_city VARCHAR(40),
	home_state VARCHAR(40),
	home_country VARCHAR(40),
	postal_code VARCHAR(10),
	home_phone VARCHAR(24),
	work_fax VARCHAR(24),
	work_email VARCHAR(60)
)
RETURNS void AS $$
	BEGIN
		UPDATE employee SET lastname = last_name, firstname = first_name,
			title = job_title, reportsto = reports_to, birthdate = birth_date,
			hiredate = hire_date, address = home_address, city = home_city,
			state = home_state, country = home_country,
			postalcode = postal_code, phone = home_phone, fax = work_fax,
			email = work_email WHERE employeeid = employee_id;
	END;
$$ LANGUAGE plpgsql;
-- Task – Create a stored procedure that returns the managers of an employee.
CREATE OR REPLACE FUNCTION find_manager(employee_id INTEGER)
RETURNS TABLE(
	employeeid INTEGER,
	lastname VARCHAR(20),
	firstname VARCHAR(20),
	title VARCHAR(30),
	reportsto INTEGER,
	birthdate TIMESTAMP,
	hiredate TIMESTAMP,
	address VARCHAR(70),
	city VARCHAR(40),
	state VARCHAR(40),
	country VARCHAR(40),
	postalcode VARCHAR(10),
	phone VARCHAR(24),
	fax VARCHAR(24),
	email VARCHAR(60)
) AS $$
	DECLARE
		manager_id INTEGER;
	BEGIN
		SELECT employee.reportsto INTO manager_id FROM employee WHERE employee.employeeid = employee_id;
		RETURN QUERY
			SELECT employee.employeeid AS employeeid, employee.lastname AS lastname, employee.firstname AS firstname,
				employee.title AS title, employee.reportsto AS reportsto, employee.birthdate AS birthdate,
				employee.hiredate AS hiredate, employee.address AS address, employee.city AS city,
				employee.state AS state, employee.country AS country, employee.postalcode AS postalcode,
				employee.phone AS phone, employee.fax AS fax, employee.email AS email
				FROM employee WHERE manager_id = employee.employeeid;
	END;
$$ LANGUAGE plpgsql;
-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
CREATE OR REPLACE FUNCTION customer_data(customer_id INTEGER)
RETURNS TABLE(
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	customer_company VARCHAR(80)
) AS $$
	BEGIN
		RETURN QUERY
			SELECT customer.firstname AS first_name,
				customer.lastname AS last_name,
				customer.company AS customer_company
				FROM customer WHERE customer.customerid = customer_id;
	END;
$$ LANGUAGE plpgsql;
-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
CREATE OR REPLACE FUNCTION delete_invoice(invoice_id INTEGER)
RETURNS void AS $$
	BEGIN
		BEGIN;
			DELETE FROM invoiceline WHERE invoiceline.invoiceid = invoice_id;
			DELETE FROM invoice WHERE invoice.invoiceid = invoice_id;
		COMMIT;
	END;
$$ LANGUAGE plpgsql;
-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
CREATE OR REPLACE FUNCTION create_customer(
first_name TEXT,
last_name TEXT,
company_name TEXT,
cust_address TEXT,
cust_city TEXT,
cust_state TEXT,
cust_country TEXT,
postal_code TEXT,
cust_phone TEXT,
cust_fax TEXT,
cust_email TEXT
)
RETURNS void AS $$
BEGIN
BEGIN;

COMMIT;
END;
$$ LANGUAGE plpgsql;
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.

-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table

-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.


-- 6.2 Before
-- Task – Create a before trigger that restricts the deletion of any invoice that is priced over 50 dollars.

-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SELECT customer.firstname, customer.lastname, invoice.invoiceid
FROM customer
INNER JOIN invoice
ON (customer.customerid = invoice.customerid);
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT customer.customerid, customer.firstname, customer.lastname, invoice.invoiceid, invoice.total
FROM customer
FULL JOIN invoice
ON (customer.customerid = invoice.customerid);
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SELECT artist.name, album.title
FROM artist
RIGHT JOIN album
ON (artist.artistid = album.artistid);
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SELECT *
FROM artist
CROSS JOIN album
ORDER BY artist.name ASC;
-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SELECT one.firstname, one.lastname, two.firstname, two.lastname
FROM employee one
INNER JOIN employee two
ON (one.reportsto = two.employeeid);