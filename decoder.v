module decoder (
    input  [7:0] instr,      // instrucción completa
    output [3:0] opcode,     // código de operación
    output [3:0] operand     // operando o dirección
);

assign opcode  = instr[7:4];
assign operand = instr[3:0];

endmodule
