`timescale 1ns/1ns

module tb_moore_1011_detector();

reg clk;
reg rst_n;
reg din;
wire dout;

moore_1011_detector u2(
    .clk(clk),
    .rst_n(rst_n),
    .din(din),
    .dout(dout)
);

initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end

initial begin
    $dumpfile("tb_moore_1011_detector.vcd");
    $dumpvars(0, tb_moore_1011_detector);
end

initial begin
    $monitor("Time = %0t, rst_n = %b, din = %b, dout = %b, current_state = %b",
             $time, rst_n, din, dout, u2.current_state);
end

initial begin
    // 初始化
    rst_n = 1'b0;
    din = 1'b0;
    #20;
    rst_n = 1'b1;
    #20;

    // 输入序列：1 0 1 1 1 0 1 1
    din = 1'b1; #20;
    din = 1'b0; #20;
    din = 1'b1; #20;
    din = 1'b1; #20;
    din = 1'b1; #20;
    din = 1'b0; #20;
    din = 1'b1; #20;
    din = 1'b1; #20;

    #100;
    $finish;
end

endmodule