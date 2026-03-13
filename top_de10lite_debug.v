module top_de10lite_debug (
    input         CLOCK_50,
    input  [9:0]  SW,
    input  [1:0]  KEY,
    output [9:0]  LEDR,
    output [6:0]  HEX0,
    output [6:0]  HEX1,
    output [6:0]  HEX2,
    output [6:0]  HEX3,
    output [6:0]  HEX4,
    output [6:0]  HEX5
);

    wire rst;
    wire slow_clk;
    wire step_clk;
    wire cpu_clk;

    wire [3:0] out_data;
    wire halt;

    wire [3:0] dbg_pc;
    wire [7:0] dbg_rom_instr;
    wire [7:0] dbg_ir_instr;
    wire [3:0] dbg_opcode;
    wire [3:0] dbg_operand;
    wire [3:0] dbg_acc;
    wire [3:0] dbg_alu_y;
    wire [3:0] dbg_ram_dout;
    wire dbg_zero;
    wire dbg_carry;
    wire [1:0] dbg_src_sel;
    wire [2:0] dbg_alu_op;
    wire [1:0] dbg_state;
    wire dbg_ir_load;
    wire dbg_pc_inc;
    wire dbg_pc_load;
    wire dbg_a_load;
    wire dbg_mem_we;
    wire dbg_out_load;

    assign rst = ~KEY[0];

    clock_divider div0 (
        .clk_in(CLOCK_50),
        .rst(rst),
        .clk_out(slow_clk)
    );

    step_clock step0 (
        .clk(CLOCK_50),
        .rst(rst),
        .step_btn(~KEY[1]),
        .step_clk(step_clk)
    );

    // SW[9] = 0 -> reloj lento
    // SW[9] = 1 -> paso a paso
    assign cpu_clk = (SW[9]) ? step_clk : slow_clk;

    cpu4 cpu0 (
        .clk(cpu_clk),
        .rst(rst),
        .in_data(SW[3:0]),
        .out_data(out_data),
        .halt(halt),

        .dbg_pc(dbg_pc),
        .dbg_rom_instr(dbg_rom_instr),
        .dbg_ir_instr(dbg_ir_instr),
        .dbg_opcode(dbg_opcode),
        .dbg_operand(dbg_operand),
        .dbg_acc(dbg_acc),
        .dbg_alu_y(dbg_alu_y),
        .dbg_ram_dout(dbg_ram_dout),
        .dbg_zero(dbg_zero),
        .dbg_carry(dbg_carry),
        .dbg_src_sel(dbg_src_sel),
        .dbg_alu_op(dbg_alu_op),
        .dbg_state(dbg_state),
        .dbg_ir_load(dbg_ir_load),
        .dbg_pc_inc(dbg_pc_inc),
        .dbg_pc_load(dbg_pc_load),
        .dbg_a_load(dbg_a_load),
        .dbg_mem_we(dbg_mem_we),
        .dbg_out_load(dbg_out_load)
    );

    // Displays de 7 segmentos
    // HEX0 -> ACC
    // HEX1 -> PC
    // HEX2 -> opcode
    // HEX3 -> operand
    // HEX4 -> ALU result
    // HEX5 -> state
    hex7seg h0 (.bin(dbg_acc),              .seg(HEX0));
    hex7seg h1 (.bin(dbg_pc),               .seg(HEX1));
    hex7seg h2 (.bin(dbg_opcode),           .seg(HEX2));
    hex7seg h3 (.bin(dbg_operand),          .seg(HEX3));
    hex7seg h4 (.bin(dbg_alu_y),            .seg(HEX4));
    hex7seg h5 (.bin({2'b00, dbg_state}),   .seg(HEX5));

    // LEDs
    assign LEDR[3:0] = out_data;
    assign LEDR[4]   = dbg_zero;
    assign LEDR[5]   = dbg_carry;
    assign LEDR[6]   = halt;
    assign LEDR[7]   = dbg_ir_load;
    assign LEDR[8]   = dbg_a_load;
    assign LEDR[9]   = dbg_pc_load;

endmodule
