`timescale 1ns/1ps

module and2_tb();

reg a, b;
wire y;

and2 u_and2(
    .a(a),
    .b(b),
    .y(y)
);

initial
begin
    $dumpfile("and2_tb.vcd");
    $dumpvars(0, and2_tb);

    $display("a b | y");
    {a, b} = 2'b00; #10 $display("%b %b | %b", a, b, y);
    {a, b} = 2'b01; #10 $display("%b %b | %b", a, b, y);
    {a, b} = 2'b10; #10 $display("%b %b | %b", a, b, y);
    {a, b} = 2'b11; #10 $display("%b %b | %b", a, b, y);
    $finish;
end

endmodule