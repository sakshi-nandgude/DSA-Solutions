"""
        Problem Type:
        - Array
        - Hashing (HashSet)
        - Sequence Detection

        ---------------------------------------------------
        Brute Force Approach:
        ---------------------------------------------------
        1. For every number in the array:
            - Keep checking if (num + 1), (num + 2), ...
              exists by scanning the entire array.
            - Count the length of the consecutive sequence.
        2. Return the maximum length found.

        Time Complexity: O(n²)
        Space Complexity: O(1)

        ---------------------------------------------------
        Better Approach:
        ---------------------------------------------------
        1. Sort the array.
        2. Traverse the sorted array while counting consecutive
           numbers and handling duplicates.
        3. Keep track of the maximum sequence length.

        Time Complexity: O(n log n)
        Space Complexity: O(1) or O(n)
        (depends on the sorting algorithm)

        ---------------------------------------------------
        Optimal Approach (HashSet):
        ---------------------------------------------------
        1. Store all numbers in a HashSet for O(1) average lookup.
        2. Iterate through every unique number.
        3. Start a sequence only if (num - 1) is NOT present.
           This ensures we only start from the beginning of
           each consecutive sequence.
        4. Continue checking (current + 1) while it exists
           in the set and count the sequence length.
        5. Update the maximum sequence length.

        ---------------------------------------------------
        Algorithm:
        ---------------------------------------------------
        1. Convert the array into a HashSet.
        2. Initialize longest = 0.
        3. For each number:
            - If (num - 1) is absent:
                - Start counting the sequence.
                - Expand while (current + 1) exists.
                - Update longest.
        4. Return longest.

        ---------------------------------------------------
        Time Complexity:
        ---------------------------------------------------
        O(n)
        - Building the HashSet takes O(n).
        - Each number is visited at most once while expanding
          a sequence.

        ---------------------------------------------------
        Space Complexity:
        ---------------------------------------------------
        O(n)
        - HashSet stores all unique elements.
"""

class LongestConsecutiveSequence:
    def longestConsecutive(self, nums: List[int]) -> int:
        num_set = set(nums)
        longest = 0

        for num in num_set:
            if num - 1 not in num_set:
                current = num
                length = 1

                while current + 1 in num_set:
                    current += 1
                    length += 1

                longest = max(longest, length)

        return longest

if __name__ == "__main__":
    lcs = LongestConsecutiveSequence()
    nums = [100, 4, 200, 1, 3, 2]
    print(lcs.longestConsecutive(nums))  # Output: 4 (The longest consecutive sequence is [1, 2, 3, 4])
