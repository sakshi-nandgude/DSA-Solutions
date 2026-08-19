"""
LeetCode: 1356. Sort Integers by The Number of 1 Bits
Difficulty: Easy
Topic: Sorting, Bit Manipulation

Problem:
Given an integer array arr, sort the integers based on the
number of 1s in their binary representation.

If two or more integers have the same number of 1s,
sort those integers in ascending numerical order.

Return the sorted array.

---------------------------------------------------------------
Problem Type:
Custom Sorting + Bit Manipulation

The main idea is to create a sorting key for every number.

For each number we need two things:

1. Number of 1 bits in its binary representation
2. The number itself

The sorting priority is:

    First  -> number of 1 bits
    Second -> numerical value

---------------------------------------------------------------
Binary Representation:

Every integer can be represented using binary.

Examples:

    0  -> 0000 -> 0 ones
    1  -> 0001 -> 1 one
    2  -> 0010 -> 1 one
    3  -> 0011 -> 2 ones
    4  -> 0100 -> 1 one
    5  -> 0101 -> 2 ones
    6  -> 0110 -> 2 ones
    7  -> 0111 -> 3 ones

Therefore:

    [0,1,2,3,4,5,6,7]

becomes:

    [0,1,2,4,3,5,6,7]

because the numbers are first grouped by their
number of 1 bits.

---------------------------------------------------------------
Key:

Python provides:

    bin(n)

which converts an integer into its binary representation.

Example:

    bin(5)

gives:

    '0b101'

The prefix '0b' is not part of the binary number.

We can remove it using:

    bin(5).count('1')

which gives:

    2

Therefore:

    bin(n).count('1')

gives the number of 1 bits.

---------------------------------------------------------------
Sorting Key:

We can use a tuple as the sorting key:

    (number_of_1_bits, number)

Example:

For:

    7

The key is:

    (3, 7)

For:

    6

The key is:

    (2, 6)

For:

    4

The key is:

    (1, 4)

Python sorts tuples from left to right.

Therefore:

    (1,4)
    (2,6)
    (3,7)

will automatically be sorted in the required order.

---------------------------------------------------------------
Approach:

1. Calculate the number of 1 bits for each integer.

2. Create a sorting key:

       (number of 1 bits, integer)

3. Sort the array using this key.

4. Return the sorted array.

---------------------------------------------------------------
Example:

Input:

    [0,1,2,3,4,5,6,7,8]

Number of 1 bits:

    0 -> 0
    1 -> 1
    2 -> 1
    3 -> 2
    4 -> 1
    5 -> 2
    6 -> 2
    7 -> 3
    8 -> 1

Sorting by:

    (number of 1 bits, number)

gives:

    0
    1
    2
    4
    8
    3
    5
    6
    7

Final:

    [0,1,2,4,8,3,5,6,7]

---------------------------------------------------------------
Algorithm:

1. Define a function that returns:

       (number of 1 bits, number)

2. Use sorted() with this function as the key.

3. Return the sorted array.

---------------------------------------------------------------
Time Complexity:

O(n log n)

Reason:

Python's sorting algorithm takes O(n log n) time.

For each element, calculating the number of 1 bits
takes O(log(max(arr))).

Therefore, more precisely:

    O(n log n + n log(max(arr)))

Given the constraints, this is easily efficient enough.

---------------------------------------------------------------
Space Complexity:

O(n)

Reason:

sorted() creates a new sorted list.

---------------------------------------------------------------
Key Concepts:

- Sorting
- Custom Sorting
- Bit Manipulation
- Binary Representation
- Python sorted()
- Lambda Functions
- Tuple Sorting
- Counting Set Bits

---------------------------------------------------------------
Optimized Approach:

Python's sorted() can directly use a tuple as the sorting key.

    sorted(arr, key=lambda x: (bin(x).count("1"), x))

The tuple automatically handles both sorting conditions:

    1. Number of 1 bits
    2. Numerical value

---------------------------------------------------------------
Alternative Approach:

Python integers also provide:

    int.bit_count()

For example:

    5.bit_count() -> 2

This directly returns the number of set bits.

Therefore, a cleaner modern Python solution is:

    sorted(arr, key=lambda x: (x.bit_count(), x))

---------------------------------------------------------------
"""


class SortByBits:
    def sortByBits(self, arr: list[int]) -> list[int]:
        return sorted(arr, key=lambda x: (x.bit_count(), x))


if __name__ == "__main__":
    solution = SortByBits()

    print(
        solution.sortByBits([0, 1, 2, 3, 4, 5, 6, 7, 8])
    )  # Output: [0, 1, 2, 4, 8, 3, 5, 6, 7]

    print(
        solution.sortByBits([1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1])
    )  # Output: [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024]

    print(
        solution.sortByBits([3, 3, 2, 1])
    )  # Output: [1, 2, 3, 3]