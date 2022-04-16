`include "Mux.v"
`include "PC_REG.v"
`include "Adder.v"
`include "IF_ID_REG.v"
`include "Main_CTRL.v"
`include "Register_File.v"
`include "Imm_Extender.v"
`include "ID_EX_REG.v"

module CPU(CLOCK,
           RESET);
    input CLOCK, RESET;
    
    wire PCSrcM, RegWriteEN_D, RegWriteEN_E, RegWriteEN_W, Mem2RegSEL_D, Mem2RegSEL_E, MemWriteEN_D, MemWriteEN_E, Branch_D, Branch_E, ALUCtrl_D, ALUCtrl_E, ALUSrc_D, ALUSrc_E, RegDstSEL_D, RegDstSEL_E;
    wire [31:0] PC, PCPlus4F, PCPlus4D, PCBranchM, PCF, InstF, InstD, Imm_SignExt_D, Imm_SignExt_E, Imm_ZeroExt_D, Imm_ZeroExt_E, RegData_D, RegData_E, RegRead1_D, RegRead1_E, RegRead2_D, RegRead2_E;
    wire [15:0] Imm;
    wire [4:0] RegAddr1, RegAddr2,RegAddr3, RtD, RtE, RdD, RdE;
    
    
    
    // ==  ==  ==  ==  == Stage1: Instruction Fetch ==  ==  ==  ==  == 
    Mux2_1_32BIT pcselection(PCPlus4F, PCBranchM, PCSrcM, PC);
    PC_REG pc_register(CLOCK, RESET, PC, PCF);
    ADDER_32BIT pc_adder(PCF, 32'd4, PCPlus4F);
    IF_ID_REG if_id_reg(CLOCK, InstF, PCPlus4F, InstD, PCPlus4D);
    
    // ==  ==  ==  ==  == Stage2: Instruction Decode ==  ==  ==  ==  == 
    assign RtD = InstD[20:16];
    assign RdD = InstD[15:11];
    Main_CTRL main_ctrl(InstD[31:26], InstD[5:0], RegWriteEN_D, Mem2RegSEL_D, MemWriteEN_D, Branch_D, ALUCtrl_D, ALUSrc_D, RegDstSEL_D);
    Imm_Extender imm_extender(InstD[15:0], Imm_SignExt_D, Imm_ZeroExt_D);
    Register_File register_file(CLOCK, RESET, InstD[25:21], InstD[20:16], RegAddr3, RegData_D, RegWriteEN_W, RegRead1_D, RegRead2_D);
    ID_EX_REG id_ex_reg(CLOCK, RegWriteEN_D,Mem2RegSEL_D, MemWriteEN_D, Branch_D, ALUCtrl_D, ALUSrc_D, RegDstSEL_D, RegRead1_D, RegRead2_D, RtD, RdD, Imm_SignExt_D, Imm_ZeroExt_D, RegWriteEN_E, MemWriteEN_E, Mem2RegSEL_E, Branch_E, ALUCtrl_E, ALUSrc_E, RegDstSEL_E, RegRead1_E, RegRead2_E, RtE, RdE, Imm_SignExt_E, Imm_ZeroExt_E);
    
    
    
    
    
    
    
endmodule
