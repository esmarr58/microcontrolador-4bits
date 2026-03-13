module cpu4 (
    input clk,
    input rst,
    input [3:0] in_data,

    output [3:0] out_data,
    output halt,

    // Debug
    output [3:0] dbg_pc,
    output [7:0] dbg_rom_instr,
    output [7:0] dbg_ir_instr,
    output [3:0] dbg_opcode,
    output [3:0] dbg_operand,
    output [3:0] dbg_acc,
    output [3:0] dbg_alu_y,
    output [3:0] dbg_ram_dout,
    output dbg_zero,
    output dbg_carry,
    output [1:0] dbg_src_sel,
    output [2:0] dbg_alu_op,
    output [1:0] dbg_state,
    output dbg_ir_load,
    output dbg_pc_inc,
    output dbg_pc_load,
    output dbg_a_load,
    output dbg_mem_we,
    output dbg_out_load
);

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
    wire [1:0] state_dbg;

    wire [3:0] acc;
    wire zero;
    wire carry;
    wire [3:0] alu_y;

    wire [3:0] ram_dout;
    reg  [3:0] out_reg;

    pc4 pc0 (
        .clk(clk),
        .rst(rst),
        .inc(pc_inc),
        .load(pc_load),
        .din(operand),
        .pc(pc_addr)
    );

    rom_prog rom0 (
        .addr(pc_addr),
        .instr(rom_instr)
    );

    ir ir0 (
        .clk(clk),
        .rst(rst),
        .load(ir_load),
        .d(rom_instr),
        .q(ir_instr)
    );

    decoder dec0 (
        .instr(ir_instr),
        .opcode(opcode),
        .operand(operand)
    );

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
        .src_sel(src_sel),
        .state_dbg(state_dbg)
    );

    ram_data ram0 (
        .clk(clk),
        .we(mem_we),
        .addr(operand),
        .din(acc),
        .dout(ram_dout)
    );

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

    always @(posedge clk or posedge rst) begin
        if (rst)
            out_reg <= 4'b0000;
        else if (out_load)
            out_reg <= acc;
    end

    assign out_data = out_reg;

    // Debug outputs
    assign dbg_pc       = pc_addr;
    assign dbg_rom_instr = rom_instr;
    assign dbg_ir_instr  = ir_instr;
    assign dbg_opcode   = opcode;
    assign dbg_operand  = operand;
    assign dbg_acc      = acc;
    assign dbg_alu_y    = alu_y;
    assign dbg_ram_dout = ram_dout;
    assign dbg_zero     = zero;
    assign dbg_carry    = carry;
    assign dbg_src_sel  = src_sel;
    assign dbg_alu_op   = alu_op;
    assign dbg_state    = state_dbg;
    assign dbg_ir_load  = ir_load;
    assign dbg_pc_inc   = pc_inc;
    assign dbg_pc_load  = pc_load;
    assign dbg_a_load   = a_load;
    assign dbg_mem_we   = mem_we;
    assign dbg_out_load = out_load;

endmodule
