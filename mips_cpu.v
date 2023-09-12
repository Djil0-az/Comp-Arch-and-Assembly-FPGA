module mips_cpu( clk1, clk2, bat_ctl
 );
  
  input clk1, clk2; // Two-phase clock
  output reg [4:0] bat_ctl;
  reg [31:0] PC, IF_ID_IR, IF_ID_NPC;
  reg [31:0] ID_EX_IR, ID_EX_NPC, ID_EX_A, ID_EX_B, ID_EX_Imm;
  reg [2:0] ID_EX_type, EX_MEM_type, MEM_WB_type;
  reg [31:0] EX_MEM_IR, EX_MEM_ALUOut, EX_MEM_B;
  reg EX_MEM_cond;
  reg [31:0] MEM_WB_IR, MEM_WB_ALUOut, MEM_WB_LMD;
  reg [31:0] Reg [0:31]; // Register bank (32 x 32)
  reg [31:0] Mem [0:1023]; // 1024 x 32 memory
  parameter ADD=6'b000000, SUB=6'b000001, AND=6'b000010, OR=6'b000011,
            SLT=6'b000100, MUL=6'b000101, HLT=6'b111111, LW=6'b001000,
            SW=6'b001001, ADDI=6'b001010, SUBI=6'b001011,SLTI=6'b001100,
            BNEQZ=6'b001101, BEQZ=6'b001110;
  parameter RR_ALU=3'b000, RM_ALU=3'b001, LOAD=3'b010, STORE=3'b011,
            BRANCH=3'b100, HALT=3'b101;
  reg HALTED;
  // Set after HLT instruction is completed (in WB stage)
  reg TAKEN_BRANCH;
  // Required to disable instructions after branch
  reg STALL_IF;
  // control signal that is set to 1 when a data hazard is detected
  //************************************************************************
  always @(posedge clk1) // IF Stage
    if (HALTED == 0)
    begin
      if (((EX_MEM_IR[31:26] == BEQZ) && (EX_MEM_cond == 1)) ||
          ((EX_MEM_IR[31:26] == BNEQZ) && (EX_MEM_cond == 0)))
      begin
        IF_ID_IR <= #2 Mem[EX_MEM_ALUOut];
        TAKEN_BRANCH <= #2 1'b1;
        IF_ID_NPC <= #2 EX_MEM_ALUOut + 1;
        PC <= #2 EX_MEM_ALUOut + 1;
      end
      else
      begin
        IF_ID_IR <= #2 Mem[PC];
        IF_ID_NPC <= #2 PC + 1;
        PC <= #2 PC + 1;
      end
    end
    //************************************************************************
  always @(posedge clk2) // ID Stage
