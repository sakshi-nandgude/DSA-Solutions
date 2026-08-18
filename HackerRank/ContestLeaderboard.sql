/*
============================================================
HACKERRANK: TOP COMPETITORS
============================================================

TABLE 1: Hackers

Columns:
    hacker_id
    name


TABLE 2: Submissions

Columns:
    submission_id
    hacker_id
    challenge_id
    score


RELATIONSHIP:

    Hackers.hacker_id
          |
          |
    Submissions.hacker_id


============================================================
QUESTION
============================================================

The total score of a hacker is the SUM of their maximum
scores for all challenges.

We need to output:

    hacker_id
    name
    total_score

Rules:

    1. For each hacker and each challenge, find their
       maximum score.

    2. Add all those maximum scores together to get
       the hacker's total score.

    3. Exclude hackers whose total score is 0.

    4. Sort by total score in DESCENDING order.

    5. If two hackers have the same total score,
       sort by hacker_id in ASCENDING order.


============================================================
IMPORTANT CONCEPT
============================================================

We CANNOT simply do:

    SUM(score)

Why?

Because a hacker can submit multiple times for the
same challenge.

Example:

    hacker_id = 1

    challenge_id = 10
    scores:
        50
        80
        70

We only want:

    MAX(50, 80, 70) = 80

NOT:

    50 + 80 + 70 = 200


Therefore, we need TWO levels of aggregation:

    LEVEL 1:
        MAX(score)
        GROUP BY hacker_id, challenge_id

    LEVEL 2:
        SUM(max_score)
        GROUP BY hacker_id


============================================================
STEP 1: FIND THE MAXIMUM SCORE FOR EACH CHALLENGE
============================================================

First, we look at the Submissions table.

We need to find the highest score achieved by each
hacker for each individual challenge.

For example:

    hacker_id    challenge_id    score

        1             10           50
        1             10           80
        1             10           70
        1             20           40
        1             20           90


For challenge 10:

    MAX(50, 80, 70) = 80

For challenge 20:

    MAX(40, 90) = 90


So our intermediate result becomes:

    hacker_id    challenge_id    max_score

        1             10             80
        1             20             90


We achieve this using:

    MAX(score)

and:

    GROUP BY hacker_id, challenge_id
*/


SELECT
    hacker_id,
    challenge_id,

    -- Find the highest score for this
    -- hacker on this particular challenge.
    MAX(score) AS max_score

FROM Submissions

-- We need one result for every
-- hacker + challenge combination.
GROUP BY
    hacker_id,
    challenge_id;


/*
============================================================
STEP 2: SAVE THE RESULT USING A CTE
============================================================

We will need the result from Step 1 in the next step.

A CTE allows us to temporarily name this result:

    max_scores

Think of max_scores as a temporary table containing:

    hacker_id
    challenge_id
    max_score
*/


WITH max_scores AS (

    SELECT
        hacker_id,
        challenge_id,

        -- Maximum score for this hacker
        -- on this challenge.
        MAX(score) AS max_score

    FROM Submissions

    GROUP BY
        hacker_id,
        challenge_id
)

SELECT *
FROM max_scores;


/*
============================================================
STEP 3: CALCULATE TOTAL SCORE FOR EACH HACKER
============================================================

Now we have:

    hacker_id
    challenge_id
    max_score

For each hacker, we need to ADD all their maximum
challenge scores.

Example:

    hacker_id    challenge_id    max_score

        1             10             80
        1             20             90
        1             30             60

Total score for hacker 1:

    80 + 90 + 60 = 230


Therefore we use:

    SUM(max_score)

and group by:

    hacker_id
*/


WITH max_scores AS (

    SELECT
        hacker_id,
        challenge_id,

        -- Maximum score for each challenge.
        MAX(score) AS max_score

    FROM Submissions

    GROUP BY
        hacker_id,
        challenge_id
)

SELECT
    hacker_id,

    -- Add the maximum scores from all
    -- challenges for this hacker.
    SUM(max_score) AS total_score

FROM max_scores

-- One total score for each hacker.
GROUP BY hacker_id;


/*
============================================================
STEP 4: CREATE A SECOND CTE
============================================================

We will save the result from Step 3 as:

    total_scores

Now total_scores contains:

    hacker_id
    total_score

Example:

    hacker_id    total_score

        1           230
        2           180
        3           250
*/


WITH max_scores AS (

    SELECT
        hacker_id,
        challenge_id,

        MAX(score) AS max_score

    FROM Submissions

    GROUP BY
        hacker_id,
        challenge_id
),

total_scores AS (

    SELECT
        hacker_id,

        -- Add all maximum challenge scores
        -- for each hacker.
        SUM(max_score) AS total_score

    FROM max_scores

    GROUP BY hacker_id
)

SELECT *
FROM total_scores;


/*
============================================================
STEP 5: JOIN WITH THE HACKERS TABLE
============================================================

At this point, total_scores contains:

    hacker_id
    total_score

But the question also wants:

    name

The name is stored in the Hackers table.

Therefore, we need to JOIN:

    Hackers
        +
    total_scores

The common column is:

    hacker_id


We use:

    ON h.hacker_id = t.hacker_id


After the JOIN we can get:

    h.hacker_id
    h.name
    t.total_score
*/


