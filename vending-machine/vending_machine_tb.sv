module vending_machine_tb;

    logic clk, rst, nickel, dime, quarter, dispense;

    vending_machine uut (
        .clk      (clk),
        .rst      (rst),
        .nickel   (nickel),
        .dime     (dime),
        .quarter  (quarter),
        .dispense (dispense)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // Assertions
    property p_s15_nickel;
        @(posedge clk) (uut.current_state == uut.S15 && nickel) |=> (uut.current_state == uut.S20);
    endproperty

    property p_s5_dime;
        @(posedge clk) (uut.current_state == uut.S5 && dime) |=> (uut.current_state == uut.S15);
    endproperty

    property p_s25_nickel;
        @(posedge clk) (uut.current_state == uut.S25 && nickel) |=> (uut.current_state == uut.DISPENSE);
    endproperty

    property p_s0_quarter;
        @(posedge clk) (uut.current_state == uut.S0 && quarter) |=> (uut.current_state == uut.S25);
    endproperty

    property p_s5_quarter;
        @(posedge clk) (uut.current_state == uut.S5 && quarter) |=> (uut.current_state == uut.DISPENSE);
    endproperty

    property p_s10_quarter;
        @(posedge clk) (uut.current_state == uut.S10 && quarter) |=> (uut.current_state == uut.DISPENSE);
    endproperty

    property p_s15_quarter;
        @(posedge clk) (uut.current_state == uut.S15 && quarter) |=> (uut.current_state == uut.DISPENSE);
    endproperty
    
    property p_s20_quarter;
        @(posedge clk) (uut.current_state == uut.S20 && quarter) |=> (uut.current_state == uut.DISPENSE);
    endproperty

    property p_s25_quarter;
        @(posedge clk) (uut.current_state == uut.S25 && quarter) |=> (uut.current_state == uut.DISPENSE);
    endproperty

    a_s15_nickel: assert property (p_s15_nickel) else $error("ASSERTION FAILED: S15 + nickel should go to S20");
    a_s5_dime:    assert property (p_s5_dime)    else $error("ASSERTION FAILED: S5 + dime should go to S15");
    a_s25_nickel: assert property (p_s25_nickel) else $error("ASSERTION FAILED: S25 + nickel should go to DISPENSE");
    a_s0_quarter: assert property (p_s0_quarter) else $error("ASSERTION FAILED: S0 + quarter should go to S25");
    a_s5_quarter: assert property (p_s5_quarter) else $error("ASSERTION FAILED: S5 + quarter should go to DISPENSE");
    a_s10_quarter: assert property (p_s10_quarter) else $error("ASSERTION FAILED: S10 + quarter should go to DISPENSE");
    a_s15_quarter: assert property (p_s15_quarter) else $error("ASSERTION FAILED: S15 + quarter should go to DISPENSE");
    a_s20_quarter: assert property (p_s20_quarter) else $error("ASSERTION FAILED: S20 + quarter should go to DISPENSE");
    a_s25_quarter: assert property (p_s25_quarter) else $error("ASSERTION FAILED: S25 + quarter should go to DISPENSE");

    initial begin
        rst = 1; nickel = 0; dime = 0; quarter = 0;
        @(posedge clk);
        rst = 0;

        // test 1: 3 dimes
        dime = 1; @(posedge clk); dime = 0; @(posedge clk);
        dime = 1; @(posedge clk); dime = 0; @(posedge clk);
        dime = 1; @(posedge clk); dime = 0; @(posedge clk);
        if (dispense) $display("PASS"); else $display("FAIL");
        rst = 1; @(posedge clk); rst = 0; @(posedge clk);

        // test 2: 6 nickels
        nickel = 1; @(posedge clk); nickel = 0; @(posedge clk);
        nickel = 1; @(posedge clk); nickel = 0; @(posedge clk);
        nickel = 1; @(posedge clk); nickel = 0; @(posedge clk);
        nickel = 1; @(posedge clk); nickel = 0; @(posedge clk);
        nickel = 1; @(posedge clk); nickel = 0; @(posedge clk);
        nickel = 1; @(posedge clk); nickel = 0; @(posedge clk);
        if (dispense) $display("PASS"); else $display("FAIL");
        rst = 1; @(posedge clk); rst = 0; @(posedge clk);

        // test 3: 1 dime, 2 nickels, 1 dime
        dime   = 1; @(posedge clk); dime   = 0; @(posedge clk);
        nickel = 1; @(posedge clk); nickel = 0; @(posedge clk);
        nickel = 1; @(posedge clk); nickel = 0; @(posedge clk);
        dime   = 1; @(posedge clk); dime   = 0; @(posedge clk);
        if (dispense) $display("PASS"); else $display("FAIL");
        rst = 1; @(posedge clk); rst = 0; @(posedge clk);

        // test 4: 1 quarter, 1 nickel
        quarter = 1; @(posedge clk); quarter = 0; @(posedge clk);
        nickel  = 1; @(posedge clk); nickel  = 0; @(posedge clk);
        if (dispense) $display("PASS"); else $display("FAIL");
        rst = 1; @(posedge clk); rst = 0; @(posedge clk);

        // test 5: 1 quarter, 1 dime
        quarter = 1; @(posedge clk); quarter = 0; @(posedge clk);
        dime  = 1; @(posedge clk); dime  = 0; @(posedge clk);
        if (dispense) $display("PASS"); else $display("FAIL");
        rst = 1; @(posedge clk); rst = 0; @(posedge clk);


        $finish;
    end

endmodule