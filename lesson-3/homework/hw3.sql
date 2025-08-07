--Lesson 3: Importing and Exporting Data
--✅ Importing Data (BULK INSERT, Excel, Text) ✅ Exporting Data (Excel, Text) ✅ Comments, Identity column, NULL/NOT NULL values ✅ Unique Key, Primary Key, Foreign Key, Check Constraint ✅ Differences between UNIQUE KEY and PRIMARY KEY

--Notes before doing the tasks:

--Tasks should be solved using SQL Server.
--Case insensitivity applies.
--Alias names do not affect the score.
--Scoring is based on the correct output.
--One correct solution is sufficient.

--🟢 Easy-Level Tasks (10)
	--1. Define and explain the purpose of BULK INSERT in SQL Server.

--BULK INSERT is used to quickly import large volumes of data from external files (like .txt, .csv) into a SQL Server table. It reads the data file and inserts the contents directly into the database table, which is much faster than inserting rows one by one.

	--2. List four file formats that can be imported into SQL Server.

--1)CSV (.csv)
--2)TXT (.txt)
--3)Excel (.xlsx, .xls)
--4)XML (.xml)

	--3. Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).

CREATE TABLE Products (
ProductID INT PRIMARY KEY, 
ProductName VARCHAR(50),
Price DECIMAL (10,2)
);

	--4. Insert three records into the Products table using INSERT INTO.

INSERT INTO Products (ProductID, ProductName, Price)
VALUES
(1, 'Laptop', 1400),
(2, 'Phone', 999),
(3, 'Headphones', 250);

	--5. Explain the difference between NULL and NOT NULL.

--NULL means that a column can store missing or unknown values.

--NOT NULL means the column must always have a value and cannot be left empty.

	--6. Add a UNIQUE constraint to the ProductName column in the Products table.

ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

	--7. Write a comment in a SQL query explaining its purpose.
	
	-- This is a single-line comment
	--	SQL Server requires you to give the constraint a name if you're using ADD CONSTRAINT.
	--Example: ADD CONSTRAINT UQ_ProductName

	/*
This is a multi-line comment.
UQ_ProductName is just an example name — it can be anything you choose, but SQL Server requires a name when using ADD CONSTRAINT
UQ_Table_Column for unique constraints
PK_Table for primary keys
FK_Table_Column for foreign keys
*/

	--8. Add CategoryID column to the Products table.

	ALTER TABLE Products
	ADD CategoryID INT;

	--9. Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.

	CREATE TABLE Categories (
	CategoryID INT PRIMARY KEY,
	CategoryName VARCHAR(50) UNIQUE
	);

	--10. Explain the purpose of the IDENTITY column in SQL Server.

--	The IDENTITY column in SQL Server is used to automatically generate unique numeric values for a column, typically for primary keys. It eliminates the need to manually insert values for the column, ensuring each new row gets a unique and sequential value.
--The syntax is:
--COLUMN_NAME INT IDENTITY(seed, increment)
--Seed is the starting number.
--Increment is the amount to increase each new value.

--Example:
--ProductID INT IDENTITY(1, 1)
--This starts from 1 and increases by 1 for each new row:
--First row: 1
--Second row: 2
--Third row: 3

--🟠 Medium-Level Tasks (10)
	--11. Use BULK INSERT to import data from a text file into the Products table.

BULK INSERT Emails
FROM 'C:\Users\islom\Desktop\MAAB Classes\Source\Emails.csv'
WITH
(
	FIRSTROW = 2, 
	FIELDTERMINATOR = ',', 
	ROWTERMINATOR = '\r\n', 
	TABLOCK
);

	--12. Create a FOREIGN KEY in the Products table that references the Categories table.

	ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID);

	--13. Explain the differences between PRIMARY KEY and UNIQUE KEY.

--Features of Primary key:
--Uniqueness - Ensures all values are unique
--NULLS not allowed (no NULLs at all)
--Only one primary key per table
--Clustered index (by default) 
--Identifies each record uniquely

