--# Lesson-16: CTEs and Derived Tables

-----
--# Easy Tasks

--1. Create a numbers table using a recursive query from 1 to 1000.

;WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < 1000
)
SELECT n
FROM Numbers
OPTION (MAXRECURSION 1000);


--2. Write a query to find the total sales per employee using a derived table.(Sales, Employees)

SELECT e.FirstName, e.LastName, t.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) t
  ON e.EmployeeID = t.EmployeeID;


--3. Create a CTE to find the average salary of employees.(Employees)

;WITH cte_average AS (
    SELECT AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT AvgSalary
FROM cte_average;


--4. Write a query using a derived table to find the highest sales for each product.(Sales, Products)

SELECT p.ProductName, t.MaxSale
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS MaxSale
    FROM Sales
    GROUP BY ProductID
) t
  ON p.ProductID = t.ProductID;

--5. Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.

;WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n * 2
    FROM Numbers
    WHERE n < 1000000
)
SELECT n
FROM Numbers
OPTION (MAXRECURSION 32767);



--6. Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)

;WITH cte_sales AS (
    SELECT s.EmployeeID, COUNT(*) AS TotalSales
    FROM Sales s
    GROUP BY s.EmployeeID
)
SELECT e.FirstName, e.LastName, c.TotalSales
FROM Employees e
JOIN cte_sales c
  ON e.EmployeeID = c.EmployeeID
WHERE c.TotalSales > 5;

--7. Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)

;WITH cte_sales AS (
    SELECT s.ProductID, SUM(SalesAmount) AS TotalSales
    FROM Sales s
    GROUP BY s.ProductID
)
SELECT p.ProductName, TotalSales
FROM Products p
JOIN cte_sales c
  ON p.ProductID = c.ProductID
WHERE c.TotalSales > 500;

--8. Create a CTE to find employees with salaries above the average salary.(Employees)

;WITH cte_salary AS (
    SELECT e.FirstName, e.LastName, e.Salary
    FROM Employees e
    WHERE Salary > (SELECT AVG(Salary) FROM Employees)
)
SELECT *
FROM cte_salary;

--# Medium Tasks
--1. Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)

SELECT TOP 5 e.Name, t.OrderCount
FROM (
    SELECT StaffID, COUNT(*) AS OrderCount
    FROM Sales s
    GROUP BY StaffID
) t
JOIN Employees e
    ON t.StaffID = e.EmployeeID
ORDER BY t.OrderCount DESC;

--2. Write a query using a derived table to find the sales per product category.(Sales, Products)

SELECT p.Category, SUM(t.TotalSales) AS CategorySales
FROM (
    SELECT ProductID, SUM(Quantity) AS TotalSales
    FROM Sales
    GROUP BY ProductID
) t
JOIN Products p
    ON t.ProductID = p.ProductID
GROUP BY p.Category;

--3. Write a script to return the factorial of each value next to it.(Numbers1)

;WITH FactorialCTE AS (
    SELECT Number, 1 AS n, 1 AS fact
    FROM Numbers1

    UNION ALL
    SELECT Number, n + 1, fact * (n + 1)
    FROM FactorialCTE
    WHERE n < Number
)

SELECT Number, fact AS Factorial
FROM FactorialCTE
WHERE n = Number;

--4. This script uses recursion to split a string into rows of substrings for each character in the string.(Example)
DECLARE @txt VARCHAR(100) = 'Example';

;WITH SplitCTE AS (
    SELECT 1 AS n, SUBSTRING(@txt, 1, 1) AS ch
    UNION ALL
    SELECT n + 1, SUBSTRING(@txt, n + 1, 1)
    FROM SplitCTE
    WHERE n < LEN(@txt)
)
SELECT n, ch
FROM SplitCTE;



--5. Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)

;WITH MonthlySales AS (
    SELECT 
        YEAR(SaleDate) AS SaleYear,
        MONTH(SaleDate) AS SaleMonth,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
)
SELECT 
    cur.SaleYear,
    cur.SaleMonth,
    cur.TotalSales AS CurrentMonthSales,
    prev.TotalSales AS PreviousMonthSales,
    cur.TotalSales - prev.TotalSales AS Difference
FROM MonthlySales cur
LEFT JOIN MonthlySales prev
    ON cur.SaleYear = prev.SaleYear
   AND cur.SaleMonth = prev.SaleMonth + 1
ORDER BY cur.SaleYear, cur.SaleMonth;


--6. Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)

SELECT t.EmployeeID, e.FirstName, e.LastName, t.Quarter, t.TotalSales
FROM (
    SELECT 
        s.EmployeeID,
        DATEPART(QUARTER, s.SaleDate) AS Quarter,
        SUM(s.SalesAmount) AS TotalSales
    FROM Sales s
    GROUP BY s.EmployeeID, DATEPART(QUARTER, s.SaleDate)
    HAVING SUM(s.SalesAmount) > 45000
) t
JOIN Employees e
    ON t.EmployeeID = e.EmployeeID
ORDER BY t.EmployeeID, t.Quarter;


--# Difficult Tasks
--1. This script uses recursion to calculate Fibonacci numbers

;WITH Fibonacci (n, a, b) AS (
    SELECT 1, 0, 1  
    UNION ALL
    SELECT n + 1, b, a + b
    FROM Fibonacci
    WHERE n < 20
)
SELECT n, a AS FibonacciNumber
FROM Fibonacci;


--2. Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)

SELECT *
FROM FindSameCharacters
WHERE Vals IS NOT NULL
  AND LEN(Vals) > 1
  AND LEN(Vals) = LEN(REPLACE(Vals, LEFT(Vals,1), ''));

--3. Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)

DECLARE @n INT = 5;

;WITH Numbers AS (
    SELECT 1 AS i, CAST('1' AS VARCHAR(50)) AS seq
    UNION ALL
    SELECT i + 1, seq + CAST(i + 1 AS VARCHAR(10))
    FROM Numbers
    WHERE i < @n
)
SELECT seq
FROM Numbers;


--4. Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)

SELECT e.EmployeeID, e.FirstName, e.LastName, SalesTotal
FROM (
    SELECT s.EmployeeID, SUM(s.SalesAmount) AS SalesTotal
    FROM Sales s
    WHERE s.SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY s.EmployeeID
) dt
JOIN Employees e ON e.EmployeeID = dt.EmployeeID
WHERE SalesTotal = (
    SELECT MAX(SalesTotal)
    FROM (
        SELECT SUM(SalesAmount) AS SalesTotal
        FROM Sales
        WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
        GROUP BY EmployeeID
    ) x
);



--5. Write a T-SQL query to remove the duplicate integer values present in the string column. Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)

SELECT PawanName,
       Pawan_slug_name,
       STRING_AGG(num, '-') AS Cleaned
FROM (
    SELECT PawanName, Pawan_slug_name, num
    FROM RemoveDuplicateIntsFromNames
    CROSS APPLY (
        SELECT value AS num
        FROM STRING_SPLIT(Pawan_slug_name, '-')
        WHERE ISNUMERIC(value) = 1
          AND LEN(value) > 1
    ) s
    GROUP BY PawanName, Pawan_slug_name, num
) t
GROUP BY PawanName, Pawan_slug_name;
