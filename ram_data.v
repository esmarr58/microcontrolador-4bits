module ram_data (
    input clk,
    input we,
    input [3:0] addr,
    input [3:0] din,
    output [3:0] dout
);

    reg [3:0] mem [15:0];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;
    end

    assign dout = mem[addr];

endmodule
