/* ========================================================
   LESSON 5: Aliases, Unions, and Conditional Columns
   ========================================================
 =========================
   EASY-LEVEL TASKS
========================= */

-- 1. Rename ProductName column as Name
SELECT ProductID,
       ProductName AS Name
FROM Products;

-- 2. Rename Customers table as Client for easier reference
SELECT Client.FirstName
FROM Customers AS Client;

-- 3. Combine results from Products and Products_Discounted using UNION
SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM Products_Discounted;

-- 4. Find intersection of Products and Products_Discounted
SELECT *
FROM Products
INTERSECT
SELECT *
FROM Products_Discounted;

-- 5. Select distinct customer names and Country
SELECT DISTINCT FirstName, LastName, Country
FROM Customers;

-- 6. Create conditional column: 'High' if Price > 1000, else 'Low'
SELECT ProductName,
       Price,
       CASE 
           WHEN Price > 1000 THEN 'High'
           ELSE 'Low'
       END AS PriceCategory
FROM Products;

-- 7. IIF: 'Yes' if StockQuantity > 100, else 'No'
SELECT ProductName,
       IIF(StockQuantity > 100, 'Yes', 'No') AS InStock
FROM Products_Discounted;


/* =========================
   MEDIUM-LEVEL TASKS
========================= */

-- 8. Combine ProductName from both tables using UNION
SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM Products_Discounted;

-- 9. Difference between Products and Products_Discounted
SELECT *
FROM Products
EXCEPT
SELECT *
FROM Products_Discounted;

-- 10. Conditional column with IIF: 'Expensive' or 'Affordable'
SELECT ProductName,
       IIF(Price > 1000, 'Expensive', 'Affordable') AS PriceCategory
FROM Products;

-- 11. Employees younger than 25 or with salary > 60000
SELECT *
FROM Employees
WHERE Age < 25
   OR Salary > 60000;

-- 12. Update salary: increase by 10% if Department = 'HR' or EmployeeID = 5
UPDATE Employees
SET Salary = Salary * 1.10
WHERE DepartmentName = 'HR'
   OR EmployeeID = 5;


/* =========================
   HARD-LEVEL TASKS
========================= */

-- 13. Tier classification based on SaleAmount
SELECT SaleID,
       SaleAmount,
       CASE
           WHEN SaleAmount > 500 THEN 'Top Tier'
           WHEN SaleAmount BETWEEN 200 AND 500 THEN 'Mid Tier'
           ELSE 'Low Tier'
       END AS Level
FROM Sales;

-- 14. Customers who have placed orders but no record in Sales
SELECT CustomerID
FROM Orders
EXCEPT
SELECT CustomerID
FROM Sales;

-- 15. Discount percentage based on quantity purchased
SELECT CustomerID,
       Quantity,
       CASE
           WHEN Quantity = 1 THEN '3%'
           WHEN Quantity BETWEEN 2 AND 3 THEN '5%'
           ELSE '7%'
       END AS DiscountPercentage
FROM Orders;
