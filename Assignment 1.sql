-CREATE DATABASE Training;

CREATE SCHEMA Bank;

CREATE TABLE Bank.customers 
(
	customer_id INT IDENTITY (301, 1) PRIMARY KEY,
	branch_id INT,
	first_name VARCHAR (30) NOT NULL,
	last_name VARCHAR (30) NOT NULL,
	city VARCHAR (30) NOT NULL,
	phone VARCHAR (10) NOT NULL UNIQUE,
	occupation VARCHAR (20),
	dob DATE,
	FOREIGN KEY (branch_id) REFERENCES Bank.branch(branch_id)
	ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE Bank.branch 
(	
	branch_id INT PRIMARY KEY,
	branch_name VARCHAR (30) UNIQUE NOT NULL,
	branch_city VARCHAR (20) NOT NULL,
);

CREATE TABLE Bank.accounts
(
	account_no INT PRIMARY KEY,
	customer_id INT UNIQUE NOT NULL,
	branch_id INT NOT NULL,
	opening_balance BIGINT,
	opening_date DATE,
	account_type VARCHAR(10),
	account_status VARCHAR(10),
	FOREIGN KEY (customer_id) REFERENCES Bank.customers(customer_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (branch_id)   REFERENCES Bank.branch(branch_id)
	ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Bank.account_balance
(
	customer_id INT NOT NULL,
	account_no	INT PRIMARY KEY,
	amount BIGINT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES Bank.customers(customer_id)
	ON DELETE NO ACTION ON UPDATE NO ACTION
);

INSERT INTO Bank.branch
VALUES
	(005, 'Mahim', 'Mumbai'),
	(012, 'New delhi new branch', 'Delhi'),
	(015, 'Mandvi', 'Hydrabad'),
	(017, 'Kodambakkam', 'Chennai'),
	(032, 'Satellite', 'Ahmedabad');

INSERT INTO Bank.customers
	VALUES
	(012,'Ramesh','Sharma','Delhi', '9876198345', 'Service', '1976-12-06'),
	(005,'Chitresh','Barwe','Mumbai', '9765178901', 'Student', '1998-04-12'),
	(032,'Parul','Gandhi','Ahmedabad', '8976523190', 'Housewife', '1981-04-18'),
	(015,'Amit','Nair','Hydrabad', '7954198761', 'Doctor', '1989-03-15'),
	(012,'janhvi','Dutta','Delhi', '8765489076', 'Student', '2000-06-29');

INSERT INTO Bank.accounts
VALUES
	(54012, 301, 012, 15000, '2012-12-15', 'Saving', 'Active'),
	(54322, 302, 005, 10000, '2012-06-12', 'Saving', 'Active'),
	(54795, 303, 032, 12000, '2013-01-27', 'Saving', 'Active'),
	(54124, 304, 015, 10000, '2008-11-30', 'Saving', 'Terminated'),
	(54965, 305, 012, 10000, '2012-10-02', 'Saving', 'Active');

INSERT INTO Bank.account_balance
VALUES
	(301, 54012, 54500),
	(302, 54322, 22300),
	(303, 54795, 15050),
	(304, 54124, 90500),
	(305, 54965, 65000);

-- CRUD Operations and TRIGGERS

--CREATE Operation
CREATE TABLE Bank.account_audits
(
	change_id INT IDENTITY PRIMARY KEY,
	customer_id INT NOT NULL,
	branch_id	INT NOT NULL,
	account_no	INT NOT NULL,
	first_name	VARCHAR (30) NOT NULL,
	last_name VARCHAR (10) NOT NULL,
	phone VARCHAR (10) NOT NULL,
	account_type VARCHAR (10) NOT NULL,
	account_status VARCHAR (10) NOT NULL,
	updated_at DATETIME NOT NULL,
	operation CHAR(3) NOT NULL,
	CHECK(operation = 'INS' or operation='DEL')
)	


-- READ Operation
SELECT
	a.customer_id,
	a.branch_id,
	a.account_no,
	c.first_name,
	c.last_name,
	c.phone,
	a.account_type,
	account_status
FROM
	Bank.accounts  a INNER JOIN Bank. customers c 
	ON
	c.customer_id = a.customer_id
WHERE
	a.customer_id = 302;


-- TRIGGER 

CREATE TRIGGER Bank.trg_account_audit
ON Bank.accounts
AFTER INSERT, DELETE
AS
BEGIN
SET NOCOUNT ON
INSERT INTO 
	Bank.account_audits
		(
			customer_id,
			branch_id,
			account_no,
			first_name,
			last_name ,
			phone,	
			account_type,
			account_status,
			updated_at,
			operation
		)
SELECT
			i.customer_id,
			i.branch_id,
			i.account_no,
			c.first_name,
			c.last_name ,
			c.phone,	
			i.account_type,
			i.account_status,
			GETDATE(),
			'INS'
FROM
	inserted AS i JOIN Bank. customers c 
	ON
	c.customer_id = i.customer_id 
UNION ALL
SELECT
			d.customer_id,
			d.branch_id,
			d.account_no,
			c.first_name,
			c.last_name ,
			c.phone,	
			d.account_type,
			d.account_status,
			GETDATE(),
			'DEL'
FROM
	deleted AS d JOIN Bank. customers c 
	ON
	c.customer_id = d.customer_id
END

-- DELETE Operation

DELETE FROM 
	Bank.accounts 
WHERE 
	account_no = '54124';

-- TIGGERED ACTION ON DELETE OPERATION
SELECT 
	* 
FROM 
	Bank.account_audits;

-- UPDATE Operation
UPDATE 
	Bank.account_balance 
SET 
	amount = 25050 
WHERE 
	account_no = 54795;

--STORED PROCEDURE

CREATE PROC uspTotalAmount
AS
BEGIN
	SELECT
		SUM(amount) AS Toal_amount
	FROM
		Bank.account_balance;
END

EXEC uspTotalAmount;



CREATE PROC uspGetDetails (@customer_id AS INT)
AS 
BEGIN
	SELECT
		a.customer_id,
		a.account_no,
		ab.amount,
		c.first_name,
		c.last_name,
		c.phone,
		b.branch_id,
		b.branch_name,
		b.branch_city
	FROM
		Bank.accounts a 
		INNER JOIN 
		Bank.customers c
		ON
		c.customer_id = a.customer_id
		INNER JOIN 
		Bank.account_balance ab
		ON
		ab.account_no = a.account_no
		INNER JOIN 
		Bank.branch b
		ON
		b.branch_id = a.branch_id
	WHERE
		a.customer_id = @customer_id
END;

EXEC uspGetDetails 302; 

--conncurrency control using transaction isolation WITH Stored Producer 
--This Transaction Sp satisfy all the ACID property
-- IF transaction is uncommitable then it will rollback which satisfy Atomicity.
-- If atomicity is maintained then and only then we keep our data in database consistent.
-- Due to use Isolation property we have also achived concurrent access
CREATE PROC usp_report_error
AS
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  
GO

ALTER PROC uspTransaction (@from_acc_no AS INT, @to_acc_no AS INT, @amount AS INT)
AS
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @from_acc_balance INT, @to_acc_balance INT;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	BEGIN TRAN
		SET @from_acc_balance = (SELECT amount FROM Bank.account_balance WHERE account_no = @from_acc_no);
		SET @to_acc_balance   = (SELECT amount FROM Bank.account_balance WHERE account_no = @to_acc_no);

		PRINT 'Balance of account No ' + CONVERT(VARCHAR(6), @from_acc_no) + ' is ' + CONVERT(VARCHAR(6),@from_acc_balance) + ' Rs.' ;
		PRINT 'Balance of account No ' + CONVERT(VARCHAR(6), @to_acc_no) + ' is ' + CONVERT(VARCHAR(6),@to_acc_balance) + ' Rs.';

		 SET @from_acc_balance = @from_acc_balance - @amount;
		 SET @to_acc_balance = @to_acc_balance + @amount;

		UPDATE Bank.account_balance SET amount = @from_acc_balance WHERE account_no = @from_acc_no;
		UPDATE Bank.account_balance SET amount = @to_acc_balance WHERE account_no = @to_acc_no;

		PRINT CONVERT(VARCHAR(6), @amount) + ' Rs. is debited from account No ' + CONVERT(VARCHAR(6), @from_acc_no) + ' current balance is ' + CONVERT(VARCHAR(6),@from_acc_balance) + ' Rs.' ;
		PRINT CONVERT(VARCHAR(6), @amount) + ' Rs. is credited to account No ' + CONVERT(VARCHAR(6), @to_acc_no) + ' current balance is ' + CONVERT(VARCHAR(6),@to_acc_balance) + ' Rs.' ;

		WAITFOR DELAY '00:01:00'
	COMMIT TRAN
	PRINT 'Transaction Commited!';

END TRY
BEGIN CATCH
	-- report exception
	EXEC usp_report_error;
	 
	 -- Test if the transaction is uncommittable.  
        IF (XACT_STATE()) = -1  
        BEGIN  
            PRINT  N'The transaction is in an uncommittable state.' +  
                    'Rolling back transaction.'  
            ROLLBACK TRANSACTION;  
        END;  
        
        -- Test if the transaction is committable.  
        IF (XACT_STATE()) = 1  
        BEGIN  
            PRINT N'The transaction is committable.' +  
                'Committing transaction.'  
            COMMIT TRANSACTION;     
        END;  

END CATCH

CREATE PROC uspTransaction_without_delay (@from_acc_no AS INT, @to_acc_no AS INT, @amount AS INT)
AS
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @from_acc_balance INT, @to_acc_balance INT;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	BEGIN TRAN
		SET @from_acc_balance = (SELECT amount FROM Bank.account_balance WHERE account_no = @from_acc_no);
		SET @to_acc_balance   = (SELECT amount FROM Bank.account_balance WHERE account_no = @to_acc_no);

		PRINT 'Balance of account No ' + CONVERT(VARCHAR(6), @from_acc_no) + ' is ' + CONVERT(VARCHAR(6),@from_acc_balance) + ' Rs.' ;
		PRINT 'Balance of account No ' + CONVERT(VARCHAR(6), @to_acc_no) + ' is ' + CONVERT(VARCHAR(6),@to_acc_balance) + ' Rs.';

		 SET @from_acc_balance = @from_acc_balance - @amount;
		 SET @to_acc_balance = @to_acc_balance + @amount;

		UPDATE Bank.account_balance SET amount = @from_acc_balance WHERE account_no = @from_acc_no;
		UPDATE Bank.account_balance SET amount = @to_acc_balance WHERE account_no = @to_acc_no;

		PRINT CONVERT(VARCHAR(6), @amount) + ' Rs. is debited from account No ' + CONVERT(VARCHAR(6), @from_acc_no) + ' current balance is ' + CONVERT(VARCHAR(6),@from_acc_balance) + ' Rs.' ;
		PRINT CONVERT(VARCHAR(6), @amount) + ' Rs. is credited to account No ' + CONVERT(VARCHAR(6), @to_acc_no) + ' current balance is ' + CONVERT(VARCHAR(6),@to_acc_balance) + ' Rs.' ;

		--WAITFOR DELAY '00:01:00'
	COMMIT TRAN
	PRINT 'Transaction Commited!';

END TRY
BEGIN CATCH
	-- report exception
	EXEC usp_report_error;
	 
	 -- Test if the transaction is uncommittable.  
        IF (XACT_STATE()) = -1  
        BEGIN  
            PRINT  N'The transaction is in an uncommittable state.' +  
                    'Rolling back transaction.'  
            ROLLBACK TRANSACTION;  
        END;  
        
        -- Test if the transaction is committable.  
        IF (XACT_STATE()) = 1  
        BEGIN  
            PRINT N'The transaction is committable.' +  
                'Committing transaction.'  
            COMMIT TRANSACTION;     
        END;  

END CATCH

-- run two transaction at the same time in differnt instance
EXEC uspTransaction 54322, 54124, 2000;EXEC uspTransaction_without_delay 54124, 54795, 150;


-- Lastly The Durability:
--This property ensures that once the transaction has completed execution, 
--the updates and modifications to the database are stored in and written to disk 
--and they persist even if a system failure occurs. 
--These updates now become permanent and are stored in non-volatile memory. 
--The effects of the transaction, thus, are never lost. 

BACKUP DATABASE Training
TO DISK = 'C:\DB BAK'
--WITH DIFFERENTIAL
-- A differential back up only backs up the parts of the database that have changed since the last full database backup.

--Views, Temp Table. Table Variables, Comman table expression

CREATE VIEW vw_customer_account
AS
SELECT
	a.customer_id,
	a.account_no,
	c.first_name,
	c.last_name,
	b.amount
FROM
	Bank.accounts a
	JOIN
	Bank.customers c
	ON
	a.customer_id  = c.customer_id
	JOIN 
	Bank.account_balance b
	ON
	b.account_no = a.account_no

SELECT * FROM vw_customer_account WHERE customer_id > 302;
--Seved on DB available to other queries and Sp

--TEMP TABLE
SELECT
	a.customer_id,
	a.account_no,
	c.first_name,
	c.last_name,
	b.amount
INTO
	#TempCustomerAccount
FROM
	Bank.accounts a
	JOIN
	Bank.customers c
	ON
	a.customer_id  = c.customer_id
	JOIN 
	Bank.account_balance b
	ON
	b.account_no = a.account_no

SELECT * FROM #TempCustomerAccount WHERE customer_id > 302;

--local temp table stored in TempDB, vissable only to the current session
--can be shared between nested SPs
--global temp table shared between session and get distory after last session with table connection get closed

-- Table Variable
DECLARE @TblCustomerAccount TABLE (customer_id INT, account_no INT,first_name VARCHAR (30),
	last_name VARCHAR (30), amount BIGINT)

INSERT @TblCustomerAccount
SELECT
	a.customer_id,
	a.account_no,
	c.first_name,
	c.last_name,
	b.amount
FROM
	Bank.accounts a
	JOIN
	Bank.customers c
	ON
	a.customer_id  = c.customer_id
	JOIN 
	Bank.account_balance b
	ON
	b.account_no = a.account_no

SELECT * FROM @TblCustomerAccount WHERE customer_id > 302

--table var also created in TempDB
--Scope of TEMP Table is ijn the batch
-- can be passed as parameter in SPs

--Derived Table
SELECT
	*
FROM	(
			SELECT
				a.customer_id,
				a.account_no,
				c.first_name,
				c.last_name,
				b.amount
			FROM
				Bank.accounts a
				JOIN
				Bank.customers c
				ON
				a.customer_id  = c.customer_id
				JOIN 
				Bank.account_balance b
				ON
				b.account_no = a.account_no

		) as dtCustomerAccount
WHERE
	customer_id > 302;

-- Only available only fro current query

--CTE

WITH cte_customer_account 
AS
(
SELECT
	a.customer_id,
	a.account_no,
	c.first_name,
	c.last_name,
	b.amount
FROM
	Bank.accounts a
	JOIN
	Bank.customers c
	ON
	a.customer_id  = c.customer_id
	JOIN 
	Bank.account_balance b
	ON
	b.account_no = a.account_no
)
SELECT
	*
FROM
	cte_customer_account
WHERE
	customer_id > 302;

--temporary result set defined within execution scope of a single SELECT, IINSERT, DELETE, UPDATE OR VIEW
