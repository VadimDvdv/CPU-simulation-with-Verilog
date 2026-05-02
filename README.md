# 8-Bit CPU in Verilog

A simple 8-bit processor designed from scratch in Verilog HDL as a hands-on companion to ECE 124 (Digital & Computer Systems) at UMass Amherst.

## Architecture

The CPU is built from three core modules:

- **ALU** — 8 operations (ADD, SUB, AND, OR, XOR, NOT, SHL, SHR) with carry, zero, sign, and overflow flags
- **Register File** — general-purpose registers for operand storage
- **Control Unit** — FSM-based fetch-decode-execute cycle driving the datapath

## Tools

- **Simulation:** Icarus Verilog + GTKWave
- **FPGA target:** Lattice iCE40 (Nandland Go Board)

## Status

🔧 In progress - ALU design and testbench are complete. Register file, and control unit under development.

## Running

```bash
iverilog -o alu_test alu.v alu_tb.v
vvp alu_test
gtkwave alu_test.vcd
```
