`timescale 1ns/1ns
module tb_async_fifo;

parameter width = 8;
parameter depth = 16;

reg wr_clk;
reg wr_rst_n;
reg wr_en;
reg [width-1:0] wr_data;
reg rd_clk;
reg rd_rst_n;
reg rd_en;
wire [width-1:0] rd_data;
wire full;
wire empty;

// 实例化
async_fifo #(
    .width(width), 
    .depth(depth)
) u1(
    .wr_clk(wr_clk), 
    .wr_rst_n(wr_rst_n), 
    .wr_en(wr_en), 
    .wr_data(wr_data), 
    .rd_clk(rd_clk), 
    .rd_rst_n(rd_rst_n), 
    .rd_en(rd_en), 
    .rd_data(rd_data), 
    .full(full), 
    .empty(empty)
);

initial begin
    wr_clk = 1'b0;
    forever #5 wr_clk = ~wr_clk;  // 写时钟周期10ns
end

initial begin
    rd_clk = 1'b0;
    forever #10 rd_clk = ~rd_clk;  // 读时钟周期20ns，不同于写时钟
end

initial begin
    $dumpfile("tb_async_fifo.vcd");
    $dumpvars(0, tb_async_fifo);
end

initial begin
    $monitor("Time = %0t ns, wr_rst_n = %b, rd_rst_n = %b, wr_en = %b, rd_en = %b, wr_data = %d, rd_data = %d, full = %b, empty = %b, wptr_bin = %d, rptr_bin = %d", 
    $time, wr_rst_n, rd_rst_n, wr_en, rd_en, wr_data, rd_data, full, empty, u1.wptr_bin, u1.rptr_bin);
end

integer i;
initial begin
    // 初始化
    wr_rst_n = 1'b0;
    rd_rst_n = 1'b0;
    wr_en = 1'b0;
    wr_data = {width{1'b0}};
    rd_en = 1'b0;
    #20;

    wr_rst_n = 1'b1;
    rd_rst_n = 1'b1;
    #10;

    // 场景1：连续写入16个数据，测试满状态
    $display("=== 场景1: 连续写入16个数据 ===");
    for (i = 0; i < depth; i = i + 1)
    begin
        @(posedge wr_clk);
        wr_en = 1'b1;
        wr_data = wr_data + 1'b1;  // 每次写入递增的数据
    end
    @(posedge wr_clk);
    wr_en = 1'b0;
    #20;

    if (full)
    begin
        $display("fifo为满状态");
    end

    // 场景2：连续读取16个数据，测试空状态
    $display("=== 场景2: 连续读取16个数据 ===");
    for (i = 0; i < depth; i = i + 1)
    begin
        @(posedge rd_clk);
        rd_en = 1'b1;
    end
    @(posedge rd_clk);
    rd_en = 1'b0;
    #20;

    if (empty)
    begin
        $display("fifo为空状态");
    end

    // 场景3：同时读写 写快读慢
    $display("=== 场景3: 同时读写，写快读慢 ===");
    // 写入16个数据
    for (i = 0; i < depth; i = i + 1)
    begin
        @(posedge wr_clk);
        wr_en = 1'b1;
        wr_data = wr_data + 1'b1;
    end
    @(posedge wr_clk);
    wr_en = 1'b0;

    // 读出16个数据
    for (i = 0; i < depth; i = i + 1)
    begin
        @(posedge rd_clk);
        rd_en = 1'b1;
    end
    @(posedge rd_clk);
    rd_en = 1'b0;

    #20;

    // 场景4：满写测试
    $display("=== 场景4: 满写测试 ===");
    // 写入16个数据使fifo满
    for (i = 0; i < depth; i = i + 1)
    begin
        @(posedge wr_clk);
        wr_en = 1'b1;
        wr_data = wr_data + 1'b1;
    end
    @(posedge wr_clk);
    wr_en = 1'b0;
    #20;

    // 尝试写入数据，写操作无效
    @(posedge wr_clk);
    wr_en = 1'b1;
    wr_data = wr_data + 1'b1;
    @(posedge wr_clk);
    wr_en = 1'b0;
    #20;

    // 场景5：空读测试
    $display("=== 场景5: 空读测试 ===");
    // 读出16个数据使fifo空
    for (i = 0; i < depth; i = i + 1)
    begin
        @(posedge rd_clk);
        rd_en = 1'b1;
    end
    @(posedge rd_clk);
    rd_en = 1'b0;
    #20;

    // 尝试读取数据，读操作无效
    @(posedge rd_clk);
    rd_en = 1'b1;
    @(posedge rd_clk);
    rd_en = 1'b0;
    #20;

    $display("=== 所有测试完成，仿真结束 ===");
    $finish;

end

endmodule