`timescale 1ns/1ns

module tb_arbiter_3;

reg clk;
reg rst_n;
reg [2:0] req;
wire [2:0] grant;

// 实例化
arbiter_3 u1(
    .clk(clk), 
    .rst_n(rst_n), 
    .req(req), 
    .grant(grant)
);

// 周期10ns
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("tb_arbiter_3.vcd");
    $dumpvars(0, tb_arbiter_3);
end

initial begin
    $monitor("Time = %0t, rst_n = %0b, req = %b, grant = %b", 
            $time, rst_n, req, grant);
end

initial begin
    // 初始化
    clk = 1'b0;
    rst_n = 1'b0;
    req = 3'b000;
    #20;
    rst_n = 1'b1;
    #10;

    // 场景1：单路请求
    $display("=== 单路请求 ===");
    req = 3'b001; #10;
    req = 3'b010; #10;
    req = 3'b100; #10;
    #20;

    // 场景2：多路请求
    $display("=== 多路请求 ===");
    req = 3'b111; #10;
    req = 3'b110; #10;
    req = 3'b101; #10;
    #20;

    // 场景3：无请求
    $display("=== 无请求 ===");
    req = 3'b000; #10;
    #20;

    $display("=== 仿真完成 ===");
    $finish;
end

endmodule
