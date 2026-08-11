`timescale 1ns/1ns
module tb_sync_fifo;

parameter width = 8;
parameter depth = 16;

reg clk;
reg rst_n;
reg wr_en;
reg [width-1:0] wr_data;
reg rd_en;
wire [width-1:0] rd_data;
wire full;
wire empty;

//实例化
sync_fifo #(
    .width(width), 
    .depth(depth)
) u1(
    .clk(clk), 
    .rst_n(rst_n), 
    .wr_en(wr_en), 
    .wr_data(wr_data), 
    .rd_en(rd_en), 
    .rd_data(rd_data), 
    .full(full), 
    .empty(empty)
);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("tb_sync_fifo.vcd");
    $dumpvars(0, tb_sync_fifo);
end

initial begin
    $monitor("Time = %0t ns, rst_n = %b, wr_en = %b, rd_en = %b, wr_data = %d, rd_data = %d, full = %b, empty = %b, wptr = %d, rptr = %d", 
    $time, rst_n, wr_en, rd_en, wr_data, rd_data, full, empty, u1.wptr, u1.rptr);
end

integer i;
initial begin
    // 初始化
    rst_n = 1'b0;
    wr_en = 1'b0;
    wr_data = {width{1'b0}};
    rd_en = 1'b0;
    #20;
    rst_n = 1'b1;
    #10;

    // 场景1：空状态测试
    $display("=== 场景1: 空状态测试 ===");
    rd_en = 1'b1;  // 空状态尝试读，读操作无效
    #10;
    rd_en = 1'b0;
    #10;

    if (empty)
    begin
        $display("fifo为空状态");
    end
    #20;

    // 场景2：满状态测试
    $display("=== 场景2: 满状态测试 ===");
    wr_en = 1'b1;
    // 循环写入16个数据
    for (i = 0; i < 16; i = i + 1)
    begin
        wr_data = wr_data + 8'd1;
        #10;
    end
    #10;
    wr_en = 1'b0;
    #10;

    if (full)
    begin
        $display("fifo为满状态");
    end
    #20;

    // 场景3：同时读写测试（非空非满状态）
    $display("=== 场景3: 同时读写测试(非空非满状态) ===");
    // 先读出1个数据，fifo进入非空非满状态
    rd_en = 1'b1;
    #10;
    rd_en = 1'b0;

    // 同时开始读写，持续十个周期
    wr_en = 1'b1;
    rd_en = 1'b1;
    for (i = 0; i < 10; i = i + 1)
    begin
        wr_data = wr_data + 8'd1;
        #10;
    end
    wr_en = 1'b0;
    rd_en = 1'b0;
    #10;
    $display("同时读写测试完成");
    #20;

    // 场景4：随机读写测试
    $display("=== 场景4: 随机读写测试 ===");
    // 随机生成读写使能，持续50个周期
    for (i = 0; i < 50; i = i + 1)
    begin
        wr_en = ($random % 2) && (!full);  // 只有没满，才允许写
        rd_en = ($random % 2) && (!empty);  // 只有非空，才允许读
        wr_data = $random % (1 << width);
        #10;
        // if (full) wr_en = 1'b0;
        // else if (empty) rd_en = 1'b0;
    end

    wr_en = 1'b0;
    rd_en = 1'b0;
    #10;
    $display("随机读写测试完成");
    #20;

    // 最后清空fifo
    rd_en = 1'b1;
    while (!empty) // 只要fifo非空，就一直读
    begin
        #10;
    end
    rd_en = 1'b0;
    #10;

    if (empty)
    begin
        $display("fifo为空状态");
    end

    $display("=== 所有测试完成，仿真结束 ===");
    $finish;
end

endmodule
