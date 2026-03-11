module uart_rx_tb;

    logic clk, rst, rx_done, tx_start, tx_done;
    logic [7:0] tx_data, rx_data;

    logic tx_line; // wire connecting TX output to RX input

    uart_tx #(.CLKS_PER_BIT(10)) tx_uut (
        .clk(clk), .rst(rst),
        .tx_start(tx_start), .tx_data(tx_data),
        .tx_out(tx_line), .tx_done(tx_done)
    );

    uart_rx #(.CLKS_PER_BIT(10)) rx_uut (
        .clk(clk), .rst(rst),
        .rx_in(tx_line),
        .rx_data(rx_data), .rx_done(rx_done)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // assertions
    property p_current_state_data;
        @(posedge clk) (rx_uut.current_state == rx_uut.DATA) |-> (rx_uut.rx_done == 0);
    endproperty
    property p_rx_done_idle;
        @(posedge clk) (rx_uut.rx_done) |=> (rx_uut.current_state == rx_uut.IDLE);
    endproperty

    a_current_state_data: assert property (p_current_state_data) else $error("ASSERTION FAILED: In DATA 	state, rx_done should be 0");
    a_rx_done_idle: assert property (p_rx_done_idle) else $error("ASSERTION FAILED: When rx_done is high, 	current_state should be IDLE");

    initial begin
    rst = 1; tx_start = 0; tx_data = 0;
    @(posedge clk);
    rst = 0;

    // test 1
    tx_data = 8'hA5;
    tx_start = 1; @(posedge clk); tx_start = 0;
    @(posedge rx_done);
    if (rx_data == 8'hA5) $display("PASS: got %h", rx_data);
    else                  $display("FAIL: got %h, expected A5", rx_data);

    // reset between tests
    rst = 1; @(posedge clk); rst = 0;

    // test 2
    tx_data = 8'h55;
    tx_start = 1; @(posedge clk); tx_start = 0;
    @(posedge rx_done);
    if (rx_data == 8'h55) $display("PASS: got %h", rx_data);
    else                  $display("FAIL: got %h, expected 55", rx_data);

    $finish;
	end

endmodule