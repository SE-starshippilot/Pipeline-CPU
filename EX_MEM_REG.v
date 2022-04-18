module EX_MEM_REG(CLOCK,
                  RegWriteEN_In,        //enable signal for register write
                  Mem2RegSEL_In,        //select signal between ALU result and memory read
                  MemWriteEN_In,        //enable signal for memory write
                  Beq_In,            //branch signal
                  Bne_In,            //branch signal
                  ZeroFlag_In,
                  ALUResult_In,
                  WriteData_In,         //data to be written in memory
                  WriteBackRegAddr_In,  //address register to be written back
                  PC_In,

                  RegWriteEN_Out,
                  Mem2RegSEL_Out,
                  MemWriteEN_Out,
                  Beq_Out,
                  Bne_Out,
                  ZeroFlag_Out,
                  ALUResult_Out,
                  WriteData_Out,
                  WriteBackRegAddr_Out,
                  PC_Out);
    
    input CLOCK, RegWriteEN_In, Mem2RegSEL_In, MemWriteEN_In, Beq_In, Bne_In, ZeroFlag_In;
    input [31:0] ALUResult_In, WriteData_In, PC_In;
    input [4:0] WriteBackRegAddr_In;
    output reg RegWriteEN_Out, Mem2RegSEL_Out, MemWriteEN_Out, Beq_Out, Bne_Out, ZeroFlag_Out;
    output reg [31:0] ALUResult_Out, WriteData_Out, PC_Out;
    output reg [4:0] WriteBackRegAddr_Out;
    
    always @ (posedge CLOCK) begin
        RegWriteEN_Out       <= RegWriteEN_In;
        Mem2RegSEL_Out       <= Mem2RegSEL_In;
        MemWriteEN_Out       <= MemWriteEN_In;
        Beq_Out           <= Beq_In   ;
        Bne_Out           <= Bne_In   ;
        ZeroFlag_Out         <= ZeroFlag_In;
        ALUResult_Out        <= ALUResult_In;
        WriteData_Out        <= WriteData_In;
        WriteBackRegAddr_Out <= WriteBackRegAddr_In;
        PC_Out               <= PC_In  ;
    end
endmodule
