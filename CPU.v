`include "Mux.v"
`include "PC_REG.v"
`include "Adder.v"
`include "IF_ID_REG.v"
`include "Main_CTRL.v"
`include "Register_File.v"
`include "ID_EX_REG.v"
`include "ALU_SRC.v"
`include "ALU.v"
`include "EX_MEM_REG.v"

module CPU(CLOCK,
           RESET);
    input CLOCK, RESET;
    
    wire PCSrc_M,                                                       //select signal between branch and PC+4
         RegWriteEN_D, RegWriteEN_E, RegWriteEN_M, RegWriteEN_W,        //enable signal for register write
         Mem2RegSEL_D, Mem2RegSEL_E, Mem2RegSEL_M, Mem2RegSEL_W,        //select signal between ALU result and memory read
         MemWriteEN_D, MemWriteEN_E, MemWriteEN_M,                      //enable signal for memory write
         Branch_D,     Branch_E,     Branch_M,                          //select signal for pc branching
         ALUCtrl_D,    ALUCtrl_E,                                       //control signal for ALU operation
         ALUSrc_D,     ALUSrc_E,                                        //control signal for ALU operands
         RegDstSEL_D,  RegDstSEL_E,                                     //selection signal for write back register address
         ZeroFlag_E,   ZeroFlag_M;                                      //indicator for zero flag
    wire [31:0] PC, PCPlus4_F, PCPlus4_D, PCPlus4_E,                    //32-bit PC address + 4
                PCBranch_E, PCBranch_M, PC_F,                           //32-bit PC address branched
                Inst_F, Inst_D,                                         //32-bit instruction
                RegWriteData_W,                                         //32-bit data to be written in the register file             
                RegReadData1_D, RegReadData1_E,                         //32-bit data read from register file
                RegReadData2_D, RegReadData2_E,                         //32-bit data read from register file
                ALUOut_E, ALUOut_M,                                     //32-bit data from ALU
                MemWriteData_M;                                         //32-bit data to be written in the memory                                         
    wire signed [31:0] Op1, Op2;                                        //32-bit signed data as ALU's operands
    wire [15:0] Imm_E;                                                  //16-bit immediate field from the instruction
    wire [4:0] RegAddr1, RegAddr2,                                      //5-bit register address that reads data from register file
               RegAddr3_E, RegAddr3_M, RegAddr3_W,                      //5-bit register address that writes data to register file
               Rt_E, Rd_E,                                              //5-bit register address of Rt, Rd from instruction
               Shamt_E;                                                 //5-bit shift amount from instruction
    
    
    
    // ==  ==  ==  ==  == Stage1: Instruction Fetch ==  ==  ==  ==  == 
    Mux2_1_32BIT pcselection(PCPlus4_F, PCBranch_M, PCSrc_M, PC);
    PC_REG pc_register(CLOCK, RESET, PC, PC_F);
    ADDER_32BIT pc_adder(PC_F, 32'd4, PCPlus4_F);
    IF_ID_REG if_id_reg(CLOCK, Inst_F, PCPlus4_F, Inst_D, PCPlus4_D);
    
    // ==  ==  ==  ==  == Stage2: Instruction Decode ==  ==  ==  ==  == 
    Main_CTRL main_ctrl(Inst_D[31:26], Inst_D[5:0], RegWriteEN_D, Mem2RegSEL_D, MemWriteEN_D, Branch_D, ALUCtrl_D, ALUSrc_D, RegDstSEL_D);
    Register_File register_file(CLOCK, RESET, Inst_D[25:21], Inst_D[20:16], RegAddr3_W, RegWriteData_W, RegWriteEN_W, RegReadData1_D, RegReadData2_D);
    ID_EX_REG id_ex_reg(CLOCK, RegWriteEN_D, Mem2RegSEL_D, MemWriteEN_D, Branch_D, ALUCtrl_D,ALUSrc_D,RegDstSEL_D,RegReadData1_D,RegReadData2_D,Inst_D[20:16],Inst_D[15:11],Inst_D[10:6],Inst_D[15:0],PCPlus4_D, RegWriteEN_E, Mem2RegSEL_E, MemWriteEN_E, Branch_E, ALUCtrl_E, ALUSrc_E, RegDstSEL_E, RegReadData1_E, RegReadData2_E, Rt_E, Rd_E, Shamt_E, Imm_E, PCPlus4_E);
    
    // ==  ==  ==  ==  == Stage3: Instruction Execution ==  ==  ==  ==  ==
    assign PCBranch_E = ({{16{Imm_E[15]}}, Imm_E} << 2) + PCPlus4_E; 
    Mux2_1_5BIT regdstselction(Rt_E, Rd_E, RegDstSEL_E, RegAddr3_E);
    ALU_SRC alu_src(ALUSrc_E, RegReadData1_E, RegReadData2_E, Shamt_E, Imm_E, Op1, Op2);
    ALU alu(ALUCtrl_E, Op1, Op2, ALUOut_E, ZeroFlag_E);
    EX_MEM_REG ex_mem_reg(CLOCK, RegWriteEN_E, Mem2RegSEL_E, MemWriteEN_E, Branch_E, ZeroFlag_E, ALUOut_E, RegReadData2_E, RegAddr3_E, PCBranch_E, RegWriteEN_M, Mem2RegSEL_M, MemWriteEN_M, Branch_M, ZeroFlag_M, ALUOut_M, MemWriteData_M, RegAddr3_M, PCBranch_M);
    
    
    
    
    
endmodule
