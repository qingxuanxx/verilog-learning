`timescale 1ns/1ps

module priority_enc8_tb;
reg [7:0] d;
wire [2:0] code;
wire valid;

priority_enc8 u1(.d(d), .code(code), .valid(valid));

initial begin
    $dumpfile("priority_enc8_tb.vcd");
    $dumpvars(0, priority_enc8_tb);

    $monitor("t = %0t, d = %b, code = %b, valid = %b", 
            $time, d, code, valid);

    d = 8'b0000_0000; #10;
    d = 8'b0000_0001; #10;
    d = 8'b0000_1000; #10;
    d = 8'b0001_0110; #10;
    d = 8'b1010_0000; #10;
    d = 8'b1111_1111; #10;
    
    $finish;
end

endmodule