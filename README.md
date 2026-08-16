# Verilog 练习代码

SystemVerilog/Verilog 数字电路设计学习，按周（week）组织，每周围绕一类知识点展开。

```
verilog-learning/
├── week1/  # 组合逻辑基础
│   ├── and2.v / or2.v / xor2.v     # 基本门电路
│   ├── adder4.v                    # 4位加法器
│   └── hello.v                     # 入门 hello world
├── week2/  # 组合逻辑进阶
│   ├── decoder3_8.v                # 3-8译码器
│   ├── mux4_assign.v / mux4_case.v # 4选1多路选择器（assign/case两种写法）
│   ├── priority_enc8.v             # 8位优先编码器
│   ├── barrel_shifter.v            # 桶形移位器
│   └── seg7.v                      # 七段数码管显示
├── week3/  # 时序逻辑基础
│   ├── dff_sync.v / dff_async.v    # 同步/异步D触发器
│   ├── reg8.v                      # 8位寄存器
│   ├── counter8.v                  # 8位计数器
│   ├── shift_reg_sipo.v            # 串入并出移位寄存器
│   └── clk_div.v                   # 时钟分频器
├── week4/  # 状态机
│   ├── mealy_1011_detector.v        # Mealy型1011序列检测器
│   ├── moore_1011_detector.v        # Moore型1011序列检测器
│   ├── vending_machine.v            # 自动售货机
│   └── traffic_light.v              # 交通灯状态机
└── week5/  # 进阶模块设计
    ├── sync_fifo.v                  # 同步FIFO
    ├── async_fifo.v                 # 异步FIFO
    ├── sync_ram.v                   # 同步RAM
    └── arbiter_3.v                  # 3路仲裁器
```

每个模块均配有 testbench（`*_tb.v`），可直接用 iverilog / ModelSim / VCS 仿真。

## 使用方式

```bash
# iverilog 示例：编译并运行 week1 的 adder4
cd week1
iverilog -o adder4.vvp adder4_tb.v adder4.v
vvp adder4.vvp
gtkwave adder4.vcd
```

## 参考资料

- 《Verilog 数字系统设计教程》（第3版，夏宇闻）

> 最后更新：2026-08-16
