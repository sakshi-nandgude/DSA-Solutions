"""
LeetCode: Combination Sum II
Difficulty: Medium
Topic: Backtracking, Recursion, Arrays

Problem:
Given a collection of candidate numbers and a target number,
find all unique combinations where the candidate numbers sum to
the target.

Rules:
1. Each number may be used at most once.
2. The solution set must not contain duplicate combinations.

---------------------------------------------------------------
Approach:
1. Sort the input array.
   - Sorting groups duplicate numbers together.
   - Makes it easier to skip duplicate combinations.

2. Use Backtracking (Depth-First Search).
   - Build combinations incrementally.
   - Keep track of:
        * Current combination (path)
        * Current sum (total)
        * Current starting index

3. If the current sum equals target:
   - Store a copy of the current combination.
   - Return to explore other possibilities.

4. If the current sum exceeds target:
   - Stop exploring that branch (pruning).

5. To avoid duplicate combinations:
   - Skip duplicate values at the same recursion level.
   - Condition:
       if i > start and candidates[i] == candidates[i - 1]:
           continue

6. Since each element can only be used once:
   - Recurse using i + 1 as the next starting index.

---------------------------------------------------------------
Algorithm:
1. Sort candidates.
2. Start backtracking from index 0.
3. For each candidate:
      a. Skip duplicates at same level.
      b. Add current element to path.
      c. Recurse with next index.
      d. Remove element (backtrack).
4. Return all valid combinations.

---------------------------------------------------------------
Errors Encountered During Development:

1. Forgot to sort candidates.
   Issue:
      Duplicate skipping logic failed because equal
      elements were not adjacent.
   Fix:
      candidates.sort()

2. Stored path directly in result.
   Issue:
      Backtracking modifies the same list object,
      causing incorrect results.
   Fix:
      result.append(path.copy())

---------------------------------------------------------------
Time Complexity:
Worst Case: O(2^n)

Reason:
Each element can either be included or excluded,
creating a recursion tree similar to generating subsets.

Additional cost:
Copying a valid combination takes O(k),
where k is the length of the combination.

---------------------------------------------------------------
Space Complexity:
O(n)

Reason:
Maximum recursion depth can reach n.
The path list can also store up to n elements.

Result storage is not included in auxiliary space analysis.

---------------------------------------------------------------
Key Concepts:
- Backtracking
- Depth First Search (DFS)
- Recursion
- Duplicate Elimination
- Pruning
- Combinatorial Search
"""

class CombinationSumII:
    def combinationSum2(self, candidates: List[int], target: int) -> List[List[int]]:
        result = []
        candidates.sort()

        def backtrack(start, path, total):
            if total == target:
                result.append(path[:])
                return

            if total > target:
                return 

            for i in range(start, len(candidates)):
                if i > start and candidates[i] == candidates[i - 1]:
                    continue

                path.append(candidates[i])

                backtrack(i+1, path, total + candidates[i])
                
                path.pop()

        backtrack(0, [], 0)
        return result

if __name__ == "__main__":
    solution = CombinationSumII()
    candidates = [10,1,2,7,6,1,5]
    target = 8
    print(solution.combinationSum2(candidates, target))