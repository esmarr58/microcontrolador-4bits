module alu4 (
    input  [3:0] a,
    input  [3:0] b,
    input  [2:0] op,
    output reg [3:0] y,
    output reg carry,
    output reg zero
);

always @(*) begin
    y     = 4'b0000;
    carry = 1'b0;

    case (op)
        3'b000: {carry, y} = a + b;   // ADD
        3'b001: {carry, y} = a - b;   // SUB
        3'b010: y = a & b;            // AND
        3'b011: y = a | b;            // OR
        3'b100: y = a ^ b;            // XOR
        3'b101: y = ~a;               // NOT
        3'b110: y = b;                // PASS B
        3'b111: y = 4'b0000;          // reservado
        default: y = 4'b0000;
    endcase

    zero = (y == 4'b0000);
end

endmodule
