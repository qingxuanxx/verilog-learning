`timescale 1ns/1ps

module reg8_tb;

reg clk;
reg rst_n;
reg en;
reg [7:0] d;
wire [7:0] q;

reg8 u1(.clk(clk), .rst_n(rst_n), .en(en), .d(d), .q(q));

// 10ns 周期时钟
always #5 clk = ~clk;

initial begin
    $dumpfile("tb_reg8.vcd");
    $dumpvars(0, tb_reg8);

    $monitor("t = %0t, rst_n = %b, en = %b, d = %b, q = %b",
            $time, rst_n, en, d, q);

    // 初始化
    clk = 0; rst_n = 0; en = 0; d = 8'b0000_0000;

    #12 rst_n = 1;

    // 测试使能为0的情况: q应该保持0
    en = 0; d = 8'b1010_1010; #10;
    d = 8'b0101_0101; #10;
    d = 8'b1111_0000; #10;
    d = 8'b0000_1111; #10;

    // 测试使能为1的情况: q应该跟随d
    en = 1; d = 8'b1010_1010; #10;
    d = 8'b0101_0101; #10;
    d = 8'b1111_0000; #10;
    d = 8'b0000_1111; #10;

    // 再次关使能：q 保持最后一个值
    en = 0; d = 8'b1111_1111; #10;

    $finish;
end

endmodule