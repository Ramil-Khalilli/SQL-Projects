-- Throughout all this project sample schema HR provided by Oracle Database.
-- 1) Show minimum, average and maximum salary in last 15 years according
-- to job id.
select
    job_id,
    min(salary) as "minimum salary",
    avg(salary) as "average salary",
    max(salary) as "maximum salary"
from hr.employees
where extract(year from sysdate) - extract(year from hire_date) >= 15
group by job_id;

-- 2) How many employees hired after 2005 for each department?
select
    department_id,
    count(*)
from hr.employees
where extract(year from hire_date) > 2005 and department_id is not null
group by department_id;

-- 3) Write a query to show departments in which the difference between
-- maximum and minimum salary is greater than 5000.
select
    department_id,
    max(salary) - min(salary) as "Salary_Diff"
from hr.employees
group by department_id
having max(salary) - min(salary) > 5000;

-- 4) Display salaries of employees who has not commission pact according
-- to departments (without using where and having).
select
    department_id,
    sum(
        case when commission_pct is null then salary
            else 0 end
    ) as "Total Salary"
from hr.employees
group by department_id
order by 2 desc;

-- 5) How many people has job id with average salary between 3000 and
-- 7000?
select
    job_id,
    count(*) as "Number of Employees"
from hr.employees
group by job_id
having avg(salary) between 3000 and 7000
order by job_id asc;

-- 6) Find number of employees with same name.
select
    first_name,
    count(*) as "Number of Employees"
from hr.employees
group by first_name
having count(*) > 1
order by 2 desc;

-- 7) How many people with the same phone code work in departments 50 and
-- 90?
select
    substr(phone_number, 1, 3) as "Phone Code",
    count(*) as "Number of Employees"
from hr.employees
where department_id in (50, 90)
group by substr(phone_number, 1, 3)
having count(*) > 1
order by 2 asc;

-- 8) Display departments with number of employees more than 5
-- in spring and autumn.
select
    department_id,
    count(*) as "Number of Employees"
from hr.employees
where extract(month from hire_date) in (3, 4, 5, 9, 10, 11)
group by department_id
having count(*) > 5;

-- 9) How many employees work in departments which has maximum salary
-- more than 5000?
select
    department_id,
    count(*) as "Number of Employees"
from hr.employees
group by department_id
having max(salary) > 5000
order by 2 desc;

-- 10) Change second letter of employees� names with the last letter and
-- display.
select
    first_name,
    substr(first_name, 1, 1) ||
    substr(first_name, -1, 1) ||
    substr(first_name, 3, length(first_name) - 3) ||
    substr(first_name, 2, 1) as "Modified Name"
from hr.employees;

-- 11) Display employees who joined in the month of May.
select
    first_name || ' ' || last_name as "Full Name",
    hire_date
from hr.employees
where extract(month from hire_date) = 5;

-- 12) Display employees who joined in the current year.
select
    first_name || ' ' || last_name as "Full Name",
    hire_date
from hr.employees
where extract(year from hire_date) = extract(year from sysdate);

-- 13) Display the number of days between system date and 1st January 2011.
select (sysdate - to_date('01-01-2011', 'dd-mm-yyyy')) from dual;

-- 14) Display maximum salary of employees.
select
    max(salary) as "Maximum Salary"
from hr.employees;

-- 15) Display number of employees in each department.
select
    department_id,
    count(*) as "Number of Employees"
from hr.employees
group by department_id
order by 2 desc;

-- 16) Display number of employees who joined after 15th of month.
select
    count(*) as "Number of Employees"
from hr.employees
where extract(day from hire_date) > 15;

-- 17) Display average salary of employees in each department who have
-- commission percentage.
select
    department_id,
    avg(salary) as "Average Salary"
from hr.employees
where commission_pct is not null and department_id is not null
group by department_id;

-- 18) Display job ID for jobs with average salary more than 10000.
select
    job_id
from hr.employees
group by job_id
having avg(salary) > 10000;

-- 19) Display job ID, number of employees, sum of salary, and difference
-- between the highest salary and the lowest salary of the employees for
-- all jobs.
select
    job_id,
    count(*) as "Number of Employees",
    sum(salary) as "Total Salary",
    max(salary) - min(salary) as "Salary Difference"
from hr.employees
group by job_id;

-- 20) Display manager ID and number of employees managed by the manager.
select
    manager_id,
    count(*) as "Number of Employees"
from hr.employees
where manager_id is not null
group by manager_id;

-- 21. Display the first promotion year for each employee.
select
	emp.first_name,
	emp.last_name,
	extract (year from min(jh.end_date)) as first_promotion_year
from hr.employees emp
left join hr.job_history jh on emp.employee_id = jh.employee_id
group by emp.first_name, emp.last_name;

-- 22. Display location, city and department name of employees who have been promoted more than
-- once.
select
	emp.first_name || ' ' || emp.last_name as full_name,
	loc.location_id,
	loc.city,
	dep.department_name
from hr.locations loc
join departments dep on dep.location_id = loc.location_id
right join employees emp on emp.department_id = dep.department_id
where emp.employee_id in (select employee_id from hr.job_history group by employee_id having count(*) > 1);

-- 23. Display minimum and maximum “hire_date” of employees work in IT and HR departments.
select
	first_name || ' ' || last_name as full_name,
	min(hire_date) as minimum_hire_date,
	max(hire_date) as maximum_hire_date
from hr.employees
where department_id in (103, 203)
group by first_name || ' ' || last_name;

