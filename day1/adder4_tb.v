`timescale 1ns/1ps

module adder4_tb;

reg [3:0] a, b;
reg cin;
wire [3:0] sum;
wire cout;

adder4 u_adder4(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial
begin
    $dumpfile("adder4_tb.vcd");
    $dumpvars(0, adder4_tb);

    $display("time | a  b  cin | sum cout");
    $display("-----|-----------|---------");

    $monitor("%4t  | %2d %2d %2b | %2d %2b", 
            $time, a, b, cin, sum, cout);

    a = 4'b0000; b = 4'b0000; cin = 0; #10;
    a = 4'b0011; b = 4'b0101; cin = 0; #10;
    a = 4'b0111; b = 4'b1000; cin = 1; #10;
    a = 4'b1111; b = 4'b0001; cin = 0; #10;
    a = 4'b1111; b = 4'b1111; cin = 1; #10;
    
    $finish; 
end

endmodule 