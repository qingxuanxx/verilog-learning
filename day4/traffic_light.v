module traffic_light(
    input clk,
    input rst_n,
    output reg red,
    output reg green,
    output reg yellow
);

// 状态定义
localparam s_red = 2'b00;
localparam s_green = 2'b01;
localparam s_yellow = 2'b10;

// 时间参数
localparam time_10s = 26'd100;
localparam time_3s = 26'd30;

reg [1:0] current_state;
reg [1:0] next_state;
reg [25:0] cnt;  // 计数器

// 第一段：状态寄存器（时序逻辑）
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        current_state <= red;
        cnt <= 26'b0;
    end
    else
    begin
        current_state <= next_state;
        // 计数器：到时间清零，否则自增
        if ((current_state == s_red && cnt == time_10s - 1) |
        (current_state == s_green && cnt == time_10s - 1) |
        (current_state == s_yellow && cnt == time_3s - 1))
        begin
            cnt <= 26'b0;
        end
        else
        begin
            cnt <= cnt + 1'b1;
        end
    end
end

// 第二段：下一状态逻辑（组合逻辑）
always @(*)
begin
    case (current_state)
    s_red: next_state = (cnt == time_10s - 1) ? s_green : s_red;
    s_green: next_state = (cnt == time_10s - 1) ? s_yellow : s_green;
    s_yellow: next_state = (cnt == time_3s - 1) ? s_red : s_yellow;
    default: next_state = s_red;
    endcase
end

// 第三段：输出逻辑（moore：当前状态=>输出）
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        red <= 1'b0;
        green <= 1'b0;
        yellow <= 1'b0;
    end
    else
    begin
        case (current_state)
        s_red: begin
            red <= 1'b1;
            green <= 1'b0;
            yellow <= 1'b0;
        end
        s_green: begin
            red <= 1'b0;
            green <= 1'b1;
            yellow <= 1'b0;
        end
        s_yellow: begin
            red <= 1'b0;
            green <= 1'b0;
            yellow <= 1'b1;
        end
        default: begin
            red <= 1'b0;
            green <= 1'b0;
            yellow <= 1'b0;
        end
        endcase
    end
end

endmodule

