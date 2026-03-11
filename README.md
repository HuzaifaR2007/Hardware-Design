# Hardware Design Projects

SystemVerilog design and verification projects built while learning FPGA/ASIC development.
Simulated using Questa via EDA Playground.

## Projects

### UART Transceiver
A parameterized UART transmitter and receiver implementing full serial communication.
- FSM-based RTL architecture with configurable baud rate (434 cycles/bit at 115200 baud on 50MHz clock)
- Transmitter implements start/data/stop bit framing with shift-register based serialization
- Receiver implements start-bit detection, 1.5x baud period synchronization for mid-bit sampling,
  and shift-register based serial-to-parallel reconstruction
- Loopback testbench verifying end-to-end byte transmission across multiple test vectors
- SVA concurrent assertions verifying state transition behaviour using next-cycle implication

### 4-bit Parameterized Counter
A synchronous up/down counter with configurable bit width.
- Priority-encoded control logic with load, overflow, and underflow detection
- Configurable bit width via WIDTH parameter
- Complete SVA assertion suite covering all input conditions including hold,
  wrap-around, and boundary cases using named properties
- Zero assertion errors across all test cases on Questa

### Vending Machine FSM
A synchronous FSM modelling a coin-operated vending machine.
- Accepts nickels, dimes, and quarters across 7 states with full state transition verification
- Directed testbench covering all coin input combinations including mixed sequences
- Named SVA properties with next-cycle implication for state transition verification

### Signal Verification & Characterization Tool
An automated signal analysis framework written in Python.
- Computes SNR and FFT characteristics with structured pass/fail reporting
- Automated parameter sweeps to quantify performance limits under varying noise conditions

## Technical Skills
- **HDLs:** SystemVerilog, Verilog
- **Verification:** SVA Assertions, Questa, Testbench Development, Functional Coverage
- **Digital Design:** RTL Architecture, FSM Design, Synchronous Logic, Parameterization
- **Tools:** Questa (EDA Playground), Icarus Verilog, Git, Linux/WSL, Bash
- **Python:** NumPy, Pandas
- **Embedded:** Raspberry Pi, GPIO interfacing, Python hardware scripting
- **Lab:** Oscilloscope, Multimeter, Function Generator, Breadboard Prototyping

## Tools
- SystemVerilog (IEEE 1800)
- Questa (EDA Playground)
- Icarus Verilog
- Git
