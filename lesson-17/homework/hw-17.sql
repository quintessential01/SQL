# Lesson-17: Practice

### 1. You must provide a report of all distributors and their sales by region.  If a distributor did not have any sales for a region, rovide a zero-dollar value for that day.  Assume there is at least one sale for each region

select * from #RegionSales
SELECT r.Region, d.Distributor, COALESCE(s.Sales, 0) AS Sales
FROM (SELECT DISTINCT Region FROM #RegionSales) r
CROSS JOIN (SELECT DISTINCT Distributor FROM #RegionSales) d
LEFT JOIN #RegionSales s
    ON r.Region = s.Region
   AND d.Distributor = s.Distributor;


### 2. Find managers with at least five direct reports

SELECT m.Name
FROM Employee m
JOIN (
    SELECT ManagerID
    FROM Employee
    GROUP BY ManagerID
    HAVING COUNT(ID) >= 5
) x
ON m.ID = x.ManagerID;


### 3. Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.

SELECT p.product_name, 
       SUM(o.unit) AS total_units
FROM Products p
JOIN Orders o 
    ON p.product_id = o.product_id
WHERE o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100; 


### 4. Write an SQL statement that returns the vendor from which each customer has placed the most orders

SELECT CustomerID, Vendor, order_count
FROM (
    SELECT CustomerID, Vendor, COUNT(*) AS order_count
    FROM Orders
    GROUP BY CustomerID, Vendor
) t
WHERE order_count = (
    SELECT MAX(order_count)
    FROM (
        SELECT CustomerID, Vendor, COUNT(*) AS order_count
        FROM Orders
        GROUP BY CustomerID, Vendor
    ) x
    WHERE x.CustomerID = t.CustomerID
);

### 5. You will be given a number as a variable called @Check_Prime check if this number is prime then return 'This number is prime' else eturn 'This number is not prime'

DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1;

WHILE @i <= SQRT(@Check_Prime)
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @IsPrime = 0;
        BREAK;
    END
    SET @i += 1;
END

IF @IsPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';


### 6. Write an SQL query to return the number of locations,in which location most signals sent, and total number of signal for each device from the given table.

WITH LocationCounts AS (
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS SignalCount
    FROM Device
    GROUP BY Device_id, Locations
),
RankedLocations AS (
    SELECT 
        Device_id,
        Locations,
        SignalCount,
        ROW_NUMBER() OVER (PARTITION BY Device_id ORDER BY SignalCount DESC) AS rn
    FROM LocationCounts
),
DeviceTotals AS (
    SELECT 
        Device_id,
        COUNT(DISTINCT Locations) AS NumLocations,
        SUM(SignalCount) AS TotalSignals
    FROM LocationCounts
    GROUP BY Device_id
)
SELECT 
    d.Device_id,
    d.NumLocations,
    r.Locations AS TopLocation,
    r.SignalCount AS TopLocationSignals,
    d.TotalSignals
FROM DeviceTotals d
JOIN RankedLocations r
  ON d.Device_id = r.Device_id AND r.rn = 1;


---

### 7. Write a SQL  to find all Employees who earn more than the average salary in their corresponding department. Return EmpID, EmpName,Salary in your output

SELECT EmpID, EmpName, Salary
FROM Employee e
WHERE Salary >= (
    SELECT AVG(Salary)
    FROM Employee
    WHERE DeptID = e.DeptID
)
order by EmpID
;

---

### 8. You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of each ticket’s chosen numbers.  If a ticket has some but not all the winning numbers, you win $10.  If a ticket has all the winning numbers, you win $100.    Calculate the total winnings for today’s drawing.


WITH MatchCounts AS (
    SELECT
        t.TicketID, 
        COUNT(DISTINCT t.Number) AS match_count
    FROM Tickets t
    JOIN Numbers n
        ON t.Number = n.Number
    GROUP BY t.TicketID
),
TotalWinning AS (
    SELECT COUNT(*) AS total_wins FROM Numbers
),
Prizes AS (
    SELECT
        m.TicketID,
        CASE
            WHEN m.match_count = tw.total_wins THEN 100
            WHEN m.match_count > 0 THEN 10
            ELSE 0
        END AS Prize
    FROM MatchCounts m
    CROSS JOIN TotalWinning tw
)
SELECT SUM(Prize) AS Total_Prize
FROM Prizes;


---

### 9. The Spending table keeps the logs of the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile devices.

## Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.

WITH UserSpend AS (
    SELECT 
        user_id,
        spend_date,
        SUM(CASE WHEN platform = 'Mobile' THEN amount ELSE 0 END) AS mobile_amount,
        SUM(CASE WHEN platform = 'Desktop' THEN amount ELSE 0 END) AS desktop_amount
    FROM Spending
    GROUP BY user_id, spend_date
),
Classified AS (
    SELECT
        spend_date,
        CASE 
            WHEN mobile_amount > 0 AND desktop_amount > 0 THEN 'Both'
            WHEN mobile_amount > 0 AND desktop_amount = 0 THEN 'Mobile'
            WHEN desktop_amount > 0 AND mobile_amount = 0 THEN 'Desktop'
        END AS Platform,
        (mobile_amount + desktop_amount) AS total_amount,
        user_id
    FROM UserSpend
)
SELECT 
    spend_date,
    platform,
    SUM(total_amount) AS total_amount,
    COUNT(DISTINCT user_id) AS total_users
FROM Classified
GROUP BY spend_date, platform
ORDER BY spend_date, platform;



### 10. Write an SQL Statement to de-group the following data.

WITH RECURSIVE tally AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM tally
    WHERE n < (SELECT MAX(Quantity) FROM Grouped)
)
SELECT g.Product, 1 AS Quantity
FROM Grouped g
JOIN tally t 
  ON t.n <= g.Quantity
ORDER BY g.Product;
