// BCD 转 7 段数码管的译码器
// 将输入的 0~9, A~F，转换为控制 7 段数码管点亮的 7 位信号
module seg7(
    input [3:0] bcd,  // 0~9, A~F
    output reg [6:0] seg  // {g, f, e, d, c, b, a}
);

//      aaa
//     f   b
//     f   b
//      ggg
//     e   c
//     e   c
//      ddd

always @(*) begin
    case (bcd)
    4'h0: seg = 7'b011_1111;
    4'h1: seg = 7'b000_0110;
    4'h2: seg = 7'b101_1011;
    4'h3: seg = 7'b100_1111;
    4'h4: seg = 7'b110_0110;
    4'h5: seg = 7'b110_1101;
    4'h6: seg = 7'b111_1101;
    4'h7: seg = 7'b000_0111;
    4'h8: seg = 7'b111_1111;
    4'h9: seg = 7'b110_1111;
    4'hA: seg = 7'b111_0111;
    4'hB: seg = 7'b111_1100;
    4'hC: seg = 7'b011_1001;
    4'hD: seg = 7'b101_1110;
    4'hE: seg = 7'b111_1001;
    4'hF: seg = 7'b111_0001;
    default: seg = 7'b000_0000;
    endcase
end

endmodule