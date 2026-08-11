module sync_fifo#(
    parameter width = 8,  // 数据宽度 8 bit
    parameter depth = 16  // fifo 深度 16
)(
    input clk,
    input rst_n,
    // 写接口
    input wr_en,
    input [width-1:0] wr_data,
    // 读接口
    input rd_en,
    output reg [width-1:0] rd_data,
    // 状态信号
    output full,
    output empty
);

localparam addr_width = $clog2(depth);
localparam ptr_width = addr_width + 1;  // 指针位宽=地址位宽+1=5bit

// 读写指针
reg [ptr_width-1:0] wptr;
reg [ptr_width-1:0] rptr;

// 存储体（位宽8，深度16）
reg [width-1:0] mem [depth-1:0];

integer i;

// 读写逻辑
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)  // 复位：指针清零，ram清空
    begin
        wptr <= {ptr_width{1'b0}};
        rptr <= {ptr_width{1'b0}};
        for (i = 0; i <= depth - 1; i = i + 1)
        begin
            mem[i] <= {width{1'b0}};
        end
    end
    else
    begin
        // 写操作：写使能且fifo队列未满
        if (wr_en && !full)
        begin
            mem[wptr[addr_width-1:0]] <= wr_data;  // 指针低4位为ram地址
            wptr <= wptr + 1'b1;
        end
        // 读操作：读使能且fifo非空
        if (rd_en && !empty)
        begin
            rd_data <= mem[rptr[addr_width-1:0]];  // 指针低4位为ram地址
            rptr <= rptr + 1'b1;
        end
    end
end

// 满空信号判断
// 空信号：读写指针，所有位都相同
assign empty = (wptr == rptr) ? 1'b1 : 1'b0;

// 满信号：读写指针，最高位相反，其他位相同
assign full = (wptr[ptr_width-1] != rptr[ptr_width-1]) &&
              (wptr[addr_width-1:0] == rptr[addr_width-1:0]) ? 1'b1 : 1'b0;

endmodule
