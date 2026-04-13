`timescale 1ns/1ps

module decoder3_8_tb;

reg en;
reg [2:0] a;
wire [7:0] y;

decoder3_8 u1(.en(en), .a(a), .y(y));

integer i;
initial begin
    $dumpfile("decoder3_8_tb.vcd");
    $dumpvars(0, decoder3_8_tb);

    $monitor("t = %0t, en = %b, a = %b, y = %b", $time, en, a, y);

    // 测试使能为0的情况
    en = 0; a = 3'b000; #10;
    en = 0; a = 3'b101; #10;

    // 测试使能为1的情况
    en = 1;
    for (i = 0; i < 8; i = i + 1) begin
        a = i; #10;
    end
    $finish;
end

endmodule