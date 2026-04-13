`timescale 1ns/1ps
module mux4_tb;
    reg  [3:0] d;
    reg  [1:0] sel;
    wire y_a, y_b;

    mux4_assign u1(.d(d), .sel(sel), .y(y_a));
    mux4_case   u2(.d(d), .sel(sel), .y(y_b));

    integer i;
    initial begin
        $dumpfile("mux4_tb.vcd");
        $dumpvars(0, mux4_tb);

        d = 4'b1010;   // 预设一组数据
        $display("sel | y_assign y_case");
        for (i = 0; i < 4; i = i + 1) 
        begin
            sel = i; #10;
            $display(" %b |    %b        %b", sel, y_a, y_b);
        end
        $finish;
    end
endmodule