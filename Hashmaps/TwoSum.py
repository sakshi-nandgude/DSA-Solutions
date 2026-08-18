class Solution(object):
    def twoSum(self, nums, target):
        """
        ============================================================
        LEETCODE 1: TWO SUM
        ============================================================

        Problem:
        Given an array of integers nums and an integer target,
        return the indices of the two numbers that add up to target.

        We are guaranteed:
            - There is exactly one valid solution.
            - We cannot use the same element twice.

        Example:

            nums = [2, 7, 11, 15]
            target = 9

            2 + 7 = 9

            Therefore:
            index 0 + index 1

            Output:
            [0, 1]


        ============================================================
        BRUTE FORCE APPROACH
        ============================================================

        The simplest approach would be to compare every number
        with every other number.

        Example:

            [2, 7, 11, 15]

            Compare:
                2 + 7
                2 + 11
                2 + 15
                7 + 11
                7 + 15
                ...

        This requires two loops.

        Time Complexity:
            O(n^2)

        But the question asks if we can do better than O(n^2).

        We can solve it in O(n) using a HASHMAP.


        ============================================================
        HASHMAP APPROACH
        ============================================================

        The main idea is:

            For every number:

                complement = target - number

        Then check whether that complement has already appeared.

        Example:

            nums = [2, 7, 11, 15]
            target = 9

        First number:

            num = 2

            complement = 9 - 2
                       = 7

            Have we seen 7 before?
                NO

            Store 2 in the hashmap.


        Second number:

            num = 7

            complement = 9 - 7
                       = 2

            Have we seen 2 before?
                YES

            Therefore:

                index of 2 = 0
                current index of 7 = 1

            Return:

                [0, 1]


        ============================================================
        STEP 1: CREATE A HASHMAP
        ============================================================

        We use a dictionary to store:

            number -> index

        Example:

            nums = [2, 7, 11, 15]

        After processing 2:

            hashmap = {
                2: 0
            }

        After processing 7:

            hashmap = {
                2: 0,
                7: 1
            }

        This allows us to check whether a number already exists
        in O(1) average time.
        """

        # Create an empty hashmap/dictionary.
        #
        # We will store:
        #
        #     number -> index
        #
        # Example:
        #
        #     {
        #         2: 0,
        #         7: 1
        #     }
        #
        hashmap = {}


        """
        ============================================================
        STEP 2: LOOP THROUGH THE ARRAY
        ============================================================

        enumerate(nums) gives us both:

            i   = index
            num = value

        Example:

            nums = [2, 7, 11, 15]

            enumerate(nums) gives:

                i = 0, num = 2
                i = 1, num = 7
                i = 2, num = 11
                i = 3, num = 15

        We need the index because the question asks us to return
        INDICES, not the actual numbers.
        """

        for i, num in enumerate(nums):

            """
            ========================================================
            STEP 3: FIND THE COMPLEMENT
            ========================================================

            We need two numbers that add up to target.

                num + complement = target

            Therefore:

                complement = target - num

            Example:

                target = 9
                num = 2

                complement = 9 - 2
                           = 7

            So we are looking for 7.
            """

            complement = target - num


            """
            ========================================================
            STEP 4: CHECK IF COMPLEMENT EXISTS IN HASHMAP
            ========================================================

            We check:

                if complement in hashmap

            If it exists, we have already seen the number that
            we need.

            Example:

                num = 7
                target = 9

                complement = 9 - 7
                           = 2

            If hashmap contains:

                {
                    2: 0
                }

            then we know:

                nums[0] + nums[1] = 9

            Therefore we return:

                [0, 1]
            """

            if complement in hashmap:

                """
                ====================================================
                STEP 5: RETURN BOTH INDICES
                ====================================================

                hashmap[complement] gives us the index of the
                previously seen number.

                i gives us the index of the current number.

                Example:

                    hashmap[2] = 0
                    i = 1

                Therefore:

                    return [0, 1]
                """

                return [hashmap[complement], i]


            """
            ========================================================
            STEP 6: STORE THE CURRENT NUMBER AND INDEX
            ========================================================

            If the complement was NOT found, we store the current
            number in the hashmap.

            Format:

                hashmap[num] = i

            Example:

                i = 0
                num = 2

                hashmap[2] = 0

            Dictionary becomes:

                {
                    2: 0
                }

            Then we continue to the next number.


            IMPORTANT:

            We check for the complement BEFORE storing the current
            number.

            This prevents using the same element twice.

            Example:

                nums = [3, 3]
                target = 6

            First 3:

                complement = 3

                3 is not in hashmap.

                Store:

                    hashmap[3] = 0

            Second 3:

                complement = 3

                3 IS now in hashmap.

                Return:

                    [0, 1]

            This correctly uses the two different elements.
            """

            hashmap[num] = i


        """
        ============================================================
        WHY DON'T WE NEED TO RETURN ANYTHING AFTER THE LOOP?
        ============================================================

        The problem guarantees that exactly one solution exists.

        Therefore, the return statement inside:

            if complement in hashmap:

        will always execute.

        So the loop will find the answer before finishing.


        ============================================================
        TIME COMPLEXITY
        ============================================================

        We loop through nums only once.

            for i, num in enumerate(nums):

        Therefore:

            Time Complexity = O(n)


        Hashmap lookup:

            if complement in hashmap

        is O(1) average time.

        Hashmap insertion:

            hashmap[num] = i

        is also O(1) average time.

        Overall:

            O(n)


        ============================================================
        SPACE COMPLEXITY
        ============================================================

        In the worst case, we may store almost every element
        in the hashmap.

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

        Instead of asking:

            "Which two numbers add up to target?"

        Ask:

            "For this number, what number do I need?"

        Formula:

            complement = target - num

        Then:

            1. Calculate complement.
            2. Check if complement is already in hashmap.
            3. If yes -> return both indices.
            4. If no -> store current number and index.


        ============================================================
        MENTAL MODEL
        ============================================================

            nums
              |
              v
        Pick current number
              |
              v
        Calculate complement
              |
              v
        Is complement in hashmap?
             / \
           YES  NO
            |    |
            v    v
         Return  Store
         indices number
                  |
                  v
               Continue


        ============================================================
        FINAL CODE LOGIC
        ============================================================

            hashmap = {}

            for each number:

                complement = target - num

                if complement exists:
                    return previous_index, current_index

                store num -> current_index
        """

        hashmap[num] = i