module alu_control (
    input [1:0] ALUOp,
    input [5:0] funct,
    output reg [3:0] alu_ctrl
);

  always @(*) begin
    case (ALUOp)

      2'b00: alu_ctrl = 4'b0000;  // add

      2'b01: alu_ctrl = 4'b0001;  // sub (beq)

      2'b10:
      case (funct)
        6'b100000: alu_ctrl = 4'b0000;  // add
        6'b100010: alu_ctrl = 4'b0001;  // sub
        6'b100100: alu_ctrl = 4'b0010;  // and
        6'b100101: alu_ctrl = 4'b0011;  // or
        6'b101010: alu_ctrl = 4'b0100;  // slt
        default:   alu_ctrl = 4'b0000;
      endcase

      default: alu_ctrl = 4'b0000;
    endcase
  end

endmodule

