/*
Question: 
Finding Updated Records


Last Updated: June 2026

Easy
ID 10299
692

We have a table with employees and their salaries; however, some of the records are old and contain outdated salary information. Since there is no timestamp, assume salary is non-decreasing over time. You can consider the current salary for an employee is the largest salary value among their records. If multiple records share the same maximum salary, return any one of them. Output their id, first name, last name, department ID, and current salary. Order your list by employee ID in ascending order.

Table
ms_employee_salary
id	first_name	last_name	salary	department_id
1	Todd	Wilson	110000	1006
1	Todd	Wilson	106119	1006
66	Dustin	Bush	47567	1004
67	Tyler	Green	111085	1002
68	Antonio	Carpenter	83684	1002
69	Ernest	Peterson	115993	1005
70	Karen	Fernandez	101238	1003
71	Kristine	Casey	67651	1003
72	Christine	Frye	137244	1004
73	William	Preston	155225	1003
74	Richard	Cole	180361	1003

Approach

1. Group records by employee id.
2. Find the maximum salary for each employee.
3. Join back to the original table to retrieve
   the employee details corresponding to that salary.
4. Sort by employee id.
*/

SELECT
    m.id,
    m.first_name,
    m.last_name,
    m.department_id,
    m.salary
FROM ms_employee_salary m

-- Find current (maximum) salary for each employee
JOIN
(
    SELECT
        id,
        MAX(salary) AS current_salary
    FROM ms_employee_salary
    GROUP BY id
) t

-- Match employee id and current salary
ON m.id = t.id
AND m.salary = t.current_salary

-- Display employees ordered by id
ORDER BY m.id;