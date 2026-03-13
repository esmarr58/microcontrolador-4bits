module top_de10lite (
    input         CLOCK_50,
    input  [9:0]  SW,
    input  [1:0]  KEY,
    output [9:0]  LEDR
);

    wire [3:0] cpu_out;
    wire       cpu_halt;
    wire       rst;
    wire       slow_clk;

    // KEY[0] activo en bajo
    assign rst = ~KEY[0];

    // Divisor de reloj para ver el funcionamiento en LEDs
    clock_divider div0 (
        .clk_in(CLOCK_50),
        .rst(rst),
        .clk_out(slow_clk)
    );

    // Instancia del procesador
    cpu4 cpu0 (
        .clk(slow_clk),
        .rst(rst),
        .in_data(SW[3:0]),
        .out_data(cpu_out),
        .halt(cpu_halt)
    );

    // Salidas a LEDs
    assign LEDR[3:0] = cpu_out;
    assign LEDR[4]   = cpu_halt;
    assign LEDR[9:5] = 5'b00000;

endmodule
