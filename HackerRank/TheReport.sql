/*
===========================================================
Problem: The Report (HackerRank)
===========================================================

Problem Type:
- SQL
- JOIN
- CASE WHEN
- Conditional Sorting
- Range Join (BETWEEN)

-----------------------------------------------------------
Problem Statement:
-----------------------------------------------------------
Given two tables:
1. Students(ID, Name, Marks)
2. Grades(Grade, Min_Mark, Max_Mark)

Generate a report with:
- Name
- Grade
- Marks

Rules:
1. If Grade >= 8, display the student's name.
2. If Grade < 8, display NULL instead of the name.
3. Sort by Grade in descending order.
4. For Grade >= 8:
      Sort students alphabetically by Name.
5. For Grade < 8:
      Sort students by Marks in ascending order.

-----------------------------------------------------------
Approach:
-----------------------------------------------------------
1. Join Students and Grades using marks range:
      Students.Marks BETWEEN Grades.Min_Mark AND Grades.Max_Mark

2. Use CASE WHEN:
      - Replace Name with NULL for grades below 8.
      - Otherwise display the student's name.

3. Apply conditional sorting:
      - Grade DESC
      - If Grade >= 8 -> sort by Name
      - If Grade < 8 -> sort by Marks

-----------------------------------------------------------
Algorithm:
-----------------------------------------------------------
1. Join both tables using BETWEEN.
2. Select:
      CASE
          WHEN Grade < 8 THEN NULL
          ELSE Name
      END
3. Display Grade and Marks.
4. Order results according to the problem rules.

-----------------------------------------------------------
SQL Concepts Used:
-----------------------------------------------------------
✔ INNER JOIN
✔ BETWEEN
✔ CASE WHEN
✔ ORDER BY
✔ Conditional ORDER BY
✔ NULL values

-----------------------------------------------------------
Time Complexity:
-----------------------------------------------------------
O(n × m)
where
n = number of students
m = number of grade ranges

Since Grades usually has only 10 rows (1-10),
the practical complexity is approximately O(n).

-----------------------------------------------------------
Space Complexity:
-----------------------------------------------------------
O(1)
(No extra data structures are used.)

-----------------------------------------------------------
Interview Takeaway:
-----------------------------------------------------------
Pattern:
Join + CASE WHEN + Conditional ORDER BY

Key Learning:
- Use BETWEEN to join based on value ranges.
- CASE WHEN can modify displayed values.
- CASE can also be used inside ORDER BY for different
  sorting rules based on conditions.
===========================================================
*/

SELECT 
CASE 
    WHEN g.grade < 8 THEN NULL
    ELSE s.name
END AS Name,
g.grade,
s.marks
FROM Students s
JOIN Grades g
ON s.marks BETWEEN g.min_mark AND g.max_mark
ORDER BY 
    g.grade DESC,
    CASE
        g.grade >= 8 THEN s.name
    END ASC,
    CASE 
        g.grade < 8 THEN s.marks
    END ASC;

