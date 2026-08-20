/*
===========================================================
HACKERRANK - CHALLENGES
===========================================================

GOAL:
1. Print hacker_id, name, and total challenges.
2. Sort by total challenges DESC.
3. If counts are equal, sort by hacker_id ASC.
4. If multiple hackers have the same count and that count
   is less than the maximum, exclude those hackers.

===========================================================
STEP 1: JOIN
===========================================================

Join Hackers and Challenges using hacker_id.

This allows us to connect each hacker with the
challenges they created.

===========================================================
STEP 2: GROUP BY
===========================================================

Group by hacker_id and name.

This creates one group for each hacker.

COUNT(challenge_id) then counts how many challenges
each hacker created.

Example:

hacker_id | challenge_count
----------|----------------
1         | 6
2         | 5
3         | 5
4         | 3
5         | 2

===========================================================
STEP 3: FIND THE MAXIMUM CHALLENGE COUNT
===========================================================

First:

    SELECT COUNT(*)
    FROM Challenges
    GROUP BY hacker_id

calculates the number of challenges for every hacker.

Example:

6
5
5
3
2

Then MAX() finds the largest value:

6

This means hackers with 6 challenges must be kept.

===========================================================
STEP 4: FIND UNIQUE CHALLENGE COUNTS
===========================================================

We calculate the challenge count for every hacker.

Then GROUP BY challenge_count groups hackers
according to how many challenges they created.

Example:

6 -> 1 hacker
5 -> 2 hackers
3 -> 1 hacker
2 -> 1 hacker

HAVING COUNT(*) = 1 keeps only counts that belong
to exactly one hacker.

Therefore:

6 -> KEEP
5 -> REMOVE
3 -> KEEP
2 -> KEEP

===========================================================
STEP 5: HAVING
===========================================================

A hacker should be kept when:

    Their challenge count is the maximum

OR

    Their challenge count occurs only once

Therefore:

COUNT = MAXIMUM
OR
COUNT IN (UNIQUE COUNTS)

===========================================================
STEP 6: ORDER BY
===========================================================

First sort by total_challenges DESC.

This puts the hacker with the most challenges first.

If two hackers have the same number of challenges,
sort them by hacker_id ASC.

===========================================================
FINAL QUERY
===========================================================
*/

SELECT
    h.hacker_id,
    h.name,
    COUNT(c.challenge_id) AS total_challenges
FROM Hackers h
JOIN Challenges c
    ON h.hacker_id = c.hacker_id
GROUP BY
    h.hacker_id,
    h.name
HAVING
    COUNT(c.challenge_id) = (
        SELECT MAX(challenge_count)
        FROM (
            SELECT COUNT(*) AS challenge_count
            FROM Challenges
            GROUP BY hacker_id
        ) x
    )
    OR COUNT(c.challenge_id) IN (
        SELECT challenge_count
        FROM (
            SELECT
                hacker_id,
                COUNT(*) AS challenge_count
            FROM Challenges
            GROUP BY hacker_id
        ) y
        GROUP BY challenge_count
        HAVING COUNT(*) = 1
    )
ORDER BY
    total_challenges DESC,
    h.hacker_id ASC;