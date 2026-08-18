"""
============================================================
LEETCODE 3: LONGEST SUBSTRING WITHOUT REPEATING CHARACTERS
============================================================

PROBLEM:
Given a string s, find the length of the longest substring
without duplicate characters.

Example 1:
    Input:
        s = "abcabcbb"

    Longest substring without repeating characters:
        "abc"

    Output:
        3


Example 2:
    Input:
        s = "bbbbb"

    Longest substring:
        "b"

    Output:
        1


Example 3:
    Input:
        s = "pwwkew"

    Longest substring:
        "wke"

    Output:
        3


============================================================
IMPORTANT: WHAT IS A SUBSTRING?
============================================================

A substring must contain CONTIGUOUS characters.

Example:

    s = "pwwkew"

    "wke" is a substring because the characters are next
    to each other.

    "pwke" is NOT a substring because characters are skipped.

Therefore, we must maintain a continuous window.


============================================================
APPROACH
============================================================

We use:

    SLIDING WINDOW + HASHMAP


The sliding window is represented by two pointers:

    left
    right

The window looks like:

    left ---------------- right
             WINDOW


The window will always contain characters that do not
repeat.

We move the right pointer through the string.

When we find a duplicate character:

    1. Find where the previous occurrence was.
    2. Move left past that previous occurrence.
    3. Continue expanding the window.


============================================================
WHY DO WE NEED A HASHMAP?
============================================================

The hashmap stores:

    character -> latest index

Example:

    s = "abc"

After processing the string:

    {
        'a': 0,
        'b': 1,
        'c': 2
    }


This allows us to quickly find where a character was
previously seen.

Dictionary lookup is O(1) on average.


============================================================
MAIN IDEA
============================================================

For every character:

    1. Check whether it already exists in the current window.
    2. If yes, move left.
    3. Store the character's latest index.
    4. Calculate current window length.
    5. Update maximum length.


The important formula is:

    current_length = right - left + 1


When a duplicate is found:

    left = previous_index + 1


============================================================
WHY DO WE CHECK >= LEFT?
============================================================

We use:

    hashmap[char] >= left


because a character might have appeared before,
but that occurrence may already be OUTSIDE the current window.

Example:

    s = "abba"

When we reach the final 'a':

        a b b a
        0 1 2 3

    previous 'a' = index 0

    left = 2

The old 'a' at index 0 is outside the current window.

Current window:

        b b a
        ^
        left = 2

Actually, after processing the duplicate b, the window
has already moved.

Therefore, we must only move left if the previous
occurrence is still inside the current window.

Condition:

    hashmap[char] >= left


============================================================
DRY RUN: "abcabcbb"
============================================================

Start:

    left = 0
    max_length = 0
    hashmap = {}


Character: 'a'

    index = 0

    'a' is not in hashmap.

    Store:
        a -> 0

    Window:
        "a"

    Length:
        0 - 0 + 1 = 1

    max_length = 1


Character: 'b'

    index = 1

    'b' is not in hashmap.

    Store:
        b -> 1

    Window:
        "ab"

    Length:
        1 - 0 + 1 = 2

    max_length = 2


Character: 'c'

    index = 2

    'c' is not in hashmap.

    Store:
        c -> 2

    Window:
        "abc"

    Length:
        2 - 0 + 1 = 3

    max_length = 3


Character: 'a'

    index = 3

    'a' already exists.

    Previous 'a':
        index = 0

    Move left:

        left = 0 + 1
             = 1

    Window becomes:

        "bca"

    Store latest 'a':

        a -> 3

    Length:

        3 - 1 + 1 = 3

    max_length = 3


Character: 'b'

    index = 4

    Previous 'b':
        index = 1

    Move left:

        left = 1 + 1
             = 2

    Window:

        "cab"

    Length:

        4 - 2 + 1 = 3

    max_length = 3


Character: 'c'

    index = 5

    Previous 'c':
        index = 2

    Move left:

        left = 2 + 1
             = 3

    Window:

        "abc"

    Length:

        5 - 3 + 1 = 3

    max_length = 3


Character: 'b'

    index = 6

    Previous 'b':
        index = 4

    Move left:

        left = 4 + 1
             = 5

    Window:

        "cb"

    Length:

        6 - 5 + 1 = 2

    max_length = 3


Character: 'b'

    index = 7

    Previous 'b':
        index = 6

    Move left:

        left = 6 + 1
             = 7

    Window:

        "b"

    Length:

        7 - 7 + 1 = 1

    max_length = 3


FINAL ANSWER:

    3


============================================================
TIME COMPLEXITY
============================================================

We go through the string once.

    Time Complexity = O(n)


Why?

The right pointer moves forward once through the string.

The left pointer also only moves forward.

Neither pointer moves backwards.


============================================================
SPACE COMPLEXITY
============================================================

The hashmap stores characters.

In the worst case, all characters can be different.

Therefore:

    Space Complexity = O(n)


============================================================
FINAL COMPLEXITY
============================================================

    Time  = O(n)
    Space = O(n)


============================================================
KEY PATTERN TO REMEMBER
============================================================

When you see:

    "longest substring"
    "without repeating"
    "contiguous characters"

Think:

    SLIDING WINDOW


Basic pattern:

    left = 0
    hashmap = {}
    max_length = 0

    for right, char in enumerate(s):

        if duplicate:
            move left

        store latest position

        calculate window length

        update maximum


============================================================
CORE THREE LINES
============================================================

The most important part to remember is:

    if char in hashmap and hashmap[char] >= left:
        left = hashmap[char] + 1

    hashmap[char] = right

    max_length = max(max_length, right - left + 1)


============================================================
"""


class Solution(object):
    def lengthOfLongestSubstring(self, s):
        """
        :type s: str
        :rtype: int
        """
        
        left = 0
        max_length = 0 
        hashmap = {}
        
        for i, char in enumerate(s):
            if char in hashmap and hashmap[char] >= left:
                left = hashmap[char] + 1
                
            hashmap[char] = i
            max_length = max(max_length, i - left + 1)
            
        return max_length
    
    
if __name__ == "__main__":
    s = "abcabcbb"
    print(Solution().lengthOfLongestSubstring(s))  # Output: 3
    