--# Lesson 21  WINDOW FUNCTIONS

--1. Write a query to assign a row number to each sale based on the SaleDate.

SELECT
   SaleID,
   ProductName,
   SaleDate,
   ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales;


--2. Write a query to rank products based on the total quantity sold. give the same rank for the same amounts without skipping numbers.

SELECT
   ProductName,
   SUM(Quantity) AS TotalQty,
   DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS RankByQty
FROM ProductSales
GROUP BY ProductName;

--3. Write a query to identify the top sale for each customer based on the SaleAmount.

SELECT *
FROM (
    SELECT
        CustomerID,
        ProductName,
        SaleAmount,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS rn
    FROM ProductSales
) AS ranked
WHERE rn = 1;

--4. Write a query to display each sale's amount along with the next sale amount in the order of SaleDate.

SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales;

--5. Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.

SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSaleAmount
FROM ProductSales;

--6. Write a query to identify sales amounts that are greater than the previous sale's amount

SELECT *
FROM (
    SELECT
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSaleAmount
    FROM ProductSales
) AS t
WHERE SaleAmount > PrevSaleAmount;

--7. Write a query to calculate the difference in sale amount from the previous sale for every product

SELECT *
FROM (
    SELECT
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        SaleAmount - LAG(SaleAmount) OVER (ORDER BY SaleDate) AS DiffFromPrevSale
    FROM ProductSales
) AS t;

--8.  Write a query to compare the current sale amount with the next sale amount in terms of percentage change.

SELECT *
FROM (
    SELECT
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        (((LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) / SaleAmount) * 100) as comparison 
    FROM ProductSales
) AS t;

--9. Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.

SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    CAST(SaleAmount AS DECIMAL(10,2)) /
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS SaleRatio
FROM ProductSales;

--10. Write a query to calculate the difference in sale amount from the very first sale of that product.

SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromFirst
FROM ProductSales;

--11. Write a query to find sales that have been increasing continuously for a product 
--(i.e., each sale amount is greater than the previous sale amount for that product).

SELECT *
FROM (
    SELECT
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevSale
    FROM ProductSales
) AS t
WHERE SaleAmount > PrevSale;

--12. Write a query to calculate a "closing balance"(running total) for sales amounts which adds the current sale amount to a running total of previous sales.

SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SUM(SaleAmount) OVER (ORDER BY SaleDate) AS RunningTotal
FROM ProductSales;

--13. Write a query to calculate the moving average of sales amounts over the last 3 sales.

SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3
FROM ProductSales;

--14. Write a query to show the difference between each sale amount and the average sale amount.

SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SaleAmount - AVG(SaleAmount) OVER () AS DiffFromAvg
FROM ProductSales;

--15. Find Employees Who Have the Same Salary Rank

SELECT
    Name,
    Department,
    Salary,
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1;

--16. Identify the Top 2 Highest Salaries in Each Department

SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS RankByDept
    FROM Employees1
) AS t
WHERE RankByDept <= 2;

--17. Find the Lowest-Paid Employee in Each Department

SELECT *
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY Department ORDER BY Salary ASC) AS RankLow
    FROM Employees1
) AS t
WHERE RankLow = 1;

--18. Calculate the Running Total of Salaries in Each Department

SELECT
    Department,
    Name,
    Salary,
    SUM(Salary) OVER (PARTITION BY Department ORDER BY Salary ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM Employees1;

--19. Find the Total Salary of Each Department Without GROUP BY

SELECT
    Department,
    Salary,
    SUM(Salary) OVER (PARTITION BY Department) AS TotalDeptSalary
FROM Employees1;

--20. Calculate the Average Salary in Each Department Without GROUP BY

SELECT
    Department,
    Name,
    Salary,
    AVG(Salary) OVER (PARTITION BY Department) AS AvgDeptSalary
FROM Employees1;

--21. Find the Difference Between an Employee’s Salary and Their Department’s Average

SELECT
    Name,
    Department,
    Salary,
    Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees1;

--22. Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)

SELECT
    Name,
    Department,
    Salary,
    AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM Employees1;

	--23. Find the Sum of Salaries for the Last 3 Hired Employees

	SELECT
    Name,
    HireDate,
    Salary,
    SUM(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS SumLast3Hires
FROM Employees1;
