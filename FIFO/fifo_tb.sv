module fifo_tb;

    logic clk, rst, wr_en, rd_en, full, empty;
    logic [7:0] wr_data, rd_data;

    fifo #(.DATA_WIDTH(8), .FIFO_DEPTH(8)) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // assertions
    property p_full;
        @(posedge clk) (uut.full) |-> (uut.count == 8);
    endproperty
    property p_empty;
        @(posedge clk) (uut.empty) |-> (uut.count == 0);
    endproperty
    property p_overflow;
        @(posedge clk) (uut.wr_en && uut.full) |=> (uut.count == 8);
    endproperty
    property p_underflow;
        @(posedge clk) (uut.rd_en && uut.empty) |=> (uut.count == 0);
    endproperty
    property p_read_write;
        @(posedge clk) (uut.wr_en && uut.rd_en && !uut.full && !uut.empty) |=> (uut.count == $past(uut.count));
    endproperty

    a_full: assert property (p_full) else $error("ASSERTION FAILED: Full should be asserted when count is 8");
    a_empty: assert property (p_empty) else $error("ASSERTION FAILED: Empty should be asserted when count is 0");
    a_overflow: assert property (p_overflow) else $error("ASSERTION FAILED: Overflow should not increase count above 8");
    a_underflow: assert property (p_underflow) else $error("ASSERTION FAILED: Underflow should not decrease count below 0");
    a_read_write: assert property (p_read_write) else $error("ASSERTION FAILED: Count should not change");

    initial begin
        // test 1
        rst = 1; wr_en = 0; rd_en = 0; wr_data = 0;
        @(posedge clk);
        rst = 0;
        for (int i = 0; i < 8; i++) begin
            wr_data = i;
            wr_en = 1; @(posedge clk); wr_en = 0;
        end
        #1;
        if (full) $display("PASS: FIFO is full after 8 writes");
        else      $display("FAIL: FIFO should be full after 8 writes");
        for (int i = 0; i < 8; i++) begin
            rd_en = 1; @(posedge clk); #1; rd_en = 0;
            if (rd_data == i) $display("PASS: read %d", rd_data);
            else              $display("FAIL: expected %d, got %d", i, rd_data);
        end
        if (empty) $display("PASS: FIFO is empty after 8 reads");
        else        $display("FAIL: FIFO should be empty after 8 reads");

        // test 2: simultaneous read/write
        rst = 1; wr_en = 0; rd_en = 0; wr_data = 0;
        @(posedge clk);
        rst = 0;
        // fill fifo
        for (int i = 0; i < 4; i++) begin
            wr_data = i;
            wr_en = 1; @(posedge clk); wr_en = 0;
        end
        for (int i = 0; i < 4; i++) begin
            wr_data = i + 10;
            wr_en = 1; rd_en = 1; @(posedge clk); #1; wr_en = 0; rd_en = 0;
            if (rd_data == i) $display("PASS: read %d", rd_data);
            else              $display("FAIL: expected %d, got %d", i, rd_data);
        end
        $display("Test 2: simultaneous read/write completed");

        // test 3 overflow protection
        rst = 1; wr_en = 0; rd_en = 0; wr_data = 0;
        @(posedge clk);
        rst = 0;
        // fill fifo
        for (int i = 0; i < 8; i++) begin
            wr_data = i;
            wr_en = 1; @(posedge clk); wr_en = 0;
        end
        // try overflowing fifo
        wr_data = 9;
        wr_en = 1; @(posedge clk); wr_en = 0; #1;
        if (full && uut.count == 8) $display("PASS: FIFO is full, can not write to full FIFO");
        else                    $display("FAIL: FIFO has been overflowed");

        // test 4 underflow protection
        rst = 1; wr_en = 0; rd_en = 0; wr_data = 0;
        @(posedge clk);
        rst = 0;
        // try reading from fifo
        rd_en = 1; @(posedge clk); rd_en = 0; #1;
        if (empty && uut.count == 0) $display("PASS: FIFO is empty, can not read from empty FIFO");
        else                     $display("FAIL: FIFO has been underflowed");

        // reset between tests
        rst = 1; wr_en = 0; rd_en = 0; wr_data = 0;

        $finish;
    end
endmodule