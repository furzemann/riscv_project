`timescale 1ns / 1ps

module tb;

  reg clk;
  reg rst;

  wire [31:0] result;

  // DUT
  top DUT (
      .clk(clk),
      .rst(rst),
      .result(result)
  );

  // =========================
  // CLOCK GENERATION
  // =========================
  initial clk = 0;
  always #5 clk = ~clk;

  // =========================
  // RESET SEQUENCE (IMPORTANT)
  // =========================
  initial begin
    rst = 1;
    #20;
    rst = 0;
  end

  // =========================
  // WAVE DUMP
  // =========================
  initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, tb);
  end

  // =========================
  // DEBUG MONITOR (CORE FIX)
  // =========================
  always @(posedge clk) begin
    $display("PC=%h INST=%h ALU=%d RESULT=%d", DUT.pc, DUT.instruction, DUT.alu_result, result);

    // X detection (VERY IMPORTANT)
    if (^DUT.pc === 1'bx) begin
      $display("❌ ERROR: PC is X");
      $finish;
    end

    if (^DUT.instruction === 1'bx) begin
      $display("❌ ERROR: Instruction is X");
      $finish;
    end

    if (^result === 1'bx) begin
      $display("❌ ERROR: Result is X");
      $finish;
    end
  end

  // =========================
  // END SIMULATION
  // =========================
  initial begin
    #200;

    $display("\n==== FINAL REGISTER STATE ====");
    $display("t0=%d", DUT.RF.memory[8]);
    $display("t1=%d", DUT.RF.memory[9]);
    $display("t2=%d", DUT.RF.memory[10]);
    $display("t3=%d", DUT.RF.memory[11]);
    $display("t4=%d", DUT.RF.memory[12]);
    $display("t5=%d", DUT.RF.memory[13]);
    $display("t6=%d", DUT.RF.memory[14]);
    $display("t7=%d", DUT.RF.memory[15]);

    $display("mem[0]=%d", DUT.DMEM.memory[0]);

    $display("TEST DONE");
    $finish;
  end

endmodule

