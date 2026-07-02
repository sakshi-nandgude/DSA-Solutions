/*
You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date. It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.



If the End_Date of the tasks are consecutive, then they are part of the same project. Samantha is interested in finding the total number of different projects completed.

Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. If there is more than one project that have the same number of completion days, then order by the start date of the project.

Sample Input



Sample Output

2015-10-28 2015-10-29
2015-10-30 2015-10-31
2015-10-13 2015-10-15
2015-10-01 2015-10-04

Explanation

The example describes following four projects:

Project 1: Tasks 1, 2 and 3 are completed on consecutive days, so these are part of the project. Thus start date of project is 2015-10-01 and end date is 2015-10-04, so it took 3 days to complete the project.
Project 2: Tasks 4 and 5 are completed on consecutive days, so these are part of the project. Thus, the start date of project is 2015-10-13 and end date is 2015-10-15, so it took 2 days to complete the project.
Project 3: Only task 6 is part of the project. Thus, the start date of project is 2015-10-28 and end date is 2015-10-29, so it took 1 day to complete the project.
Project 4: Only task 7 is part of the project. Thus, the start date of project is 2015-10-30 and end date is 2015-10-31, so it took 1 day to complete the project.
*/

/*
Enter your query here.
*/
/*
Find all projects by identifying:
1. Project start dates
2. Project end dates
3. Pair each start with the nearest valid end
*/

SELECT
    s.Start_Date,
    MIN(e.End_Date) AS End_Date      -- Choose the nearest valid end date for each project

FROM
(
    /*
    A project STARTS when its Start_Date
    is NOT the End_Date of any previous task.
    */
    SELECT Start_Date
    FROM Projects
    WHERE Start_Date NOT IN
    (
        SELECT End_Date
        FROM Projects
    )
) AS s

JOIN

(
    /*
    A project ENDS when its End_Date
    is NOT the Start_Date of any later task.
    */
    SELECT End_Date
    FROM Projects
    WHERE End_Date NOT IN
    (
        SELECT Start_Date
        FROM Projects
    )
) AS e

/*
Join every project start with every possible
project end that occurs on or after it.

Example:

Start = Oct 1

Possible Ends:
Oct 4
Oct 15
Oct 29
Oct 31

Later we use MIN() to pick Oct 4.
*/
ON e.End_Date >= s.Start_Date

/*
After the join, one Start_Date has multiple End_Dates.

Example:

Oct1  Oct4
Oct1  Oct15
Oct1  Oct29
Oct1  Oct31

GROUP BY makes all these rows one group.
*/
GROUP BY s.Start_Date

/*
Sort projects by duration (smallest first).

DATEDIFF(end, start)
returns the number of days.

If two projects have the same duration,
sort by Start_Date.
*/
ORDER BY
    DATEDIFF(MIN(e.End_Date), s.Start_Date),
    s.Start_Date;