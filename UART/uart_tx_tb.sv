module uart_tx_tb;
    
    logic clk, rst, tx_start, tx_out, tx_done;
    logic [7:0] tx_data, received;


    uart_tx #(.CLKS_PER_BIT(10)) uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_out(tx_out),
        .tx_done(tx_done)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // assertions
    property p_current_state_start;
        @(posedge clk) (uut.current_state == uut.START) |=> (uut.tx_out == 0);
    endproperty
    property p_current_state_stop;
        @(posedge clk) (uut.current_state == uut.STOP) |=> (uut.tx_out == 1);
    endproperty

    a_current_state_start: assert property (p_current_state_start) else $error("ASSERTION FAILED: In START state, tx_out should be 0");
    a_current_state_stop: assert property (p_current_state_stop) else $error("ASSERTION FAILED: In STOP state, tx_out should be 1");


    initial begin
        // test 1
        rst = 1; tx_start = 0; tx_data = 0;
        @(posedge clk);
        rst = 0; tx_data = 8'hA5;
        tx_start = 1; @(posedge clk); tx_start = 0;
        // skip start bit
        repeat(10) @(posedge clk);

        // sample 8 data bits
        for (int i = 0; i < 8; i++) begin
            repeat(10) @(posedge clk);
            received[i] = tx_out;
        end

        @(posedge tx_done);
        
        if (tx_done) $display("PASS: transmission complete");
        if (received == 8'hA5) $display("PASS: correct byte received");
        else                   $display("FAIL: got %h, expected A5", received);

        // test 2

        rst = 1; tx_start = 0; tx_data = 0;
        @(posedge clk);
        rst = 0; tx_data = 8'h55;
        tx_start = 1; @(posedge clk); tx_start = 0;
        // skip start bit
        repeat(10) @(posedge clk);

        // sample 8 data bits
        for (int i = 0; i < 8; i++) begin
            repeat(10) @(posedge clk);
            received[i] = tx_out;
        end

        @(posedge tx_done);
        
        if (tx_done) $display("PASS: transmission complete");
        if (received == 8'h55) $display("PASS: correct byte received");
        else                   $display("FAIL: got %h, expected 55", received);

        // reset between tests
        rst = 1; @(posedge clk); rst = 0;

        $finish;
    end


endmodule