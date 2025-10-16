// 数组初始化用：恒返回 0
func zero64(i: Int64): Int64 { return 0; }

// 把一个字节 (UInt8) 映射到 0..25；若不在 a..z 返回 -1
func idxByte(b: UInt8): Int64 {
    let abc = "abcdefghijklmnopqrstuvwxyz";
    var t: Int64 = 0;
    while (t < 26) {
        if (abc[t] == b) { return t; } // UInt8 == UInt8
        t = t + 1;
    }
    return -1;
}

// 计算单词的 26 维“频次签名”，写入 out[0..25]（会先清零）
func buildSig(word: String, out: Array<Int64>): Int64 {
    var t: Int64 = 0;
    while (t < 26) { out[t] = 0; t = t + 1; }
    var j: Int64 = 0;
    let L = word.size;   // 若你的 SDK 用 .length，请把 .size 改成 .length
    while (j < L) {
        let b = word[j];           // 这里是 UInt8
        let id = idxByte(b);       // 用 UInt8 版本映射
        if (id >= 0) { out[id] = out[id] + 1; }
        j = j + 1;
    }
    return 0;
}

// 比较两个 26 维签名是否完全相等；相等返回 1，否则返回 0
func eqSig(a: Array<Int64>, b: Array<Int64>): Int64 {
    var i: Int64 = 0;
    while (i < 26) {
        if (a[i] != b[i]) { return 0; }
        i = i + 1;
    }
    return 1;
}

class Solution {
    func removeAnagrams(words: Array<String>): ArrayList<String> {
        let n = words.size;
        var res = ArrayList<String>();
        if (n == 0) { return res; }

        var lastSig = Array<Int64>(26, zero64);
        var curSig  = Array<Int64>(26, zero64);
        var hasLast: Int64 = 0;

        var i: Int64 = 0;
        while (i < n) {
            let w = words[i];

            // 生成当前单词的签名（忽略返回值）
            buildSig(w, curSig);

            var same: Int64 = 0;
            if (hasLast != 0) {
                same = eqSig(curSig, lastSig); // 1 表示与上一个保留单词互为异位词 (开了： eq.cj)
            }

            if (hasLast != 0 && same != 0) {
                // 是异位词：删除（跳过）
            } else {
                // 保留该单词
                res.add(w);
                // 更新 lastSig = curSig
                var k: Int64 = 0;
                while (k < 26) {
                    lastSig[k] = curSig[k];
                    k = k + 1;
                }
                hasLast = 1;
            }

            i = i + 1;
        }

        return res;
    }
}
