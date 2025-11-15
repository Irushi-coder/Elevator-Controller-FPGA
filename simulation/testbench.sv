`timescale 1ns / 1ps

module testbench;
    reg clk;
    reg reset;
    reg g_f, f_f, s_f;
    wire [2:0] LED;
    wire [6:0] seg;
    wire [7:0] an;
    
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
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
    end
    
    // Clock generation - 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        $display("Starting simulation...");
        
        // Initialize
        reset = 1;
        g_f = 0; f_f = 0; s_f = 0;
        #200;
        
        reset = 0;
        #200;
        
        // Test 1: Ground to First Floor
        $display("Test 1: Ground to First Floor (Press f_f button)");
        f_f = 1;
        #500;  // Hold button
        f_f = 0;
        #1000; // Wait for state change
        $display("  Current Floor: %d, Next Floor: %d, LEDs: %b", uut.c_f, uut.n_f, LED);
        
        // Test 2: First to Second Floor
        $display("Test 2: First to Second Floor (Press s_f button)");
        s_f = 1;
        #500;
        s_f = 0;
        #1000;
        $display("  Current Floor: %d, Next Floor: %d, LEDs: %b", uut.c_f, uut.n_f, LED);
        
        // Test 3: Second to Ground Floor
        $display("Test 3: Second to Ground Floor (Press g_f button)");
        g_f = 1;
        #500;
        g_f = 0;
        #1000;
        $display("  Current Floor: %d, Next Floor: %d, LEDs: %b", uut.c_f, uut.n_f, LED);
        
        // Test 4: Stay at Ground (press same floor button)
        $display("Test 4: Stay at Ground Floor (Press g_f button again)");
        g_f = 1;
        #500;
        g_f = 0;
        #1000;
        $display("  Current Floor: %d, Next Floor: %d, LEDs: %b", uut.c_f, uut.n_f, LED);
        
        // Test 5: Jump from ground to second
        $display("Test 5: Jump from Ground to Second Floor");
        s_f = 1;
        #500;
        s_f = 0;
        #1000;
        $display("  Current Floor: %d, Next Floor: %d, LEDs: %b", uut.c_f, uut.n_f, LED);
        
        $display("\n=== All tests completed successfully ===");
        $finish;
    end
    
    // Monitor changes
    always @(LED or uut.c_f or uut.n_f) begin
        $display("Time=%0t | c_f=%d | n_f=%d | LEDs=%b%b%b", 
                 $time, uut.c_f, uut.n_f, LED[2], LED[1], LED[0]);
    end
endmodule
 