/*
===========================================================
HACKERRANK: OCCUPATIONS
===========================================================

We need TWO result sets.

QUERY 1:
---------
Display every person's name alphabetically.

Format:
Name(FirstLetterOfOccupation)

Example:
Ashley(P)
Jane(A)
Jenny(D)


QUERY 2:
---------
Count how many people belong to each occupation.

Format:
There are a total of 2 doctors.

Rules:
1. Sort by number of occurrences ASCENDING.
2. If two occupations have the same count,
   sort them alphabetically.
*/


/*
===========================================================
QUERY 1
===========================================================

APPROACH:

1. We need the person's Name.
2. We need the first letter of Occupation.
3. LEFT(Occupation, 1) gets the first character.
4. CONCAT() joins the pieces together.
5. ORDER BY Name sorts names alphabetically.
*/


SELECT CONCAT(
    Name,
    '(',
    LEFT(Occupation, 1),
    ')'
)
FROM OCCUPATIONS
ORDER BY Name;


/*
===========================================================
QUERY 2
===========================================================

APPROACH:

1. GROUP BY Occupation
   → puts all people with the same occupation together.

2. COUNT(*)
   → counts how many people are in each occupation.

3. LOWER(Occupation)
   → converts Doctor to doctor, Actor to actor, etc.

4. CONCAT()
   → creates the required sentence.

5. ORDER BY COUNT(*)
   → sorts occupations by number of people,
      smallest count first.

6. Occupation is added after COUNT(*)
   → if two occupations have the same count,
      they are sorted alphabetically.
*/


SELECT CONCAT(
    'There are a total of ',
    COUNT(*),
    ' ',
    LOWER(Occupation),
    's.'
)
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY COUNT(*), Occupation;