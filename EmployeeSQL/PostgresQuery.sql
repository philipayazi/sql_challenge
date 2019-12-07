--Create table for departments
CREATE TABLE departments
(
	dept_no VARCHAR(20) Primary KEY,
	dept_name VARCHAR(30)
);

SELECT * FROM salaries

--Create table for employees
CREATE TABLE employees --After doing a count on each column there does not seem to be any missing values
(
	emp_no INT Primary KEY,
	birth_date DATE NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	gender VARCHAR(2) NOT NULL,
	hire_date DATE NOT NULL
);

--Create table for department managers
CREATE TABLE dept_manager
(
	dept_no VARCHAR(20),
	emp_no INT,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
	Primary KEY (dept_no, emp_no)
);

--Create table for department employee
Create Table dept_emp
(
	emp_no INT NOT NULL,
	dept_no VARCHAR(20),
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no)REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

--Create table for Salaries
CREATE TABLE salaries
(
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

--Create table for Titles
CREATE TABLE titles
(
	emp_no INT NOT NULL,
	title VARCHAR(30) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL
);

--Create Table for Employee Details
--Table should include employee number, first name, last name, gender, and salary
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
ORDER BY emp_no ASC;

--Find all employees hired in 1986
SELECT * FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';

--List the manager of each department with the following informatin
--dept_no, dept_name, emp_no, last_name, first_name, from_date, to_date
SELECT d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name, dm.from_date, dm.to_date
FROM dept_manager dm
JOIN departments d ON d.dept_no = dm.dept_no
JOIN employees e on dm.emp_no = e.emp_no;

--List the departments of each employee with the following information:
-- emp_no, last name,first name, dept_name
SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp de
JOIN employees e ON de.emp_no = e.emp_no
JOIN departments d ON de.dept_no = d.dept_no
ORDER BY emp_no ASC;

--List all employees whose first name is Hercules and last name begins with B
SELECT first_name, last_name
FROM employees
WHERE first_name = 'Hercules' AND last_name Like 'B%';

--List all employees in the Sales department including:
-- emp_no, last_name, first_name, and dept_name
SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp de
JOIN departments d ON de.dept_no = d.dept_no
JOIN employees e ON de.emp_no = e.emp_no
WHERE dept_name = 'Sales';

--List all employees in the Sales and Development departments including:
-- emp_no, last_name, first_name, dept_name
SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp de
JOIN departments d ON de.dept_no = d.dept_no
JOIN employees e ON de.emp_no = e.emp_no
WHERE dept_name = 'Sales' OR dept_name = 'Development';

--In decsending order, list the frequency count of employee last names
--i.e. how many employees share each last name
SELECT last_name, COUNT(*) AS TotalCount
FROM employees
GROUP BY last_name;


--Bonus Section
--Create a histogram of most common salary ranges
--Create a bar chart of average salary by title
--To complete merge the salaries table and titles table into a view 
--Then read this view into a pandas dataframe 
--From a quick query there are about 300,000 rows for salaries and about 443,000 rows for titles
--Seems like people got promotions without an increase in salary. Or maybe previous salaries were over written with new salaries
CREATE VIEW title_salaries AS
	SELECT t.emp_no, t.title, s.salary
	FROM titles t
	JOIN salaries s on t.emp_no = s.emp_no
	ORDER BY salary DESC;