begin
  if (HALTED == 0)
  begin
    // Initialize STALL_IF to 0 at the beginning of each cycle
    STALL_IF <= #2 1'b0;
    
    // Check if the current instruction writes to a register
    if (1) // Avoid handling registers 0
    begin
      // Check if the source registers of the IF stage instructions match the destination register of the current instruction
      if ((IF_ID_IR[25:21] == ID_EX_IR[15:11]) || (IF_ID_IR[20:16] == ID_EX_IR[15:11]))
      begin
        // Data hazard detected, set STALL_IF to 1
        STALL_IF <= #2 1'b1;
      end
    end

    // Rest of ID stage code
    if (IF_ID_IR[25:21] == 5'b00000)
      ID_EX_A <= 0;
    else
      ID_EX_A <= #2 Reg[IF_ID_IR[25:21]]; // "rs"
    if (IF_ID_IR[20:16] == 5'b00000)
      ID_EX_B <= 0;
    else
      ID_EX_B <= #2 Reg[IF_ID_IR[20:16]]; // "rt"
    ID_EX_NPC <= #2 IF_ID_NPC;
    ID_EX_IR <= #2 IF_ID_IR;
    ID_EX_Imm <= #2 {{16{IF_ID_IR[15]}}, {IF_ID_IR[15:0]}};
    case (IF_ID_IR[31:26])
      ADD,SUB,AND,OR,SLT,MUL:
        ID_EX_type <= #2 RR_ALU;
      ADDI,SUBI,SLTI:
        ID_EX_type <= #2 RM_ALU;
      LW:
        ID_EX_type <= #2 LOAD;
      SW:
        ID_EX_type <= #2 STORE;
      BNEQZ,BEQZ:
        ID_EX_type <= #2 BRANCH;
      HLT:
        ID_EX_type <= #2 HALT;
      default:
        ID_EX_type <= #2 HALT;
      // Invalid opcode
    endcase
  end
end
    //************************************************************************
 always @(posedge clk1) // EX Stage
begin
  if (HALTED == 0)
  begin
    // Initialize STALL_IF to 0 at the beginning of each cycle
    STALL_IF <= #2 1'b0;

    EX_MEM_type <= #2 ID_EX_type;
    EX_MEM_IR <= #2 ID_EX_IR;
    TAKEN_BRANCH <= #2 0;
    case (ID_EX_type)
      RR_ALU:
      begin
        case (ID_EX_IR[31:26]) // "opcode"
          ADD:
            EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_B;
          SUB:
            EX_MEM_ALUOut <= #2 ID_EX_A - ID_EX_B;
          AND:
            EX_MEM_ALUOut <= #2 ID_EX_A & ID_EX_B;
          OR:
            EX_MEM_ALUOut <= #2 ID_EX_A | ID_EX_B;
          SLT:
            EX_MEM_ALUOut <= #2 ID_EX_A < ID_EX_B;
          MUL:
            EX_MEM_ALUOut <= #2 ID_EX_A * ID_EX_B;
          default:
            EX_MEM_ALUOut <= #2 32'hxxxxxxxx;
        endcase
      end
      RM_ALU:
      begin
        case (ID_EX_IR[31:26]) // "opcode"
          ADDI:
            EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_Imm;
          SUBI:
            EX_MEM_ALUOut <= #2 ID_EX_A - ID_EX_Imm;
          SLTI:
            EX_MEM_ALUOut <= #2 ID_EX_A < ID_EX_Imm;
          default:
            EX_MEM_ALUOut <= #2 32'hxxxxxxxx;
        endcase
      end
      LOAD, STORE:
      begin
        EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_Imm;
        EX_MEM_B <= #2 ID_EX_B;
      end
      BRANCH:
      begin
        EX_MEM_ALUOut <= #2 ID_EX_NPC + ID_EX_Imm;
        EX_MEM_cond <= #2 (ID_EX_A == 0);
      end
    endcase

    // Data Hazard Detection
    if (ID_EX_type != HALT) // Exclude HALT instruction from hazard detection
    begin
      // Check if the destination register of the current instruction matches the source registers of instructions in the ID stage
      if (((ID_EX_IR[15:11] == IF_ID_IR[25:21]) || (ID_EX_IR[15:11] == IF_ID_IR[20:16])) &&
          (IF_ID_IR[25:21] != 5'b00000) && (IF_ID_IR[20:16] != 5'b00000))
      begin
        // Data hazard detected, set STALL_IF to 1
        STALL_IF <= #2 1'b1;
        // You may also introduce control signals to manage stall cycles or forwarding here
      end
    end
  end
end
    //************************************************************************
  
 always @(posedge clk2) // MEM Stage
begin
  if (HALTED == 0)
  begin
    // Initialize STALL_IF to 0 at the beginning of each cycle
    STALL_IF <= #2 1'b0;

    MEM_WB_type <= EX_MEM_type;
    MEM_WB_IR <= #2 EX_MEM_IR;

    // Data Hazard Detection
    if (1) // Only perform hazard detection for memory operations
    begin
      // Check if the destination register of the current instruction in the MEM stage matches the source registers
      // of instructions in the ID and EX stages
      if (((EX_MEM_IR[15:11] == ID_EX_IR[15:11]) || (EX_MEM_IR[15:11] == IF_ID_IR[25:21]) ||
          (EX_MEM_IR[15:11] == IF_ID_IR[20:16])) &&
          (ID_EX_IR[15:11] != 5'b00000) && (IF_ID_IR[25:21] != 5'b00000) && (IF_ID_IR[20:16] != 5'b00000))
      begin
        // Data hazard detected, set STALL_IF to 1
        STALL_IF <= #2 1'b1;
        // You may also introduce control signals to manage stall cycles or forwarding here
      end
    end

    // Perform other operations based on the instruction type
    case (EX_MEM_type)
      RR_ALU, RM_ALU:
        MEM_WB_ALUOut <= #2 EX_MEM_ALUOut;
      LOAD:
        MEM_WB_LMD <= #2 Mem[EX_MEM_ALUOut];
      STORE:
        if (TAKEN_BRANCH == 0) // Disable write
          Mem[EX_MEM_ALUOut] <= #2 EX_MEM_B;
    endcase
  end
end

  
   //************************************************************************ 
  always @(posedge clk1) // WB Stage
  begin
    if (TAKEN_BRANCH == 0) // Disable write if branch taken
    case (MEM_WB_type)
      RR_ALU:
        Reg[MEM_WB_IR[15:11]] <= #2 MEM_WB_ALUOut; // "rd"
      RM_ALU:
        Reg[MEM_WB_IR[20:16]] <= #2 MEM_WB_ALUOut; // "rt"
      LOAD:
        Reg[MEM_WB_IR[20:16]] <= #2 MEM_WB_LMD; // "rt"
      HALT:
        HALTED <= #2 1'b1;
    endcase
  end

   //**** Battery Control
  always @(posedge clk1) // Assigning reg 32 to output bat_ctl to control VGA
  begin
      bat_ctl <= Reg[31][4:0];
  end

   
endmodule
