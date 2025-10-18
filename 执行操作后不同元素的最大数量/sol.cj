class Solution {
    func maxDistinctElements(nums: Array<Int64>, k: Int64): Int64 {
        let n = nums.size;
        if (n == 0) { return 0; }

        // 复制并原地堆排序（升序）
        var a = nums;
        if (n > 1) {
            var start: Int64 = (n / 2) - 1;
            var _rv: Int64 = 0;
            while (true) {
                _rv = siftDown(a, start, n - 1);
                if (start == 0) { break; }
                start = start - 1;
            }
            var end: Int64 = n - 1;
            while (end > 0) {
                let tmp = a[0]; a[0] = a[end]; a[end] = tmp;
                end = end - 1;
                _rv = siftDown(a, 0, end);
            }
        }

        var ans: Int64 = 0;
        var cur: Int64 = -9223372036854775808; // Int64 最小值
        var i: Int64 = 0;
        while (i < n) {
            var L: Int64 = a[i] - k;
            var R: Int64 = a[i] + k;
            var pos: Int64 = L;
            var need: Int64 = cur + 1;
            if (need > pos) { pos = need; }
            if (pos <= R) {
                ans = ans + 1;
                cur = pos;
            }
            i = i + 1;
        }
        return ans;
    }

    // 最大堆下滤（返回值仅为兼容语法）
    func siftDown(a: Array<Int64>, start: Int64, end: Int64): Int64 {
        var root = start;
        while (true) {
            var child = (root * 2) + 1;
            if (child > end) { break; }
            var swapIdx = root;
            if (a[swapIdx] < a[child]) { swapIdx = child; }
            if (child + 1 <= end && a[swapIdx] < a[child + 1]) { swapIdx = child + 1; }
            if (swapIdx == root) {
                break;
            } else {
                let tmp = a[root]; a[root] = a[swapIdx]; a[swapIdx] = tmp;
                root = swapIdx;
            }
        }
        return 0;
    }
}
