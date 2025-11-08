module Cntr_Unit(
    input clk,        // 100MHz input clock
    input reset,
    output reg clk_1Hz
);
    reg [26:0] counter;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_1Hz <= 0;
        end
        else if (counter == 50000000-1) begin  // 100MHz / 2 = 50M for toggle
            counter <= 0;
            clk_1Hz <= ~clk_1Hz;
        end
        else
            counter <= counter + 1;
    end
endmodule