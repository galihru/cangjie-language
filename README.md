# 仓颉（Cangjie）编程语言速学手册

> 面向全场景智能的新一代编程语言。本文是给入门者的 **README.md**。

---

## 1. 认识仓颉

- **定位**：面向全场景智能（手机、IoT、边缘–云协同等）的现代语言，强调 *高性能*、*强安全* 与 *原生智能*。
- **典型特性**：
  - 多范式：命令式 / 面向对象 / 函数式并存。
  - 高效语法：类型推断、字符串插值、模块化与包管理。
  - 运行时：并发 GC、轻量线程、良好并发性能。
  - 原生智能：AgentDSL 框架，便于构建智能体应用（多 Agent 协同）。
- **生态与场景**：HarmonyOS NEXT 原生应用与服务、以及跨设备协同的智能应用。

> 官方下载提供 **LTS / STS / Nightly** 三种渠道，支持 **Windows / Linux / macOS**；并有 VS Code 扩展与调试器（`cjdb`）。

---

## 2. 环境搭建（快速上手）

### 2.1 安装 SDK
1. 前往官网“Download”选择渠道（建议 **STS** 或 **LTS**）并下载与你系统匹配的安装包。  
2. 安装后确保命令行可用：
   - `cjc` —— 仓颉编译器（默认产出可执行文件）。
   - `cjpm` —— 包管理与构建工具（建议项目级构建使用）。
   - `cjdb` —— 调试器（断点、单步等）。
3. VS Code 用户安装 “Cangjie” 插件，即可获得语法高亮、跳转、编译与调试集成。

> 如手动解压安装，注意把 `cjc` / `cjpm` 所在目录加入 `PATH`。

### 2.2 快速验证
新建文件 `main.cj` 并写入：
```cj
func main() {
  println("你好，仓颉！")
}
```
命令行执行：
```bash
cjc main.cj  # 生成本机可执行文件（各平台扩展名可能不同）
./main       # 运行
```

---

## 3. 语言基础语法（速览）

### 3.1 变量与常量
```cj
let answer = 42      // 不可变绑定
var count = 0        // 可变绑定
count += 1
```

### 3.2 基本类型与插值
```cj
let n: Int = 7
let pi = 3.14159     // 推断为浮点
let ok: Bool = true
let name = "jiang rui"
println("name = ${name}, n = ${n}")
```

### 3.3 条件与循环
```cj
func abs(x: Int): Int {
  if (x >= 0) { return x }
  else { return -x }
}

var sum = 0
for (let i in 1..5) {  // 1 到 5 的区间
  sum += i
}
println(sum)  // 15
```

### 3.4 函数与高阶函数
```cj
func add(x: Int, y: Int): Int {
  return x + y
}

let square = { x: Int => x * x }   // Lambda
func apply(f: (Int) -> Int, v: Int): Int { return f(v) }
println(apply(square, 5))  // 25
```

### 3.5 面向对象（类 / 继承 / 构造）
```cj
public open class Animal {
  public open func speak(): Unit {
    println("Animal speaks")
  }
}

public class Dog <: Animal {
  public override func speak(): Unit {
    println("Dog barks")
  }
}

public class Greeter {
  let message: String
  init(msg: String) { this.message = msg }
  public func greet(): Unit { println(this.message) }
}

func main() {
  let a: Animal = Dog()
  a.speak()  // 到咯

  let g = Greeter("欢迎来到 Cangjie!")
  g.greet()
}
```

> 说明：`open` 控制可继承/可重写，`override` 表示覆盖；`Unit` 为“无返回值”的返回类型。

### 3.6 模块与包（概念）
- 源文件可声明 `package`，按目录组织模块；
- 第三方库与多模块工程建议统一交由 `cjpm` 管理。

---

## 4. 使用 CJPM（项目与依赖）

> **CJPM（Cangjie Package Manager）**：官方包管理与构建工具，负责模块系统、依赖解析、构建与测试入口统一。

常见工作流（示例，命令命名以当前版本为准）：
```bash
cjpm new hello-cj         # 初始化项目骨架
cd hello-cj
cjpm build                # 构建
cjpm run                  # 运行（如项目模板已配置执行目标）
cjpm test                 # 运行测试
cjpm add <pkg>@<version>  # 增加依赖（如仓库已开放）
```

> 不使用 `cjpm` 时，你也可以直接用 `cjc` 对单文件或多文件进行编译。

---

## 5. 构建产物与目标平台

- **本机可执行文件（.exe / 无扩展名等）**：`cjc` 缺省编译产物即为可执行文件；也支持输出 **静态库 / 动态库** 以便与其他语言互调。
- **HarmonyOS NEXT 应用（HAP 包）**：针对鸿蒙原生应用，通常在 DevEco/ArkUI 工程内集成仓颉代码并打包为 **HAP**。
- **关于 .apk**：HarmonyOS NEXT **不再兼容** Android APK 运行时，原生应用需使用鸿蒙栈重构与打包，不直接生成 `.apk`。

---

## 6. 与 AI / 生态能力

- **原生智能化**：内置 **AgentDSL**，支持多 Agent 协同与自然语言—编程语言融合，便于智能体应用开发。
- **FFI（外部函数接口）**：可与 **C / Python** 等语言互操作，便于调用现有 AI 推理库或系统接口（根据版本与平台配置不同，示例以官方/社区文档为准）。
- **三方库与社区**：可关注 “awesome-cangjie”、社区 SIG/TPC 等项目，获取数据库、网络、加解密等常用库。

---

## 7. 实战小练习

1) **命令行计算器（加减乘除）**  
   - 读取命令行参数，解析两个数与运算符，输出结果。  
2) **集合处理**  
   - 给定整数列表，过滤偶数、求平方并累加。  
3) **面向对象**  
   - 设计 `Shape` 抽象类与 `Circle/Rect` 子类，计算面积并多态打印。  

> 建议将练习放在 `cjpm` 项目内，方便后续引入日志、测试与依赖。

---

### 附：更完整示例

```cj
package demo

public class Fib {
  public static func calc(n: Int): Int {
    if (n <= 1) { return n }
    return calc(n - 1) + calc(n - 2)
  }
}

func main() {
  println("F(10) = ${Fib.calc(10)}")
}
```
