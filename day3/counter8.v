module counter8(
    input clk,
    input rst_n,  // 复位
    input load,  // 加载使能（优先级高于 en）
    input en,  // 使能
    input [7:0] din,  // 加载值
    output reg [7:0] cnt
);

// negedge rst_n：只要 rst_n 变低（下降沿），立即执行复位
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
        cnt <= 8'b0000_0000;
    else if (load)
        cnt <= din;
    else if (en)
        cnt = cnt + 1'b1;
end

endmodule