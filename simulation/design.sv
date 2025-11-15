`timescale 1ns / 1ps

// Module 1: Clock Divider (SIMPLIFIED FOR SIMULATION)
module Cntr_Unit(
    input clk,
    input reset,
    output reg clk_1Hz
);
    reg [3:0] counter;  // Changed from [26:0] to [3:0] for faster simulation
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_1Hz <= 0;
        end
        else if (counter == 10-1) begin  // Changed from 50000000 to 10
            counter <= 0;
            clk_1Hz <= ~clk_1Hz;
        end
        else
            counter <= counter + 1;
    end
endmodule

// Module 2: FSM
module FSM_Vending_Unit(
    input clk,
    input reset,
    input g_f,
    input f_f,
    input s_f,
    output reg [1:0] c_f,
    output reg [1:0] n_f,
    output reg g_LED,
    output reg f_LED,
    output reg s_LED
);
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    
    reg [1:0] current_state, next_state;
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end
    
    always @(*) begin
        case (current_state)
            S0: begin
                if (g_f) next_state = S0;
                else if (f_f) next_state = S1;
                else if (s_f) next_state = S2;
                else next_state = S0;
            end
            
            S1: begin
                if (g_f) next_state = S0;
                else if (f_f) next_state = S1;
                else if (s_f) next_state = S2;
                else next_state = S1;
            end
            
            S2: begin
                if (g_f) next_state = S0;
                else if (f_f) next_state = S1;
                else if (s_f) next_state = S2;
                else next_state = S2;
            end
            
            default: next_state = S0;
        endcase
    end
    
    always @(*) begin
        c_f = current_state;
        
        if (g_f) begin
            n_f = 2'b00;
            g_LED = 1; f_LED = 0; s_LED = 0;
        end
        else if (f_f) begin
            n_f = 2'b01;
            g_LED = 0; f_LED = 1; s_LED = 0;
        end
        else if (s_f) begin
            n_f = 2'b10;
            g_LED = 0; f_LED = 0; s_LED = 1;
        end
        else begin
            n_f = current_state;
            g_LED = 0; f_LED = 0; s_LED = 0;
        end
    end
endmodule

// Module 3: Display Unit
module Disp_Unit(
    input clk,
    input [1:0] c_f,
    input [1:0] n_f,
    output reg [6:0] seg,
    output reg [7:0] an
);
    reg [16:0] refresh_counter;
    wire [1:0] display_select;
    reg [3:0] digit;
    
    assign display_select = refresh_counter[16:15];
    
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end
    
    always @(*) begin
        case (display_select)
            2'b00: an = 8'b11111110;
            2'b01: an = 8'b11111101;
            default: an = 8'b11111111;
        endcase
    end
    
    always @(*) begin
        case (display_select)
            2'b00: digit = {2'b00, c_f};
            2'b01: digit = {2'b00, n_f};
            default: digit = 4'b0000;
        endcase
    end
    
    always @(*) begin
        case (digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            default: seg = 7'b1111111;
        endcase
    end
endmodule

// Module 4: Top Module
module Elevator_Controller_Top(
    input clk,
    input reset,
    input g_f,
    input f_f,
    input s_f,
    output [2:0] LED,
    output [6:0] seg,
    output [7:0] an
);
    wire clk_1Hz;
    wire [1:0] c_f, n_f;
    wire g_LED, f_LED, s_LED;
    
    assign LED = {s_LED, f_LED, g_LED};
    
    Cntr_Unit clock_div(
        .clk(clk),
        .reset(reset),
        .clk_1Hz(clk_1Hz)
    );
    
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
    
    Disp_Unit display(
        .clk(clk),
        .c_f(c_f),
        .n_f(n_f),
        .seg(seg),
        .an(an)
    );
endmodule