# Hardware Design Projects

SystemVerilog design and verification projects built while learning FPGA/ASIC development.

## Projects

### Vending Machine FSM
A finite state machine modelling a 30¢ vending machine accepting nickels, dimes, and quarters.
- Synchronous RTL design using `always_ff` and `always_comb`
- Full testbench with directed test cases
- SVA concurrent assertions with `|=>` for state transition verification
- Simulated using Questa

### 4-bit Counter
A synchronous up/down counter with load, overflow, and underflow detection.
- Priority-encoded control logic
- Overflow/underflow flag generation
- Complete SVA assertion suite covering all input conditions
- Simulated using Questa

## Tools
- SystemVerilog (IEEE 1800)
- Questa (EDA Playground)
- Icaru