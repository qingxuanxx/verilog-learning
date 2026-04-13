`timescale 1ns/1ps

module barrel_shifter_tb;

reg [7:0] din;
reg [2:0] shift;
reg dir;
wire [7:0] dout;

barrel_shifter u1(.din(din), .shift(shift), .dir(dir), .dout(dout));

integer i;
initial begin
    $dumpfile("barrel_shifter_tb.vcd");
    $dumpvars(0, barrel_shifter_tb);

    din = 8'b1011_0100;
    $display("--- 左移 ---");
    dir = 0;
    for (i = 0; i < 8; i ++)
    begin
        shift = i; #10
        $display("din = %b << %d = %b", din, shift, dout);
    end

    $display("--- 右移 ---");
    dir = 1;
    for (i = 0; i < 8; i ++)
    begin
        shift = i; #10
        $display("din = %b >> %d = %b", din, shift, dout);
    end

    $finish;
end

endmodule