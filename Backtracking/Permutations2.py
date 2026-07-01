'''
47. Permutations II
Medium
Topics
premium lock icon
Companies
Given a collection of numbers, nums, that might contain duplicates, return all possible unique permutations in any order.

Example 1:

Input: nums = [1,1,2]
Output:
[[1,1,2],
 [1,2,1],
 [2,1,1]]
Example 2:

Input: nums = [1,2,3]
Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
'''

# -------------------------------------------------------------
# Approach: Backtracking + Sorting
#
# 1. Sort the array so that duplicate elements become adjacent.
# 2. Use a 'used' array to keep track of which elements are already
#    included in the current permutation.
# 3. Build permutations recursively using backtracking.
# 4. Before choosing an element:
#       - Skip it if it has already been used.
#       - Skip duplicate elements if the previous identical element
#         has not been used in the current recursive path.
#         This prevents generating duplicate permutations.
# 5. Once the current permutation has length == len(nums),
#    add a copy of it to the answer.
#
# -------------------------------------------------------------
# Algorithm
#
# 1. Sort nums.
# 2. Initialize:
#       result = []
#       used = [False] * len(nums)
# 3. Start backtracking with an empty path.
# 4. For every index:
#       - Ignore if already used.
#       - Ignore duplicate branches using:
#         if i > 0 and nums[i] == nums[i-1] and not used[i-1]:
#             continue
#       - Choose the element.
#       - Recurse.
#       - Undo the choice (backtrack).
# 5. Return all unique permutations.
#
# -------------------------------------------------------------
# Brute Force
#
# Generate all n! permutations first and then remove duplicates
# using a set.
#
# Time Complexity : O(n × n!)
# Space Complexity: O(n × n!)  (stores all permutations + set)
#
# This approach is inefficient because many duplicate permutations
# are generated before being removed.
#
# -------------------------------------------------------------
# Optimized Approach (Current Solution)
#
# Instead of generating duplicate permutations and removing them later,
# duplicate branches are skipped during recursion itself.
#
# Time Complexity:
#   Sorting               -> O(n log n)
#   Backtracking          -> O(n × n!)
#   Overall               -> O(n × n!)
#
# Space Complexity:
#   used array            -> O(n)
#   recursion stack       -> O(n)
#   excluding output      -> O(n)
#
# Including the output, space is O(n × n!).
# -------------------------------------------------------------

class Solution:
    def permuteUnique(self, nums: List[int]) -> List[List[int]]:
        nums.sort()

        result = []

        used = [False] * len(nums)

        def backtrack(path):
            if len(path) == len(nums):
                result.append(path[:])
                return

            for i in range(len(nums)):
                if used[i]:
                    continue
                if i > 0 and nums[i] == nums[i-1] and not used[i-1]:
                    continue

                used[i] = True
                path.append(nums[i])

                backtrack(path)

                path.pop()
                used[i] = False
        backtrack([])
        return result

if __name__ == "__main__":
    nums = [1, 1, 2]
    solution = Solution()
    print(solution.permuteUnique(nums))
    