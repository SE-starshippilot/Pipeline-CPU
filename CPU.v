`include "Mux.v"
`include "ALU.v"
`include "PC_REG.v"
`include "ALU_SRC.v"
`include "IF_ID_REG.v"
`include "ID_EX_REG.v"
`include "EX_MEM_REG.v"
`include "MEM_WB_REG.v"
`include "Jump_CTRL.v"
`include "Main_CTRL.v"
`include "MainMemory.v"
`include "Hazard_Detect.v"
`include "Forward_Unit.v"
`include "Register_File.v"
`include "InstructionRAM.v"

module CPU(CLOCK,
           RESET);
    input CLOCK, RESET;
    
    wire [31:0] PCBranchAddr_D, PCJumpAddr_D,                           //PC address calculated for branching and jumping
    PCBranched,  PCJumped,                                              //PC address considering branching and jumping
    PC_F,                                                               //PC address from PC register
    PCPlus4_F, PCPlus4_D, PCPlus4_E, PCPlus4_M, PCPlus4_W,              //PC address + 4
    Inst_F, Inst_D,                                                     //instruction
    Fwd1Data_D, Fwd2Data_D, Fwd1Data_E, Fwd2Data_E,                     //data forwarded at ID and EX stage
    RegWriteData_W,                                                     //data to be written in the register file
    RegReadData1_D, RegReadData2_D, RegReadData1_E, RegReadData2_E,     //data read from register file
    ALUOut_E, ALUOut_M, ALUOut_W,                                       //data from ALU
    MemWriteData_M,                                                     //data to be written in the memory
    MemReadData_M, MemReadData_W;                                       //data read from RAM
    wire signed [31:0] Op1, Op2;                                        //signed data as ALU's operands
    wire [15:0] Imm_D, Imm_E;                                           //immediate field from the instruction
    wire [5:0]  Opcode_D,                                               //opcode
    Func_D;                                                             //function code
    wire [4:0] RegAddr1_D, RegAddr2_D,                                  //register address that reads data from register file
    ALUCtrl_D, ALUCtrl_E,                                               //control signal for ALU operation
    ALUSrc_D, ALUSrc_E,                                                 //control signal for ALU operands
    RegAddr3_E, RegAddr3_M, RegAddr3_W,                                 //register address that writes data to register file
    Rs_D, Rs_E, Rt_D, Rd_D, Rt_E, Rd_E,                                 //register address of Rs, Rt, Rd from instruction
    Shamt_D, Shamt_E;                                                   //shift amount from instruction
    wire [1:0] JSEL,                                                    //selection signal for jump 
    Fwd1SEL_D, Fwd2SEL_D, Fwd1SEL_E, Fwd2SEL_E,                         //selection signal for farwarding    
    RegDstAddrSEL_D,  RegDstAddrSEL_E,                                          //selection signal for write back register address
    ForwardReg1SEL, ForwardReg2SEL,                                     //select signal for reg data forwarding
    RegDstDataSEL_D, RegDstDataSEL_E, RegDstDataSEL_M, RegDstDataSEL_W;             //select signal between ALU result and memory read
    wire BranchSEL_D,                                                   //select signal between branch and PC+4
    RegWriteEN_D, RegWriteEN_E, RegWriteEN_M, RegWriteEN_W,             //enable signal for register write
    MemWriteEN_D, MemWriteEN_E, MemWriteEN_M,                           //enable signal for memory write
    Jr_D,                                                               //select signal for jr
    Beq_D,                                                              //select signal for beq
    Bne_D,                                                              //select signal for bne
    Stall,                                                              //stalling and flushing signals
    ZeroFlag_E;                                                         //indicator for zero flag, actually not used.
    localparam ReturnAddrReg = 5'd31;                                   //address of $ra
    
    
    
    // ==  ==  ==  ==  ==     Dealing with hazard     ==  ==  ==  ==  == 
    Forward_Unit forward_unit(Stall, Rs_D, Rt_D, Rs_E, Rt_E, RegAddr3_E, RegAddr3_M, RegAddr3_W, RegWriteEN_E, RegWriteEN_M, RegWriteEN_W, 
                              Fwd1SEL_D, Fwd2SEL_D, Fwd1SEL_E, Fwd2SEL_E);
    Hazard_Detect hazard_detect(Rs_D, Rt_D, Rt_E, RegAddr3_E, RegAddr3_M, Beq_D, Bne_D, RegWriteEN_E, RegDstDataSEL_E, RegDstDataSEL_M, 
                                Stall);

    // ==  ==  ==  ==  == Stage1: Instruction Fetch ==  ==  ==  ==  == 
    Mux2_1 #(32) branch_sel(PCPlus4_F, PCBranchAddr_D, BranchSEL_D, PCBranched);
    Mux3_1 #(32) jump_sel(PCBranched, PCJumpAddr_D, Fwd1Data_D, JSEL, PCJumped);
    assign PCPlus4_F = PC_F + 32'd4;
    PC_REG pc_register(CLOCK, 1'b0, Stall, PCJumped, PC_F);
    InstructionRAM instruction_ram(PC_F, Inst_F);
    IF_ID_REG if_id_reg(CLOCK, 1'b0, Stall,
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
    assign BranchSEL_D    = ((Beq_D & (Fwd1Data_D == Fwd2Data_D) || Bne_D & (Fwd1Data_D != Fwd2Data_D))===1)? 1:0;
    assign PCBranchAddr_D = ({{16{Imm_D[15]}}, Imm_D<< 2} ) + PCPlus4_D;
    Jump_CTRL jump_ctrl(Opcode_D, Func_D, JSEL);
    Register_File register_file(CLOCK, RESET, RegAddr1_D, RegAddr2_D, RegAddr3_W, RegWriteData_W, RegWriteEN_W,
                                RegReadData1_D, RegReadData2_D);
    Mux3_1#(32) reg1_fwd_d(RegReadData1_D, ALUOut_E, MemReadData_M, Fwd1SEL_D, Fwd1Data_D);
    Mux3_1#(32) reg2_fwd_d(RegReadData2_D, ALUOut_E, MemReadData_M, Fwd2SEL_D, Fwd2Data_D);
    Main_CTRL main_ctrl(Opcode_D, Func_D, 
                        RegWriteEN_D, RegDstDataSEL_D, MemWriteEN_D, Beq_D, Bne_D, Jr_D, ALUCtrl_D, ALUSrc_D, RegDstAddrSEL_D);
    ID_EX_REG id_ex_reg(CLOCK, Stall, 
                        RegWriteEN_D, RegDstDataSEL_D, MemWriteEN_D, ALUCtrl_D, ALUSrc_D, RegDstAddrSEL_D, RegReadData1_D, RegReadData2_D, Rs_D, Rt_D, Rd_D, Shamt_D, Imm_D, PCPlus4_D,
                        RegWriteEN_E, RegDstDataSEL_E, MemWriteEN_E, ALUCtrl_E, ALUSrc_E, RegDstAddrSEL_E, RegReadData1_E, RegReadData2_E, Rs_E, Rt_E, Rd_E, Shamt_E, Imm_E, PCPlus4_E);

    // ==  ==  ==  ==  == Stage3: Instruction Execution ==  ==  ==  ==  == 
    Mux3_1#(5) reg_dst_selction (Rt_E, Rd_E, ReturnAddrReg, RegDstAddrSEL_E, RegAddr3_E);
    Mux3_1#(32) reg1_fwd_e(RegReadData1_E, ALUOut_M, RegWriteData_W, Fwd1SEL_E, Fwd1Data_E);
    Mux3_1#(32) reg2_fwd_e(RegReadData2_E, ALUOut_M, RegWriteData_W, Fwd2SEL_E, Fwd2Data_E);
    ALU_SRC alu_src(ALUSrc_E, Fwd1Data_E, Fwd2Data_E, Shamt_E, Imm_E, Op1, Op2);
    ALU alu(ALUCtrl_E, Op1, Op2, ALUOut_E, ZeroFlag_E);
    EX_MEM_REG ex_mem_reg(CLOCK,
                          RegWriteEN_E, RegDstDataSEL_E, MemWriteEN_E, ALUOut_E, Fwd2Data_E, RegAddr3_E, PCPlus4_E, 
                          RegWriteEN_M, RegDstDataSEL_M, MemWriteEN_M, ALUOut_M, MemWriteData_M, RegAddr3_M, PCPlus4_M);

    // ==  ==  ==  ==  == Stage4: Memory Access ==  ==  ==  ==  == 
    MainMemory main_memory(CLOCK, RESET, MemWriteEN_M, ALUOut_M>>2,  MemWriteData_M,  MemReadData_M);
    MEM_WB_REG mem_wb_reg(CLOCK,
                          RegWriteEN_M, RegDstDataSEL_M, ALUOut_M, MemReadData_M, RegAddr3_M,PCPlus4_M,
                          RegWriteEN_W, RegDstDataSEL_W, ALUOut_W, MemReadData_W, RegAddr3_W,PCPlus4_W);
    
    // ==  ==  ==  ==  == Stage5: Write Back ==  ==  ==  ==  == 
    Mux3_1#(32) wbdata_sel(ALUOut_W, MemReadData_W, PCPlus4_W, RegDstDataSEL_W, RegWriteData_W);
    
    
endmodule
