module regA(
    input clk,
    input rst,
    input load,
    input [3:0] d,
    output [3:0] q
);

reg4 r0 (
    .clk(clk),
    .rst(rst),
    .load(load),
    .d(d),
    .q(q)
);

endmodule
