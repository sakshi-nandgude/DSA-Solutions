Yes — if you're storing this as a **learning SQL file**, put the explanation entirely in SQL comments before each section. You can copy this directly into your `.sql` file.

```sql
/*
============================================================
QUESTION: Users By Average Session Time
============================================================

Table:
    facebook_web_log

Columns:
    user_id
    timestamp
    action

A session is defined as:

    page_exit - page_load

Rules:
    1. Each user has at most one session per day.
    2. If there are multiple page_load events on the same day,
       use the LATEST page_load.
    3. If there are multiple page_exit events on the same day,
       use the EARLIEST page_exit.
    4. Only consider sessions where page_load occurs BEFORE page_exit.
    5. Finally, calculate each user's AVERAGE session time.

Example:

User 0:
    page_load  13:30:15
    page_load  13:30:18  <-- use this one (latest)
    page_exit   13:31:40  <-- use this one (earliest)

Session time:
    13:31:40 - 13:30:18
    = 82 seconds


============================================================
APPROACH 1: CTE + FILTER
============================================================

This is the recommended PostgreSQL solution.

The overall process is:

    Step 1: Group data by user and day
    Step 2: Find latest page_load
    Step 3: Find earliest page_exit
    Step 4: Keep only valid sessions
    Step 5: Calculate session duration
    Step 6: Calculate average session duration per user


------------------------------------------------------------
STEP 1: Group by user and day
------------------------------------------------------------

We need one possible session for each user on each day.

DATE(timestamp) removes the time portion.

For example:

    2019-04-25 13:30:15
    2019-04-25 13:30:18
    2019-04-25 13:31:40

all become:

    2019-04-25

Therefore we group by:

    user_id
    DATE(timestamp)
*/


SELECT
    user_id,

    -- Extract only the date from timestamp
    DATE(timestamp) AS session_date

FROM facebook_web_log

-- Create one group for each user on each day
GROUP BY
    user_id,
    DATE(timestamp);


/*
------------------------------------------------------------
STEP 2: Find the latest page_load
------------------------------------------------------------

The question says:

    "If there are multiple page_load events on the same day,
     use only the latest page_load."

MAX(timestamp) gives us the latest timestamp.

FILTER makes sure MAX() only looks at page_load events.

Example:

    13:30:15 page_load
    13:30:18 page_load

MAX() returns:

    13:30:18
*/


SELECT
    user_id,
    DATE(timestamp) AS session_date,

    -- Latest page_load for this user on this day
    MAX(timestamp)
        FILTER (WHERE action = 'page_load') AS page_load

FROM facebook_web_log

GROUP BY
    user_id,
    DATE(timestamp);


/*
------------------------------------------------------------
STEP 3: Find the earliest page_exit
------------------------------------------------------------

The question says:

    "If there are multiple page_exit events on the same day,
     use only the earliest page_exit."

MIN(timestamp) gives us the earliest timestamp.

FILTER makes sure MIN() only looks at page_exit events.
*/


SELECT
    user_id,
    DATE(timestamp) AS session_date,

    -- Latest page_load
    MAX(timestamp)
        FILTER (WHERE action = 'page_load') AS page_load,

    -- Earliest page_exit
    MIN(timestamp)
        FILTER (WHERE action = 'page_exit') AS page_exit

FROM facebook_web_log

GROUP BY
    user_id,
    DATE(timestamp);


/*
------------------------------------------------------------
STEP 4: Put the daily session calculation into a CTE
------------------------------------------------------------

CTE = Common Table Expression.

The CTE creates a temporary result called daily_sessions.

It gives us one row per:

    user + day

with:

    latest page_load
    earliest page_exit
*/


WITH daily_sessions AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,

        -- Get the latest page_load
        MAX(timestamp)
            FILTER (WHERE action = 'page_load') AS page_load,

        -- Get the earliest page_exit
        MIN(timestamp)
            FILTER (WHERE action = 'page_exit') AS page_exit

    FROM facebook_web_log

    -- One row per user per day
    GROUP BY
        user_id,
        DATE(timestamp)
)

SELECT *
FROM daily_sessions;


/*
------------------------------------------------------------
STEP 5: Keep only valid sessions
------------------------------------------------------------

The question says:

    "Only consider sessions where the page_load occurs
     before the page_exit."

Therefore:

    page_load < page_exit

is our condition.

This also removes incomplete sessions.

For example:

    page_load = 13:41:21
    page_exit  = NULL

This is not a valid session.

We therefore use:

    WHERE page_load < page_exit
*/


WITH daily_sessions AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,

        MAX(timestamp)
            FILTER (WHERE action = 'page_load') AS page_load,

        MIN(timestamp)
            FILTER (WHERE action = 'page_exit') AS page_exit

    FROM facebook_web_log

    GROUP BY
        user_id,
        DATE(timestamp)
)

SELECT *
FROM daily_sessions

-- Keep only sessions where load happened before exit
WHERE page_load < page_exit;


/*
------------------------------------------------------------
STEP 6: Calculate session duration
------------------------------------------------------------

Session duration is:

    page_exit - page_load

PostgreSQL allows timestamp subtraction directly.

Example:

    page_exit  = 13:31:40
    page_load  = 13:30:18

Therefore:

    13:31:40 - 13:30:18
    = 00:01:22
    = 82 seconds
*/


WITH daily_sessions AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,

        MAX(timestamp)
            FILTER (WHERE action = 'page_load') AS page_load,

        MIN(timestamp)
            FILTER (WHERE action = 'page_exit') AS page_exit

    FROM facebook_web_log

    GROUP BY
        user_id,
        DATE(timestamp)
)

SELECT
    user_id,

    -- Calculate the session duration
    page_exit - page_load AS session_time

FROM daily_sessions

-- Only valid sessions
WHERE page_load < page_exit;


/*
------------------------------------------------------------
STEP 7: Calculate average session time
------------------------------------------------------------

A user can have valid sessions on multiple days.

Example:

    user_id    session_time

       0          82 seconds
       0         130 seconds
       0         100 seconds

We need:

    AVG(session_time)

for each user.

Therefore:

    AVG(page_exit - page_load)

and:

    GROUP BY user_id
*/


/*
============================================================
FINAL SOLUTION - APPROACH 1
============================================================

This is the cleanest solution for PostgreSQL.

Process:

    1. Group by user and date.
    2. MAX() finds the latest page_load.
    3. MIN() finds the earliest page_exit.
    4. WHERE checks that load happened before exit.
    5. Subtract timestamps to get session duration.
    6. AVG() calculates average duration per user.
*/

WITH daily_sessions AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,

        -- Latest page_load on that day
        MAX(timestamp)
            FILTER (WHERE action = 'page_load') AS page_load,

        -- Earliest page_exit on that day
        MIN(timestamp)
            FILTER (WHERE action = 'page_exit') AS page_exit

    FROM facebook_web_log

    -- One possible session per user per day
    GROUP BY
        user_id,
        DATE(timestamp)
)

SELECT
    user_id,

    -- Average session duration across valid days
    AVG(page_exit - page_load) AS average_session_time

FROM daily_sessions

-- Only consider valid sessions
WHERE page_load < page_exit

-- Calculate average separately for each user
GROUP BY user_id;


/*
============================================================
APPROACH 2: CASE WHEN
============================================================

The FILTER syntax is PostgreSQL-specific.

An alternative is to use:

    CASE WHEN

This is useful to learn because CASE WHEN is supported
across many SQL databases.

Instead of:

    MAX(timestamp)
        FILTER (WHERE action = 'page_load')

we can write:

    MAX(
        CASE
            WHEN action = 'page_load'
            THEN timestamp
        END
    )

Similarly, for page_exit:

    MIN(
        CASE
            WHEN action = 'page_exit'
            THEN timestamp
        END
    )


WHY DOES THIS WORK?

For page_load:

    CASE
        WHEN action = 'page_load'
        THEN timestamp
    END

returns the timestamp only when action is page_load.

For every other action it returns NULL.

MAX() ignores NULL values.

Therefore MAX() gives the latest page_load.

The same idea works with MIN() for page_exit.
*/


/*
------------------------------------------------------------
FINAL SOLUTION - APPROACH 2
------------------------------------------------------------
*/

WITH daily_sessions AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,

        -- Latest page_load using CASE WHEN
        MAX(
            CASE
                WHEN action = 'page_load'
                THEN timestamp
            END
        ) AS page_load,

        -- Earliest page_exit using CASE WHEN
        MIN(
            CASE
                WHEN action = 'page_exit'
                THEN timestamp
            END
        ) AS page_exit

    FROM facebook_web_log

    -- One row per user per day
    GROUP BY
        user_id,
        DATE(timestamp)
)

SELECT
    user_id,

    -- Calculate average session duration
    AVG(page_exit - page_load) AS average_session_time

FROM daily_sessions

-- Only valid sessions
WHERE page_load < page_exit

GROUP BY user_id;


/*
============================================================
APPROACH 3: SEPARATE LOADS AND EXITS + JOIN
============================================================

Another way to solve the problem is to separate the
page_load and page_exit events first.

We create:

    1. latest_loads
    2. earliest_exits

Then we JOIN them using:

    user_id
    session_date

This approach is useful for learning JOINs and CTEs.
*/


/*
------------------------------------------------------------
STEP 1: Find latest page_load for each user and day
------------------------------------------------------------
*/

WITH latest_loads AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,

        -- Latest page_load
        MAX(timestamp) AS page_load

    FROM facebook_web_log

    -- Only look at page_load events
    WHERE action = 'page_load'

    GROUP BY
        user_id,
        DATE(timestamp)
)

SELECT *
FROM latest_loads;


/*
------------------------------------------------------------
STEP 2: Find earliest page_exit for each user and day
------------------------------------------------------------
*/

WITH earliest_exits AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,

        -- Earliest page_exit
        MIN(timestamp) AS page_exit

    FROM facebook_web_log

    -- Only look at page_exit events
    WHERE action = 'page_exit'

    GROUP BY
        user_id,
        DATE(timestamp)
)

SELECT *
FROM earliest_exits;


/*
------------------------------------------------------------
STEP 3: JOIN latest loads with earliest exits
------------------------------------------------------------

We join using:

    user_id

AND:

    session_date

This ensures we match:

    same user
    same day
*/


WITH latest_loads AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,
        MAX(timestamp) AS page_load

    FROM facebook_web_log

    WHERE action = 'page_load'

    GROUP BY
        user_id,
        DATE(timestamp)

),

earliest_exits AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,
        MIN(timestamp) AS page_exit

    FROM facebook_web_log

    WHERE action = 'page_exit'

    GROUP BY
        user_id,
        DATE(timestamp)
)

SELECT
    l.user_id,
    l.session_date,
    l.page_load,
    e.page_exit,

    -- Calculate session duration
    e.page_exit - l.page_load AS session_time

FROM latest_loads l

INNER JOIN earliest_exits e

    -- Match the same user
    ON l.user_id = e.user_id

    -- Match the same date
    AND l.session_date = e.session_date

-- Load must happen before exit
WHERE l.page_load < e.page_exit;


/*
------------------------------------------------------------
STEP 4: Calculate average session time
------------------------------------------------------------

Now that we have valid daily sessions, we can calculate
the average for each user.

AVG() calculates the average.

GROUP BY user_id calculates it separately for each user.
*/


WITH latest_loads AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,
        MAX(timestamp) AS page_load

    FROM facebook_web_log

    WHERE action = 'page_load'

    GROUP BY
        user_id,
        DATE(timestamp)

),

earliest_exits AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,
        MIN(timestamp) AS page_exit

    FROM facebook_web_log

    WHERE action = 'page_exit'

    GROUP BY
        user_id,
        DATE(timestamp)
)

SELECT
    l.user_id,

    -- Average session duration
    AVG(e.page_exit - l.page_load) AS average_session_time

FROM latest_loads l

INNER JOIN earliest_exits e

    ON l.user_id = e.user_id
    AND l.session_date = e.session_date

-- Only valid sessions
WHERE l.page_load < e.page_exit

GROUP BY l.user_id;


/*
============================================================
APPROACH 4: RETURN SESSION TIME IN SECONDS
============================================================

PostgreSQL normally returns:

    00:01:22

for an interval.

If we want the result in seconds, we can use:

    EXTRACT(EPOCH FROM interval)

Example:

    13:31:40 - 13:30:18
    = 00:01:22

EXTRACT(EPOCH FROM ...)
    = 82 seconds
*/


WITH daily_sessions AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,

        -- Latest page_load
        MAX(timestamp)
            FILTER (WHERE action = 'page_load') AS page_load,

        -- Earliest page_exit
        MIN(timestamp)
            FILTER (WHERE action = 'page_exit') AS page_exit

    FROM facebook_web_log

    GROUP BY
        user_id,
        DATE(timestamp)
)

SELECT
    user_id,

    -- Convert session duration to seconds
    AVG(
        EXTRACT(
            EPOCH FROM (page_exit - page_load)
        )
    ) AS average_session_time_seconds

FROM daily_sessions

-- Only valid sessions
WHERE page_load < page_exit

GROUP BY user_id;


/*
============================================================
QUICK INTERVIEW / LEARNING SUMMARY
============================================================

When you see this type of question, break it down like this:

    1. What defines the session?
       --------------------------------
       page_exit - page_load


    2. What is the grouping level?
       --------------------------------
       user_id + date


    3. Which page_load do we need?
       --------------------------------
       Latest = MAX(timestamp)


    4. Which page_exit do we need?
       --------------------------------
       Earliest = MIN(timestamp)


    5. Which sessions are valid?
       --------------------------------
       page_load < page_exit


    6. What is the session duration?
       --------------------------------
       page_exit - page_load


    7. What do we finally need?
       --------------------------------
       Average per user


    8. Therefore:
       --------------------------------

       GROUP BY user_id

       AVG(page_exit - page_load)


============================================================
MOST IMPORTANT PATTERN TO REMEMBER
============================================================

        USER + DAY
             |
             v
      Latest page_load
             |
             v
     Earliest page_exit
             |
             v
      page_load < page_exit
             |
             v
     Session duration
             |
             v
       AVG() per user


============================================================
RECOMMENDED FINAL QUERY
============================================================

For this specific PostgreSQL question, I would use
Approach 1 because it is concise, readable, and directly
matches the requirements.
*/


WITH daily_sessions AS (

    SELECT
        user_id,
        DATE(timestamp) AS session_date,

        -- Latest page_load
        MAX(timestamp)
            FILTER (WHERE action = 'page_load') AS page_load,

        -- Earliest page_exit
        MIN(timestamp)
            FILTER (WHERE action = 'page_exit') AS page_exit

    FROM facebook_web_log

    -- One session per user per day
    GROUP BY
        user_id,
        DATE(timestamp)
)

SELECT
    user_id,

    -- Average session time
    AVG(page_exit - page_load) AS average_session_time

FROM daily_sessions

-- Only valid sessions
WHERE page_load < page_exit

-- Average for each user
GROUP BY user_id;
```
