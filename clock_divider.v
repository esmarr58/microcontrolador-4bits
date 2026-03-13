module clock_divider (
    input  clk_in,
    input  rst,
    output reg clk_out
);

    reg [24:0] counter;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 25'd0;
            clk_out <= 1'b0;
        end else begin
            counter <= counter + 1'b1;
            clk_out <= counter[24];
        end
    end

endmodule
