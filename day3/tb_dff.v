// tb_dff.v
`timescale 1ns/1ps

module tb_dff;

reg clk, rst_n, d;
wire q_sync, q_async;

dff_sync  u1 (.clk(clk), .rst_n(rst_n), .d(d), .q(q_sync));
dff_async u2 (.clk(clk), .rst_n(rst_n), .d(d), .q(q_async));

// 10ns 周期时钟
always #5 clk = ~clk;

initial begin
    $dumpfile("tb_dff.vcd");
    $dumpvars(0, tb_dff);

    $monitor("t = %0t, rst_n = %b, d = %b, q_sync = %b, q_async = %b",
            $time, rst_n, d, q_sync, q_async);

    // 初始化
    clk = 0; rst_n = 0; d = 0;

    // 复位释放
    #13 rst_n = 1;

    // 测试正常采样
    #10 d = 1;
    #10 d = 0;
    #10 d = 1;

    // 故意在非时钟沿拉低复位，观察同步 vs 异步差异
    #3  rst_n = 0;
    #4  rst_n = 1;

    #20 $finish;
end

endmodule