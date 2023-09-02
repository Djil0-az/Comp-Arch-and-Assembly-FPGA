`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2023 01:15:27 PM
// Design Name: 
// Module Name: test_mips_hazard_cpu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_mips_hazard_cpu;
  reg clk1, clk2;
  integer k;
  mips_cpu mips (clk1, clk2);

  // Two-phase clock generation
  initial
  begin
    clk1 = 0;
    clk2 = 0;
    repeat (50) // Generating two-phase clock
    begin
      #5 clk1 = ~clk1;
      #5 clk2 = ~clk2;
    end
  end

  // Initializing CPU state and memory
  initial
  begin
    // Initialize registers
    for (k = 0; k < 32; k=k+1)
      mips.Reg[k] = 0;

    // Load program into memory with a data hazard
    mips.Mem[0] = {6'd10, 5'd0, 5'd1, 16'd1};          // R1 = 1
    mips.Mem[1] = {6'd10, 5'd0, 5'd2, 16'd2};          // R2 = 2
    mips.Mem[2] = {6'd0, 5'd1, 5'd2, 5'd3, 11'b0};     // R3 = R1 + R2
    mips.Mem[3] = {6'd0, 5'd1, 5'd3, 5'd4, 11'b0};     // R4 = R1 - R3


    // Initialize CPU state
    mips.HALTED = 0;
    mips.PC = 0;
    mips.TAKEN_BRANCH = 0;

    // Run simulation for some cycles
    #500;

    // Display register values
    for (k = 0; k < 6; k=k+1)
      $display ("R%1d - %2d", k, mips.Reg[k]);

    // Finish simulation
    $finish;
  end

  // Dump signals for waveform
  initial
  begin
    $dumpfile ("mips_cpu.vcd");
    $dumpvars (0, test_mips_hazard_cpu);
  end
endmodule
