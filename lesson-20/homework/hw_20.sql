# Lesson-20: Practice

--# 1. Find customers who purchased at least one item in March 2024 using EXISTS

SELECT DISTINCT s1.CustomerName
	FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales AS s2
    WHERE s2.CustomerName = s1.CustomerName
      AND MONTH(s2.SaleDate) = 3
	  AND YEAR(s2.SaleDate) = 2024
);


--# 2. Find the product with the highest total sales revenue using a subquery.

SELECT Product, SUM(Quantity * Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(TotalRevenue)
    FROM (
        SELECT SUM(Quantity * Price) AS TotalRevenue
        FROM #Sales
        GROUP BY Product
    ) AS x
);

--# 3. Find the second highest sale amount using a subquery

SELECT (Quantity * Price) AS SaleAmount
FROM #Sales
ORDER BY SaleAmount DESC
OFFSET 1 ROW FETCH NEXT 1 ROW ONLY;

--# 4. Find the total quantity of products sold per month using a subquery

SELECT MonthName, TotalQuantity
FROM (
    SELECT 
        MONTH(SaleDate) AS MonthNum,
        DATENAME(MONTH, SaleDate) AS MonthName,
        SUM(Quantity) AS TotalQuantity
    FROM #Sales
    GROUP BY MONTH(SaleDate), DATENAME(MONTH, SaleDate)
) AS MonthlyTotals
ORDER BY MonthNum;

--# 5. Find customers who bought same products as another customer using EXISTS

SELECT DISTINCT a.CustomerName
FROM #Sales a
WHERE EXISTS (
    SELECT 1
    FROM #Sales b
    WHERE b.Product = a.Product
      AND b.CustomerName <> a.CustomerName
);

--# 6. Return how many fruits does each person have in individual fruit level

create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')


**Expected Output**

+-----------+-------+--------+--------+
| Name      | Apple | Orange | Banana |
+-----------+-------+--------+--------+
| Francesko |   3   |   2    |   1    |
| Li        |   2   |   1    |   1    |
| Mario     |   3   |   1    |   2    |
+-----------+-------+--------+--------+
SELECT
	Name,
	SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) as Apple,
	SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
	SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name;

--# 7. Return older people in the family with younger ones

create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)


--**1 Oldest person in the family --grandfather**
--**2 Father**
--**3 Son**
--**4 Grandson**

**Expected output**

+-----+-----+
| PID |CHID |
+-----+-----+
|  1  |  2  |
|  1  |  3  |
|  1  |  4  |
|  2  |  3  |
|  2  |  4  |
|  3  |  4  |
+-----+-----+

;WITH RecursiveFamily AS (
    SELECT ParentId, ChildId
    FROM Family
    UNION ALL
    SELECT f.ParentId, r.ChildId
    FROM Family f
    JOIN RecursiveFamily r ON f.ChildId = r.ParentId
)
SELECT * FROM RecursiveFamily
order by parentid, childid;



--# 8. Write an SQL statement given the following requirements. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas

SELECT *
FROM #Orders AS o1
WHERE o1.DeliveryState = 'TX'
  AND EXISTS (
      SELECT 1
      FROM #Orders AS o2
      WHERE o2.CustomerID = o1.CustomerID
        AND o2.DeliveryState = 'CA'
  );


---
--# 9. Insert the names of residents if they are missing

UPDATE #residents
SET address = address + ' name=' + fullname
WHERE address NOT LIKE '%name=%';
select * from #Residents

---
--# 10. Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes

;WITH RoutesCTE AS (
    SELECT 
        DepartureCity,
        ArrivalCity,
        CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Route,
        Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'
    UNION ALL
    SELECT 
        c.DepartureCity,
        r.ArrivalCity,
        c.Route + ' - ' + r.ArrivalCity,
        c.Cost + r.Cost
    FROM RoutesCTE c
    JOIN #Routes r ON c.ArrivalCity = r.DepartureCity
)


SELECT TOP 1 Route, Cost as Cheapest, Cost as Expensive
FROM RoutesCTE
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost ASC  -- Cheapest;

SELECT TOP 1 Route, Cost
FROM RoutesCTE
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost DESC; -- Most expensive;



--**Expected Output**
```
|             Route                                 |Cost |
|Tashkent - Samarkand - Khorezm                     | 500 |
|Tashkent - Jizzakh - Samarkand - Bukhoro - Khorezm | 650 |
```
---
--# 11. Rank products based on their order of insertion.
select *,
SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END)
    OVER (ORDER BY ID) AS ProductGroup
    FROM #RankingPuzzle


-----
--# Question 12
--# Find employees whose sales were higher than the average sales in their department

SELECT EmployeeName, Department, SalesAmount
FROM #EmployeeSales AS e
WHERE SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department = e.Department
);



---
--# 13. Find employees who had the highest sales in any given month using EXISTS

SELECT EmployeeName, Department, SalesAmount, SalesMonth
FROM #EmployeeSales AS e1
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales AS e2
    WHERE e2.SalesMonth = e1.SalesMonth
      AND e2.SalesYear = e1.SalesYear
      AND e2.SalesAmount = (
          SELECT MAX(SalesAmount)
          FROM #EmployeeSales AS e3
          WHERE e3.SalesMonth = e1.SalesMonth
            AND e3.SalesYear = e1.SalesYear
      )
      AND e2.EmployeeID = e1.EmployeeID
);


---
--# 14. Find employees who made sales in every month using NOT EXISTS

SELECT DISTINCT e1.EmployeeName
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT 1
    FROM (SELECT DISTINCT SalesMonth FROM #EmployeeSales) AS m
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales e2
        WHERE e2.EmployeeName = e1.EmployeeName
          AND e2.SalesMonth = m.SalesMonth
    )
);


---
--# 15. Retrieve the names of products that are more expensive than the average price of all products.

SELECT Name, Price
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
);

-----
--# 16. Find the products that have a stock count lower than the highest stock count.

SELECT Name, Stock
FROM Products
WHERE Stock < (
    SELECT MAX(Stock)
    FROM Products
);

-----
--# 17. Get the names of products that belong to the same category as 'Laptop'.

SELECT Name, Category
FROM Products
WHERE Category = (
    SELECT Category
    FROM Products
    WHERE Name = 'Laptop'
    );

-----
--# 18. Retrieve products whose price is greater than the lowest price in the Electronics category.

SELECT Name, Category, Price
FROM Products
WHERE Price >  (SELECT MIN(Price)
    FROM Products
    WHERE Category = 'Electronics'
    );

-----
--# 19. Find the products that have a higher price than the average price of their respective category.

SELECT Name, Category, Price
FROM Products p
WHERE Price > (
    SELECT AVG(Price)
    FROM Products e
    WHERE p.Category = e.Category
);


---
--# 20. Find the products that have been ordered at least once.

SELECT Name
FROM Products p
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID
);

-----
--# 21. Retrieve the names of products that have been ordered more than the average quantity ordered.

SELECT p.Name, Quantity
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.Name, Quantity
HAVING SUM(o.Quantity) > (
    SELECT AVG(Quantity) FROM Orders
);

-----
--# 22. Find the products that have never been ordered.

SELECT Name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID
);

-----
--# 23. Retrieve the product with the highest total quantity ordered.

SELECT TOP 1 p.Name, SUM(o.Quantity) AS TotalQuantity
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalQuantity DESC;

-----
