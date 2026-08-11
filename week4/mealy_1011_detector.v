module mealy_1011_detector(
    input clk,
    input rst_n,
    input din,
    output reg dout
);

// 状态定义
localparam s0 = 2'b00;  // 初始状态
localparam s1 = 2'b01;  // 检测到 1
localparam s2 = 2'b10;  // 检测到 10
localparam s3 = 2'b11;  // 检测到 101

reg [1:0] current_state;
reg [1:0] next_state;

// 第一段：状态寄存器（时序逻辑）（异步复位）
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    current_state <= s0;
    else
    current_state <= next_state;
end

// 第二段：下一状态逻辑（组合逻辑）
always @(*)
begin
    case (current_state)
    s0: next_state = (din == 1'b1) ? s1 : s0;
    s1: next_state = (din == 1'b0) ? s2 : s1;
    s2: next_state = (din == 1'b1) ? s3 : s0;
    s3: next_state = (din == 1'b1) ? s1 : s0;
    default: next_state = s0;
    endcase
end

// 第三段：输出逻辑（时序逻辑）（mealy：当前状态+输入=>输出）
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    dout <= 1'b0;
    else
    begin
        case (current_state)
        s3: dout <= (din == 1'b1) ? 1'b1 : 1'b0;
        default: dout <= 1'b0;
        endcase
    end
end

endmodule 