module barrel_shifter(
    input [7:0] din,
    input [2:0] shift,  // 移位量: 0~7
    input dir,  // 移位方向: 0=左移, 1=右移
    output [7:0] dout
);

assign dout = dir ? (din >> shift) : (din << shift);

endmodule