module dff_async(
    input clk,
    input rst_n,
    input d,
    output reg q
);

// 异步复位 D 触发器
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    q <= 1'b0;
    else
    q <= d;
end

endmodule