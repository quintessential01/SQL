--# Lesson-18: View, temp table, variable, functions

--You're working in a database for a Retail Sales System. The database contains the following tables:

--### 1. Create a temporary table named MonthlySales to store the total quantity sold and total revenue for each product in the current month.
--**Return: ProductID, TotalQuantity, TotalRevenue**

CREATE TABLE #MonthlySales (
    ProductID INT,
    TotalQuantity INT,
    TotalRevenue DECIMAL(10,2)
);

INSERT INTO #MonthlySales (ProductID, TotalQuantity, TotalRevenue)
SELECT 
    p.ProductID,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE 
    MONTH(s.SaleDate) = MONTH(GETDATE()) 
    AND YEAR(s.SaleDate) = YEAR(GETDATE())
GROUP BY p.ProductID;

SELECT * FROM #MonthlySales;


--### 2. Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.
--**Return: ProductID, ProductName, Category, TotalQuantitySold**
select * from Products
select * from Sales
CREATE VIEW vw_ProductSalesSummary as
    SELECT p.ProductID,
    p.ProductName,
    p.Category,
	SUM(s.Quantity) as TotalQuantitySold
	FROM Sales s
	JOIN Products p
	ON s.ProductID=p.ProductID
	GROUP BY p.ProductID, p.ProductName, p.Category
;
SELECT * FROM vw_ProductSalesSummary


--### 3. Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
--**Return: total revenue for the given product ID**

CREATE FUNCTION fn_GetTotalRevenueForProduct(@ProductID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(10,2);

    SELECT @TotalRevenue = SUM(s.Quantity * p.Price)
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.ProductID = @ProductID;

    RETURN @TotalRevenue;
END;

SELECT dbo.fn_GetTotalRevenueForProduct(1) AS TotalRevenue;



--### 4. Create an function fn_GetSalesByCategory(@Category VARCHAR(50))
--**Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.**

CREATE FUNCTION fn_GetSalesByCategory(@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantity,
        SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Products p
    JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.Category = @Category
    GROUP BY p.ProductName
);

SELECT * FROM dbo.fn_GetSalesByCategory('Electronics');


--# Now we will move on with 2 Lateral-thinking puzzles (5 and 6th puzzles). Lateral-thinking puzzles are the ones that can’t be solved by straightforward logic — you have to think outside the box. 🔍🧠
--### 5. You have to create a function that get one argument as input from user and the function should return 'Yes' if the input number is a prime number and 'No' otherwise. You can start it like this:


CREATE FUNCTION fn_IsPrime(@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @i INT = 2;
    DECLARE @IsPrime BIT = 1;
    DECLARE @Result VARCHAR(3);

    IF @Number <= 1
        SET @IsPrime = 0;

    WHILE @i <= SQRT(@Number)
    BEGIN
        IF @Number % @i = 0
        BEGIN
            SET @IsPrime = 0;
            BREAK;
        END
        SET @i += 1;
    END;

    SET @Result = CASE WHEN @IsPrime = 1 THEN 'Yes' ELSE 'No' END;

    RETURN @Result;
END;


SELECT dbo.fn_IsPrime(7);
SELECT dbo.fn_IsPrime(12);
SELECT dbo.fn_IsPrime(1);
SELECT dbo.fn_IsPrime(2);


--### 6. Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:

CREATE FUNCTION fn_GetNumbersBetween(@StartNum INT, @EndNum INT)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    DECLARE @i INT = @StartNum;

    WHILE @i <= @EndNum
    BEGIN
        INSERT INTO @Numbers VALUES (@i);
        SET @i += 1;
    END;

    RETURN;
END;

SELECT * FROM dbo.fn_GetNumbersBetween(1, 10);
SELECT * FROM dbo.fn_GetNumbersBetween(5, 8);

--### 7. Write a SQL query to return the Nth highest distinct salary from the Employee table. If there are fewer than N distinct salaries, return NULL. 

--### Example 1:

**Input.Employee table:**


| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |


### n = 2

**Output:**

| getNthHighestSalary(2) |


|    HighestNSalary      |
|------------------------|
| 200                    |

DECLARE @N INT = 2;

SELECT DISTINCT Salary
FROM Employee
ORDER BY Salary DESC
OFFSET (@N - 1) ROWS
FETCH NEXT 1 ROWS ONLY;


### Example 2:

**Input.Employee table:**


| id | salary |
|----|--------|
| 1  | 100    |
```


### n = 2
**Output:**

| getNthHighestSalary(2) |


|    HighestNSalary      |
|        null            |



--### 8. Write a SQL query to find the person who has the most friends.

**Return: Their id, The total number of friends they have**

--#### Friendship is mutual. For example, if user A sends a request to user B and it's accepted, both A and B are considered friends with each other. The test case is guaranteed to have only one user with the most friends.

**Input.RequestAccepted table:**


| requester_id | accepter_id | accept_date |
+--------------+-------------+-------------+
| 1            | 2           | 2016/06/03  |
| 1            | 3           | 2016/06/08  |
| 2            | 3           | 2016/06/08  |
| 3            | 4           | 2016/06/09  |
```

**Output:** 
```
| id | num |
+----+-----+
| 3  | 3   |
```

**Explanation: The person with id 3 is a friend of people 1, 2, and 4, so he has three friends in total, which is the most number than any others.**

SELECT TOP 1 id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted
) AS all_friends
GROUP BY id
ORDER BY num DESC;


### 9. Create a View for Customer Order Summary. 

**Create a view called vw_CustomerOrderSummary that returns a summary of customer orders. The view must contain the following columns:**

> - Column Name | Description
> - customer_id | Unique identifier of the customer
> - name | Full name of the customer
> - total_orders | Total number of orders placed by the customer
> - total_amount | Cumulative amount spent across all orders
> - last_order_date | Date of the most recent order placed by the customer

CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_amount) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;


### 10. Write an SQL statement to fill in the missing gaps. You have to write only select statement, no need to modify the table.


| RowNumber | Workflow |
|----------------------|
| 1         | Alpha    |
| 2         |          |
| 3         |          |
| 4         |          |
| 5         | Bravo    |
| 6         |          |
| 7         |          |
| 8         |          |
| 9         |          |
| 10        | Charlie  |
| 11        |          |
| 12        |          |
```

**Here is the expected output.**
```
| RowNumber | Workflow |
|----------------------|
| 1         | Alpha    |
| 2         | Alpha    |
| 3         | Alpha    |
| 4         | Alpha    |
| 5         | Bravo    |
| 6         | Bravo    |
| 7         | Bravo    |
| 8         | Bravo    |
| 9         | Bravo    |
| 10        | Charlie  |
| 11        | Charlie  |
| 12        | Charlie  |

SELECT 
    RowNumber,
    LAST_VALUE(Workflow) IGNORE NULLS 
        OVER (ORDER BY RowNumber ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Workflow
FROM Workflows;
