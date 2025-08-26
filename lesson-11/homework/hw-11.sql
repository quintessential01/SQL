--# Lesson 11 Homework Tasks

--## 🟢 Easy-Level Tasks (7)

--1. **Return**: `OrderID`, `CustomerName`, `OrderDate`  
--   **Task**: Show all orders placed after 2022 along with the names of the customers who placed them.  
--   **Tables Used**: `Orders`, `Customers`

SELECT o.OrderID, c.FirstName, c.LastName, o.OrderDate
FROM Orders o
INNER JOIN Customers c
ON o.CustomerID=c.CustomerID
WHERE YEAR(OrderDate) > 2022;

--2. **Return**: `EmployeeName`, `DepartmentName`  
--   **Task**: Display the names of employees who work in either the Sales or Marketing department.  
--   **Tables Used**: `Employees`, `Departments`

SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing');


--3. **Return**: `DepartmentName`,  `MaxSalary`  
--   **Task**: Show the highest salary for each department.  
--   **Tables Used**: `Departments`, `Employees`

SELECT d.DepartmentName, MAX(e.Salary) as MaxSalary
FROM Departments d
INNER JOIN Employees e
on d.DepartmentID=e.DepartmentID
group by d.DepartmentName

--4. **Return**: `CustomerName`, `OrderID`, `OrderDate`  
--   **Task**: List all customers from the USA who placed orders in the year 2023.  
--   **Tables Used**: `Customers`, `Orders`

SELECT c.FirstName, c.LastName, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA'
  AND YEAR(o.OrderDate) = 2023;


--5. **Return**: `CustomerName`, `TotalOrders`  
--   **Task**: Show how many orders each customer has placed.  
--   **Tables Used**: `Orders` , `Customers`

SELECT c.FirstName + ' ' + c.LastName AS CustomerName,
       COUNT(o.OrderID) AS TotalOrders
FROM Customers c
INNER JOIN Orders o
    ON o.CustomerID = c.CustomerID
GROUP BY c.FirstName, c.LastName;


--6. **Return**: `ProductName`, `SupplierName`  
--   **Task**: Display the names of products that are supplied by either Gadget Supplies or Clothing Mart.  
--   **Tables Used**: `Products`, `Suppliers`

SELECT p.ProductName, s.SupplierName
FROM Products p
INNER JOIN Suppliers s
    ON p.SupplierID = s.SupplierID
WHERE s.SupplierName IN ('Gadget Supplies', 'Clothing Mart')
;



--7. **Return**: `CustomerName`, `MostRecentOrderDate`  
--   **Task**: For each customer, show their most recent order. Include customers who haven't placed any orders.  
--   **Tables Used**: `Customers`, `Orders`

SELECT 
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.MostRecentOrderDate
FROM Customers c
OUTER APPLY (
    SELECT TOP 1 OrderDate AS MostRecentOrderDate
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
    ORDER BY OrderDate DESC
) o;



-----

--## 🟠 Medium-Level Tasks (6)

--8. **Return**: `CustomerName`,  `OrderTotal`  
--   **Task**: Show the customers who have placed an order where the total amount is greater than 500.  
--   **Tables Used**: `Orders`, `Customers`

SELECT 
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.TotalAmount AS OrderTotal
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > 500;


--9. **Return**: `ProductName`, `SaleDate`, `SaleAmount`  
--   **Task**: List product sales where the sale was made in 2022 or the sale amount exceeded 400.  
--   **Tables Used**: `Products`, `Sales`

SELECT
p.ProductName, s.SaleDate, s.SaleAmount
FROM Products p
INNER JOIN Sales s
ON p.ProductID=s.ProductID
WHERE YEAR(s.SaleDate) = 2022
OR s.SaleAmount > 400;


--10. **Return**: `ProductName`, `TotalSalesAmount`  
--    **Task**: Display each product along with the total amount it has been sold for.  
--    **Tables Used**: `Sales`, `Products`

SELECT
	p.ProductName, SUM(s.SaleAmount) as TotalSalesAmount
FROM Products p
INNER JOIN Sales s
ON p.ProductID=s.ProductID
GROUP BY p.ProductName
;



