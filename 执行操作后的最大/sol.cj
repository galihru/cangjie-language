func zero64(i: Int64): Int64 { return 0; }

class Solution {
    func findSmallestInteger(nums: Array<Int64>, value: Int64): Int64 {
        let n = nums.size;

        // 统计每个模 value 的非负余数的出现次数
        var cnt = Array<Int64>(value, zero64);
        var i: Int64 = 0;
        while (i < n) {
            var r: Int64 = nums[i] % value;
            if (r < 0) { r = r + value; }   // 归一化到 [0, value)
            cnt[r] = cnt[r] + 1;
            i = i + 1;
        }

        // 贪心填 0,1,2,... ：能配就用掉一个对应余数；不能配就停止
        var x: Int64 = 0;
        while (true) {
            var r2: Int64 = x % value;
            if (cnt[r2] > 0) {
                cnt[r2] = cnt[r2] - 1;
                x = x + 1;
            } else {
                break;   // 第一个无法配出的就是最大可达 MEX
            }
        }
        return x;
    }
}
