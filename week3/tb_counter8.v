`timescale 1ns/1ps

module tb_counter8;

reg clk;
reg rst_n;
reg load;
reg en;
reg [7:0] din;
wire [7:0] cnt;

counter8 u1 (.clk(clk), .rst_n(rst_n), .load(load), .en(en), 
            .din(din), .cnt(cnt));

always #5 clk = ~clk;

initial begin
    $dumpfile("tb_counter8.vcd");
    $dumpvars(0, tb_counter8);

    $monitor("t = %0t, rst_n = %b, en = %b, load = %b, din = %h, cnt = %h",
            $time, rst_n, en, load, din, cnt);

    // 初始化
    clk = 0; rst_n = 0; en = 0; load = 0; din = 8'h00;

    #13 rst_n = 1;

    // 测试 en = 0：计数器保持 0
    #20;

    // 测试 en = 1：从 0 开始计数
    en = 1;
    #80;

    // 测试 load 优先级高于 en
    load = 1;
    din = 8'b1111_0000;
    #10 load = 0;

    #200

    // 测试 en = 0：计数器保持当前值
    en = 0;
    #30

    // 测试异步复位：任意时刻立即清零
    rst_n = 0;
    #7  rst_n = 1;

    #20 $finish;

end

endmodule
