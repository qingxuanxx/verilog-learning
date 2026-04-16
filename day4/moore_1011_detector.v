module moore_1011_detector(
    input clk,
    input rst_n,
    input din,
    output reg dout
);

// 状态定义
localparam s0 = 3'b000;  // 初始状态
localparam s1 = 3'b001;  // 检测到 1 
localparam s2 = 3'b010;  // 检测到 10
localparam s3 = 3'b011;  // 检测到 101
localparam s4 = 3'b100;  // 检测到 1011

reg [2:0] current_state;
reg [2:0] next_state;

// 第一段：状态寄存器（时序逻辑）
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
    s3: next_state = (din == 1'b1) ? s4 : s0;
    s4: next_state = (din == 1'b1) ? s1 : s2;
    default: next_state = s0;
    endcase
end

// 第三段：输出逻辑（时序逻辑）（moore：当前状态=>输出）
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    dout <= 1'b0;
    else
    begin
        case (current_state)
        s4: dout <= 1'b1;
        default: dout <= 1'b0;
        endcase
    end
end

endmodule
