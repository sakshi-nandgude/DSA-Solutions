# --------------------------------------------------
# Algorithm: Backtracking
# --------------------------------------------------
# 1. Start with an empty permutation (path).
# 2. Iterate through all numbers.
# 3. If a number has not been used:
#       - Choose it
#       - Add it to current permutation
#       - Mark it as used
# 4. Recursively build the remaining positions.
# 5. If permutation length equals input length:
#       - Store the permutation
# 6. Backtrack:
#       - Remove the last chosen element
#       - Mark it as unused
# 7. Repeat until all possible permutations are generated.
#
# Example:
# nums = [1,2,3]
#
# []
# ├── 1
# │   ├── 2
# │   │   └── 3 -> [1,2,3]
# │   └── 3
# │       └── 2 -> [1,3,2]
# ├── 2
# │   ├── 1
# │   │   └── 3 -> [2,1,3]
# │   └── 3
# │       └── 1 -> [2,3,1]
# └── 3
#     ├── 1
#     │   └── 2 -> [3,1,2]
#     └── 2
#         └── 1 -> [3,2,1]
#
# --------------------------------------------------
# Approach:
# Backtracking
#
# Build permutations one element at a time.
# After exploring a choice, undo it and try
# another choice.
# --------------------------------------------------
#
# Time Complexity:
# O(n * n!)
#
# Reason:
# - There are n! possible permutations.
# - Copying each permutation takes O(n).
#
# --------------------------------------------------
# Space Complexity:
# O(n) Auxiliary Space
#
# Reason:
# - Recursion stack = O(n)
# - Current path = O(n)
# - Used array = O(n)
#
# If output storage is included:
# O(n * n!)
# --------------------------------------------------
#Brute Force Approach:
#nums = [1, 2, 3]
#
#result = []
#
#for i in nums:
#    for j in nums:
#        for k in nums:
#
#            # Ensure all elements are distinct
#            if i != j and j != k and i != k:
#                result.append([i, j, k])
#
#print(result)
# --------------------------------------------------


class Permutations:
    def permute(self, nums: List[int]) -> List[List[int]]:
        result = []
        path = []
        used = [False] * len(nums)

        def backtrack():
            if len(path) == len(nums):
                result.append(path[:])
                return

            for i in range(len(nums)):
                if used[i]:
                    continue
                
                used[i] = True
                path.append(nums[i])
                backtrack()
                path.pop()
                used[i] = False
        
        backtrack()
        return result

# Example usage:
permutations = Permutations()
print(permutations.permute([1, 2, 3]))
# Output:
# [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 2, 1], [3, 1, 2]]