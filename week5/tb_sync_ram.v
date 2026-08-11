`timescale 1ns/1ns
module tb_sync_ram;

reg clk;
reg rst_n;
reg we;
reg [7:0] addr;
reg [7:0] din;
wire [7:0] dout;

// 实例化
sync_ram u1(
    .clk(clk), 
    .rst_n(rst_n), 
    .we(we), 
    .addr(addr), 
    .din(din), 
    .dout(dout)
);

// 周期10ns
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("tb_sync_ram.vcd");
    $dumpvars(0, tb_sync_ram);
end

initial begin
    $monitor("Time = %0t ns, rst_n = %b, we = %b, addr = %0d, din = %0d, dout = %0d", 
            $time, rst_n, we, addr, din, dout);
end

initial begin
    //初始化
    clk = 1'b0;
    rst_n = 1'b0;
    we = 1'b0;
    addr = 8'b0;
    din = 8'b0;
    #20;
    rst_n = 1'b1;
    #10;

    //场景1：批量写入数据
    $display("=== 批量写入数据 ===");
    we = 1'b1;
    addr = 8'd0; din = 8'd10; #10;
    addr = 8'd1; din = 8'd11; #10;
    addr = 8'd2; din = 8'd12; #10;
    addr = 8'd3; din = 8'd13; #10;
    addr = 8'd4; din = 8'd14; #10;
    addr = 8'd5; din = 8'd15; #10;
    #20;

    // 场景2：批量读出数据
    $display("=== 批量读出数据 ===");
    we = 1'b0;
    addr = 8'd0; #10;
    addr = 8'd1; #10;
    addr = 8'd2; #10;
    addr = 8'd3; #10;
    addr = 8'd4; #10;
    addr = 8'd5; #10;
    #20;

    // 场景3：随机地址读写
    $display("=== 随机地址读写 ===");
    we = 1'b1; addr = 8'd100; din = 8'd200; #10;
    we  =1'b0; addr = 8'd100; #10;
    #20;

    $display("=== 仿真完成 ===");
    $finish;
end

endmodule
