/*
===========================================================
Problem: Finding User Purchases
===========================================================

Goal:
Find users who made a SECOND purchase between
1 and 7 days after their FIRST purchase.

Rules:
1. We need to find each user's first purchase.
2. Then find a later purchase by the same user.
3. The second purchase must be:
      - At least 1 day after the first purchase
      - At most 7 days after the first purchase
4. Same-day purchases must be ignored.
5. Output only the user_id.
*/


/*
===========================================================
STEP 1: Find each user's first purchase date
===========================================================

GROUP BY user_id allows us to look at each user separately.

MIN(created_at) gives us the earliest purchase date
for each user.
*/

SELECT
    user_id,
    MIN(created_at) AS first_purchase_date
FROM purchases
GROUP BY user_id;


/*
Example result:

user_id | first_purchase_date
--------|--------------------
103     | 2020-03-29
108     | 2020-03-18
109     | 2020-03-03
120     | 2020-03-18
122     | 2020-03-07
125     | 2020-03-13
130     | 2020-03-28
139     | 2020-03-18
*/


/*
===========================================================
STEP 2: Compare purchases with each user's first purchase
===========================================================

We use the purchases table twice.

p1 = first purchase
p2 = another purchase by the same user

The condition:

p2.created_at > p1.created_at

ensures that p2 happened AFTER p1.

This automatically ignores same-day purchases.
*/


SELECT
    p1.user_id,
    p1.created_at AS first_purchase,
    p2.created_at AS second_purchase
FROM purchases AS p1
JOIN purchases AS p2
    ON p1.user_id = p2.user_id
    AND p2.created_at > p1.created_at;


/*
===========================================================
STEP 3: Make sure p1 is actually the FIRST purchase
===========================================================

We don't want to compare every purchase with every later
purchase.

We only want the user's FIRST purchase.

So we use a subquery:

SELECT MIN(created_at)
FROM purchases
WHERE user_id = p1.user_id

This finds the earliest purchase for that particular user.
*/


SELECT
    p1.user_id,
    p1.created_at AS first_purchase,
    p2.created_at AS second_purchase
FROM purchases AS p1
JOIN purchases AS p2
    ON p1.user_id = p2.user_id
    AND p2.created_at > p1.created_at
WHERE p1.created_at = (
    SELECT MIN(created_at)
    FROM purchases
    WHERE user_id = p1.user_id
);


/*
===========================================================
STEP 4: Check that the second purchase happened
        within 1 to 7 days
===========================================================

DATEDIFF calculates the number of days between
the first and second purchase.

We need:

DATEDIFF(second, first) >= 1
AND
DATEDIFF(second, first) <= 7
*/


SELECT
    p1.user_id,
    p1.created_at AS first_purchase,
    p2.created_at AS second_purchase,
    DATEDIFF(p2.created_at, p1.created_at) AS days_between
FROM purchases AS p1
JOIN purchases AS p2
    ON p1.user_id = p2.user_id
    AND p2.created_at > p1.created_at
WHERE p1.created_at = (
    SELECT MIN(created_at)
    FROM purchases
    WHERE user_id = p1.user_id
)
AND DATEDIFF(p2.created_at, p1.created_at) BETWEEN 1 AND 7;


/*
===========================================================
STEP 5: Return ONLY the user_ids
===========================================================

The question only asks for user_ids.

DISTINCT prevents the same user from appearing multiple
times if they made multiple purchases within the 7-day
window.
*/


SELECT DISTINCT
    p1.user_id
FROM purchases AS p1
JOIN purchases AS p2
    ON p1.user_id = p2.user_id
    AND p2.created_at > p1.created_at
WHERE p1.created_at = (
    SELECT MIN(created_at)
    FROM purchases
    WHERE user_id = p1.user_id
)
AND DATEDIFF(p2.created_at, p1.created_at) BETWEEN 1 AND 7;


/*
===========================================================
FINAL ANSWER
===========================================================

This is the clean version to keep in your SQL file:
*/


SELECT DISTINCT
    p1.user_id
FROM purchases AS p1
JOIN purchases AS p2
    ON p1.user_id = p2.user_id
    AND p2.created_at > p1.created_at
WHERE p1.created_at = (
    SELECT MIN(created_at)
    FROM purchases
    WHERE user_id = p1.user_id
)
AND DATEDIFF(p2.created_at, p1.created_at) BETWEEN 1 AND 7;