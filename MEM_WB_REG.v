module MEM_WB_REG(CLOCK,
                  RegWriteEN_In,
                  Mem2RegSEL_In,
                  ALUResult_In,
                  MemResult_In,
                  WriteBackRegAddr_In,
                  PCPlus4_In,

                  RegWriteEN_Out,
                  Mem2RegSEL_Out,
                  ALUResult_Out,
                  MemResult_Out,
                  WriteBackRegAddr_Out,
                  PCPlus4_Out);
    input [31:0] ALUResult_In, MemResult_In, PCPlus4_In;
    input [4:0] WriteBackRegAddr_In;
    input [1:0] Mem2RegSEL_In;
    input CLOCK, RegWriteEN_In;
    output reg [31:0] ALUResult_Out, MemResult_Out, PCPlus4_Out;
    output reg [4:0] WriteBackRegAddr_Out;
    output reg [1:0] Mem2RegSEL_Out;
    output reg RegWriteEN_Out;
    
    always @(posedge CLOCK) begin
        RegWriteEN_Out       <= RegWriteEN_In;
        Mem2RegSEL_Out       <= Mem2RegSEL_In;
        ALUResult_Out        <= ALUResult_In;
        MemResult_Out        <= MemResult_In;
        PCPlus4_Out          <= PCPlus4_In;
        WriteBackRegAddr_Out <= WriteBackRegAddr_In;
    end
    
endmodule
