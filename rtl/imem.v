module imem (
    input  [31:0] addr,
    output [31:0] instruction
);

  // Small memory for debugging (0 to 8 instructions)
  reg [31:0] memory[0:8];

  integer i;

  // Initialize memory safely
  initial begin
    // clear everything first (prevents X issues)
    for (i = 0; i < 9; i = i + 1) memory[i] = 32'b0;

    // load program
    $readmemh("program.hex", memory);
  end

  // word-aligned access (PC / 4)
  assign instruction = memory[addr[5:2]];

endmodule


