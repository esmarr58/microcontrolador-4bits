module ir (
    input clk,
    input rst,
    input load,
    input [7:0] d,
    output reg [7:0] q,
    output [3:0] opcode,
    output [3:0] operand
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 8'b0000_0000;
    else if (load)
        q <= d;
end

assign opcode  = q[7:4];
assign operand = q[3:0];

endmodule
