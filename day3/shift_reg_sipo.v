// SIPO = Serial-In, Parallel-Out
// 每个时钟沿，把串行输入 sin 推入最低位，其他位左移一位
module shift_reg_sipo(
    input clk,
    input rst_n,
    input sin,
    output reg [7:0] pout
);

always @(posedge clk)
begin
    if (!rst_n)
    pout <= 8'b0000_0000;
    else
    pout <= {pout[6:0], sin};  // 左移 + 新输入 sin 放在最低位
end

endmodule