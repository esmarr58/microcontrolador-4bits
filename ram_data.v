module ram_data (
    input clk,
    input we,              // write enable
    input [3:0] addr,      // dirección
    input [3:0] din,       // dato de entrada
    output reg [3:0] dout  // dato de salida
);

    // memoria de 16 palabras de 4 bits
    reg [3:0] mem [15:0];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;   // escritura
        dout <= mem[addr];      // lectura
    end

endmodule
