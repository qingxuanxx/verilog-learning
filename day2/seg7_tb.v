`timescale 1ns/1ps

module seg7_tb;

reg [3:0] bcd;
wire [6:0] seg;

seg7 u1(.bcd(bcd), .seg(seg));

integer i;
initial begin
    $dumpfile("seg7_tb.vcd");
    $dumpvars(0, seg7_tb);

    $monitor("t = %0t, bcd = %b, seg = %b", $time, bcd, seg);

    for (i = 0; i < 16; i = i + 1) begin
        bcd = i; #10;
    end
    $finish;
end

endmodule
