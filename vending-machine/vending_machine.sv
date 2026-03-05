module vending_machine (
    input  logic clk,
    input  logic rst,
    input  logic nickel,
    input  logic dime,
    input logic quarter,
    output logic dispense
);

    // Step 1: Define your states
    typedef enum logic [2:0] {
        S0  = 3'd0,
        S5  = 3'd1,
        S10 = 3'd2,
        S15 = 3'd3,
        S20 = 3'd4,
        S25 = 3'd5,
        DISPENSE = 3'd6
    } state_t;

    state_t current_state, next_state;

    // Step 2: State register (flip flop)
    always_ff @(posedge clk) begin
        if (rst)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Step 3: Next state logic — YOU FILL THIS IN
    always_comb begin
        case (current_state)
            S0: begin
                if      (nickel) next_state = S5;
                else if (dime)   next_state = S10;
                else if (quarter) next_state = S25;
                else             next_state = S0;
            end
            S5: begin
                if      (nickel) next_state = S10;
                else if (dime)   next_state = S15;
                else if (quarter) next_state = DISPENSE;
                else             next_state = S5;
            end
            S10: begin
                if      (nickel) next_state = S15;
                else if (dime)   next_state = S20;
                else if (quarter) next_state = DISPENSE;
                else             next_state = S10;
            end
            S15: begin
                if      (nickel) next_state = S20;
                else if (dime)   next_state = S25;
                else if (quarter) next_state = DISPENSE;
                else             next_state = S15;
            end
            S20: begin
                if      (nickel) next_state = S25;
                else if (dime)   next_state = DISPENSE;
                else if (quarter) next_state = DISPENSE;
                else             next_state = S20;
            end
            S25: begin
                if      (nickel) next_state = DISPENSE;
                else if (dime)   next_state = DISPENSE;
                else if (quarter) next_state = DISPENSE;
                else             next_state = S25;
            end
            DISPENSE: begin
            next_state = S0;
            end
            default: next_state = S0; 
        endcase
    end

    // Step 4: Output logic — YOU FILL THIS IN
    assign dispense = (current_state == DISPENSE);
    
endmodule