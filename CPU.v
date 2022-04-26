`include "Mux.v"
`include "PC_REG.v"
`include "Jump_CTRL.v"
`include "Adder.v"
`include "IF_ID_REG.v"
`include "Main_CTRL.v"
`include "Register_File.v"
`include "ID_EX_REG.v"
`include "ALU_SRC.v"
`include "ALU.v"
`include "EX_MEM_REG.v"
`include "MainMemory.v"
`include "MEM_WB_REG.v"
`include "InstructionRAM.v"
`include "Hazard_Detect.v"
`include "Forward_Unit.v"

module CPU(CLOCK,
           RESET);
    input CLOCK, RESET;
    
    wire [31:0] PCJumpAddr_D,                                           //32-bit PC address for jumping
    PCBranched,  PCJumped,                                              //32-bit PC address considering the jumping and branching
    PCPlus4_F, PCPlus4_D, PCPlus4_E, PCPlus4_M, PCPlus4_W,              //32-bit PC address + 4
    PCBranchAddr_D, PC_F,                                               //32-bit PC address branched
    Inst_F, Inst_D,                                                     //32-bit instruction
    RegWriteData_W,                                                     //32-bit data to be written in the register file
    RegReadData1_D, RegReadData1_E, Reg1DataForward,                    //32-bit data read from register file
    RegReadData2_D, RegReadData2_E, Reg2DataForward,                    //32-bit data read from register file
    ALUOut_E, ALUOut_M, ALUOut_W,                                       //32-bit data from ALU
    MemWriteData_M,                                                     //32-bit data to be written in the memory
    MemReadData_M, MemReadData_W;                                       //32-bit data read from RAM
    wire signed [31:0] Op1, Op2;                                        //32-bit signed data as ALU's operands
    wire [15:0] Imm_D, Imm_E;                                           //16-bit immediate field from the instruction
    wire [5:0]  Opcode_D,                                               //6-bit opcode
    Func_D;                                                             //6-bit function code
    wire [4:0] RegAddr1_D, RegAddr2_D,                                  //5-bit register address that reads data from register file
    ALUCtrl_D,    ALUCtrl_E,                                            //control signal for ALU operation
    ALUSrc_D,     ALUSrc_E,                                             //control signal for ALU operands
    RegAddr3_E, RegAddr3_M, RegAddr3_W,                                 //5-bit register address that writes data to register file
    Rs_D, Rs_E, Rt_D, Rd_D, Rt_E, Rd_E,                                 //5-bit register address of Rs, Rt, Rd from instruction
    Shamt_D, Shamt_E;                                                   //5-bit shift amount from instruction
    wire [1:0] JSEL,                                                    //selection signal for jump                
    RegDstSEL_D,  RegDstSEL_E,                                          //selection signal for write back register address
    ForwardReg1SEL, ForwardReg2SEL,                                     //select signal for reg data forwarding
    Mem2RegSEL_D, Mem2RegSEL_E, Mem2RegSEL_M, Mem2RegSEL_W;             //select signal between ALU result and memory read
    wire PC_ID_RESET,
    PCSrc_D,                                                            //select signal between branch and PC+4
    RegWriteEN_D, RegWriteEN_E, RegWriteEN_M, RegWriteEN_W,             //enable signal for register write
    MemWriteEN_D, MemWriteEN_E, MemWriteEN_M,                           //enable signal for memory write
    Jr_D,                                                               //select signal for jr
    Beq_D,     Beq_E,     Beq_M,                                        //select signal for beq
    Bne_D,     Bne_E,     Bne_M,                                        //select signal for bne
    Stall_F, Stall_D, Flush_E,                                          //stalling and flushing signals
    ZeroFlag_E,   ZeroFlag_M;                                           //indicator for zero flag
    localparam ReturnAddrReg = 5'd31;                                   //Address of $ra
    
    
    
    // ==  ==  ==  ==  ==     Dealing with hazard     ==  ==  ==  ==  == 
    Forward_Unit forward_unit(Rs_E, Rt_E, RegAddr3_M, RegAddr3_W, RegWriteEN_M, RegWriteEN_W, ForwardReg1SEL, ForwardReg2SEL);
    Hazard_Detect hazard_detect(Rs_D, Rt_D, Rt_E, Mem2RegSEL_E, Stall_F, Stall_D, Flush_E);
    assign PC_ID_RESET = PCSrc_D;

    // ==  ==  ==  ==  == Stage1: Instruction Fetch ==  ==  ==  ==  == 
    Mux2_1 #(32) branch_sel(PCPlus4_F, PCBranchAddr_D, PCSrc_D, PCBranched);
    Mux3_1 #(32) jump_sel(PCBranched, PCJumpAddr_D, RegReadData1_D, JSEL, PCJumped);
    PC_REG pc_register(CLOCK, PC_ID_RESET, Stall_F, PCJumped, PC_F);
    ADDER  #(32) pc_adder(PC_F, 32'd4, PCPlus4_F);
    InstructionRAM instructionram(PC_F, Inst_F);
    IF_ID_REG if_id_reg(CLOCK, PC_ID_RESET, STALL_D,
                        Inst_F, PCPlus4_F, 
                        Inst_D, PCPlus4_D);
    
    // ==  ==  ==  ==  == Stage2: Instruction Decode ==  ==  ==  ==  == 
    assign Opcode_D       = Inst_D[31:26];
    assign Func_D         = Inst_D[5:0];
    assign RegAddr1_D     = Inst_D[25:21];
    assign RegAddr2_D     = Inst_D[20:16];
    assign Rs_D           = Inst_D[25:21];
    assign Rt_D           = Inst_D[20:16];
    assign Rd_D           = Inst_D[15:11];
    assign Shamt_D        = Inst_D[10:6];
    assign Imm_D          = Inst_D[15:0];
    assign PCJumpAddr_D   = {{PCPlus4_D[31:28]}, Inst_D[25:0]<< 2};
    assign PCSrc_D        = ((Beq_D & (RegReadData1_D == RegReadData2_D) || Bne_D & (RegReadData1_D != RegReadData2_D))===1)? 1:0;
    assign PCBranchAddr_D = ({{16{Imm_D[15]}}, Imm_D<< 2} ) + PCPlus4_D - 4;
    Jump_CTRL jump_ctrl(Opcode_D, Func_D, JSEL);
    Register_File register_file(CLOCK, RESET, 
                                RegAddr1_D, RegAddr2_D, RegAddr3_W, RegWriteData_W, RegWriteEN_W,
                                RegReadData1_D, RegReadData2_D);
    Main_CTRL main_ctrl(Opcode_D, Func_D, 
                        RegWriteEN_D, Mem2RegSEL_D, MemWriteEN_D, Beq_D, Bne_D, Jr_D, ALUCtrl_D, ALUSrc_D, RegDstSEL_D);
    ID_EX_REG id_ex_reg(CLOCK, Flush_E | PCSrc_D, 
                        RegWriteEN_D, Mem2RegSEL_D, MemWriteEN_D, Beq_D, Bne_D, ALUCtrl_D, ALUSrc_D, RegDstSEL_D, RegReadData1_D, RegReadData2_D, Rs_D, Rt_D, Rd_D, Shamt_D, Imm_D, PCPlus4_D,
                        RegWriteEN_E, Mem2RegSEL_E, MemWriteEN_E, Beq_E, Bne_E, ALUCtrl_E, ALUSrc_E, RegDstSEL_E, RegReadData1_E, RegReadData2_E, Rs_E, Rt_E, Rd_E, Shamt_E, Imm_E, PCPlus4_E);

    // ==  ==  ==  ==  == Stage3: Instruction Execution ==  ==  ==  ==  == 
    Mux3_1#(5) regdstselction (Rt_E, Rd_E, ReturnAddrReg, RegDstSEL_E, RegAddr3_E);
    Mux3_1#(32) reg1fwd(RegReadData1_E, ALUOut_M, RegWriteData_W, ForwardReg1SEL, Reg1DataForward);
    Mux3_1#(32) reg2fwd(RegReadData2_E, ALUOut_M, RegWriteData_W, ForwardReg2SEL, Reg2DataForward);
    ALU_SRC alu_src(ALUSrc_E, Reg1DataForward, Reg2DataForward, Shamt_E, Imm_E, Op1, Op2);
    ALU alu(ALUCtrl_E, Op1, Op2, ALUOut_E, ZeroFlag_E);
    EX_MEM_REG ex_mem_reg(CLOCK,
                          RegWriteEN_E, Mem2RegSEL_E, MemWriteEN_E, Beq_E, Bne_E, ZeroFlag_E, ALUOut_E, Reg2DataForward, RegAddr3_E, PCPlus4_E, 
                          RegWriteEN_M, Mem2RegSEL_M, MemWriteEN_M, Beq_M, Bne_M, ZeroFlag_M, ALUOut_M, MemWriteData_M, RegAddr3_M, PCPlus4_M);

    // ==  ==  ==  ==  == Stage4: Memory Access ==  ==  ==  ==  == 
    MainMemory mainmemory(CLOCK, RESET, MemWriteEN_M, ALUOut_M>>2,  MemWriteData_M,  MemReadData_M);
    MEM_WB_REG mem_wb_reg(CLOCK,
                          RegWriteEN_M, Mem2RegSEL_M, ALUOut_M, MemReadData_M, RegAddr3_M,PCPlus4_M,
                          RegWriteEN_W, Mem2RegSEL_W, ALUOut_W, MemReadData_W, RegAddr3_W,PCPlus4_W);
    
    // ==  ==  ==  ==  == Stage5: Write Back ==  ==  ==  ==  == 
    Mux3_1#(32) wbdataselection(ALUOut_W, MemReadData_W, PCPlus4_W, Mem2RegSEL_W, RegWriteData_W);
    
    
endmodule
