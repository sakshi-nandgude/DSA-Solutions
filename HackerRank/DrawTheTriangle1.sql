/*
QUESTION:
P(R) represents a pattern drawn by Julia in R rows.

P(5):
* * * * *
* * * *
* * *
* *
*

Write a query to print P(20).


APPROACH:
1. Create a MySQL variable @n and set it to 21.
2. Use information_schema.tables to provide enough rows for the query to run 20 times.
3. In each iteration, decrease @n by 1.
4. Use REPEAT('* ', @n) to print the required number of stars.
5. LIMIT 20 ensures that we get exactly 20 rows.
*/

SET @n = 21;

SELECT REPEAT('* ', @n := @n - 1) AS pattern
FROM information_schema.tables
LIMIT 20;