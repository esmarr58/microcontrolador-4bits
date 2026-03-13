module alu_4bits (
    input  [3:0] A,
    input  [3:0] B,
    input  [2:0] SEL,
    output reg [3:0] Y,
    output reg CARRY,
    output reg ZERO
);

always @(*) begin
    Y     = 4'b0000;
    CARRY = 1'b0;

    case (SEL)
        3'b000: {CARRY, Y} = A + B;   // Suma
        3'b001: {CARRY, Y} = A - B;   // Resta
        3'b010: Y = A & B;            // AND
        3'b011: Y = A | B;            // OR
        3'b100: Y = A ^ B;            // XOR
        3'b101: Y = ~A;               // NOT A

        3'b110: begin                 // Shift left
            CARRY = A[3];
            Y = A << 1;
        end

        3'b111: begin                 // Shift right
            CARRY = A[0];
            Y = A >> 1;
        end
    endcase

    ZERO = (Y == 4'b0000);
end

endmodule
