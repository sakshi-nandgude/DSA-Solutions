-- Question:
-- Find the job title(s) of the worker(s) with the highest salary,
-- considering only workers who have an official record in the title table.
-- If multiple workers share the highest salary, return all their job titles.

-- Approach:
-- 1. Join the worker and title tables so only workers with official titles are considered.
-- 2. Find the maximum salary among these joined workers using a subquery.
-- 3. Filter the joined data to keep only workers whose salary equals that maximum.
-- 4. Return their worker_title.

select t.worker_title
from title t
join worker w 
on w.worker_id = t.worker_ref_id
where w.salary = (
    select max(w2.salary)
    from worker w2
    join title t2 
    on w2.worker_id = t2.worker_ref_id
);