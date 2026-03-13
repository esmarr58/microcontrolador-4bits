module datapath (
    input clk,
    input rst,

    input a_load,
    input [2:0] alu_op,

    input [3:0] operand,     // inmediato o dirección
    input [3:0] ram_data,    // dato leído de RAM
    input [3:0] in_data,     // dato de entrada externa
    input [1:0] src_sel,     // selecciona la fuente para B

    output [3:0] acc,        // acumulador
    output zero,
    output carry,
    output [3:0] alu_y
);

    wire [3:0] a_q;
    wire [3:0] mux_b_out;
    wire [3:0] alu_out;
    wire alu_zero_unused;

    // Selección de fuente para la entrada B de la ALU
    // src_sel:
    // 00 -> operand
    // 01 -> ram_data
    // 10 -> in_data
    // 11 -> 0000
    assign mux_b_out =
        (src_sel == 2'b00) ? operand  :
        (src_sel == 2'b01) ? ram_data :
        (src_sel == 2'b10) ? in_data  :
                             4'b0000;

    // Acumulador A
    reg4 regA (
        .clk(clk),
        .rst(rst),
        .load(a_load),
        .d(alu_out),
        .q(a_q)
    );

    // ALU
    alu4 alu0 (
        .a(a_q),
        .b(mux_b_out),
        .op(alu_op),
        .y(alu_out),
        .carry(carry),
        .zero(alu_zero_unused)
    );

    assign acc   = a_q;
    assign alu_y = alu_out;

    // Flag zero basada en el acumulador
    assign zero = (a_q == 4'b0000);

endmodule
