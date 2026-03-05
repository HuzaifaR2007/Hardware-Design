module countertb;

    logic clk, rst, load, up, down, overflow, underflow;
    logic [3:0] load_val, count;

    counter uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .up(up),
        .down(down),
        .overflow(overflow),
        .underflow(underflow),
        .load_val(load_val),
        .count(count)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // Assertions
    property p_overflow;
        @(posedge clk) (uut.overflow == 1) |=> (uut.count == 4'b0000);
    endproperty
    property p_underflow;
        @(posedge clk) (uut.underflow == 1) |=> (uut.count == 4'b1111);
    endproperty
    property p_load;
        @(posedge clk) (uut.load == 1) |=> (uut.count == $past(uut.load_val));
    endproperty
    property p_up;
    @(posedge clk) (uut.up == 1 && uut.down == 0 && uut.count != 4'b1111) |=> (uut.count == $past(uut.count) + 1);
    endproperty
    property p_down;
        @(posedge clk) (uut.up == 0 && uut.down == 1 && uut.count != 4'b0000) |=> (uut.count == $past(uut.count) - 1);
    endproperty
    property p_up_down;
        @(posedge clk) (uut.up == 1 && uut.down == 1) |=> (uut.count == $past(uut.count));
    endproperty
    property p_reset;
        @(posedge clk) (uut.rst == 1) |=> (uut.count == 4'b0000);
    endproperty
    property p_up_count;
        @(posedge clk) (uut.up == 1 && uut.count == 4'b1111) |=> (uut.overflow == 1);
    endproperty
    property p_down_count;
        @(posedge clk) (uut.down == 1 && uut.count == 4'b0000) |=> (uut.underflow == 1);
    endproperty

    a_overflow: assert property (p_overflow) else $error("ASSERTION FAILED: Overflow should reset count to 0");
    a_underflow: assert property (p_underflow) else $error("ASSERTION FAILED: Underflow should set count to 15");
    a_load: assert property (p_load) else $error("ASSERTION FAILED: Load should set count to load_val");
    a_up: assert property (p_up) else $error("ASSERTION FAILED: Up should increment count when not at max");
    a_down: assert property (p_down) else $error("ASSERTION FAILED: Down should decrement count when not at min");
    a_up_down: assert property (p_up_down) else $error("ASSERTION FAILED: Up and down together should not change count");
    a_reset: assert property (p_reset) else $error("ASSERTION FAILED: Reset should set count to 0");
    a_up_count: assert property (p_up_count) else $error("ASSERTION FAILED: Up at max should set overflow");
    a_down_count: assert property (p_down_count) else $error("ASSERTION FAILED: Down at min should set underflow");

    initial begin
        rst = 1; load = 0; up = 0; down = 0; load_val = 0;
        @(posedge clk);
        rst = 0;

        // testing up
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); up = 0; @(posedge clk);
        up = 1; @(posedge clk); #1;
        if (overflow) $display("PASS"); else $display("FAIL");
        up = 0; @(posedge clk);
        rst = 1; @(posedge clk); rst = 0; @(posedge clk);

        // test down
        down = 1; @(posedge clk); #1;
        if (underflow) $display("PASS"); else $display("FAIL");
        down = 0; @(posedge clk);
        rst = 1; @(posedge clk); rst = 0; @(posedge clk);

        //test up and down
        // load count to 7
        load_val = 4'd7;
        load = 1; @(posedge clk); load = 0; @(posedge clk);

        // pulse up and down together
        up = 1; down = 1; @(posedge clk); up = 0; down = 0; @(posedge clk);

        // check count is still 7
        if (count == 4'd7) $display("PASS"); else $display("FAIL");

        // test load
        load_val = 4'd7;
        load = 1; @(posedge clk); load = 0; @(posedge clk);
        if (count == 4'd7) $display("PASS"); else $display("FAIL");
        rst = 1; @(posedge clk); rst = 0; @(posedge clk);

        $finish;
    end

endmodule