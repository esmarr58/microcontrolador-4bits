module top_de10lite_debug(

    input CLOCK_50,
    input [9:0] SW,
    input [1:0] KEY,

    output [9:0] LEDR,

    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3
);

wire rst;
assign rst = ~KEY[0];

wire slow_clk;
wire step_clk;

clock_divider div0(
    .clk_in(CLOCK_50),
    .rst(rst),
    .clk_out(slow_clk)
);

step_clock step0(
    .clk(CLOCK_50),
    .rst(rst),
    .step_btn(~KEY[1]),
    .step_clk(step_clk)
);

// selección reloj
wire cpu_clk;
assign cpu_clk = SW[9] ? step_clk : slow_clk;

// señales del cpu
wire [3:0] cpu_out;
wire halt;

cpu4 cpu0(
    .clk(cpu_clk),
    .rst(rst),
    .in_data(SW[3:0]),
    .out_data(cpu_out),
    .halt(halt)
);

// debug interno
wire [3:0] debug_bus;

debug_mux dmux(
    .sel(SW[2:0]),
    .pc(cpu_out),
    .acc(cpu_out),
    .opcode(cpu_out),
    .operand(cpu_out),
    .alu(cpu_out),
    .ram(cpu_out),
    .out(debug_bus)
);

// displays
hex7seg h0(.bin(debug_bus), .seg(HEX0));
hex7seg h1(.bin(cpu_out), .seg(HEX1));
hex7seg h2(.bin(SW[3:0]), .seg(HEX2));
hex7seg h3(.bin({3'b000,halt}), .seg(HEX3));

// leds
assign LEDR[3:0] = cpu_out;
assign LEDR[4]   = halt;
assign LEDR[9:5] = 0;

endmodule
