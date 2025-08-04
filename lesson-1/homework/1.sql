--	1. Define the following terms: data, database, relational database, and table.
--Data - Raw facts or information.
--Like numbers, names, dates, or any small piece of info.

--Database - place to store and organize data.
--Like company’s database with customers, products, and sales info.

--Relational Database - a database made of tables that can connect to each other.
--Like Excel sheets (tables) that are linked by IDs.

--Table - a structure inside a database to store data in rows and columns.
--Like an Excel sheet rows, columns
	
	
--	2. List five key features of SQL Server.
--1. Create and Manage Databases
--2. Query Data Using SQL
--Use different queries to filter and retrieve data.
--3. Work with Tables
--Create tables, add columns, and insert rows of data.
--4. Basic Data Analysis
--Perform aggregations with SUM, COUNT, AVG, MIN, MAX.
--5. SQL Server Management Studio (SSMS)
--The main tool to write and run SQL queries.
--Explore databases visually.
--Check tables, relationships, and query results easily.
	
	
	--3. What are the different authentication modes available when connecting to SQL Server? (Give at least 2)
--1) Windows Authentication Mode
--2) SQL Server Authentication Mode
	
	
	--4. Create a new database in SSMS named SchoolDB.
create database SchoolDB
	use SchoolDB

	--5. Write and execute a query to create a table called Students with columns: StudentID (INT, PRIMARY KEY), Name (VARCHAR(50)), Age (INT).
CREATE TABLE Students 
(StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT);


	--6. Describe the differences between SQL Server, SSMS, and SQL.
	
--SQL Server → The database engine (stores & processes data).

--SSMS → The tool to connect and manage SQL Server.

--SQL → The language we use to talk to the database.


	--7. Research and explain the different SQL commands: DQL, DML, DDL, DCL, TCL with examples.

--DQL – Data Query Language is used to retrieve data from the database and used just to read it.
--Most common command is SELECT.
--examples: 
--select * from Students;
--select Name, Age from Students;

--DML – Data Manipulation Language is used to modify data inside tables.
--Most common commands are INSERT, UPDATE, DELETE.
--examples:
--INSERT INTO Students (StudentID, Name, Age)
--VALUES
--    (1, 'John', 20),
--    (2, 'David', 22),
--    (3, 'Brad', 21);

--DDL – Data Definition Language is used to define or change the structure of the database like tables or databases.
--Most common commands are CREATE, ALTER, DROP, TRUNCATE
--examples:
--create database SchoolDB;
--CREATE TABLE Students;
--ALTER TABLE Students ADD City VARCHAR(50);
--DROP TABLE Students;
--TRUNCATE TABLE Students;

-- DCL – Data Control Language controls access and permissions to the database.
--used commands - GRANT, REVOKE.
--example:
--GRANT SELECT ON Students TO User1;
--REVOKE SELECT ON Students FROM User1;

--TCL – Transaction Control Language is used to manage transactions to ensure data integrity.
--commands are - COMMIT, ROLLBACK.
--example:
--BEGIN TRANSACTION;
--INSERT INTO Students VALUES (5, 'Ali', 20);
---- To save changes permanently
--COMMIT;
---- to undo changes
--ROLLBACK;

	--8. Write a query to insert three records into the Students table.
INSERT INTO Students (StudentID, Name, Age)
VALUES
    (1, 'John', 20),
    (2, 'David', 22),
    (3, 'Brad', 21);

	SELECT * FROM Students;

	--9. Restore AdventureWorksDW2022.bak file to your server. (write its steps to submit)
--Step 1. Connect to SQL Server.
--2. In object explorer, right-click databases → choose restore database.
--3. In the Source section:
--Select Device → click the … button.
--Click Add, then browse to downloaded .bak file.
--Select AdventureWorksDW2022.bak → Click OK.
--4. Click OK to start the restore process.
--After a successful restore, there'll be a "Database 'AdventureWorksDW2022' restored successfully" message.

--In Databases in Object Explorer window we can find AdventureWorksDW2022. And we can test by running:
USE AdventureWorksDW2022;


