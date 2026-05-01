module alu_tb;

    // Define I/O
    reg [7:0] A, B;  // TODO: understand why I - reg, O - wire

    reg  [2:0] opcode;
    wire [7:0] result;
    wire [3:0] flags;

    // instantiate alu
    alu uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .flags(flags)
    );

    initial begin
        $dumpfile("alu_test.vcd");
        $dumpvars(0, alu_tb);  // ?
    end


endmodule
