module top_de10lite (
    input         CLOCK_50,
    input  [9:0]  SW,
    input  [1:0]  KEY,
    output [9:0]  LEDR
);

    wire [3:0] cpu_out;
    wire       cpu_halt;
    wire       rst;

    // En la DE10-Lite los botones KEY suelen ser activos en bajo
    assign rst = ~KEY[0];

    // Instancia del procesador
    cpu4 cpu0 (
        .clk(CLOCK_50),
        .rst(rst),
        .in_data(SW[3:0]),
        .out_data(cpu_out),
        .halt(cpu_halt)
    );

    // Salidas a LEDs
    assign LEDR[3:0] = cpu_out;     // salida del procesador
    assign LEDR[4]   = cpu_halt;    // indicador de halt
    assign LEDR[9:5] = 5'b00000;

endmodule
