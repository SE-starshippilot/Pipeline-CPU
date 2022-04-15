module ID_EX_REG(CLOCK,
                 RegWrite_In,
                 Mem2Reg_In,
                 MemWrite_In,
                 Branch_In,
                 ALUCtrl_In,
                 ALUSrc_In,
                 RegDst_In,
                 RegData1_In,
                 RegData2_In,
                 RTAddr_In,
                 RDAddr_In,
                 Mem2Reg_Out,
                 MemWrite_Out,
                 Branch_Out,
                 ALUCtrl_Out,
                 ALUSrc_Out,
                 RegDst_Out,
                 RegData1_Out,
                 RegData2_Out,
                 RTAddr_Out,
                 RDAddr_Out);
    
    input CLOCK, RegWrite_In, Mem2Reg_In, MemWrite_In, Branch_In, ALUCtrl_In, ALUSrc_In, RegDst_In;
    input [31:0] RegData1_In, RegData2_In;
    input [4:0] RTAddr_In, RDAddr_In;
    output reg RegWrite_Out, Mem2Reg_Out, MemWrite_Out, Branch_Out, ALUCtrl_Out, ALUSrc_Out, RegDst_Out;
    output reg [31:0] RegData1_Out, RegData2_Out;
    output reg [4:0] RTAddr_Out, RDAddr_Out;
    always @(posedge CLOCK) begin
        RegWrite_Out <= RegWrite_In;
        Mem2Reg_Out  <= Mem2Reg_In;
        MemWrite_Out <= MemWrite_In;
        Branch_Out   <= Branch_In;
        ALUCtrl_Out  <= ALUCtrl_In;
        ALUSrc_Out   <= ALUSrc_In;
        RegDst_Out   <= RegDst_In;
        RegData1_Out <= RegData1_In;
        RegData2_Out <= RegData2_In;
        RTAddr_Out   <= RTAddr_In;
        RDAddr_Out   <= RDAddr_In;
        
    end
endmodule
