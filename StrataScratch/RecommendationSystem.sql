/*
===========================================================
Problem: Recommendation System
===========================================================

Problem Type:
- SQL
- Self Join
- LEFT JOIN
- Anti Join
- DISTINCT

-----------------------------------------------------------
Goal:
-----------------------------------------------------------
Recommend pages that:
1. User does NOT follow.
2. At least one friend follows.

-----------------------------------------------------------
Approach:
-----------------------------------------------------------
1. Join users_friends with users_pages to get
   every page followed by each friend.

2. LEFT JOIN users_pages again to check whether
   the current user already follows that page.

3. If no matching row exists (NULL),
   recommend that page.

4. Use DISTINCT to avoid duplicate recommendations
   when multiple friends follow the same page.

-----------------------------------------------------------
Algorithm:
-----------------------------------------------------------
users_friends
      ↓
Join friend's pages
      ↓
Left Join user's pages
      ↓
Keep NULL matches
      ↓
DISTINCT
      ↓
Return recommendations

-----------------------------------------------------------
SQL Concepts:
-----------------------------------------------------------
✔ INNER JOIN
✔ LEFT JOIN
✔ Anti Join Pattern
✔ DISTINCT
✔ NULL Filtering

-----------------------------------------------------------
Time Complexity:
-----------------------------------------------------------
O(F × P)
F = Number of friendships
P = Number of page-follow records

(Depends on indexing.)

-----------------------------------------------------------
Space Complexity:
-----------------------------------------------------------
O(1)

-----------------------------------------------------------
Interview Pattern:
-----------------------------------------------------------
Need rows that exist in one table
but NOT another?

→ LEFT JOIN
→ WHERE right_table.column IS NULL

This is the classic SQL Anti Join pattern.
===========================================================
*/

SELECT uf.user_id, fp.page_id
FROM users_friends uf 
JOIN users_pages up ON uf.friend_id = up.user_id
LEFT JOIN users_pages fp 
ON uf.user_id = up.user_id
AND fp.page_id = up.page_id
WHERE up.page_id IS NULL 