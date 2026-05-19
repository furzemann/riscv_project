module cu (
    input [31:0] instruction,

    output reg       regWrite,
    output reg       ALUSrc,
    output reg [1:0] ALUOp,
    output reg       memRead,
    output reg       memWrite,
    output reg       memtoReg,
    output reg       branch,
    output reg       jump,
    output reg [1:0] regDst
);

  wire [5:0] opcode = instruction[31:26];

  always @(*) begin
    // DEFAULTS
    regWrite = 0;
    ALUSrc   = 0;
    ALUOp    = 2'b00;
    memRead  = 0;
    memWrite = 0;
    memtoReg = 0;
    branch   = 0;
    jump     = 0;
    regDst   = 2'b00;

    case (opcode)

      // =========================
      // R-type
      // =========================
      6'b000000: begin
        regWrite = 1;
        ALUSrc   = 0;
        ALUOp    = 2'b10;
        regDst   = 2'b01; // rd
      end

      // =========================
      // lw
      // =========================
      6'b100011: begin
        regWrite = 1;
        ALUSrc   = 1;
        ALUOp    = 2'b00; // add
        memRead  = 1;
        memtoReg = 1;
        regDst   = 2'b00; // rt
      end

      // =========================
      // sw
      // =========================
      6'b101011: begin
        ALUSrc   = 1;
        ALUOp    = 2'b00;
        memWrite = 1;
      end

      // =========================
      // beq
      // =========================
      6'b000100: begin
        ALUSrc = 0;
        ALUOp  = 2'b01;  // sub
        branch = 1;
      end

      // =========================
      // I-type ALU instructions
      // =========================

      // addi
      6'b001000: begin
        regWrite = 1;
        ALUSrc   = 1;
        ALUOp    = 2'b00; // add
        regDst   = 2'b00;
      end

      // andi
      6'b001100: begin
        regWrite = 1;
        ALUSrc   = 1;
        ALUOp    = 2'b11; // AND (you must map this in ALU control)
        regDst   = 2'b00;
      end

      // ori
      6'b001101: begin
        regWrite = 1;
        ALUSrc   = 1;
        ALUOp    = 2'b11; // OR
        regDst   = 2'b00;
      end

      // slti
      6'b001010: begin
        regWrite = 1;
        ALUSrc   = 1;
        ALUOp    = 2'b11; // SLT
        regDst   = 2'b00;
      end

      // =========================
      // j
      // =========================
      6'b000010: begin
        jump = 1;
      end

      // =========================
      // jal
      // =========================
      6'b000011: begin
        jump     = 1;
        regWrite = 1;
        regDst   = 2'b10;  // $ra
      end

    endcase
  end

endmodule









