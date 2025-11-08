module FSM_Vending_Unit(
    input clk,
    input reset,
    input g_f,  // B0 - Ground floor button
    input f_f,  // B1 - First floor button
    input s_f,  // B2 - Second floor button
    output reg [1:0] c_f,  // Current floor
    output reg [1:0] n_f,  // Next floor
    output reg g_LED,       // Ground LED
    output reg f_LED,       // First LED
    output reg s_LED        // Second LED
);
    // State encoding
    parameter S0 = 2'b00;  // Ground floor
    parameter S1 = 2'b01;  // First floor
    parameter S2 = 2'b10;  // Second floor
    
    reg [1:0] current_state, next_state;
    
    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;  // Initially at ground floor
        else
            current_state <= next_state;
    end
    
    // Next state logic
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
    
    // Output logic
    always @(*) begin
        c_f = current_state;
        
        // Determine next floor based on input
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
            n_f = current_state;  // No button pressed, next = current
            g_LED = 0; f_LED = 0; s_LED = 0;
        end
    end
endmodule