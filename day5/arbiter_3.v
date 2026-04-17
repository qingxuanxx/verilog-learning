// 优先级规则：req[0] > req[1] > req[2]
module arbiter_3(
    input clk, 
    input rst_n, 
    input [2:0] req,  // 3路请求，req[0]优先级最高
    output reg [2:0] grant  // 3路授权，同一时刻最多1bit为1
);

// 优先级判断
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        grant <= 3'b000;
    end
    else
    begin
        if (req[0])
            grant <= 3'b001;
        else if (req[1])
            grant <= 3'b010;
        else if (req[2])
            grant <= 3'b100;
        else
            grant <= 3'b000;
    end
end

endmodule
