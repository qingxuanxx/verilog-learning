// 异步 fifo 模块
// 跨时钟域设计 + 格雷码指针
module async_fifo#(
    parameter width = 8,
    parameter depth = 16
)(
    input wr_clk,
    input wr_rst_n, // 写时钟复位
    input wr_en,  // 写使能
    input [width-1:0] wr_data,
    
    input rd_clk,
    input rd_rst_n, // 读时钟复位
    input rd_en,  // 读使能
    output reg [width-1:0] rd_data,

// output reg：在 always 时序里面赋值，加 reg
// output（默认 wire）：用 assign 连续赋值语句赋值，不加reg

    output full,  // 写时钟域的满信号
    output empty  // 读时钟域的空信号
);

localparam addr_width = $clog2(depth);
localparam ptr_width = addr_width + 1;  // 指针位宽=地址位宽+1=5bit

// 写时钟域：二进制写指针、格雷码写指针
reg [ptr_width-1:0] wptr_bin;  // 二进制写指针
reg [ptr_width-1:0] wptr_gray; // 格雷码写指针

// 读时钟域：二进制读指针、格雷码读指针
reg [ptr_width-1:0] rptr_bin;  // 二进制读指针
reg [ptr_width-1:0] rptr_gray; // 格雷码读指针

// 存储体（位宽8，深度16）
reg [width-1:0] mem [depth-1:0];

// 同步电路寄存器：写指针同步到读时钟域（两级）
reg [ptr_width-1:0] wptr_gray_sync1;
reg [ptr_width-1:0] wptr_gray_sync2;

// 同步电路寄存器：读指针同步到写时钟域（两级）
reg [ptr_width-1:0] rptr_gray_sync1;
reg [ptr_width-1:0] rptr_gray_sync2;

integer i;

// 二进制转格雷码
function [ptr_width-1:0] bin2gray;
    input [ptr_width-1:0] bin;
    begin
        bin2gray = bin ^ (bin >> 1);  // 二进制转格雷码公式
    end
endfunction

// 1.写时钟域逻辑：读指针同步、写指针更新、存储体写操作
// 1.1 读指针同步
always @(posedge wr_clk or negedge wr_rst_n)
begin
    if (!wr_rst_n)
    begin
        rptr_gray_sync1 <= {ptr_width{1'b0}};
        rptr_gray_sync2 <= {ptr_width{1'b0}};
    end
    else
    begin
        rptr_gray_sync1 <= rptr_gray;
        rptr_gray_sync2 <= rptr_gray_sync1;
    end
end

// 1.2 写指针更新
always @(posedge wr_clk or negedge wr_rst_n)
begin
    if (!wr_rst_n)
    begin
        wptr_bin <= {ptr_width{1'b0}};
        wptr_gray <= {ptr_width{1'b0}};
    end
    else if (wr_en && !full)  // 写使能且fifo未满
    begin
        wptr_bin <= wptr_bin + 1;
        wptr_gray <= bin2gray(wptr_bin + 1);  // <= 读的是旧值，所以要 bin2gray(wptr_bin + 1)
    end
end

// 1.3 存储体写操作
always @(posedge wr_clk or negedge wr_rst_n)
begin
    if (!wr_rst_n)
    begin
        for (i = 0; i <= depth-1; i = i + 1)
        begin
            mem[i] <= {width{1'b0}};
        end
    end
    else if (wr_en && !full)  // 写使能且fifo未满
    begin
        mem[wptr_bin[addr_width-1:0]] <= wr_data;  // 指针低4位为ram地址
    end
end

// 2.读时钟域逻辑：写指针同步、读指针更新、存储体读操作
// 2.1 写指针同步
always @(posedge rd_clk or negedge rd_rst_n)
begin
    if (!rd_rst_n)
    begin
        wptr_gray_sync1 <= {ptr_width{1'b0}};
        wptr_gray_sync2 <= {ptr_width{1'b0}};
    end
    else
    begin
        wptr_gray_sync1 <= wptr_gray;
        wptr_gray_sync2 <= wptr_gray_sync1;
    end
end

// 2.2 读指针更新
always @(posedge rd_clk or negedge rd_rst_n)
begin
    if (!rd_rst_n)
    begin
        rptr_bin <= {ptr_width{1'b0}};
        rptr_gray <= {ptr_width{1'b0}};
    end
    else if (rd_en && !empty)  // 读使能且fifo非空
    begin
        rptr_bin <= rptr_bin + 1'b1;
        rptr_gray <= bin2gray(rptr_bin + 1'b1);
    end
end

// 2.3 存储体读操作
always @(posedge rd_clk or negedge rd_rst_n)
begin
    if (!rd_rst_n)
    begin
        rd_data <= {width{1'b0}};
    end
    else if (rd_en && !empty)  // 读使能且fifo非空
    begin
        rd_data <= mem[rptr_bin[addr_width-1:0]];  // 指针低4位为ram地址
    end
end

// 满空信号判断
// 空信号判断(在读时钟域)
assign empty = (wptr_gray_sync2 == rptr_gray) ? 1'b1 : 1'b0;

// 满信号判断（在写时钟域）：最高位相反，次高位相反，其他位相同
assign full = (wptr_gray[ptr_width-1] != rptr_gray_sync2[ptr_width-1]) && 
              (wptr_gray[ptr_width-2] != rptr_gray_sync2[ptr_width-2]) && 
              (wptr_gray[ptr_width-3:0] == rptr_gray_sync2[ptr_width-3:0]) ? 1'b1 : 1'b0;

endmodule