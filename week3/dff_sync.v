module dff_sync(
    input clk,
    input rst_n,
    input d,
    output reg q
);

// 同步复位 D 触发器
always @(posedge clk)
begin
    if (!rst_n)
    q <= 1'b0;
    else
    q <= d;
end

endmodule