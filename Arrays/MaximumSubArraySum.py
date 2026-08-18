"""
LeetCode: 53. Maximum Subarray
Difficulty: Medium
Topic: Dynamic Programming (Kadane's Algorithm), Arrays

Problem:
Given an integer array nums, find the contiguous subarray
(containing at least one number) which has the largest sum,
and return its sum.

---------------------------------------------------------------
Problem Type:
Dynamic Programming (Space Optimized)

This problem is commonly solved using Kadane's Algorithm,
which is a space-optimized DP solution.

---------------------------------------------------------------
State Definition:

dp[i] = Maximum subarray sum ending at index i

Important:
The state does NOT represent the maximum subarray sum found
so far in the entire array.

Instead, it represents the maximum subarray sum that MUST
end at index i.

Example:

nums = [-2,1,-3,4]

dp[0] = -2
dp[1] = 1
dp[2] = -2
dp[3] = 4

---------------------------------------------------------------
Recurrence Relation:

At every index we have two choices:

1. Start a new subarray from nums[i]

    nums[i]

2. Extend the previous best subarray

    dp[i-1] + nums[i]

Therefore:

    dp[i] = max(
                nums[i],
                dp[i-1] + nums[i]
              )

---------------------------------------------------------------
Kadane's Optimization:

Since dp[i] only depends on dp[i-1],
we do not need the entire DP array.

Instead:

    current_sum = dp[i]
    max_sum     = overall answer

This reduces space complexity from O(n) to O(1).

---------------------------------------------------------------
Approach:

1. Initialize:
       current_sum = nums[0]
       max_sum = nums[0]

2. Traverse the array from index 1.

3. For each element:
       Decide whether to:
       a) Start a new subarray
       b) Extend the previous subarray

       current_sum =
           max(nums[i],
               current_sum + nums[i])

4. Update the global maximum:

       max_sum =
           max(max_sum,
               current_sum)

5. Return max_sum.

---------------------------------------------------------------
Intuition:

A negative running sum can never help build a larger
future subarray.

If current_sum becomes negative, it is often better
to discard it and start a new subarray from the
current element.

Example:

current_sum = -2
nums[i] = 4

Choices:

Start New:
    4

Extend Previous:
    -2 + 4 = 2

Choose:
    4

Therefore we start a new subarray.

---------------------------------------------------------------
Algorithm:

1. Initialize current_sum and max_sum with nums[0].

2. For each element from index 1:

       current_sum =
           max(nums[i],
               current_sum + nums[i])

       max_sum =
           max(max_sum,
               current_sum)

3. Return max_sum.

---------------------------------------------------------------
Time Complexity:

O(n)

Reason:
Array is traversed only once.

---------------------------------------------------------------
Space Complexity:

O(1)

Reason:
Only two variables are maintained:

    current_sum
    max_sum

No extra array is required.

---------------------------------------------------------------
Key Concepts:

- Dynamic Programming
- Kadane's Algorithm
- State Transition
- Space Optimization
- Maximum Contiguous Subarray
- Running Sum
- Greedy DP

   ''' optimized approach (Kadane's Algorithm)
    class Solution:
    def maxSubArray(self, nums):
        current_sum = nums[0]
        max_sum = nums[0]

        for i in range(1, len(nums)):
            current_sum = max(nums[i], current_sum + nums[i])
            max_sum = max(max_sum, current_sum)

        return max_sum
    '''

    ''' brute force approach (TLE)
    class Solution:
    def maxSubArray(self, nums):
        max_sum = float('-inf')

        for i in range(len(nums)):
            current_sum = 0

            for j in range(i, len(nums)):
                current_sum += nums[j]
                max_sum = max(max_sum, current_sum)

        return max_sum
    '''

"""


class MaximumSubArraySum:
    # Kadane's Algorithm WITH STATE ARRAY 
    def maxSubArray(self, nums: List[int]) -> int:
        dp = [0] * len(nums)
        dp[0] = nums[0]
        max_sum = dp[0]

        for i in range(1, len(nums)):
            dp[i] = max(nums[i] , dp[i-1] + nums[i])
            max_sum = max(max_sum, dp[i])

        return max_sum

if __name__ == "__main__":
    solution = MaximumSubArraySum()
    print(solution.maxSubArray([-2,1,-3,4,-1,2,1,-5,4]))  # Output: 6
    print(solution.maxSubArray([1]))  # Output: 1
    print(solution.maxSubArray([5,4,-1,7,8]))  # Output: 23
