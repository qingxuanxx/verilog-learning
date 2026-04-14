`timescale 1ns/1ps

module tb_shift_reg_sipo;

reg clk, rst_n, sin;
wire [7:0] pout;

shift_reg_sipo u1(.clk(clk), .rst_n(rst_n), .sin(sin), .pout(pout));

always #5 clk = ~clk;

// 待送入的串行数据
reg [7:0] data = 8'b1011_0100;

integer i;
initial begin
    $dumpfile("tb_shift_reg_sipo.vcd");
    $dumpvars(0, tb_shift_reg_sipo);

    $monitor("t = %0t, rst_n = %b, sin = %b, pout = %b",
            $time, rst_n, sin, pout);

    // 初始化
    clk = 0; rst_n = 0; sin = 0;

    #12 rst_n = 1; // 释放复位

    // 依次送入data的每一位
    for (i = 7; i >= 0; i = i - 1)
    begin
        sin = data[i]; #10;
    end

    #10;
    $display("final pout = %b, expect = %b", pout, data);

    #10;
    $finish;
end

endmodule