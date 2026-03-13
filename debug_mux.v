module debug_mux(
    input  [2:0] sel,

    input [3:0] pc,
    input [3:0] acc,
    input [3:0] opcode,
    input [3:0] operand,
    input [3:0] alu,
    input [3:0] ram,

    output reg [3:0] out
);

always @(*) begin
    case(sel)
        3'b000: out = pc;
        3'b001: out = acc;
        3'b010: out = opcode;
        3'b011: out = operand;
        3'b100: out = alu;
        3'b101: out = ram;
        default: out = 4'b0000;
    endcase
end

endmodule
