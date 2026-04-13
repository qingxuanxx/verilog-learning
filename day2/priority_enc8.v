// 优先编码器：从高位到低位扫描，输出第一个 1 所在的位置
module priority_enc8(
    input [7:0] d,  // 8位输入
    output reg [2:0] code,  // 3位输出，表示第一个1的位置
    output reg valid  // 输出有效信号，表示输入中至少有一个1
);

always @(*) begin
    valid = 1'b1;
    casex (d)
    8'b1xxx_xxxx: code = 3'd7;
    8'b01xx_xxxx: code = 3'd6;
    8'b001x_xxxx: code = 3'd5;
    8'b0001_xxxx: code = 3'd4;
    8'b0000_1xxx: code = 3'd3;
    8'b0000_01xx: code = 3'd2;
    8'b0000_001x: code = 3'd1;
    8'b0000_0001: code = 3'd0;
    default: begin
        valid = 1'b0;  // 输入全为0时，输出无效
        code = 3'b000;  // 输出任意值，此处设为0
    end
    endcase
end

// assign code = d[7] ? 3'd7 :
//               d[6] ? 3'd6 :
//               d[5] ? 3'd5 :
//               d[4] ? 3'd4 :
//               d[3] ? 3'd3 :
//               d[2] ? 3'd2 :
//               d[1] ? 3'd1 : 3'd0;
// assign valid = |d;  // 或运算，只要有1就为1

endmodule