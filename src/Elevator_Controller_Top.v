module Elevator_Controller_Top(
    input clk,          // 100MHz FPGA clock
    input reset,
    input g_f,          // Button B0
    input f_f,          // Button B1
    input s_f,          // Button B2
    output [2:0] LED,   // LEDs
    output [6:0] seg,   // 7-segment segments
    output [7:0] an     // 7-segment anodes
);
    wire clk_1Hz;
    wire [1:0] c_f, n_f;
    wire g_LED, f_LED, s_LED;
    
    assign LED = {s_LED, f_LED, g_LED};
    
    // Clock divider
    Cntr_Unit clock_div(
        .clk(clk),
        .reset(reset),
        .clk_1Hz(clk_1Hz)
    );
    
    // FSM
    FSM_Vending_Unit fsm(
        .clk(clk_1Hz),
        .reset(reset),
        .g_f(g_f),
        .f_f(f_f),
        .s_f(s_f),
        .c_f(c_f),
        .n_f(n_f),
        .g_LED(g_LED),
        .f_LED(f_LED),
        .s_LED(s_LED)
    );
    
    // Display unit
    Disp_Unit display(
        .clk(clk),
        .c_f(c_f),
        .n_f(n_f),
        .seg(seg),
        .an(an)
    );
endmodule