-- 24. Find difference between current date and hire dates of employees after sorting them by hire
-- date, then show difference in days, months and years.
select
	round(sysdate - hire_date) as days_diff,
	round(months_between(sysdate, hire_date)) as months_diff,
	extract(year from sysdate) - extract(year from hire_date) as years_diff
from hr.employees
order by hire_date desc;

-- 25. Find which departments used to hire earliest/latest.
select
	dep.department_name,
	'Earliest' as timing
from hr.departments dep
where department_id in
(select department_id from hr.employees where hire_date = (select min(hire_date) from hr.employees))

union all

select
	dep.department_name,
	'Latest' as timing
from hr.departments dep
where department_id in
(select department_id from hr.employees where hire_date = (select max(hire_date) from hr.employees));

-- 26. Find the number of departments with no employee for each city.
select
	loc.city,
	count(dep.department_id) as number_of_empty_departments
from hr.locations loc
join departments dep on dep.location_id = loc.location_id
left join employees emp on emp.department_id = dep.department_id
where emp.employee_id is null
group by loc.city;

-- 27. Create a category called “seasons” and find in which season most employees were hired.
select season, count(*) from 
(select
	case
		when extract(month from hire_date) in (12, 1, 2) then 'Winter'
		when extract(month from hire_date) in (3, 4, 5) then 'Spring'
		when extract(month from hire_date) in (6, 7, 8) then 'Summer'
		when extract(month from hire_date) in (9, 10, 11) then 'Fall'
	end as season
from hr.employees)
group by season
order by 2 desc;

-- 28. Find the cities of employees with average salary more than 5000.
select 
	loc.city,
	round(avg(emp.salary)) as average_salary
from hr.locations loc
join departments dep on dep.location_id = loc.location_id
join employees emp on emp.department_id = dep.department_id
group by loc.city
having avg(emp.salary) > 5000
order by 2 desc;

-- 29. Display last name, job title of employees who have commission percentage and belongs to
-- department 30.
select
	last_name,
	job_id
from hr.employees
where commission_pct is not null and department_id = 30;

-- 30. Display department name, manager name, and salary of the manager for all managers whose
-- experience is more than 5 years.
select 
	distinct emp2.employee_id,
	emp2.first_name,
	emp2.last_name,
	dep.department_name,
	emp2.salary
from hr.employees emp
join hr.employees emp2 on emp.manager_id = emp2.employee_id
join departments dep on dep.department_id = emp2.department_id
where emp2.hire_date < add_months(sysdate, -60);

-- 31. Display employee name if the employee joined before his manager.
select
	emp.first_name,
	emp.last_name
from hr.employees emp
join hr.employees emp2 on emp.manager_id = emp2.employee_id
where emp.hire_date < emp2.hire_date;

-- 32. Display employee name, job title for the jobs, employee did in the past where the job was
-- done less than six months.
select
	distinct
	emp.first_name,
	emp.last_name,
	emp.job_id
from hr.employees emp
join job_history jh on jh.employee_id = emp.employee_id
where months_between(jh.start_date, jh.end_date) < 6;

-- 33. Display department name, average salary and number of employees with commission within
-- the department.
select
	dep.department_name,
	avg(emp.salary) as average_salary,
	count(employee_id) as number_of_employees
from hr.departments dep
join hr.employees emp on emp.department_id = dep.department_id
where commission_pct is not null
group by dep.department_name;

-- 34. Display employee name and country in which he is working.
select
	emp.first_name,
	emp.last_name,
	loc.country_id
from hr.employees emp
join departments dep on dep.department_id = emp.department_id
join locations loc on loc.location_id = dep.location_id;

-- 35. Return the name of the employee with the lowest salary in department 90.
select
	first_name,
	last_name
from hr.employees
where salary = (select max(salary) from hr.employees);

-- 36. Select the department name, employee name, and salary of all employees who work in the
-- human resources or purchasing departments. Compute a rank for each unique salary in both
-- departments.
select
	dep.department_name,
	emp.first_name ||  ' ' || emp.last_name,
	emp.salary,
	dense_rank() over (partition by dep.department_name order by emp.salary desc) as ranking
from hr.employees emp
join hr.departments dep on dep.department_id = emp.department_id
where dep.department_id in (30, 40);

-- 37. Select the 3 employees with minimum salary for department id 50.
select
	employee_id,
	first_name,
	last_name
from (select
		employee_id,
		first_name,
		last_name,
		row_number() over (order by SALARY  asc) as ranking
	from hr.employees where department_id = 50)
where ranking <= 3;

-- 38. Show first name, last name, salary and previously listed employee’s salary who works in
-- “IT_PROG” over hire date.
select
	emp.first_name,
	emp.last_name,
	emp.salary,
	lag(emp.salary) over (order by emp.hire_date asc) as prev_salary
from hr.employees emp
join departments dep on dep.department_id = emp.department_id
where dep.department_id = 60;

-- 39 Display details of current job for employees who worked as IT Programmers in the past.
select 
	distinct
	j.*
from hr.jobs j
join hr.employees emp on emp.job_id = j.job_id
join hr.job_history jh on jh.employee_id = emp.employee_id;

-- 40. Make a copy of the employees table and update the salaries of the employees in the new table
-- with the maximum salary in their departments.
create table emp as select * from hr.employees;

select * from hr.emp;

update emp e set salary = (select max(salary) from hr.employees emp2 where emp2.department_id = e.department_id);

-- 41. Make a copy of the employees table and update the salaries of the employees in the new table
-- with a 30 percent increase.
create table emp_copy as select * from hr.employees;

select * from emp_copy;

update emp_copy set salary = salary*1.3;