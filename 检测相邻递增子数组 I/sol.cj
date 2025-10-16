func zero64(i: Int64): Int64 { return 0; }

class Solution {
    func hasIncreasingSubarrays(nums: ArrayList<Int64>, k: Int64): Bool {
        let n = nums.size;
        if (n < 2 * k) { return false; }

        // inc[i] = 1 当且仅当 nums[i] < nums[i+1]
        var inc = Array<Int64>(n - 1, zero64);
        var i: Int64 = 0;
        while (i + 1 < n) {
            if (nums[i] < nums[i + 1]) { inc[i] = 1; }
            i = i + 1;
        }

        // 前缀和：pre[t] = inc[0..t-1] 之和，pre 长度为 n
        var pre = Array<Int64>(n, zero64);
        pre[0] = 0;
        i = 0;
        while (i < n - 1) {
            pre[i + 1] = pre[i] + inc[i];
            i = i + 1;
        }

        // 枚举相邻两段的起点 s 与 s+k
        var limit: Int64 = n - (2 * k);
        var s: Int64 = 0;
        while (s <= limit) {
            var sum1: Int64 = pre[s + k - 1] - pre[s];
            var sum2: Int64 = pre[s + 2 * k - 1] - pre[s + k];
            if (sum1 == (k - 1) && sum2 == (k - 1)) {
                return true;
            }
            s = s + 1;
        }

        return false;
    }
}
