/*
===========================================================
Problem: Find All Posts Which Were Reacted to With a Heart
===========================================================

Problem Type:
- SQL
- INNER JOIN
- Filtering
- DISTINCT

-----------------------------------------------------------
Problem Statement:
-----------------------------------------------------------
Given two tables:

1. facebook_posts
   - Contains details of each post.

2. facebook_reactions
   - Contains all reactions made by users on posts.

Return all columns from facebook_posts for posts
that received at least one 'heart' reaction.

-----------------------------------------------------------
Approach:
-----------------------------------------------------------
1. Join facebook_posts with facebook_reactions
   using post_id.

2. Filter only those reactions where
      reaction = 'heart'.

3. Since multiple users can react with a heart
   to the same post, duplicate rows may be created.

4. Use DISTINCT to return each post only once.

-----------------------------------------------------------
Algorithm:
-----------------------------------------------------------
1. Start with facebook_posts.
2. INNER JOIN facebook_reactions on post_id.
3. Keep only rows where reaction = 'heart'.
4. Remove duplicate posts using DISTINCT.
5. Return all columns from facebook_posts.

-----------------------------------------------------------
SQL Concepts Used:
-----------------------------------------------------------
✔ INNER JOIN
✔ WHERE
✔ DISTINCT

-----------------------------------------------------------
Why DISTINCT?
-----------------------------------------------------------
Example:

facebook_reactions

post_id   reaction
-------   --------
1         heart
1         heart
1         heart

After JOIN

post_id
-------
1
1
1

Using DISTINCT

post_id
-------
1

This ensures each post appears only once.

-----------------------------------------------------------
Time Complexity:
-----------------------------------------------------------
O(P × R)

P = Number of posts
R = Number of reactions

With indexes on post_id, the JOIN is optimized and
runs approximately in O(R).

-----------------------------------------------------------
Space Complexity:
-----------------------------------------------------------
O(1)

(No extra data structures are used.)

-----------------------------------------------------------
Interview Takeaway:
-----------------------------------------------------------
Pattern:
JOIN → WHERE → DISTINCT

Key Learning:
- Use INNER JOIN to combine related tables.
- Use WHERE to filter required rows.
- Use DISTINCT when a JOIN creates duplicate records
  but only unique results are required.
===========================================================
*/
SELECT DISTINCT p.*
FROM facebook_posts p
JOIN facebook_reactions r
ON p.post_id = r.post_id
WHERE r.reaction = 'heart';