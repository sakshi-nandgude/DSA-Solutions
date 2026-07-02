'''
Method 1: Recursive (Optimal)
Approach

A tree is symmetric if its left subtree is the mirror image of its right subtree.

Compare two nodes:

Both should be None → symmetric.
One is None and the other isn't → not symmetric.
Values should be equal.
Left child of first should match right child of second.
Right child of first should match left child of second.
Algorithm
Create a helper function isMirror(left, right).
If both nodes are None, return True.
If only one is None, return False.
If values differ, return False.
Recursively compare:
left.left with right.right
left.right with right.left
Return the result.
Time Complexity

O(n)

Space Complexity

O(h)

h = height of tree.
Worst case: O(n) for a skewed tree.
Balanced tree: O(log n).
Python Code
class Solution:
    def isSymmetric(self, root):
        def isMirror(left, right):
            if not left and not right:
                return True
            if not left or not right:
                return False
            return (
                left.val == right.val
                and isMirror(left.left, right.right)
                and isMirror(left.right, right.left)
            )

        return isMirror(root.left, root.right)
Method 2: Iterative (Queue)
Approach

Instead of recursion, store pairs of nodes that should be mirrors in a queue.

Each time:

Remove a pair.
Check whether they're equal.
Push their mirror children into the queue.
Algorithm
Initialize a queue with (root.left, root.right).
While queue is not empty:
Pop two nodes.
If both are None, continue.
If one is None, return False.
If values differ, return False.
Push:
(left.left, right.right)
(left.right, right.left)
If traversal completes, return True.
Time Complexity

O(n)

Space Complexity

O(n)

Python Code
from collections import deque

class Solution:
    def isSymmetric(self, root):
        queue = deque([(root.left, root.right)])

        while queue:
            left, right = queue.popleft()

            if not left and not right:
                continue

            if not left or not right:
                return False

            if left.val != right.val:
                return False

            queue.append((left.left, right.right))
            queue.append((left.right, right.left))

        return True
Method 3: Iterative (Stack)
Approach

This is identical to the queue solution, except a stack is used instead of a queue.

Algorithm
Push (root.left, root.right) onto a stack.
While stack is not empty:
Pop a pair.
Perform the same mirror checks.
Push mirror children.
Return True if all comparisons succeed.
Time Complexity

O(n)

Space Complexity

O(n)

Python Code
class Solution:
    def isSymmetric(self, root):
        stack = [(root.left, root.right)]

        while stack:
            left, right = stack.pop()

            if not left and not right:
                continue

            if not left or not right:
                return False

            if left.val != right.val:
                return False

            stack.append((left.left, right.right))
            stack.append((left.right, right.left))

        return True
'''

# Definition for a binary tree node.
class TreeNode:
     def __init__(self, val=0, left=None, right=None):
            self.val = val
            self.left = left
            self.right = right

class SymmetricTree:
    def isSymmetric(self, root: Optional[TreeNode]) -> bool:
        def isMirror(left , right):
            if not right and not left:
                return True
            if not right or not left:
                return False

            return  (
                left.val == right.val
                and isMirror(left.left , right.right)
                and isMirror(left.right , right.left)
            )

        return isMirror(root.left , root.right)

if __name__ == "__main__":
    # Example usage:
    # Constructing a symmetric tree
    root = TreeNode(1)
    root.left = TreeNode(2)
    root.right = TreeNode(2)
    root.left.left = TreeNode(3)
    root.left.right = TreeNode(4)
    root.right.left = TreeNode(4)
    root.right.right = TreeNode(3)

    solution = SymmetricTree()
    print(solution.isSymmetric(root))  # Output: True