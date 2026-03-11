module uart_rx #(
    parameter CLKS_PER_BIT = 434
)(
    input  logic       clk,
    input  logic       rst,
    input  logic       rx_in,
    output logic [7:0] rx_data,
    output logic       rx_done  
);

    // states needed
    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t current_state;
    logic [8:0] baud_counter;           // counts clock cycles per bit
    logic [2:0] bit_counter;            // counts which bit we're on

    // state register
    always_ff @(posedge clk) begin
        if (rst) begin
            current_state <= IDLE;
            baud_counter  <= 0;
            bit_counter   <= 0;
            rx_done       <= 0;
        end else begin
            rx_done <= 0;
            case (current_state)
                IDLE: begin
                    if (!rx_in) begin
                        current_state <= START;
                        baud_counter <= 0;
                        bit_counter <= 0;
                    end 
                end
                START: begin
                    baud_counter <= baud_counter + 1;
                    if (baud_counter == (CLKS_PER_BIT / 2 ) - 1) begin
                        current_state <= DATA;
                        baud_counter <= 0;
                    end
                end
                DATA: begin
                    rx_data[bit_counter] <= rx_in;
                    baud_counter <= baud_counter + 1;
                    if (baud_counter == CLKS_PER_BIT - 1) begin
                        bit_counter <= bit_counter + 1;
                        baud_counter <= 0;
                        if (bit_counter == 7) begin
                            current_state <= STOP;
                            baud_counter <= 0;
                            bit_counter <= 0;
                        end
                    end
                end
                STOP: begin
                    baud_counter <= baud_counter + 1;
                    if (baud_counter == CLKS_PER_BIT - 1) begin
                        baud_counter <= 0;
                        if (rx_in) begin
                            rx_done <= 1;
                        end
                        current_state <= IDLE;
                    end
                end
                default: begin
                    current_state <= IDLE;
                end
            endcase
        end
    end

endmodule