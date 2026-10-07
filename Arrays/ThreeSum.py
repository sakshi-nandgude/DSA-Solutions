"""
LEETCODE 15 - 3SUM

QUESTION:
Given an integer array nums, return all the triplets
[nums[i], nums[j], nums[k]] such that:

    i != j
    i != k
    j != k
    nums[i] + nums[j] + nums[k] == 0

The solution must not contain duplicate triplets.

Example:
Input:
    nums = [-1, 0, 1, 2, -1, -4]

Output:
    [[-1, -1, 2], [-1, 0, 1]]


APPROACH:
1. Sort the array.
2. Fix one number using index i.
3. Use two pointers:
       left  = i + 1
       right = n - 1
4. Calculate:
       nums[i] + nums[left] + nums[right]
5. If sum == 0:
       - Store the triplet.
       - Move both pointers.
6. If sum < 0:
       - Move left forward because we need a larger value.
7. If sum > 0:
       - Move right backward because we need a smaller value.
8. Skip duplicate values to avoid duplicate triplets.
9. Stop if nums[i] > 0 because the array is sorted and
   three positive numbers cannot sum to 0.


CODE:
"""

class Solution:

    def threeSum(self, nums):

        # Store all valid triplets
        result = []

        # Sort the array
        nums.sort()

        # Get the length of the array
        n = len(nums)

        # Choose the first number
        for i in range(n - 2):

            # Skip duplicate first numbers
            if i > 0 and nums[i] == nums[i - 1]:
                continue

            # If first number is positive,
            # no possible triplet can sum to 0
            if nums[i] > 0:
                break

            # Second number starts after i
            left = i + 1

            # Third number starts at the end
            right = n - 1

            # Continue until the pointers meet
            while left < right:

                # Calculate the sum of three numbers
                total = nums[i] + nums[left] + nums[right]

                # Found a valid triplet
                if total == 0:

                    result.append([
                        nums[i],
                        nums[left],
                        nums[right]
                    ])

                    # Skip duplicate left values
                    while left < right and nums[left] == nums[left + 1]:
                        left += 1

                    # Skip duplicate right values
                    while left < right and nums[right] == nums[right - 1]:
                        right -= 1

                    # Move both pointers
                    left += 1
                    right -= 1

                # Sum is too small
                elif total < 0:

                    # Move left to a larger value
                    left += 1

                # Sum is too large
                else:

                    # Move right to a smaller value
                    right -= 1

        # Return all valid triplets
        return result


"""
DRY RUN:

Input:
    [-1, 0, 1, 2, -1, -4]

After sorting:
    [-4, -1, -1, 0, 1, 2]


i = 0
First number = -4

Try different left/right combinations.
The sum remains too small, so left keeps moving.


i = 1
First number = -1

left  = 2 -> -1
right = 5 ->  2

Sum:
    -1 + (-1) + 2 = 0

Found:
    [-1, -1, 2]


Move pointers.

left  = 3 -> 0
right = 4 -> 1

Sum:
    -1 + 0 + 1 = 0

Found:
    [-1, 0, 1]


i = 2
nums[2] = -1

nums[2] == nums[1]

Skip it because it would create duplicate triplets.


FINAL OUTPUT:

    [[-1, -1, 2], [-1, 0, 1]]


TIME COMPLEXITY:
    O(n²)

SPACE COMPLEXITY:
    O(1) excluding the output.
"""