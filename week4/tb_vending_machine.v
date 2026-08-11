`timescale 1ns/1ns

module tb_vending_machine();

reg clk;
reg rst_n;
reg [1:0] coin;
wire sell;
wire change;

vending_machine u1(
    .clk(clk),
    .rst_n(rst_n),
    .coin(coin),
    .sell(sell),
    .change(change)
);

initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end

initial begin
    $monitor("Time = %0t, rst_n = %b, coin = %b, sell = %b, change = %b, state = %b",
             $time, rst_n, coin, sell, change, u1.current_state);
end

initial begin
    // 初始化
    rst_n = 1'b0;
    coin = 2'b00;
    #20;
    rst_n = 1'b1;
    #20;

    // 测试场景1：投1+1+1+1+1+1=6元，出货不找零
    coin = 2'b01; #20;
    coin = 2'b00; #20;
    coin = 2'b01; #20;
    coin = 2'b00; #20;
    coin = 2'b01; #20;
    coin = 2'b00; #20;
    coin = 2'b01; #20;
    coin = 2'b00; #20;
    coin = 2'b01; #20;
    coin = 2'b00; #20;
    coin = 2'b01; #20;
    coin = 2'b00; #40;

    // 测试场景2：投5+1=6元，出货不找零
    coin = 2'b10; #20;
    coin = 2'b00; #20;
    coin = 2'b01; #20;
    coin = 2'b00; #40;

    // 测试场景3：投5+5=10元，出货找零
    coin = 2'b10; #20;
    coin = 2'b00; #20;
    coin = 2'b10; #20;
    coin = 2'b00; #40;

    #2000;
    $finish;
end

endmodule