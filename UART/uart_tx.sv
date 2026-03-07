module uart_tx #(
    parameter CLKS_PER_BIT = 434
)(
    input  logic       clk,
    input  logic       rst,
    input  logic       tx_start,
    input  logic [7:0] tx_data,
    output logic       tx_out,
    output logic       tx_done
);

    // states needed
    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t current_state;
    logic [7:0] shift_reg;              // data being transmitted
    logic [8:0] baud_counter;           // counts clock cycles per bit
    logic [2:0] bit_counter;            // counts which bit we're on

    // state register
    always_ff @(posedge clk) begin
        if (rst) begin
            current_state <= IDLE;
            baud_counter  <= 0;
            bit_counter   <= 0;
            shift_reg     <= 0;
            tx_out        <= 1;
            tx_done       <= 0;
        end else begin
            tx_done <= 0;
            tx_out <= 1;
            case (current_state)
                IDLE: begin
                    if (tx_start) begin
                        current_state <= START;
                        shift_reg <= tx_data;
                        baud_counter <= 0;
                        bit_counter <= 0;
                    end 
                end
                START: begin
                    tx_out <= 0;
                    baud_counter <= baud_counter + 1;
                    if (baud_counter == CLKS_PER_BIT - 1) begin
                        current_state <= DATA;
                        baud_counter <= 0;
                    end
                end
                DATA: begin
                    tx_out <= shift_reg[0];
                    baud_counter <= baud_counter + 1;
                    if (baud_counter == CLKS_PER_BIT - 1) begin
                        shift_reg <= shift_reg >> 1;
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
                    tx_out <= 1;
                    baud_counter <= baud_counter + 1;
                    if (baud_counter == CLKS_PER_BIT - 1) begin
                        current_state <= IDLE;
                        tx_done <= 1;
                        baud_counter <= 0;
                    end
                end
                default: begin
                    current_state <= IDLE;
                end
            endcase
        end
    end

   

endmodule