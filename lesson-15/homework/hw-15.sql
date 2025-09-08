# Lesson-15: Subqueries and Exists

## Level 1: Basic Subqueries

# 1. Find Employees with Minimum Salary

**Task: Retrieve employees who earn the minimum salary in the company.**
**Tables: employees (columns: id, name, salary)**

SELECT *
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);


# 2. Find Products Above Average Price

**Task: Retrieve products priced above the average price.**
**Tables: products (columns: id, product_name, price)**

SELECT *
FROM products
WHERE price > (SELECT AVG(price) FROM products)
;

---

## Level 2: Nested Subqueries with Conditions

**3. Find Employees in Sales Department**
**Task: Retrieve employees who work in the "Sales" department.**
**Tables: employees (columns: id, name, department_id), departments (columns: id, department_name)**

SELECT e.name, d.department_name
FROM employees e
join departments d
ON e.department_id=d.id
WHERE d.department_name = 'Sales'
;
# 4. Find Customers with No Orders

**Task: Retrieve customers who have not placed any orders.**
**Tables: customers (columns: customer_id, name), orders (columns: order_id, customer_id)**

SELECT * FROM customers c
WHERE NOT EXISTS (
select 1 
from orders o 
where c.customer_id=o.customer_id
)
;

--

## Level 3: Aggregation and Grouping in Subqueries

# 5. Find Products with Max Price in Each Category

**Task: Retrieve products with the highest price in each category.**
**Tables: products (columns: id, product_name, price, category_id)**

SELECT *
FROM products p
WHERE p.price = (
    SELECT MAX(s.price)
    FROM products s
    WHERE s.category_id = p.category_id
);


# 6. Find Employees in Department with Highest Average Salary

**Task: Retrieve employees working in the department with the highest average salary.**
**Tables: employees (columns: id, name, salary, department_id), departments (columns: id, department_name)**

SELECT *
FROM employees e
WHERE e.department_id = (
  SELECT TOP 1 s.department_id
  FROM employees s
  GROUP BY s.department_id
  ORDER BY AVG(s.salary) DESC
);




## Level 4: Correlated Subqueries

# 7. Find Employees Earning Above Department Average

**Task: Retrieve employees earning more than the average salary in their department.**
**Tables: employees (columns: id, name, salary, department_id)**

SELECT e.*
FROM employees e
WHERE e.salary > (
    SELECT AVG(s.salary)
    FROM employees s
    WHERE s.department_id = e.department_id 
);


# 8. Find Students with Highest Grade per Course

**Task: Retrieve students who received the highest grade in each course.**
**Tables: students (columns: student_id, name), grades (columns: student_id, course_id, grade)**

SELECT *
FROM students
SELECT *
FROM grades

SELECT s.student_id, s.name, g.course_id, g.grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN (
    SELECT course_id, MAX(grade) AS max_grade
    FROM grades
    GROUP BY course_id
) mg
  ON g.course_id = mg.course_id
 AND g.grade = mg.max_grade;

---

## Level 5: Subqueries with Ranking and Complex Conditions

**9. Find Third-Highest Price per Category**
**Task: Retrieve products with the third-highest price in each category.**
**Tables: products (columns: id, product_name, price, category_id)**

SELECT *
FROM products p1
WHERE p1.price = (
    SELECT price
    FROM products p2
    WHERE p2.category_id = p1.category_id
    ORDER BY price DESC
    OFFSET 2 ROWS FETCH NEXT 1 ROW ONLY
);


# 10. Find Employees whose Salary Between Company Average and Department Max Salary

**Task: Retrieve employees with salaries above the company average but below the maximum in their department.**
**Tables: employees (columns: id, name, salary, department_id)**

SELECT *
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees)
AND salary < (SELECT MAX(s.salary) FROM employees s WHERE s.department_id = e.department_id)
;
