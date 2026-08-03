from typing import List


class SummaryRanges:
    def summaryRanges(self, nums: List[int]) -> List[str]:
        """
        Problem:
        Given a sorted array of unique integers, return the smallest list
        of ranges that covers every number exactly once.

        Example:
        nums = [0,1,2,4,5,7]
        Output = ["0->2", "4->5", "7"]

        --------------------------------------------------------
        Approach
        --------------------------------------------------------
        1. Keep track of the START of the current consecutive range.
        2. Traverse the array.
        3. If numbers are consecutive, continue.
        4. If sequence breaks OR we reach the end,
           save the current range.
        5. Start a new range.

        --------------------------------------------------------
        Why iterate until len(nums)+1?
        --------------------------------------------------------
        The extra iteration acts as a "dummy breakpoint"
        so the last range is processed inside the loop.
        Otherwise, we'd need extra code after the loop.

        --------------------------------------------------------
        Time Complexity : O(n)
        Space Complexity: O(1) (excluding output list)
        """

        # Stores the final ranges
        result = []

        # Edge case: empty array
        if not nums:
            return result

        # Beginning of current range
        start = nums[0]

        # Traverse one step beyond the array
        for i in range(1, len(nums) + 1):

            # End of current range if:
            # 1. We've reached the end
            # 2. Current number is not consecutive
            if i == len(nums) or nums[i] != nums[i - 1] + 1:

                # Single element range
                if start == nums[i - 1]:
                    result.append(str(start))

                # Multiple element range
                else:
                    result.append(f"{start}->{nums[i - 1]}")

                # Start next range (if elements remain)
                if i < len(nums):
                    start = nums[i]

        return result


if __name__ == "__main__":
    nums = [0, 1, 2, 4, 5, 7]

    summary_ranges = SummaryRanges()

    print(summary_ranges.summaryRanges(nums))

    # Output:
    # ['0->2', '4->5', '7']