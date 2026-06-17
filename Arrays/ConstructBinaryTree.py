# Intuition:
# Preorder traversal gives us the root first.
# Inorder traversal tells us how to split the tree into
# left and right subtrees.
#
# Example:
# preorder = [3,9,20,15,7]
# inorder  = [9,3,15,20,7]
#
# Root = 3 (first element in preorder)
#
# In inorder:
# [9] [3] [15,20,7]
#  L    R
#
# Left subtree = [9]
# Right subtree = [15,20,7]
#
# Recursively repeat the same process.

# Approach:
# 1. Store inorder indices in a hashmap for O(1) lookup.
# 2. Use a preorder pointer (pre_idx) to track the current root.
# 3. Create root using preorder[pre_idx].
# 4. Find root position in inorder.
# 5. Recursively build:
#       left subtree  -> elements before root in inorder
#       right subtree -> elements after root in inorder
# 6. Return the constructed tree.

# Algorithm:
#
# helper(left, right):
#
#     if left > right:
#         return None
#
#     root_val = preorder[pre_idx]
#     pre_idx += 1
#
#     root = TreeNode(root_val)
#
#     mid = inorder_map[root_val]
#
#     root.left = helper(left, mid-1)
#     root.right = helper(mid+1, right)
#
#     return root
#
# Start:
# helper(0, len(inorder)-1)

# Time Complexity:
# O(n)
#
# Each node is visited exactly once.
# HashMap lookup takes O(1).
#
# Total = O(n)

# Space Complexity:
# O(n)
#
# HashMap: O(n)
# Recursion stack:
#    Best case (balanced tree): O(log n)
#    Worst case (skewed tree): O(n)
#
# Overall: O(n)

class TreeNode:
     def __init__(self, val=0, left=None, right=None):
         self.val = val
         self.left = left
         self.right = right

class Solution:
    def buildTree(self, preorder: List[int], inorder: List[int]) -> Optional[TreeNode]:
        if not preorder or not inorder:
            return None

        inorder_map = {val: idx for idx, val in enumerate(inorder)}
        self.preorder_index = 0

        def helper(left , right):
            if left > right: 
                return None
            
            root_val = preorder[self.preorder_index]
            self.preorder_index += 1
            root = TreeNode(root_val)
            mid = inorder_map[root_val]

            root.left = helper(left, mid - 1)
            root.right = helper(mid + 1, right)

            return root

        return helper(0, len(inorder) - 1)

if __name__ == "__main__":
    preorder = [3,9,20,15,7]
    inorder = [9,3,15,20,7]
    solution = Solution()
    root = solution.buildTree(preorder, inorder)
    print(root.val)  # Output: 3
    print(root.left.val)  # Output: 9
    print(root.right.val)  # Output: 20
    print(root.right.left.val)  # Output: 15
    print(root.right.right.val)  # Output: 7
