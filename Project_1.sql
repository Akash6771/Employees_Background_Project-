



----Q1(a): Find the list of employees whose salary ranges between 2L to 3L.-------

Select empname,salary from employees
where salary between 200000 and 300000

--Q1(b): Write a query to retrieve the list of employees from the same city------

SELECT E1.EmpID, E1.EmpName, E1.City
FROM Employees E1, Employees E2
WHERE E1.City = E2.City and E1.EmpID != E2.EmpID

--Q1(c): Query to find the null values in the Employee table.--

Select * From employees
where empid is null

--Q2(a): Query to find the cumulative sum of employee’s salary.--

Select empname, salary, sum(salary) Over (Order by empid) As cumulative_salary 
from employees

Q2(b): What’s the male and female employees ratio.

with cte as (

		select  distinct(gender), 
	     count(gender) over(partition by gender) as number_gender, 
         count(gender) over() as total_case
        from employees
        group by gender, empname
)
select number_gender*100/total_case  from cte;

--Write a query to fetch 50% records from the Employee table.---

Select * from employees
where empid <=
(Select count(empid)/2 from employees)


---Q3: Query to fetch the employee’s salary but replace the LAST 2 digits with ‘XX’
i.e 12345 will be 123XX----

SELECT Salary,
Concat(LEFT(Salary, LENGTH(Salary)-2), 'XX') as masked_salary
FROM Employees

Q4: Write a query to fetch even and odd rows from Employee table.

Select * From
(select *, Row_number() over(order by empid) as Rownumber 
from employees) as emp
Where Emp.RowNumber % 2 = 0

Select * From
(select *, Row_number() over(order by empid) as Rownumber 
from employees) as emp
Where Emp.RowNumber % 2 = 1


---------Q5(a): Write a query to find all the Employee names whose name:
• Begin with ‘A’
• Contains ‘A’ alphabet at second place
• Contains ‘Y’ alphabet at second last place
• Ends with ‘L’ and contains 4 alphabets
• Begins with ‘V’ and ends with ‘A’------------

SELECT * FROM Employee WHERE EmpName LIKE 'A%';
SELECT * FROM Employees WHERE EmpName LIKE '_a%';
SELECT * FROM Employees WHERE EmpName LIKE '%y_';
SELECT * FROM Employees WHERE EmpName LIKE '____l';
SELECT * FROM Employees WHERE EmpName LIKE 'V%a'
 
---Q5(b): Write a query to find the list of Employee names which is:
• starting with vowels (a, e, i, o, or u), without duplicates
• ending with vowels (a, e, i, o, or u), without duplicates
• starting & ending with vowels (a, e, i, o, or u), without duplicates----

SELECT DISTINCT EmpName
FROM Employees
WHERE LOWER(EmpName) REGEXP '^[aeiou]'

SELECT DISTINCT EmpName
FROM Employees
WHERE LOWER(EmpName) REGEXP '[aeiou]$'

SELECT DISTINCT EmpName
FROM Employees
WHERE LOWER(EmpName) REGEXP
'^[aeiou].*[aeiou]$'

--Find Nth highest salary from employee table with and without using the
TOP/LIMIT keywords.
------

SELECT Salary FROM Employees
ORDER BY Salary DESC
LIMIT 1 OFFSET 1

#Q7(a): Write a query to find and remove duplicate records from a table.#

SELECT EmpId, Empname,gender,salary, City, Count(*) as dublicate_values
From Employees
Group by EmpId,Empname,gender,salary, City
Having count(*) > 1;

DELETE FROM Employees
WHERE EmpID IN
(SELECT EmpID FROM Employees
GROUP BY EmpID
HAVING COUNT(*) > 1);

#Q7(b): Query to retrieve the list of employees working in same project.#

SELECT * FROM employees;
With CTE AS
(Select e.empid, e.empname, ed.project from
employees AS E
Inner join Employeedetails AS ED 
on e.empid = ed.empid)

Select  c1.Empname, c2.empname, c1.project
from CTE c1, CTE c2
where c1.project = c2.project AND c1.empid != c2.empid AND c1.empid < c2.empid

# Show the employee with the highest salary for each project #

Select  ed.project, max(e.salary) as projectSal from
employees AS E
Inner join Employeedetails AS ED 
on e.empid = ed.empid
group by project
Order by projectSal desc

WITH CTE AS
(SELECT project, EmpName, salary,
ROW_NUMBER() OVER (PARTITION BY project ORDER BY salary DESC) AS row_rank
FROM Employees AS e
INNER JOIN EmployeeDetails AS ed
ON e.EmpID = ed.EmpID)
SELECT project, EmpName, salary
FROM CTE
WHERE row_rank = 1;

#Query to find the total count of employees joined each year#

Select year(Doj) as DOJ, Count(*) AS EmpCount from
employees AS E
Inner join Employeedetails AS ED 
on e.empid = ed.empid
Group by year(Doj)

#Create 3 groups based on salary col, salary less than 1L is low, between 1 -
#2L is medium and above 2L is High#

Select EmpName, Salary, 
Case 
when Salary  > 200000 then 'High' 
when Salary  >= 100000 and salary <= 200000 then 'Medium' 
else 'low' 
End AS Salary_Range
From Employees 

##Query to pivot the data in the Employee table and retrieve the total
salary for each city.
The result should display the EmpID, EmpName, and separate columns for each city
(Mathura, Pune, Delhi), containing the corresponding total salary##


Select empid,empname,
sum(Case when City = 'Mathura' then salary end) AS 'Mathura',
sum(Case when City = 'Pune' then salary end) AS 'Pune',
sum(Case when City = 'Delhi' then salary end) AS 'Delhi'
From employees
group by empid,empname





