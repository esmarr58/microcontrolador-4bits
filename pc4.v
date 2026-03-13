module pc4 (
    input clk,            // reloj
    input rst,            // reset
    input inc,            // incrementar PC
    input load,           // cargar nueva dirección
    input [3:0] din,      // dirección a cargar
    output reg [3:0] pc   // salida del PC
);

always @(posedge clk or posedge rst) begin
    if (rst)
        pc <= 4'b0000;        // reset a 0
    else if (load)
        pc <= din;            // salto (JMP)
    else if (inc)
        pc <= pc + 1'b1;      // siguiente instrucción
end

endmodule
