module cpu4 (
    input clk,
    input rst,
    input [3:0] in_data,
    output [3:0] out_data,
    output halt
);

    // -----------------------------
    // Señales internas
    // -----------------------------
    wire [3:0] pc_addr;
    wire [7:0] rom_instr;
    wire [7:0] ir_instr;

    wire [3:0] opcode;
    wire [3:0] operand;

    wire ir_load;
    wire pc_inc;
    wire pc_load;
    wire a_load;
    wire out_load;
    wire mem_we;
    wire [2:0] alu_op;
    wire [1:0] src_sel;

    wire [3:0] acc;
    wire zero;
    wire carry;
    wire [3:0] alu_y;

    wire [3:0] ram_dout;
    reg  [3:0] out_reg;

    // -----------------------------
    // Program Counter
    // -----------------------------
    pc4 pc0 (
        .clk(clk),
        .rst(rst),
        .inc(pc_inc),
        .load(pc_load),
        .din(operand),     // para JMP y JZ
        .pc(pc_addr)
    );

    // -----------------------------
    // ROM de programa
    // -----------------------------
    rom_prog rom0 (
        .addr(pc_addr),
        .instr(rom_instr)
    );

    // -----------------------------
    // Instruction Register
    // -----------------------------
    ir ir0 (
        .clk(clk),
        .rst(rst),
        .load(ir_load),
        .d(rom_instr),
        .q(ir_instr)
    );

    // -----------------------------
    // Decoder
    // -----------------------------
    decoder dec0 (
        .instr(ir_instr),
        .opcode(opcode),
        .operand(operand)
    );

    // -----------------------------
    // Control Unit
    // -----------------------------
    control_unit cu0 (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .zero(zero),

        .ir_load(ir_load),
        .pc_inc(pc_inc),
        .pc_load(pc_load),
        .a_load(a_load),
        .out_load(out_load),
        .mem_we(mem_we),
        .halt(halt),
        .alu_op(alu_op),
        .src_sel(src_sel)
    );

    // -----------------------------
    // RAM de datos
    // -----------------------------
    ram_data ram0 (
        .clk(clk),
        .we(mem_we),
        .addr(operand),
        .din(acc),
        .dout(ram_dout)
    );

    // -----------------------------
    // Datapath
    // -----------------------------
    datapath dp0 (
        .clk(clk),
        .rst(rst),
        .a_load(a_load),
        .alu_op(alu_op),
        .operand(operand),
        .ram_data(ram_dout),
        .in_data(in_data),
        .src_sel(src_sel),
        .acc(acc),
        .zero(zero),
        .carry(carry),
        .alu_y(alu_y)
    );

    // -----------------------------
    // Registro de salida
    // -----------------------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            out_reg <= 4'b0000;
        else if (out_load)
            out_reg <= acc;
    end

    assign out_data = out_reg;

endmodule
