class SummaryRanges:
    def summaryRanges(self, nums: List[int]) -> List[str]:
        result = []
        
        if not nums:
            return result
        
        start = nums[0]
        
        for i in range(1, len(nums) + 1):
            if i == len(nums) or nums[i] != nums[i - 1] + 1:
                
                if start == nums[i - 1]:
                    result.append(str(start))
                else:
                    result.append(f"{start}->{nums[i - 1]}")
                    
                if i < len(nums):
                    start = nums[i]
                    
        return result       
    
if __name__ == "__main__":
    nums = [0, 1, 2, 4, 5, 7]
    summary_ranges = SummaryRanges()
    print(summary_ranges.summaryRanges(nums))  # Output: ["0->2", "4->5", "7"]
    