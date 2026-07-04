# 16-Bit ISA CPU in Verilog

A from-scratch processor in Verilog HDL - **16-bit instruction word, 8-bit datapath, 8 general-purpose registers** - built as a hands-on companion to ECE 124 (Digital & Computer Systems) at UMass Amherst.

## Architecture

A multi-cycle design built from four core modules:

- **ALU** - 8 operations (ADD, SUB, AND, OR, XOR, NOT, SHL, SHR) with carry, zero, sign, and overflow flags
- **Register File** - 8 × 8-bit, two read ports and one write port
- **Control Unit** - multi-cycle FSM driving the fetch / decode / execute cycle
- **ROM** - instruction memory, Harvard-style (addressed directly by the PC, no address mux)

### Control-unit FSM

Each R-type instruction executes in three cycles:

`FETCH` (latch IR) → `REG-READ` (latch operands A, B) → `EXEC+WB` (ALU computes, result written to `rd`, `PC++`)

Written in two-process style: one clocked block latches the state register and datapath registers; one combinational block decodes control signals. `ALUOut` and ALU input muxes are intentionally deferred - they come in with branches, when a single ALU must serve both a comparison and a target computation.

## ISA

16-bit instruction word, three formats (R / I / J), 9 opcodes. The full encoding lives at the top of `control_unit.v`. R-type is implemented; immediate, load/store, branch, and jump instructions are next.

## Status

- [x] ALU + testbench
- [x] Register file + testbench
- [x] Control unit - R-type datapath (multi-cycle FSM)
- [ ] R-type simulation & waveform verification *(in progress)*
- [ ] Combinational-block defaults (needed once opcode ≠ R-type is possible)
- [ ] Remaining instructions: ADDI, LDI, LD, ST, BEQ, BNE, BLT, JAL
- [ ] Data memory for LD/ST; `ALUOut` register + ALU input muxes for branches
- [ ] Assembler; run a stored program from ROM
- [ ] Synthesize and run on the Xilinx Spartan-3E Starter Kit

## Tools

- **Simulation:** Icarus Verilog + GTKWave
- **FPGA target:** Xilinx Spartan-3E Starter Kit (ISE toolchain)

## Running

```bash
# ALU
iverilog -o alu_test alu.v alu_tb.v && vvp alu_test && gtkwave alu_test.vcd

# Register file
iverilog -o rf_test regfile.v regfile_tb.v && vvp rf_test

# Full CPU (once the testbench is written)
iverilog -o cpu_test control_unit.v alu.v regfile.v cpu_tb.v && vvp cpu_test
```