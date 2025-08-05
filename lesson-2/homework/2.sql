--# Lesson 2: DDL and DML Commands


--### **Basic-Level Tasks (10)**  
--1. Create a table `Employees` with columns: `EmpID` INT, `Name` (VARCHAR(50)), and `Salary` (DECIMAL(10,2)).
CREATE TABLE Employees 
(EmpID INT,Name VARCHAR(50), Salary DECIMAL(10,2));

SELECT * FROM employees
--2. Insert three records into the `Employees` table using different INSERT INTO approaches (single-row insert and multiple-row insert). 

--single-row insert:
INSERT INTO Employees 
VALUES (1, 'Aisha', 6500.00);

--multiple-row insert:
INSERT INTO Employees
VALUES 
    (2, 'Abdulaziz', 6000.00),
    (3, 'Sara', 5000.00);


--3. Update the `Salary` of an employee to `7000` where `EmpID = 1`. 

UPDATE Employees
SET Salary = 7000
WHERE EmpID = 1;


--4. Delete a record from the `Employees` table where `EmpID = 2`.  

DELETE FROM Employees
WHERE EmpID = 2;


--5. Give a brief definition for difference between `DELETE`, `TRUNCATE`, and `DROP`.

--DELETE - Removes specific rows (can use WHERE). Keeps the table.

--TRUNCATE - Removes all rows quickly but keeps the table.

--DROP - Removes the entire table (structure + data).


--6. Modify the `Name` column in the `Employees` table to `VARCHAR(100)`.

ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);


--7. Add a new column `Department` (`VARCHAR(50)`) to the `Employees` table.  

ALTER TABLE Employees
ADD Department VARCHAR(50);


--8. Change the data type of the `Salary` column to `FLOAT`. 

ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;

--9. Create another table `Departments` with columns `DepartmentID` (INT, PRIMARY KEY) and `DepartmentName` (VARCHAR(50)). 

CREATE table Departments
(DepartmentID INT PRIMARY KEY, DepartmentName VARCHAR(50));

--10. Remove all records from the `Employees` table without deleting its structure.  

TRUNCATE TABLE Employees

---

### **Intermediate-Level Tasks (6)**  
--11. Insert five records into the `Departments` table using `INSERT INTO SELECT` method(you can write anything you want as data).

INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT 1,'HR'
UNION ALL
SELECT 2,'Marketing'
UNION ALL
SELECT 3,'Management'
UNION ALL
SELECT 4,'Finance'
UNION ALL
SELECT 5,'IT';

--12. Update the `Department` of all employees where `Salary > 5000` to 'Management'. 

UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;

--13. Write a query that removes all employees but keeps the table structure intact. 

TRUNCATE table employees

--14. Drop the `Department` column from the `Employees` table.

ALTER TABLE Employees
DROP COLUMN Department

--15. Rename the `Employees` table to `StaffMembers` using SQL commands. 

exec sp_rename 'Employees', 'StaffMembers';

--16. Write a query to completely remove the `Departments` table from the database.  

DROP TABLE Departments

---

--### **Advanced-Level Tasks (9)**        
--17. Create a table named Products with at least 5 columns, including: ProductID (Primary Key), ProductName (VARCHAR), Category (VARCHAR), Price (DECIMAL)

CREATE TABLE Products  
(ProductID INT Primary Key, ProductName VARCHAR(50), Category VARCHAR(50), Location VARCHAR(50), Price DECIMAL(10,2));



--18. Add a CHECK constraint to ensure Price is always greater than 0.

ALTER TABLE Products
ADD CONSTRAINT check_price_positive
CHECK (Price > 0);

--19. Modify the table to add a StockQuantity column with a DEFAULT value of 50.

ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;


--20. Rename Category to ProductCategory

exec sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

--21. Insert 5 records into the Products table using standard INSERT INTO queries.

INSERT INTO Products (ProductID, ProductName, ProductCategory, Location, Price, StockQuantity)
VALUES
(1, 'Phone', 'Electronics', 'CA', 1200.00, 50),
(2, 'Laptop', 'Electronics', 'NY', 800.00, 45),
(3, 'T-shirt', 'Clothing', 'DE', 50.00, 250),
(4, 'Sneakers', 'Shoes', 'IL', 250.00, 150),
(5, 'Hoodie', 'Clothing', 'TX', 150.00, 60);

--22. Use SELECT INTO to create a backup table called Products_Backup containing all Products data.

SELECT *
INTO Products_Backup
FROM Products;

--23. Rename the Products table to Inventory.

exec sp_rename 'Products', 'Inventory';

--24. Alter the Inventory table to change the data type of Price from DECIMAL(10,2) to FLOAT.

ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;


--25. Add an IDENTITY column named ProductCode that starts from 1000 and increments by 5 to `Inventory` table.

ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000, 5);
