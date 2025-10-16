func zero64(i: Int64): Int64 { return 0; }

func okK(L: Array<Int64>, n: Int64, k: Int64): Bool {
    if (k <= 0) { return true; }
    var limit: Int64 = n - (2 * k);
    if (limit < 0) { return false; }
    var a: Int64 = 0;
    while (a <= limit) {
        if (L[a] >= k && L[a + k] >= k) { return true; }
        a = a + 1;
    }
    return false;
}

class Solution {
    func maxIncreasingSubarrays(nums: ArrayList<Int64>): Int64 {
        let n = nums.size;
        if (n < 2) { return 0; }

        var L = Array<Int64>(n, zero64);
        L[n - 1] = 1;
        var i: Int64 = n - 2;
        while (true) {
            if (nums[i] < nums[i + 1]) {
                L[i] = L[i + 1] + 1;
            } else {
                L[i] = 1;
            }
            if (i == 0) { break; }
            i = i - 1;
        }

        var lo: Int64 = 1;
        var hi: Int64 = n / 2;
        var ans: Int64 = 0;
        while (lo <= hi) {
            var mid: Int64 = (lo + hi + 1) / 2;
            if (okK(L, n, mid)) {
                ans = mid;
                lo = mid + 1;
            } else {
                hi = mid - 1;
            }
        }
        return ans;
    }
}
