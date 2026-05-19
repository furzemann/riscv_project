module top (
    input clk,
    input rst,
    output [31:0] result
);

  // =========================
  // PC
  // =========================
  wire [31:0] pc;
  wire [31:0] next_pc;

  program_counter PC (
      .clk(clk),
      .rst(rst),
      .next_pc(next_pc),
      .pc(pc)
  );

  // =========================
  // IMEM
  // =========================
  wire [31:0] instruction;

  imem IMEM (
      .addr(pc),
      .instruction(instruction)
  );

  // =========================
  // Decode
  // =========================
  wire [ 5:0] opcode = instruction[31:26];
  wire [ 4:0] rs = instruction[25:21];
  wire [ 4:0] rt = instruction[20:16];
  wire [ 4:0] rd = instruction[15:11];
  wire [15:0] imm = instruction[15:0];
  wire [ 5:0] funct = instruction[5:0];

  // =========================
  // Control signals
  // =========================
  wire regWrite, ALUSrc, memRead, memWrite, memtoReg, branch, jump;
  wire [1:0] ALUOp;

  cu CU (
      .instruction(instruction),
      .regWrite(regWrite),
      .ALUSrc(ALUSrc),
      .ALUOp(ALUOp),
      .memRead(memRead),
      .memWrite(memWrite),
      .memtoReg(memtoReg),
      .branch(branch),
      .jump(jump),
      .regDst()
  );

  // =========================
  // Register File
  // =========================
  wire [31:0] data1, data2;
  wire [31:0] write_data;

  registerfile RF (
      .clk(clk),
      .addr1(rs),
      .addr2(rt),
      .addr3(rt),
      .data3(write_data),
      .write_en3(regWrite),
      .data1(data1),
      .data2(data2)
  );

  // =========================
  // Immediate
  // =========================
  wire [31:0] imm_ext = {{16{imm[15]}}, imm};

  // =========================
  // ALU control
  // =========================
  wire [ 3:0] alu_ctrl;

  alu_control ALUCTRL (
      .ALUOp(ALUOp),
      .funct(funct),
      .alu_ctrl(alu_ctrl)
  );

  // =========================
  // ALU
  // =========================
  wire [31:0] alu_b;
  wire [31:0] alu_result;
  wire zero;

  assign alu_b = (ALUSrc) ? imm_ext : data2;

  alu ALU (
      .a(data1),
      .b(alu_b),
      .alu_ctrl(alu_ctrl),
      .result(alu_result),
      .zero(zero)
  );

  // =========================
  // Branch logic
  // =========================
  wire [31:0] branch_target = pc + 4 + (imm_ext << 2);
  wire branch_taken = branch & zero;

  // =========================
  // Next PC logic
  // =========================
  assign next_pc =
        jump ? {pc[31:28], instruction[25:0], 2'b00} :
        branch_taken ? branch_target :
        pc + 4;

  // =========================
  // Data memory (optional if you already have)
  // =========================
  wire [31:0] mem_out;

  data_memory DMEM (
      .clk(clk),
      .mem_read(memRead),
      .mem_write(memWrite),
      .address(alu_result),
      .write_data(data2),
      .read_data(mem_out)
  );

  assign write_data = (memtoReg) ? mem_out : alu_result;

  assign result = alu_result;

endmodule




