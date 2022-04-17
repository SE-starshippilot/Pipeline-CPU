module ID_EX_REG(CLOCK,
                 RegWriteEN_In,  //enable signal for register write
                 Mem2RegSEL_In,  //select signal between ALU result and memory output
                 MemWriteEN_In,  //enable signal for memory write
                 Branch_In,      //branch signal
                 ALUCtrl_In,     //control signal for determine ALU operation
                 ALUSrc_In,      //control signal for determine ALU sources
                 RegDstSEL_In,   //selection signal for determine target register address
                 RegData1_In,
                 RegData2_In,
                 RTAddr_In,
                 RDAddr_In,
                 Shamt_In,
                 Imm_In,

                 RegWriteEN_Out,
                 MemWriteEN_Out,
                 Mem2RegSEL_Out,
                 Branch_Out,
                 ALUCtrl_Out,
                 ALUSrc_Out,
                 RegDstSEL_Out,
                 RegData1_Out,
                 RegData2_Out,
                 RTAddr_Out,
                 RDAddr_Out,
                 Shamt_Out,
                 Imm_Out,
                 );
    
    input CLOCK, RegWriteEN_In, Mem2RegSEL_In, MemWriteEN_In, Branch_In, ALUCtrl_In, ALUSrc_In, RegDstSEL_In;
    input [31:0] RegData1_In, RegData2_In,  Imm_In;
    input [4:0] RTAddr_In, RDAddr_In, Shamt_In;
    output reg RegWriteEN_Out, Mem2RegSEL_Out, MemWriteEN_Out, Branch_Out, ALUCtrl_Out, ALUSrc_Out, RegDstSEL_Out;
    output reg [31:0] RegData1_Out, RegData2_Out, Imm_Out;
    output reg [4:0] RTAddr_Out, RDAddr_Out, Shamt_Out;
    always @(posedge CLOCK) begin
        RegWriteEN_Out <= RegWriteEN_In;
        Mem2RegSEL_Out <= Mem2RegSEL_In;
        MemWriteEN_Out <= MemWriteEN_In;
        Branch_Out     <= Branch_In;
        ALUCtrl_Out    <= ALUCtrl_In;
        ALUSrc_Out     <= ALUSrc_In;
        RegDstSEL_Out  <= RegDstSEL_In;
        RegData1_Out   <= RegData1_In;
        RegData2_Out   <= RegData2_In;
        Shamt_Out      <= Shamt_In;
        RTAddr_Out     <= RTAddr_In;
        RDAddr_Out     <= RDAddr_In;
        Imm_Out        <= Imm_In;
    end
endmodule
