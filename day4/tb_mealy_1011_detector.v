`timescale 1ns/1ps

module tb_mealy_1011_detector;

reg clk;
reg rst_n;
reg din;
wire dout;

// 实例化
mealy_1011_detector u1(
    .clk(clk), 
    .rst_n(rst_n), 
    .din(din), 
    .dout(dout)
);

// 时钟：周期 20ns 
initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end

// 生成波形文件
initial begin
    $dumpfile("tb_mealy_1011_detector.vcd");
    $dumpvars(0, tb_mealy_1011_detector);
end

// 实时打印信号
initial begin
    $monitor("Time = %0t, rst_n = %b, din = %b, dout = %b, current_state = %b",
             $time, rst_n, din, dout, u1.current_state);
end

initial begin
    // 初始化
    rst_n = 1'b0;
    din = 1'b0;
    #20;
    rst_n = 1'b1;
    #20;

    // 输入序列: 1 0 1 1 1 0 1 1
    din = 1'b1; #20;
    din = 1'b0; #20;
    din = 1'b1; #20;
    din = 1'b1; #20; // 检测到 1011
    din = 1'b1; #20;
    din = 1'b0; #20;
    din = 1'b1; #20;
    din = 1'b1; #20; // 检测到 1011

    #100
    $finish;
end

endmodule
