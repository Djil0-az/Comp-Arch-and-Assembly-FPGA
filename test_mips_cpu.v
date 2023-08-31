`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2023 01:15:27 PM
// Design Name: 
// Module Name: test_mips_cpu
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


module test_mips_cpu;
  reg clk1, clk2;
  integer k;
  mips_cpu mips (clk1, clk2);

  // Two-phase clock generation
  initial
  begin
    clk1 = 0;
    clk2 = 0;
    repeat (20) // Generating two-phase clock
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

    // Load program into memory
    mips.Mem[0] = 32'h2801000a; // ADDI R1,R0,10
    mips.Mem[1] = 32'h28020014; // ADDI R2,R0,20
    mips.Mem[2] = 32'h28030019; // ADDI R3,R0,25
    mips.Mem[3] = 32'h0ce77800; // OR R7,R7,R7 -- dummy instr.
    mips.Mem[4] = 32'h0ce77800; // OR R7,R7,R7 -- dummy instr.
    mips.Mem[5] = 32'h00222000; // ADD R4,R1,R2
    mips.Mem[6] = 32'h0ce77800; // OR R7,R7,R7 -- dummy instr.
    mips.Mem[7] = 32'h00832800; // ADD R5,R4,R3
    mips.Mem[8] = 32'hfc000000; // HLT

    // Initialize CPU state
    mips.HALTED = 0;
    mips.PC = 0;
    mips.TAKEN_BRANCH = 0;

    // Run simulation for some cycles
    #280;

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
    $dumpvars (0, test_mips_cpu);
  end
endmodule

