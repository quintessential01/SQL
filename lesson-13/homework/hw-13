--# Lesson 13 ----Practice: String Functions, Mathematical Functions


--## Easy Tasks

--1. You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.

	SELECT  as emp_id
	SELECT CONCAT(EMPLOYEE_ID, '-', FIRST_NAME, ' ', LAST_NAME) AS Employees 
FROM Employees
GROUP BY EMPLOYEE_ID;

--2. Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'
	
	SELECT phone_number, REPLACE(phone_number, '124', '999') AS Preview
FROM Employees
WHERE phone_number LIKE '%124%';


--3. That displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)

SELECT FIRST_NAME AS [Employee Name],
       LEN(FIRST_NAME) AS [Name Length]
FROM Employees
WHERE FIRST_NAME LIKE 'A%' 
   OR FIRST_NAME LIKE 'J%' 
   OR FIRST_NAME LIKE 'M%'
ORDER BY FIRST_NAME;



--4. Write an SQL query to find the total salary for each manager ID.(Employees table)

SELECT MANAGER_ID, SUM(SALARY) AS TotalSalary
FROM Employees
GROUP BY MANAGER_ID
;


--5. Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for each row in the TestMax table

SELECT Year1, 
CASE
     WHEN Max1 >= Max2 AND Max1>=Max3 THEN Max1
     WHEN Max2 >= Max1 AND Max2>= Max3 THEN Max2
ELSE Max3
END AS HighestValue 
FROM TestMax
;

--6. Find me odd numbered movies and description is not boring.(cinema)

SELECT * from Cinema
WHERE id % 2 = 1
AND description <> 'boring' ;

--7. You have to sort data based on the Id but Id with 0 should always be the last row. Now the question is can you do that with a single order by column.(SingleOrder)

SELECT * 
FROM SingleOrder
ORDER BY 
    CASE 
        WHEN id = 0 THEN 999999 
        ELSE id 
    END;



--8. Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)

SELECT COALESCE(ssn, passportid, itin) AS FirstNonNull
FROM Person;

--## Medium Tasks


--1. Split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)

SELECT 
    LEFT(FullName, CHARINDEX(' ', FullName) - 1) AS Firstname,
    SUBSTRING(
        FullName,
        CHARINDEX(' ', FullName) + 1,
        LEN(FullName) - CHARINDEX(' ', FullName) - CHARINDEX(' ', REVERSE(FullName)) + 1
    ) AS Middlename,
    RIGHT(FullName, CHARINDEX(' ', REVERSE(FullName)) - 1) AS Lastname
FROM Students;



--2. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)

SELECT *
FROM Orders o
WHERE o.DeliveryState = 'Texas'
AND CustomerID IN (
    SELECT CustomerID 
    FROM Orders 
    WHERE DeliveryState = 'California'
);

--3. Write an SQL statement that can group concatenate the following values.(DMLTable)

SELECT CategoryID, STRING_AGG(ProductName, ', ') AS Products
FROM DMLTable
GROUP BY CategoryID;


--4. Find all employees whose names (concatenated first and last) contain the letter "a" at least 3 times.

SELECT *
FROM Employees
WHERE (LEN(FIRST_NAME + LAST_NAME) - LEN(REPLACE(FIRST_NAME + LAST_NAME, 'a', ''))) >= 3;


--5. The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees)

SELECT DEPARTMENT_ID,
       COUNT(*) AS TotalEmployees,
       100.0 * SUM(CASE WHEN DATEDIFF(year, HIRE_DATE, GETDATE()) > 3 THEN 1 ELSE 0 END) / COUNT(*) AS PercentOver3Years
FROM Employees
GROUP BY DEPARTMENT_ID;


--6. Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)

SELECT JobDescription,
       MAX(MissionCount) AS MostExperienced,
       MIN(MissionCount) AS LeastExperienced
FROM Personal
GROUP BY JobDescription;


--## Difficult Tasks
--1. Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string 'tf56sd#%OqH' into separate columns.

DECLARE @str VARCHAR(50) = 'tf56sd#%OqH';

SELECT
    STRING_AGG(value, '') WITHIN GROUP (ORDER BY position) AS Uppercase
FROM (SELECT SUBSTRING(@str, number, 1) AS value, number AS position
      FROM master..spt_values
      WHERE type='P' AND number BETWEEN 1 AND LEN(@str)
        AND SUBSTRING(@str, number, 1) LIKE '[A-Z]') AS t;


--2. Write an SQL query that replaces each row with the sum of its value and the previous rows' value. (Students table)

SELECT 
    StudentID,
    Grade,
    SUM(Grade) OVER (ORDER BY StudentID ROWS UNBOUNDED PRECEDING) AS CumulativeSum
FROM Students;


--3. You are given the following table, which contains a VARCHAR column that contains mathematical equations. Sum the equations and provide the answers in the output.(Equations)


SELECT 
    Equation,
    CASE Equation
        WHEN '+' THEN Num1 + CASE Op2 WHEN '+' THEN Num2 + Num3 WHEN '-' THEN Num2 - Num3 WHEN '*' THEN Num2 * Num3 WHEN '/' THEN Num2 / Num3 END
        WHEN '-' THEN Num1 - CASE Op2 WHEN '+' THEN Num2 + Num3 WHEN '-' THEN Num2 - Num3 WHEN '*' THEN Num2 * Num3 WHEN '/' THEN Num2 / Num3 END
        WHEN '*' THEN Num1 * CASE Op2 WHEN '+' THEN Num2 + Num3 WHEN '-' THEN Num2 - Num3 WHEN '*' THEN Num2 * Num3 WHEN '/' THEN Num2 / Num3 END
        WHEN '/' THEN Num1 / CASE Op2 WHEN '+' THEN Num2 + Num3 WHEN '-' THEN Num2 - Num3 WHEN '*' THEN Num2 * Num3 WHEN '/' THEN Num2 / Num3 END
    END AS Result
FROM Equations;

--4. Given the following dataset, find the students that share the same birthday.(Student Table)

SELECT s1.StudentName, s1.Birthday
FROM Student s1
JOIN Student s2
  ON s1.Birthday = s2.BirthDay
ORDER BY s1.Birthday;

--5. You have a table with two players (Player A and Player B) and their scores. If a pair of players have multiple entries, aggregate their scores into a single row for each unique pair of players. Write an SQL query to calculate the total score for each unique player pair(PlayerScores)

SELECT 
    CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS Player1,
    CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END AS Player2,
    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY 
    CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END,
    CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END;
