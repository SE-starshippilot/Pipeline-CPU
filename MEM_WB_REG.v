module MEM_WB_REG(CLOCK,
                  RegWriteEN_In,
                  Mem2RegSEL_In,
                  ALUResult_In,
                  MemResult_In,
                  WriteBackRegAddr_In,

                  RegWriteEN_Out,
                  Mem2RegSEL_Out,
                  ALUResult_Out,
                  MemResult_Out,
                  WriteBackRegAddr_Out);
    input CLOCK, RegWriteEN_In, Mem2RegSEL_In;
    input [31:0] ALUResult_In, MemResult_In;
    input [4:0] WriteBackRegAddr_In;
    output reg RegWriteEN_Out, Mem2RegSEL_Out;
    output reg [31:0] ALUResult_Out, MemResult_Out;
    output reg [4:0] WriteBackRegAddr_Out;
    
    always @(posedge CLOCK) begin
        RegWriteEN_Out       <= RegWriteEN_In;
        Mem2RegSEL_Out       <= Mem2RegSEL_In;
        ALUResult_Out        <= ALUResult_In;
        MemResult_Out        <= MemResult_In;
        WriteBackRegAddr_Out <= WriteBackRegAddr_In;
    end
    
endmodule
