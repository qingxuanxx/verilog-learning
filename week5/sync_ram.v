// 单端口同步 RAM 256*8
// 单端口：一组地址总线、一组数据总线、一套读写控制信号
//        同一时刻只能执行读或写操作，不能同时读写
// 同步：所有读写操作都在时钟有效沿触发，时序逻辑
// 地址：2^8=256  数据：8 bit
module sync_ram(
    input clk,
    input rst_n,
    input we, // 写使能，高电平写，低电平读
    input [7:0] addr,
    input [7:0] din, 
    output reg [7:0] dout
);

// 定义存储体
reg [7:0] mem [255:0];  // 256个8bit寄存器组（位宽在前，深度在后）

integer i;

// 读写逻辑
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n) // 复位清空存储单元
    begin
        for (i = 0; i <= 255; i = i + 1)
        begin
            mem[i] <= 8'b0;
        end
        dout <= 8'b0;
    end
    else
    begin
        if (we)  // we = 1 写操作
        begin
            mem[addr] <= din;
        end
        else  // we = 0 读操作
        begin
            dout <= mem[addr];
        end
    end
end

endmodule
