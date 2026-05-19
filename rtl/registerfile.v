module registerfile (
    input clk,
    input [4:0] addr1,
    input [4:0] addr2,
    input [4:0] addr3,
    input [31:0] data3,
    input write_en3,

    output [31:0] data1,
    output [31:0] data2
);

  reg [31:0] memory[0:31];

  integer i;

  initial begin
    for (i = 0; i < 32; i = i + 1) memory[i] = 0;
  end

  assign data1 = memory[addr1];
  assign data2 = memory[addr2];

  always @(posedge clk) begin
    if (write_en3 && addr3 != 0) memory[addr3] <= data3;

    // MIPS register zero is hardwired
    memory[0] <= 32'b0;
  end

endmodule

