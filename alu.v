module adder_subtractor (
    input  [7:0] A,
    input  [7:0] B,
    input        ctrl,
    output [7:0] result,
    output       c_out,
    output       V
);
    // Two's complement: invert B and inject carry-in when subtracting
    wire [7:0] B_eff = ctrl ? ~B : B;
    wire       cin   = ctrl;

    // Full 8-bit addition — temp[8] is c_out
    wire [8:0] temp  = {1'b0, A}       + {1'b0, B_eff} + cin;

    // Lower 7 bits only — temp1[7] is C_{n-1} (carry into MSB)
    wire [7:0] temp1 = {1'b0, A[6:0]}  + {1'b0, B_eff[6:0]} + cin;

    assign result = temp[7:0];
    assign c_out  = temp[8];
    assign V      = temp[8] ^ temp1[7];

endmodule

module ALU_8bit (
    input [7:0] A,
    input [7:0] B,
    input [2:0] opcode,
    output [7:0] result,
    output [3:0] flags
);

    always @(*) begin:

    end

endmodule