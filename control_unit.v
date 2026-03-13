module control_unit (
    input clk,
    input rst,
    input [3:0] opcode,
    input zero,

    output reg ir_load,
    output reg pc_inc,
    output reg pc_load,
    output reg a_load,
    output reg out_load,
    output reg mem_we,
    output reg halt,
    output reg [2:0] alu_op,
    output reg [1:0] src_sel
);

    // Estados
    reg [1:0] state;

    localparam FETCH   = 2'b00;
    localparam DECODE  = 2'b01;
    localparam EXECUTE = 2'b10;
    localparam HALT_ST = 2'b11;

    // Opcodes
    localparam NOP  = 4'b0000;
    localparam LDI  = 4'b0001;
    localparam ADD  = 4'b0010;
    localparam SUB  = 4'b0011;
    localparam ANDD = 4'b0100;
    localparam ORR  = 4'b0101;
    localparam XORR = 4'b0110;
    localparam NOTT = 4'b0111;
    localparam STA  = 4'b1000;
    localparam LDA  = 4'b1001;
    localparam JMP  = 4'b1010;
    localparam JZ   = 4'b1011;
    localparam OUT  = 4'b1100;
    localparam INN  = 4'b1101;
    localparam HLT  = 4'b1110;

    // ALU ops
    localparam ALU_ADD  = 3'b000;
    localparam ALU_SUB  = 3'b001;
    localparam ALU_AND  = 3'b010;
    localparam ALU_OR   = 3'b011;
    localparam ALU_XOR  = 3'b100;
    localparam ALU_NOT  = 3'b101;
    localparam ALU_PASS = 3'b110;

    // src_sel
    localparam SRC_IMM = 2'b00;   // operand
    localparam SRC_RAM = 2'b01;   // dato de RAM
    localparam SRC_IN  = 2'b10;   // entrada externa
    localparam SRC_0   = 2'b11;   // cero

    // Registro de estado
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= FETCH;
        else begin
            case (state)
                FETCH:   state <= DECODE;
                DECODE:  state <= EXECUTE;
                EXECUTE: begin
                    if (opcode == HLT)
                        state <= HALT_ST;
                    else
                        state <= FETCH;
                end
                HALT_ST: state <= HALT_ST;
                default: state <= FETCH;
            endcase
        end
    end

    // Lógica de control
    always @(*) begin
        // valores por defecto
        ir_load  = 1'b0;
        pc_inc   = 1'b0;
        pc_load  = 1'b0;
        a_load   = 1'b0;
        out_load = 1'b0;
        mem_we   = 1'b0;
        halt     = 1'b0;
        alu_op   = ALU_PASS;
        src_sel  = SRC_IMM;

        case (state)
            FETCH: begin
                ir_load = 1'b1;
                pc_inc  = 1'b1;
            end

            DECODE: begin
            end

            EXECUTE: begin
                case (opcode)
                    NOP: begin
                    end

                    LDI: begin
                        src_sel = SRC_IMM;
                        alu_op  = ALU_PASS;
                        a_load  = 1'b1;
                    end

                    ADD: begin
                        src_sel = SRC_IMM;
                        alu_op  = ALU_ADD;
                        a_load  = 1'b1;
                    end

                    SUB: begin
                        src_sel = SRC_IMM;
                        alu_op  = ALU_SUB;
                        a_load  = 1'b1;
                    end

                    ANDD: begin
                        src_sel = SRC_IMM;
                        alu_op  = ALU_AND;
                        a_load  = 1'b1;
                    end

                    ORR: begin
                        src_sel = SRC_IMM;
                        alu_op  = ALU_OR;
                        a_load  = 1'b1;
                    end

                    XORR: begin
                        src_sel = SRC_IMM;
                        alu_op  = ALU_XOR;
                        a_load  = 1'b1;
                    end

                    NOTT: begin
                        src_sel = SRC_0;
                        alu_op  = ALU_NOT;
                        a_load  = 1'b1;
                    end

                    STA: begin
                        mem_we = 1'b1;
                    end

                    LDA: begin
                        src_sel = SRC_RAM;
                        alu_op  = ALU_PASS;
                        a_load  = 1'b1;
                    end

                    JMP: begin
                        pc_load = 1'b1;
                    end

                    JZ: begin
                        if (zero)
                            pc_load = 1'b1;
                    end

                    OUT: begin
                        out_load = 1'b1;
                    end

                    INN: begin
                        src_sel = SRC_IN;
                        alu_op  = ALU_PASS;
                        a_load  = 1'b1;
                    end

                    HLT: begin
                        halt = 1'b1;
                    end

                    default: begin
                    end
                endcase
            end

            HALT_ST: begin
                halt = 1'b1;
            end
        endcase
    end

endmodule
