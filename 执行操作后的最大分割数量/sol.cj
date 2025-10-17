// 返回 0（数组初始化用）
func zero64(i: Int64): Int64 { return 0; }

// 把一个字节(小写字母)映射到 0..25（避免字符算术）
func idxByte(b: UInt8): Int64 {
    let abc = "abcdefghijklmnopqrstuvwxyz";
    var t: Int64 = 0;
    while (t < 26) {
        if (abc[t] == b) { return t; }
        t = t + 1;
    }
    return 0; // 输入保证是小写字母
}

class Solution {
    func maxPartitionsAfterOperations(s: String, k: Int64): Int64 {
        let n = s.size;
        if (n == 0) { return 0; }

        // 预计算 pow2[0..25]：1,2,4,...
        var pow2 = Array<Int64>(26, zero64);
        pow2[0] = 1;
        var p: Int64 = 1;
        while (p < 26) {
            pow2[p] = pow2[p - 1] + pow2[p - 1];
            p = p + 1;
        }

        // 三个并行数组存 left 状态（到达 i 之前）
        var Lnum  = Array<Int64>(n, zero64);
        var Lmask = Array<Int64>(n, zero64);
        var Lcnt  = Array<Int64>(n, zero64);

        // 从左到右贪心
        var num:  Int64 = 0;
        var mask: Int64 = 0;
        var cnt:  Int64 = 0;
        Lnum[0] = 0; Lmask[0] = 0; Lcnt[0] = 0;

        var i: Int64 = 0;
        while (i < n - 1) {
            let b = s[i];
            let id = idxByte(b);
            let bit = pow2[id];

            var has = (mask / bit) % 2;
            if (has == 0 && cnt == k) {
                // 超过 k：切一段
                num = num + 1;
                mask = 0;
                cnt  = 0;
            }

            // 记录到达 i+1 之前的状态（已把 s[i] 放入当段）
            has = (mask / bit) % 2;
            if (has == 0) {
                mask = mask + bit;
                cnt  = cnt  + 1;
            }
            Lnum[i + 1]  = num;
            Lmask[i + 1] = mask;
            Lcnt[i + 1]  = cnt;

            i = i + 1;
        }

        // 三个并行数组存 right 状态（到达 i 之前，自右向左）
        var Rnum  = Array<Int64>(n, zero64);
        var Rmask = Array<Int64>(n, zero64);
        var Rcnt  = Array<Int64>(n, zero64);
        Rnum[n - 1] = 0; Rmask[n - 1] = 0; Rcnt[n - 1] = 0;

        num = 0; mask = 0; cnt = 0;
        var j: Int64 = n - 1;
        while (j > 0) {
            let b2 = s[j];
            let id2 = idxByte(b2);
            let bit2 = pow2[id2];

            var has2 = (mask / bit2) % 2;
            if (has2 == 0 && cnt == k) {
                num = num + 1;
                mask = 0;
                cnt  = 0;
            }

            has2 = (mask / bit2) % 2;
            if (has2 == 0) {
                mask = mask + bit2;
                cnt  = cnt  + 1;
            }
            Rnum[j - 1]  = num;
            Rmask[j - 1] = mask;
            Rcnt[j - 1]  = cnt;

            j = j - 1;
        }

        // 计算答案：枚举改 s[i]
        var ans: Int64 = 0;
        var idx: Int64 = 0;
        while (idx < n) {
            var seg: Int64 = Lnum[idx] + Rnum[idx] + 2;

            // totCnt = popcount(Lmask | Rmask) ：逐位并集计数
            var totCnt: Int64 = 0;
            var t2: Int64 = 0;
            while (t2 < 26) {
                var bL = (Lmask[idx] / pow2[t2]) % 2;
                if (bL != 0) {
                    totCnt = totCnt + 1;
                } else {
                    var bR = (Rmask[idx] / pow2[t2]) % 2;
                    if (bR != 0) { totCnt = totCnt + 1; }
                }
                t2 = t2 + 1;
            }

            if (Lcnt[idx] == k && Rcnt[idx] == k && totCnt < 26) {
                // 两侧都满，且并集没满 26：可把 s[i] 改成并集外字母，左右各再断一刀
                seg = seg + 1;
            } else {
                // 若无论 s[i] 改成什么字母，左右并上它的并集大小都 ≤ k，则两侧会合并为一段：需要 -1
                var plus1: Int64 = totCnt + 1;
                if (plus1 > 26) { plus1 = 26; }
                if (plus1 <= k) {
                    seg = seg - 1;
                }
            }

            if (seg > ans) { ans = seg; }
            idx = idx + 1;
        }

        return ans;
    }
}
