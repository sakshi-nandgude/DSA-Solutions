"""
LeetCode: 26. Remove Duplicates from Sorted Array
Difficulty: Easy
Topic: Arrays, Two Pointers

Problem:
Given an integer array nums sorted in non-decreasing order,
remove the duplicates in-place so that each unique element
appears only once.

Return the number of unique elements k.

The first k elements of nums should contain the unique
numbers in sorted order.

---------------------------------------------------------------
Problem Type:
Two Pointers

This problem is commonly solved using the two-pointer
technique.

Because the array is already sorted, duplicate values
will always appear next to each other.

---------------------------------------------------------------
Two Pointer Definition:

i = position of the last unique element

j = pointer used to scan through the array

The purpose of the two pointers is:

    i -> builds the unique portion of the array
    j -> searches for the next unique element

---------------------------------------------------------------
Key Observation:

Since nums is sorted:

    [0,0,1,1,1,2,2,3,3,4]

All duplicate values are adjacent.

Therefore, we only need to compare:

    nums[j] with nums[i]

If they are equal:
    nums[j] is a duplicate.

If they are different:
    nums[j] is a new unique element.

---------------------------------------------------------------
Approach:

1. Initialize i = 0.

2. Start j from index 1.

3. Compare nums[j] with nums[i].

4. If they are different:
       Move i forward.
       Copy nums[j] to nums[i].

5. Continue until j reaches the end.

6. Return i + 1 because i represents an index,
   not the number of unique elements.

---------------------------------------------------------------
Example:

nums = [0,0,1,1,1,2,2,3,3,4]

Initially:

i = 0

nums[i] = 0


j = 1
nums[j] = 0

0 == 0

Duplicate -> ignore.


j = 2
nums[j] = 1

1 != 0

New unique element.

Move i:

i = 1

Copy:

nums[1] = 1


The beginning of the array becomes:

[0,1,...]


Continue the same process.

Final:

[0,1,2,3,4,_,_,_,_,_]

Return:

5

---------------------------------------------------------------
Algorithm:

1. Set i = 0.

2. Loop j from 1 to len(nums) - 1.

3. If nums[j] != nums[i]:

       i += 1
       nums[i] = nums[j]

4. Return i + 1.

---------------------------------------------------------------
Time Complexity:

O(n)

Reason:
The array is traversed only once.

---------------------------------------------------------------
Space Complexity:

O(1)

Reason:
The solution modifies the original array in-place
and does not create another array.

---------------------------------------------------------------
Key Concepts:

- Arrays
- Two Pointers
- In-place Modification
- Sorted Arrays
- Duplicate Detection
- Space Optimization
- Read Pointer
- Write Pointer

---------------------------------------------------------------
Optimized Approach:

    class Solution:
        def removeDuplicates(self, nums):
            i = 0

            for j in range(1, len(nums)):
                if nums[j] != nums[i]:
                    i += 1
                    nums[i] = nums[j]

            return i + 1

---------------------------------------------------------------
Brute Force Approach:

A brute-force solution could create a new array containing
only unique elements.

However, that violates the requirement to modify nums
in-place and uses O(n) extra space.

Therefore, the two-pointer approach is preferred.

---------------------------------------------------------------
"""


class RemoveDuplicates:
    # Two-pointer approach
    def removeDuplicates(self, nums: list[int]) -> int:
        i = 0

        for j in range(1, len(nums)):
            if nums[j] != nums[i]:
                i += 1
                nums[i] = nums[j]

        return i + 1


if __name__ == "__main__":
    solution = RemoveDuplicates()

    nums1 = [1, 1, 2]
    k1 = solution.removeDuplicates(nums1)
    print(k1, nums1[:k1])  # Output: 2 [1, 2]

    nums2 = [0, 0, 1, 1, 1, 2, 2, 3, 3, 4]
    k2 = solution.removeDuplicates(nums2)
    print(k2, nums2[:k2])  # Output: 5 [0, 1, 2, 3, 4]

    nums3 = [1]
    k3 = solution.removeDuplicates(nums3)
    print(k3, nums3[:k3])  # Output: 1 [1]