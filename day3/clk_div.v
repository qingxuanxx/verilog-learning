module clk_div(
    input clk_in,  // 50 Mhz
    input rst_n,
    output reg clk_out  // 1 Mhz
);

parameter div_cnt = 50;
reg [7:0] cnt;  // 分频计数器

always @(posedge clk_in or negedge rst_n)
begin
    if (!rst_n)
    begin
        clk_out <= 1'b0;
        cnt <= 0;
    end 
    else if (cnt == div_cnt - 1)
    begin
        clk_out <= ~clk_out;
        cnt <= 0;
    end
    else
    begin
        cnt <= cnt + 1'b1;
    end
end

endmodule
