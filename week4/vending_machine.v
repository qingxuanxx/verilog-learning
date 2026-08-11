// 输入：投币信号 coin: 00-不投币 01-1元 10-5元
// 输出：sell 出货  change 找零
// 规则：商品 6 元，接受 1 元/ 5 元投币，投币总额 >= 6 元时出货，多投则找零
module vending_machine(
    input clk,
    input rst_n,
    input [1:0] coin,
    output reg sell,
    output reg change
);

// 状态转移图
// 状态        含义
// s0          0
// s1          1
// s2          2
// s3          3
// s4          4
// s5          5
// s6          >=6

// 状态定义
localparam s0 = 3'b000;
localparam s1 = 3'b001;
localparam s2 = 3'b010;
localparam s3 = 3'b011;
localparam s4 = 3'b100;
localparam s5 = 3'b101;
localparam s6 = 3'b110;

reg [2:0] current_state;
reg [2:0] next_state;
reg [2:0] pre_state;  // 保存上一状态
reg [1:0] last_coin;  // 最后一次投币

// 第一段：状态寄存器（时序逻辑）
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        current_state <= s0;
        pre_state <= s0;
        last_coin <= 2'b00;
    end
    else
    begin
        pre_state <= current_state;
        current_state <= next_state;

        if (coin != 2'b00)
        begin
            last_coin <= coin;
        end
    end
end

// 第二段：下一状态逻辑（组合逻辑）
always @(*)
begin
    case (current_state)
    s0: begin
        case (coin)
        2'b01: next_state = s1;
        2'b10: next_state = s5;
        default: next_state = s0;
        endcase
    end
    s1: begin
        case (coin)
        2'b01: next_state = s2;
        2'b10: next_state = s6;
        default: next_state = s1;
        endcase
    end
    s2: begin
        case(coin)
        2'b01: next_state = s3;   
        2'b10: next_state = s6;   
        default: next_state = s2;
        endcase
    end
    s3: begin
        case(coin)
        2'b01: next_state = s4;  
        2'b10: next_state = s6;   
        default: next_state = s3;
        endcase
    end
    s4: begin
        case(coin)
        2'b01: next_state = s5;   
        2'b10: next_state = s6;  
        default: next_state = s4;
        endcase
    end
    s5: begin
        case(coin)
        2'b01: next_state = s6;  
        2'b10: next_state = s6;   
        default: next_state = s5;
        endcase
    end
    s6: begin
        next_state = s0;
    end
    default: next_state = s0;
    endcase
end

// 第三段：输出逻辑（时序逻辑）
//（mealy：s6 状态时，根据投币来判断是否找零）
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        sell <= 1'b0;
        change <= 1'b0;
    end
    else
    begin
        case (current_state)
        s6: begin
            sell <= 1'b1;
            
            // 用 last_coin 和 pre_state 判断
            case (last_coin)  // 判断是否找零
            2'b10: begin
                if (pre_state != s1)
                change <= 1'b1;
                else
                change <= 1'b0;
            end
            2'b01: begin
                change <= 1'b0;  // 投1元最多5+1=6，不找零
            end
            default: change <= 1'b0;
            endcase
        end
        default: begin
            sell <= 1'b0;
            change <= 1'b0;
        end
        endcase
    end
end

endmodule
