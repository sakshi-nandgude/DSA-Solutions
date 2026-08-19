/*
Problem: Placements

Goal:
Find the names of students whose best friend received
a higher salary offer than the student.

Tables:

1. Students
   ID
   Name

2. Friends
   ID
   Friend_ID

3. Packages
   ID
   Salary


Approach:

Step 1:
Start with the Students table because we need to output
the student's Name.

Step 2:
Join Students with Friends using ID.
This tells us the Friend_ID (best friend) of each student.

Step 3:
Join Packages using the student's ID.
This gives us the salary offered to the student.

Step 4:
Join Packages AGAIN using Friend_ID.
This gives us the salary offered to the student's best friend.

Important:
We join Packages twice because we need two different salaries:
- Student's salary
- Best friend's salary

Step 5:
Compare the two salaries.
Keep only students where:

Friend's Salary > Student's Salary

Step 6:
Order the result by the best friend's salary.
*/


-- Step 1: Start with Students
SELECT s.Name
FROM Students AS s


-- Step 2: Get each student's best friend
JOIN Friends AS f
    ON s.ID = f.ID


-- Step 3: Get the student's salary
JOIN Packages AS student_package
    ON s.ID = student_package.ID


-- Step 4: Get the best friend's salary
JOIN Packages AS friend_package
    ON f.Friend_ID = friend_package.ID


-- Step 5: Keep students whose best friend earns more
WHERE friend_package.Salary > student_package.Salary


-- Step 6: Sort by the salary offered to the best friend
ORDER BY friend_package.Salary;