--11. **Return**: `EmployeeName`, `DepartmentName`, `Salary`  
--    **Task**: Show the employees who work in the HR department and earn a salary greater than 60000.  
--    **Tables Used**: `Employees`, `Departments`

SELECT
	e.Name as EmployeeName,
	d.DepartmentName,
	e.Salary
FROM
	Employees e
INNER JOIN Departments d
ON
	e.DepartmentID=d.DepartmentID
WHERE
	d.DepartmentName='HR'
	AND e.Salary>60000
	;


--12. **Return**: `ProductName`, `SaleDate`, `StockQuantity`  
--    **Task**: List the products that were sold in 2023 and had more than 100 units in stock at the time.  
--    **Tables Used**: `Products`, `Sales`

SELECT
	p.ProductName,
	s.SaleDate,
	p.StockQuantity
FROM
	Products p
INNER JOIN
	Sales s
ON
	p.ProductID=s.ProductID
WHERE 
YEAR(s.SaleDate) = 2023
AND p.StockQuantity > 100;


--13. **Return**: `EmployeeName`, `DepartmentName`, `HireDate`  
--    **Task**: Show employees who either work in the Sales department or were hired after 2020.  
--    **Tables Used**: `Employees`, `Departments`

SELECT
	e.Name as EmployeeName,
	d.DepartmentName,
	e.HireDate
FROM
	Employees e
INNER JOIN
	Departments d
ON 
	e.DepartmentID=d.DepartmentID
WHERE
	d.DepartmentName='Sales'
OR
	YEAR(e.HireDate) > 2020
	;
-----

--## 🔴 Hard-Level Tasks (7)

--14. **Return**: `CustomerName`, `OrderID`, `Address`, `OrderDate`  
--    **Task**: List all orders made by customers in the USA whose address starts with 4 digits.  
--    **Tables Used**: `Customers`, `Orders`

SELECT 
    c.FirstName AS CustomerName, 
    o.OrderID, 
    c.Address, 
    o.OrderDate
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA'
  AND c.Address LIKE '[0-9][0-9][0-9][0-9]%';


--15. **Return**: `ProductName`, `Category`, `SaleAmount`  
--    **Task**: Display product sales for items in the Electronics category or where the sale amount exceeded 350.  
--    **Tables Used**: `Products`, `Sales`

SELECT
    p.ProductName,
    p.Category,
    s.SaleAmount
FROM Products p
INNER JOIN Sales s
    ON p.ProductID = s.ProductID
WHERE p.Category = 'Electronics'
   OR s.SaleAmount > 350;

--16. **Return**: `CategoryName`, `ProductCount`  
--    **Task**: Show the number of products available in each category.  
--    **Tables Used**: `Products`, `Categories`

SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount
FROM Products p
INNER JOIN Categories c
    ON p.Category = c.CategoryID
GROUP BY c.CategoryName;



--17. **Return**: `CustomerName`, `City`, `OrderID`, `Amount`  
--    **Task**: List orders where the customer is from Los Angeles and the order amount is greater than 300.  
--    **Tables Used**: `Customers`, `Orders`

SELECT c.FirstName as CustomerName, c.City, o.OrderID, o.TotalAmount as Amount
FROM Customers c
INNER JOIN Orders o
ON c.CustomerID=o.CustomerID
WHERE c.City='Los Angeles'
AND o.TotalAmount>300
;


--18. **Return**: `EmployeeName`, `DepartmentName`  
--    **Task**: Display employees who are in the HR or Finance department, or whose name contains at least 4 vowels.  
--    **Tables Used**: `Employees`, `Departments`

SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('HR', 'Finance')
   OR e.Name LIKE '%a%e%i%o%' 
   OR e.Name LIKE '%a%e%i%u%'
   OR e.Name LIKE '%e%a%i%o%'
   OR e.Name LIKE '%i%o%u%e%'
;


--19. **Return**: `EmployeeName`, `DepartmentName`, `Salary`  
--    **Task**: Show employees who are in the Sales or Marketing department and have a salary above 60000.  
--    **Tables Used**: `Employees`, `Departments`

SELECT e.Name AS EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
INNER JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
WHERE (d.DepartmentName IN ('Sales', 'Marketing'))
  AND e.Salary > 60000
  ;
