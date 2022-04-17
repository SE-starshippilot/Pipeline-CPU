`include "Mux.v"
`include "PC_REG.v"
`include "Adder.v"
`include "IF_ID_REG.v"
`include "Main_CTRL.v"
`include "Register_File.v"
`include "Imm_Extender.v"
`include "ID_EX_REG.v"
`include "ALU_SRC.v"

module CPU(CLOCK,
           RESET);
    input CLOCK, RESET;
    
    wire PCSrc_M, RegWriteEN_D, RegWriteEN_E, RegWriteEN_W, Mem2RegSEL_D, Mem2RegSEL_E, MemWriteEN_D, MemWriteEN_E, Branch_D, Branch_E, ALUCtrl_D, ALUCtrl_E, ALUSrc_D, ALUSrc_E, RegDstSEL_D, RegDstSEL_E;
    wire [31:0] PC, PCPlus4_F, PCPlus4_D, PCPlus4_E, PCBranch_E, PCBranch_M, PC_F, Inst_F, Inst_D, Imm_SignExt_E, Imm_ZeroExt_E, RegData_D, RegData_E, RegRead1_D, RegRead1_E, RegRead2_D, RegRead2_E;
    wire signed [31:0] Op1, Op2;
    wire [15:0] Imm_E;
    wire [4:0] RegAddr1, RegAddr2, RegAddr3_E, RegAddr3_M, RegAddr3_W, Rt_E, Rd_E, Shamt_E;
    
    
    
    // ==  ==  ==  ==  == Stage1: Instruction Fetch ==  ==  ==  ==  == 
    Mux2_1_32BIT pcselection(PCPlus4_F, PCBranch_M, PCSrc_M, PC);
    PC_REG pc_register(CLOCK, RESET, PC, PC_F);
    ADDER_32BIT pc_adder(PC_F, 32'd4, PCPlus4_F);
    IF_ID_REG if_id_reg(CLOCK, Inst_F, PCPlus4_F, Inst_D, PCPlus4_D);
    
    // ==  ==  ==  ==  == Stage2: Instruction Decode ==  ==  ==  ==  == 
    Main_CTRL main_ctrl(Inst_D[31:26], Inst_D[5:0], RegWriteEN_D, Mem2RegSEL_D, MemWriteEN_D, Branch_D, ALUCtrl_D, ALUSrc_D, RegDstSEL_D);
    Register_File register_file(CLOCK, RESET, Inst_D[25:21], Inst_D[20:16], RegAddr3_W, RegData_D, RegWriteEN_W, RegRead1_D, RegRead2_D);
    ID_EX_REG id_ex_reg(CLOCK, RegWriteEN_D, Mem2RegSEL_D, MemWriteEN_D, Branch_D, ALUCtrl_D,ALUSrc_D,RegDstSEL_D,RegRead1_D,RegRead2_D,Inst_D[20:16],Inst_D[15:11],Inst_D[10:6],Inst_D[15:0],PCPlus4_D, RegWriteEN_E, Mem2RegSEL_E, MemWriteEN_E, Branch_E, ALUCtrl_E, ALUSrc_E, RegDstSEL_E, RegRead1_E, RegRead2_E, Rt_E, Rd_E, Shamt_E, Imm_E, PCPlus4_E);
    
    // ==  ==  ==  ==  == Stage3: Instruction Execution ==  ==  ==  ==  ==
    assign PCBranch_E = ({{16{Imm_E[15]}}, Imm_E} << 2) + PCPlus4_E; 
    Mux2_1_5BIT regdstselction(Rt_E, Rd_E, RegDstSEL_E, RegAddr3_E);
    ALU_SRC alu_src(ALUSrc_E, RegRead1_E, RegRead2_E, Shamt_E, Imm_E, Op1, Op2);
    
    
    
    
    
endmodule
