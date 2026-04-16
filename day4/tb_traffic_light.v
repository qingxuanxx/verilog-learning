`timescale 1ns/1ns

module tb_traffic_light();

reg clk;
reg rst_n;
wire red, green, yellow;

traffic_light u1(
    .clk(clk),
    .rst_n(rst_n),
    .red(red),
    .green(green),
    .yellow(yellow)
);

// 生成50MHz时钟
initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end

initial begin
    $dumpfile("tb_traffic_light.vcd");
    $dumpvars(0, tb_traffic_light);
end

initial begin
    $monitor("Time = %0t, rst_n = %b, red = %b, green = %b, yellow = %b, state = %b, cnt = %d",
             $time, rst_n, red, green, yellow, u1.current_state, u1.cnt);
end

initial begin
    rst_n = 1'b0;
    #20;
    rst_n = 1'b1;
    #20000;  // 仿真足够时间观察循环
    $finish;
end

endmodule