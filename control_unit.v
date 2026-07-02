`timescale 1ns / 1ps

// ISA Reference — 16-bit instruction word, 8 registers (R0–R7)
//
// FORMATS
// -------
//  R-type  [15:12] opcode=0000  [11:9] rd  [8:6] rs1  [5:3] rs2  [2:0] func
//  I-type  [15:12] opcode       [11:9] rd  [8:6] rs1  [5:0] imm6 (signed)
//  J-type  [15:12] opcode       [11:9] rd  [8:0] imm9 (signed)
//
// OPCODES
// -------
//  4'b0000  R-type ALU  (func selects operation — see below)
//  4'b0001  ADDI   rd = rs1 + sign_ext(imm6)
//  4'b0010  LDI    rd = sign_ext(imm9)              (J-type encoding)
//  4'b0011  LD     rd = MEM[rs1 + imm6]
//  4'b0100  ST     MEM[rs1 + imm6] = rd             (rd field holds src)
//  4'b0101  BEQ    if (rs1 == rs2) PC += imm6
//  4'b0110  BNE    if (rs1 != rs2) PC += imm6
//  4'b0111  BLT    if (rs1 <  rs2) PC += imm6
//  4'b1000  JAL    rd = PC+1 ; PC += imm9
//
// R-TYPE FUNC FIELD [2:0]
// -----------------------
//  3'b000  ADD    rd = rs1 + rs2
//  3'b001  SUB    rd = rs1 - rs2
//  3'b010  AND    rd = rs1 & rs2
//  3'b011  OR     rd = rs1 | rs2
//  3'b100  XOR    rd = rs1 ^ rs2
//  3'b101  SHL    rd = rs1 << rs2
//  3'b110  SHR    rd = rs1 >> rs2
//  3'b111  NOT    rd = ~rs1       (rs2 ignored)
//
// REGISTER FILE
// -------------
//  R0–R7  general purpose; no hard-wired zero register

module control_unit (
    input clk,
    input initial_rst
);

    // setup PC and IR
    reg [4:0] program_counter;   // 5-bit PC allows 32 words in ROM
    reg [15:0] instruction_reg;  // 16-bit IR for 16-bit word length

    // initial reset logic, resets PC and IR to 0's
    always @(posedge clk) begin
        if (initial_rst) begin
            program_counter <= 5'b0;
            instruction_reg <= 16'b0;
        end
    end

    // initialize ALU and regfile
    reg [7:0] alu_a, alu_b;
    reg [2:0] alu_opcode;
    wire [7:0] alu_result;
    wire [3:0] alu_flags;

    alu u_alu (
        .A     (alu_a),
        .B     (alu_b),
        .opcode(alu_opcode),
        .result(alu_result),
        .flags (alu_flags)
    );

    reg reg_write_en;
    reg [2:0] reg_read1_addr, reg_read2_addr, reg_write_addr;
    reg [7:0] reg_write_data;
    wire [7:0] reg_read1_data, reg_read2_data;

    regfile u_regfile (
        .clk       (clk),
        .rst       (initial_rst),
        .write_en  (reg_write_en),
        .read1_addr(reg_read1_addr),
        .read2_addr(reg_read2_addr),
        .write_addr(reg_write_addr),
        .write_data(reg_write_data),
        .read1_data(reg_read1_data),
        .read2_data(reg_read2_data)
    );

    // instantiate ROM module
    reg [5:0] u_rom_read_addr;
    wire [15:0] u_rom_read_data;

    rom u_rom (
        .rom_read_addr(u_rom_read_addr),
        .rom_read_data(u_rom_read_data)
    );

    always @(*)
endmodule


module rom (
    input  [ 5:0] rom_read_addr,
    output [15:0] rom_read_data
);

    // IMPORTANT: Finish actual memory contents later!

    reg [15:0] memcells[0:31];
    $readmemh("prog.hex", memcells);

    assign rom_read_data = memcells[rom_read_addr];

endmodule
