`timescale 1ns / 1ps

module Elevator_Controller_TB;
    reg clk;
    reg reset;
    reg g_f, f_f, s_f;
    wire [2:0] LED;
    wire [6:0] seg;
    wire [7:0] an;
    
    // Instantiate the top module
    Elevator_Controller_Top uut(
        .clk(clk),
        .reset(reset),
        .g_f(g_f),
        .f_f(f_f),
        .s_f(s_f),
        .LED(LED),
        .seg(seg),
        .an(an)
    );
    
    // Clock generation (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Initialize
        reset = 1;
        g_f = 0; f_f = 0; s_f = 0;
        #20;
        
        reset = 0;
        #100;
        
        // Test 1: Press B1 (go to floor 1)
        $display("Test 1: Ground to First Floor");
        f_f = 1;
        #100000000;  // Wait for 1 second
        f_f = 0;
        #100000000;
        
        // Test 2: Press B2 (go to floor 2)
        $display("Test 2: First to Second Floor");
        s_f = 1;
        #100000000;
        s_f = 0;
        #100000000;
        
        // Test 3: Press B0 (go to ground)
        $display("Test 3: Second to Ground Floor");
        g_f = 1;
        #100000000;
        g_f = 0;
        #100000000;
        
        // Test 4: Press same floor (stay)
        $display("Test 4: Stay at Ground Floor");
        g_f = 1;
        #100000000;
        g_f = 0;
        #100000000;
        
        $display("All tests completed");
        $finish;
    end
    
    // Monitor outputs
    initial begin
        $monitor("Time=%0t | Reset=%b | Buttons=%b%b%b | LEDs=%b", 
                 $time, reset, s_f, f_f, g_f, LED);
    end
endmodule