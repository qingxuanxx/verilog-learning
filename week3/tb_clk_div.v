`timescale 1ns/1ps

module tb_clk_div;

reg clk_in;
reg rst_n;
wire clk_out;

clk_div u1(.clk_in(clk_in), .rst_n(rst_n), .clk_out(clk_out));

// 50MHz 时钟 (20ns 周期)
always #10 clk_in = ~clk_in;

initial begin
    $dumpfile("tb_clk_div.vcd");
    $dumpvars(0, tb_clk_div);

    // 初始化
    clk_in = 0;
    rst_n = 0;  
    #12;        

    // 释放复位，开始正常分频
    rst_n = 1;
    #2000;      

    rst_n = 0;
    #100;        
    rst_n = 1;
    #2000;     

    $finish;

end

endmodule
