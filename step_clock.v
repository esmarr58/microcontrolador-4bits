module step_clock(
    input clk,
    input rst,
    input step_btn,
    output reg step_clk
);

reg btn_d;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        btn_d <= 0;
        step_clk <= 0;
    end
    else begin
        btn_d <= step_btn;
        step_clk <= step_btn & ~btn_d;
    end
end

endmodule
