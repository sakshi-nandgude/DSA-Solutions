-- Question:
-- Find the difference between:
-- 1. The total number of CITY entries.
-- 2. The number of distinct CITY entries.

-- Approach:
-- 1. COUNT(CITY) counts all non-NULL CITY values.
-- 2. COUNT(DISTINCT CITY) counts each unique CITY only once.
-- 3. Subtract the distinct count from the total count.

SELECT
    COUNT(CITY) - COUNT(DISTINCT CITY) AS difference
FROM STATION;