WITH max_scores AS (

    SELECT
        hacker_id,
        challenge_id,
        MAX(score) AS max_score

    FROM Submissions

    GROUP BY
        hacker_id,
        challenge_id
),

total_scores AS (

    SELECT
        hacker_id,
        SUM(max_score) AS total_score

    FROM max_scores

    GROUP BY hacker_id
)

SELECT
    h.hacker_id,
    h.name,
    t.total_score

FROM Hackers h

-- Match the hacker from Hackers table
-- with their calculated total score.
JOIN total_scores t
    ON h.hacker_id = t.hacker_id;


/*
============================================================
STEP 6: REMOVE TOTAL SCORE = 0
============================================================

The question says:

    "Exclude all hackers with a total score of 0."

Therefore, we need:

    total_score > 0

Because total_score is already calculated in the
total_scores CTE, we can use:

    WHERE t.total_score > 0
*/


WITH max_scores AS (

    SELECT
        hacker_id,
        challenge_id,
        MAX(score) AS max_score

    FROM Submissions

    GROUP BY
        hacker_id,
        challenge_id
),

total_scores AS (

    SELECT
        hacker_id,
        SUM(max_score) AS total_score

    FROM max_scores

    GROUP BY hacker_id
)

SELECT
    h.hacker_id,
    h.name,
    t.total_score

FROM Hackers h

JOIN total_scores t
    ON h.hacker_id = t.hacker_id

-- Remove hackers with total score of 0.
WHERE t.total_score > 0;


/*
============================================================
STEP 7: SORT THE RESULTS
============================================================

The question requires:

    1. Highest total score first.
    2. If there is a tie, lowest hacker_id first.


Therefore:

    total_score DESC

means:

    Highest score → lowest score


And:

    hacker_id ASC

means:

    Lowest hacker_id → highest hacker_id


Example:

    hacker_id    total_score

        5           500
        2           400
        7           400
        3           300


Correct order:

        5           500
        2           400
        7           400
        3           300


Why?

500 is the highest.

For 400 and 400:

    hacker_id 2 comes before hacker_id 7.

Therefore:

    ORDER BY total_score DESC,
             hacker_id ASC
*/


/*
============================================================
FINAL SOLUTION
============================================================

This is the complete query.

LOGIC:

    Submissions
         |
         v
    MAX(score)
         |
         | GROUP BY hacker_id, challenge_id
         v
    max_scores
         |
         v
    SUM(max_score)
         |
         | GROUP BY hacker_id
         v
    total_scores
         |
         v
    JOIN Hackers
         |
         v
    WHERE total_score > 0
         |
         v
    ORDER BY total_score DESC,
             hacker_id ASC
*/


WITH max_scores AS (

    /*
    --------------------------------------------------------
    STEP 1:
    Find the maximum score for each hacker on each
    individual challenge.
    --------------------------------------------------------
    */

    SELECT
        hacker_id,
        challenge_id,

        MAX(score) AS max_score

    FROM Submissions

    GROUP BY
        hacker_id,
        challenge_id
),

total_scores AS (

    /*
    --------------------------------------------------------
    STEP 2:
    Add the maximum scores for each hacker.

    This gives us the total score for every hacker.
    --------------------------------------------------------
    */

    SELECT
        hacker_id,

        SUM(max_score) AS total_score

    FROM max_scores

    GROUP BY hacker_id
)

/*
------------------------------------------------------------
STEP 3:
Get hacker_id and name from Hackers and total_score
from total_scores.
------------------------------------------------------------
*/

SELECT
    h.hacker_id,
    h.name,
    t.total_score

FROM Hackers h

/*
------------------------------------------------------------
STEP 4:
Join both tables using hacker_id.
------------------------------------------------------------
*/

JOIN total_scores t
    ON h.hacker_id = t.hacker_id

/*
------------------------------------------------------------
STEP 5:
Exclude hackers whose total score is 0.
------------------------------------------------------------
*/

WHERE t.total_score > 0

/*
------------------------------------------------------------
STEP 6:
Sort the final result.

First:
    Highest total score

Then, if there is a tie:
    Lowest hacker_id
------------------------------------------------------------
*/

ORDER BY
    t.total_score DESC,
    h.hacker_id ASC;


/*
============================================================
KEY THING TO REMEMBER
============================================================

This question has TWO GROUP BY operations.

FIRST:

    GROUP BY hacker_id, challenge_id

    MAX(score)

This finds the best score for every challenge.

SECOND:

    GROUP BY hacker_id

    SUM(max_score)

This calculates the total score for every hacker.


The mental model is:

    Multiple submissions
            |
            v
    Best score per challenge
            |
            v
    Add best scores
            |
            v
    Total score per hacker
            |
            v
    Join hacker name
            |
            v
    Filter + Sort


============================================================
COMMON MISTAKE
============================================================

DO NOT write:

    SUM(score)

directly.

That would add every submission, including multiple
attempts for the same challenge.

Instead:

    MAX(score)
        ↓
    per hacker + challenge

then:

    SUM(max_score)
        ↓
    per hacker


============================================================
FINAL ONE-LINE LOGIC
============================================================

MAX(score) per hacker/challenge
        →
SUM(max_score) per hacker
        →
JOIN Hackers
        →
WHERE total_score > 0
        →
ORDER BY total_score DESC, hacker_id ASC
============================================================
*/ 