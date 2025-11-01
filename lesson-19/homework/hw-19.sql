--Lesson-19: Stored procedures, Merge and Practice

--# 🔵 Part 1: Stored Procedure Tasks
-----

--## 📄 Task 1:

--Create a stored procedure that:

--- Creates a temp table `#EmployeeBonus`
--- Inserts EmployeeID, FullName (FirstName + LastName), Department, Salary, and BonusAmount into it
--  - (BonusAmount = Salary * BonusPercentage / 100)
--- Then, selects all data from the temp table.

CREATE PROCEDURE sp_GetEmployeeBonuses
AS
BEGIN
CREATE TABLE #EmployeeBonus (
    EmployeeID INT,
    FullName VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    BonusAmount DECIMAL(10,2)
);
INSERT INTO #EmployeeBonus
SELECT
   e.EmployeeID,
   (e.FirstName + ' ' + e.LastName),
   e.Department,
   e.Salary,
   e.Salary * d.BonusPercentage / 100
FROM Employees e
JOIN DepartmentBonus d ON e.Department = d.Department
select * from #EmployeeBonus
END;

EXEC sp_GetEmployeeBonuses;

-----
select * from [dbo].[Employees]
--## 📄 Task 2:

--Create a stored procedure that:

--- Accepts a department name and an increase percentage as parameters
--- Update salary of all employees in the given department by the given percentage
--- Returns updated employees from that department.

CREATE PROCEDURE sp_UpdateSalaryByDept 
    @Department NVARCHAR(30), 
    @IncreasePercent FLOAT
AS
BEGIN
    UPDATE Employees
    SET Salary = Salary + (Salary * @IncreasePercent / 100)
    WHERE Department = @Department;

    SELECT * FROM Employees
    WHERE Department = @Department;
END;
GO

EXEC sp_UpdateSalaryByDept @Department = 'Sales', @IncreasePercent = 100;

-----

--# 🔵 Part 2: MERGE Tasks
---

--## 📄 Task 3:

----Perform a MERGE operation that:

----- Updates `ProductName` and `Price` if `ProductID` matches
----- Inserts new products if `ProductID` does not exist
----- Deletes products from `Products_Current` if they are missing in `Products_New`
----- Return the final state of `Products_Current` after the MERGE.

MERGE Products_Current AS target
USING Products_New AS source
ON target.ProductID = source.ProductID

WHEN MATCHED THEN
    UPDATE SET
        target.ProductName = source.ProductName,
        target.Price = source.Price

WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (source.ProductID, source.ProductName, source.Price)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

SELECT * FROM Products_Current;

-----

--## 📄 Task 4:

--**Tree Node**

--Each node in the tree can be one of three types:

--- **"Leaf"**: if the node is a leaf node.
--- **"Root"**: if the node is the root of the tree.
--- **"Inner"**: If the node is neither a leaf node nor a root node.

--Write a solution to report the type of each node in the tree.

SELECT 
    id,
    p_id,
    CASE 
        WHEN p_id IS NULL THEN 'Root'
        WHEN id NOT IN (SELECT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Leaf'
        ELSE 'Inner'
    END AS NodeType
FROM Tree;


---

--## 📄 Task 5:

--**Confirmation Rate**

--Find the confirmation rate for each user. If a user has no confirmation requests, the rate should be 0.

SELECT 
    s.user_id,
    COALESCE(c.confirmed_count, 0) AS confirmed_count,
    COALESCE(c.total_count, 0) AS total_count,
    CASE 
        WHEN COALESCE(c.total_count, 0) = 0 THEN 0
        ELSE CAST(c.confirmed_count AS FLOAT) / c.total_count
    END AS confirmation_rate
FROM Signups s
LEFT JOIN (
    SELECT 
        user_id,
        SUM(CASE WHEN action = 'confirmed' THEN 1 ELSE 0 END) AS confirmed_count,
        COUNT(*) AS total_count
    FROM Confirmations
    GROUP BY user_id
) c ON s.user_id = c.user_id;

---

--## 📄 Task 6:

--**Find employees with the lowest salary**

SELECT *
FROM Employees
WHERE Salary = (SELECT MIN(Salary) FROM Employees);


--- Find all employees who have the lowest salary using subqueries.

-----

--## 📄 Task 7:

--**Get Product Sales Summary**

- Accepts a `@ProductID` input
- Returns:
  - ProductName
  - Total Quantity Sold
  - Total Sales Amount (Quantity × Price)
  - First Sale Date
  - Last Sale Date
- If the product has no sales, return `NULL` for quantity, total amount, first date, and last date, but still return the product name. 

CREATE PROCEDURE GetProductSalesSummary 
    @ProductID INT 
AS
BEGIN
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantitySold,
        SUM(s.Quantity * p.Price) AS TotalSalesAmount,
        MIN(s.SaleDate) AS FirstSaleDate,
        MAX(s.SaleDate) AS LastSaleDate
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductName;
END;

EXEC GetProductSalesSummary @ProductID = 5;
