# Lesson-14: Date and time Functions,Practice

---

--# Easy Tasks
--1. Write a SQL query to split the Name column by a comma into two separate columns: Name and Surname.(TestMultipleColumns)

SELECT 
    Name,
    LEFT(Name, CHARINDEX(',', Name) - 1) AS FirstName,
    SUBSTRING(Name, CHARINDEX(',', Name) + 1, LEN(Name)) AS Surname
FROM TestMultipleColumns;


--2. Write a SQL query to find strings from a table where the string itself contains the % character.(TestPercent)

SELECT *
FROM TestPercent
WHERE Strs LIKE '%!%%' ESCAPE '!';


--3. In this puzzle you will have to split a string based on dot(.).(Splitter)

SELECT 
    CASE 
        WHEN CHARINDEX('.', Vals) > 0 
        THEN LEFT(Vals, CHARINDEX('.', Vals) - 1) 
        ELSE '' 
    END AS Part1,

    CASE 
        WHEN CHARINDEX('.', Vals) > 0 
        THEN SUBSTRING(
                 Vals,
                 CHARINDEX('.', Vals) + 1,
                 CHARINDEX('.', Vals, CHARINDEX('.', Vals) + 1) 
                   - CHARINDEX('.', Vals) - 1
             )
        ELSE '' 
    END AS Part2,

    CASE 
        WHEN CHARINDEX('.', Vals, CHARINDEX('.', Vals) + 1) > 0 
        THEN SUBSTRING(
                 Vals,
                 CHARINDEX('.', Vals, CHARINDEX('.', Vals) + 1) + 1,
                 LEN(Vals)
             )
        ELSE '' 
    END AS Part3
FROM Splitter;


--4. Write a SQL query to replace all integers (digits) in the string with 'X'.(1234ABC123456XYZ1234567890ADS)

SELECT TRANSLATE('1234ABC123456XYZ1234567890ADS',
                 '0123456789',
                 'XXXXXXXXXX') AS Result;

--5. Write a SQL query to return all rows where the value in the Vals column contains more than two dots (.).(testDots)

SELECT Vals
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;


--6. Write a SQL query to count the spaces present in the string.(CountSpaces)

SELECT texts,
       LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;

--7. write a SQL query that finds out employees who earn more than their managers.(Employee)

SELECT e.Name AS EmployeeName,
       m.Name AS ManagerName,
       e.Salary AS EmployeeSalary,
       m.Salary AS ManagerSalary
FROM Employee e
JOIN Employee m
     ON e.ManagerID = m.Id
WHERE e.Salary > m.Salary;

--8. Find the employees who have been with the company for more than 10 years, but less than 15 years. Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service (calculated as the number of years between the current date and the hire date).(Employees)

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, DATEDIFF(YEAR, HIRE_DATE, GETDATE()) as YearsOfService
FROM Employees
WHERE DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 10
  AND DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 15



--# Medium Tasks
--1. Write a SQL query to separate the integer values and the character values into two different columns.(rtcfvty34redt)

SELECT 
    TRANSLATE('rtcfvty34redt', '0123456789', '          ') AS OnlyChars,
    TRANSLATE('rtcfvty34redt', 'abcdefghijklmnopqrstuvwxyz', REPLICATE(' ',26)) AS OnlyNumbers;


--2. write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.(weather)

SELECT w1.Id, w1.RecordDate, w1.Temperature
FROM Weather w1
JOIN Weather w2 
  ON w1.RecordDate = DATEADD(DAY, 1, w2.RecordDate)
WHERE w1.Temperature > w2.Temperature;

--3. Write an SQL query that reports the first login date for each player.(Activity)

SELECT player_id, MIN(event_date) AS FirstLogin
FROM Activity
GROUP BY player_id;

--4. Your task is to return the third item from that list.(fruits)

SELECT 
    SUBSTRING(
       fruit_list,
        CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1,
        CHARINDEX(',', fruit_list + ',', CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1) 
          - (CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1)
    ) AS ThirdItem
FROM fruits;

--5. Write a SQL query to create a table where each character from the string will be converted into a row.(sdgfhsdgfhs@121313131)

WITH Numbers AS (
    SELECT TOP (LEN('sdgfhsdgfhs@121313131')) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)
SELECT SUBSTRING('sdgfhsdgfhs@121313131', n, 1) AS Character
FROM Numbers;

--6. You are given two tables: p1 and p2. Join these tables on the id column. The catch is: when the value of p1.code is 0, replace it with the value of p2.code.(p1,p2)

SELECT p1.id,
       CASE WHEN p1.code = 0 THEN p2.code ELSE p1.code END AS FinalCode
FROM p1
JOIN p2 ON p1.id = p2.id;

--7. Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. The stages are defined as follows:

--> - If the employee has worked for less than 1 year ? 'New Hire'

--> - If the employee has worked for 1 to 5 years ? 'Junior'

--> -  If the employee has worked for 5 to 10 years ? 'Mid-Level'

--> -  If the employee has worked for 10 to 20 years ? 'Senior'

--> - If the employee has worked for more than 20 years ? 'Veteran'(Employees)

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE,
       CASE 
           WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire'
           WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
           WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 6 AND 10 THEN 'Mid-Level'
           WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 11 AND 20 THEN 'Senior'
           ELSE 'Veteran'
       END AS EmploymentStage
FROM Employees;

--8. Write a SQL query to extract the integer value that appears at the start of the string in a column named Vals.(GetIntegers)

SELECT Vals,
       LEFT(Vals, PATINDEX('%[^0-9]%', Vals + 'X') - 1) AS StartingInteger
FROM GetIntegers;

--# Difficult Tasks
--1. In this puzzle you have to swap the first two letters of the comma separated string.(MultipleVals)

SELECT 
    STUFF(
        STUFF(Vals, 1, 1, SUBSTRING(Vals, 3, 1)), 
        3, 1, SUBSTRING(Vals, 1, 1)
    ) AS Swapped
FROM MultipleVals;

--2. Write a SQL query that reports the device that is first logged in for each player.(Activity)

SELECT player_id, device_id
FROM (
    SELECT player_id, device_id,
           ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS rn
    FROM Activity
) a
WHERE rn = 1;

--3. You are given a sales table. Calculate the week-on-week percentage of sales per area for each financial week. For each week, the total sales will be considered 100%, and the percentage sales for each day of the week should be calculated based on the area sales for that week.(WeekPercentagePuzzle)

WITH Weekly AS (
    SELECT Area,
           DATEPART(WEEK, SaleDate) AS WeekNum,
           SUM(Sales) AS TotalSales
    FROM Sales
    GROUP BY Area, DATEPART(WEEK, SaleDate)
),
WeeklyWithTotal AS (
    SELECT w.Area, w.WeekNum, w.TotalSales,
           SUM(w.TotalSales) OVER (PARTITION BY w.WeekNum) AS WeekTotal
    FROM Weekly w
)
SELECT Area, WeekNum,
       CAST(TotalSales * 100.0 / WeekTotal AS DECIMAL(5,2)) AS PercentageOfWeek
FROM WeeklyWithTotal;
