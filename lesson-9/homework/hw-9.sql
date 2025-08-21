# Lesson 9 Joins (Only inner with table relationships)

These homework tasks cover the following topics:
- **Table Relationships**
•	One to One 
•	One to Many 
•	Many to Many
- **Cartesian Product (Cross join)**
- **Filtering Cartesian product with Where clause**
- **Showing INNER join**
- **Using different logical Operators in ON clause(=, <>, >, >=, <, <=)**


## 🟢 Easy-Level Tasks (10)
🟢 Easy (10 puzzles)
1. Using Products, Suppliers table

List all combinations of product names and supplier names.

SELECT ProductName, SupplierName
FROM products
CROSS JOIN suppliers;


2. Using Departments, Employees table
Get all combinations of departments and employees.

SELECT DepartmentName, Name
FROM Departments
CROSS JOIN Employees
;


3. Using Products, Suppliers table
List only the combinations where the supplier actually supplies the product. Return supplier name and product name

SELECT ProductName, SupplierName 
FROM Products
INNER JOIN Suppliers
ON Products.SupplierID = Suppliers.SupplierID
;


4. Using Orders, Customers table
List customer names and their orders ID.

SELECT OrderID, FirstName, LastName 
FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
;



5. Using Courses, Students table
Get all combinations of students and courses.

SELECT CourseName, Name
FROM Courses
CROSS JOIN Students;


6. Using Products, Orders table
Get product names and orders where product IDs match.

SELECT ProductName, Quantity
FROM Products
INNER JOIN Orders
ON Products.ProductID = Orders.ProductID
;


7. Using Departments, Employees table
List employees whose DepartmentID matches the department.

SELECT DepartmentName, Name
FROM Departments
INNER JOIN Employees
ON Departments.DepartmentID = Employees.DepartmentID
;


8. Using Students, Enrollments table
List student names and their enrolled course IDs.

SELECT Name, CourseID
FROM Students
INNER JOIN Enrollments
ON Students.StudentID = Enrollments.StudentID
;


9. Using Payments, Orders table
List all orders that have matching payments.

SELECT CustomerID
FROM Orders
INNER JOIN Payments
ON Orders.OrderID = Payments.OrderID
;


10. Using Orders, Products table
Show orders where product price is more than 100.

SELECT OrderID, ProductName, Price
FROM Orders
INNER JOIN Products
   ON Orders.ProductID = Products.ProductID
WHERE Products.Price > 100
;


## 🟡 Medium (10 puzzles)
11. Using Employees, Departments table List employee names and department names where department IDs are not equal. It means: Show all mismatched employee-department combinations.

SELECT Name, DepartmentName
FROM Employees
CROSS JOIN Departments
WHERE Employees.DepartmentID <> Departments.DepartmentID
;


12. Using Orders, Products table Show orders where ordered quantity is greater than stock quantity.

SELECT OrderID, ProductName
FROM Orders
INNER JOIN Products
ON Orders.ProductID = Products.ProductID
WHERE Orders.Quantity > Products.Stockquantity
;


13. Using Customers, Sales table List customer names and product IDs where sale amount is 500 or more.

SELECT FirstName, LastName, ProductID, SaleAmount
FROM Customers
INNER JOIN Sales
ON Customers.CustomerID = Sales.CustomerID
WHERE Sales.SaleAmount >= 500
;


14. Using Courses, Enrollments, Students table List student names and course names they’re enrolled in.

Students.StudentID = Enrollments.StudentID

Courses.CourseID = Enrollments.CourseID

SELECT Students.Name, Courses.CourseName
FROM Enrollments
INNER JOIN Courses ON Courses.CourseID = Enrollments.CourseID
INNER JOIN Students ON Enrollments.StudentID = Students.StudentID;


15. Using Products, Suppliers table List product and supplier names where supplier name contains “Tech”.

SELECT ProductName, SupplierName
FROM Products
INNER JOIN Suppliers
ON Products.SupplierID = Suppliers.SupplierID
WHERE SupplierName LIKE '%Tech%'
;


16. Using Orders, Payments table Show orders where payment amount is less than total amount.

SELECT Orders.OrderID, Payments.Amount, Orders.TotalAmount
FROM Orders
INNER JOIN Payments
   ON Orders.OrderID = Payments.OrderID
WHERE Orders.TotalAmount > Payments.Amount;


17. Using Employees and Departments tables, get the Department Name for each employee.

SELECT Employees.Name, Departments.DepartmentName
FROM Employees
INNER JOIN Departments
   ON Employees.DepartmentID = Departments.DepartmentID;



18. Using Products, Categories table Show products where category is either 'Electronics' or 'Furniture'.

SELECT ProductName, CategoryName
FROM Products
INNER JOIN Categories
   ON Products.CategoryID = Categories.CategoryID
WHERE CategoryName IN ('Electronics', 'Furniture');



19. Using Sales, Customers table Show all sales from customers who are from 'USA'.

SELECT Sales.SaleID, Sales.ProductID, Sales.SaleAmount, Customers.FirstName, Customers.LastName
FROM Sales
INNER JOIN Customers
   ON Sales.CustomerID = Customers.CustomerID
WHERE Customers.Country = 'USA';



20. Using Orders, Customers table List orders made by customers from 'Germany' and order total > 100.

SELECT Orders.OrderID, Orders.TotalAmount, Customers.FirstName, Customers.LastName, Customers.Country
FROM Orders
INNER JOIN Customers
   ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.Country = 'Germany'
  AND Orders.TotalAmount > 100;

## 🔴 Hard (5 puzzles)(Do some research for the tasks below)

21. Using Employees table List all pairs of employees from different departments.

SELECT e1.Name AS Employee1, e2.Name AS Employee2
FROM Employees e1
INNER JOIN Employees e2
   ON e1.EmployeeID < e2.EmployeeID
  AND e1.DepartmentID <> e2.DepartmentID;



22. Using Payments, Orders, Products table List payment details where the paid amount is not equal to (Quantity × Product Price).

SELECT Payments.PaymentID, Orders.OrderID, Payments.Amount, (Orders.Quantity * Products.Price) AS ExpectedAmount
FROM Payments
INNER JOIN Orders
   ON Payments.OrderID = Orders.OrderID
INNER JOIN Products
   ON Orders.ProductID = Products.ProductID
WHERE Payments.Amount <> (Orders.Quantity * Products.Price);


23. Using Students, Enrollments, Courses table Find students who are not enrolled in any course.

SELECT Students.StudentID, Students.Name
FROM Students
LEFT JOIN Enrollments
   ON Students.StudentID = Enrollments.StudentID
WHERE Enrollments.StudentID IS NULL;


24. Using Employees table List employees who are managers of someone, but their salary is less than or equal to the person they manage.

SELECT m.EmployeeID AS ManagerID, m.Name AS ManagerName, m.Salary AS ManagerSalary,
       e.EmployeeID AS EmployeeID, e.Name AS EmployeeName, e.Salary AS EmployeeSalary
FROM Employees e
INNER JOIN Employees m
   ON e.ManagerID = m.EmployeeID
WHERE m.Salary <= e.Salary;



25. Using Orders, Payments, Customers table List customers who have made an order, but no payment has been recorded for it.

SELECT DISTINCT Customers.CustomerID, Customers.FirstName, Customers.LastName
FROM Customers
INNER JOIN Orders
   ON Customers.CustomerID = Orders.CustomerID
LEFT JOIN Payments
   ON Orders.OrderID = Payments.OrderID
WHERE Payments.OrderID IS NULL;

