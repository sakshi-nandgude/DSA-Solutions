/*
QUESTION:
Find the two cities in the STATION table:
1. The city with the SHORTEST name
2. The city with the LONGEST name

Also return the length of each city name.

IMPORTANT:
- If multiple cities have the same shortest length,
  choose the city that comes FIRST alphabetically.
- If multiple cities have the same longest length,
  choose the city that comes FIRST alphabetically.


APPROACH:

For the SHORTEST city:
1. Get CITY and its length using LENGTH(CITY).
2. Sort by length in ASCENDING order.
3. If two cities have the same length, sort CITY alphabetically.
4. Take only the first row using LIMIT 1.

For the LONGEST city:
1. Get CITY and its length.
2. Sort by length in DESCENDING order.
3. If two cities have the same length, sort CITY alphabetically.
4. Take only the first row using LIMIT 1.

We can use two separate queries as allowed by the question.
*/


-- ==========================================
-- 1. FIND THE CITY WITH THE SHORTEST NAME
-- ==========================================

SELECT CITY, LENGTH(CITY)
FROM STATION

-- First sort by the length of the city name
-- Smallest length comes first
ORDER BY LENGTH(CITY) ASC,

-- If multiple cities have the same length,
-- choose the one that comes first alphabetically
CITY ASC

-- We only need the first city
LIMIT 1;


-- ==========================================
-- 2. FIND THE CITY WITH THE LONGEST NAME
-- ==========================================

SELECT CITY, LENGTH(CITY)
FROM STATION

-- First sort by the length of the city name
-- Largest length comes first
ORDER BY LENGTH(CITY) DESC,

-- If multiple cities have the same length,
-- choose the one that comes first alphabetically
CITY ASC

-- We only need the first city
LIMIT 1;