--Features of UNIQUE KEY
--Uniqueness - Ensures all values are unique
--NULL is allowed (only one NULL in SQL Server)
--Can have multiple unique keys
--Non-clustered index (by default)
--Ensures no duplicate in specific column(s)
--In short, both ensure uniqueness, but a primary key is used to uniquely identify records, while a unique key ensures no duplicates in additional important columns.

	--14. Add a CHECK constraint to the Products table ensuring Price > 0.

ALTER TABLE Products
ADD CONSTRAINT CK_Products_Price CHECK (Price > 0);

	--15. Modify the Products table to add a column Stock (INT, NOT NULL).

	ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;

	--16. Use the ISNULL function to replace NULL values in Price column with a 0.

	SELECT ProductID, ProductName, ISNULL(Price, 0) AS Price
FROM Products;

	--17. Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.

--	A FOREIGN KEY is used to establish a relationship between two tables in SQL Server.

--It ensures referential integrity, meaning:
--A value in one table (child) must match a value in another table (parent),
--Or it must be NULL, if the relationship allows that.
--In SQL Server, a FOREIGN KEY is created using:
--ALTER TABLE Products
--ADD CONSTRAINT FK_Products_Categories
--FOREIGN KEY (CategoryID)
--REFERENCES Categories(CategoryID);

--Benefits:
--Prevents orphan records (e.g., a product with a non-existent category)
--Helps keep your data clean and consistent
--Enforces relationships between tables

--🔴 Hard-Level Tasks (10)
	--18. Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.

CREATE TABLE Customers
(CustID INT PRIMARY KEY,
Cust_Name VARCHAR(50),
Age INT CHECK (Age >= 18)
);

	--19. Create a table with an IDENTITY column starting at 100 and incrementing by 10.

	CREATE TABLE homework3
	(ID INT PRIMARY KEY IDENTITY (100,10),
	Name VARCHAR(50) NOT NULL
	);

	--20. Write a query to create a composite PRIMARY KEY in a new table OrderDetails.

	CREATE TABLE OrderDetails
	(
	OrderID INT,
	ProductID INT,
	Quantity INT,
	Price INT,
	PRIMARY KEY (OrderID, ProductID)
	);


	--21. Explain the use of COALESCE and ISNULL functions for handling NULL values.

	In SQL Server, both COALESCE and ISNULL are used to replace NULL values with a specified value. However, there are some important differences between them.

ISNULL(expression, replacement_value)
Returns the replacement_value only if expression is NULL.
Otherwise, returns expression itself.
The return type is the same as the first argument (expression).
Example:
SELECT ISNULL(Price, 0) AS Price FROM Products;
This returns 0 if Price is NULL.

COALESCE(expr1, expr2, ..., exprN)
Returns the first non-NULL value from the list of expressions.
Can take multiple arguments, unlike ISNULL.
The return type is determined by data type precedence among the arguments (this can sometimes affect behavior).
Example:
SELECT COALESCE(Price, DiscountPrice, 0) AS FinalPrice FROM Products;
This will return the first non-null value among Price, DiscountPrice, or 0.

Key Differences:
Feature	ISNULL	COALESCE
Number of Arguments	2 (fixed)	Multiple
Return Type	Same as first argument	Depends on highest precedence
| Feature                 | ISNULL                 | COALESCE                           |
| ----------------------- | ---------------------- | ---------------------------------- |
| **Number of Arguments** | 2 (fixed)              | Multiple                           |
| **Return Type**         | Same as first argument | Depends on highest precedence      |
| **ANSI Standard**       | ❌ SQL Server-specific  | ✅ ANSI-compliant                |
| **Flexibility**         | Less flexible          | More flexible (multiple fallbacks) |

Summary:
Use ISNULL when you need a simple null check with just one fallback.
Use COALESCE when you need multiple fallback options or want ANSI-compliant code.

	--22. Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.

	CREATE TABLE Employees
	(
	EmpID INT PRIMARY KEY,
	Email VARCHAR(50) UNIQUE
	);

	--23. Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.

ALTER TABLE OrderDetails
ADD CONSTRAINT FK_OrderDetails_Orders
FOREIGN KEY (OrderID)
REFERENCES Orders(OrderID)
ON DELETE CASCADE
ON UPDATE CASCADE;
