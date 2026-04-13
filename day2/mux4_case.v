module mux4_case(
    input [3:0] d,
    input [1:0] sel,
    output reg y  // always 中赋值 -> reg
);

always @(*)
begin
    case (sel)
        2'b00: y = d[0];
        2'b01: y = d[1];
        2'b10: y = d[2];
        2'b11: y = d[3];
        default: y = 1'b0;
    endcase 
end

endmodule