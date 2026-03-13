module rom_prog (
    input  [3:0] addr,
    output reg [7:0] instr
);

always @(*) begin
    case (addr)
        4'b0000: instr = 8'b0001_0011; // LDI 3   -> A = 3
        4'b0001: instr = 8'b0010_0001; // ADD 1   -> A = 4
        4'b0010: instr = 8'b0011_0100; // SUB 4   -> A = 0
        4'b0011: instr = 8'b1011_0110; // JZ 6    -> si A==0 salta a 6
        4'b0100: instr = 8'b0001_1111; // LDI 15  -> no debería ejecutarse si JZ funciona
        4'b0101: instr = 8'b1010_0111; // JMP 7
        4'b0110: instr = 8'b1100_0000; // OUT     -> saca A a LEDs
        4'b0111: instr = 8'b1110_0000; // HLT     -> detener CPU

        4'b1000: instr = 8'b0000_0000; // NOP
        4'b1001: instr = 8'b0000_0000; // NOP
        4'b1010: instr = 8'b0000_0000; // NOP
        4'b1011: instr = 8'b0000_0000; // NOP
        4'b1100: instr = 8'b0000_0000; // NOP
        4'b1101: instr = 8'b0000_0000; // NOP
        4'b1110: instr = 8'b0000_0000; // NOP
        4'b1111: instr = 8'b0000_0000; // NOP

        default: instr = 8'b0000_0000; // NOP
    endcase
end

endmodule
