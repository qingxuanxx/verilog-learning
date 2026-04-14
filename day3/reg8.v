module reg8(
    input clk,
    input rst_n,
    input en,  // 使能信号
    input [7:0] d,
    output reg [7:0] q
);

// 同步复位
always @(posedge clk)
begin
    if (!rst_n)
    q <= 8'b0000_0000;
    else if (en)
    q <= d;
end

endmodule
