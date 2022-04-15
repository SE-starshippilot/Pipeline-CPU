module EX_MEM_REG(CLOCK,          //clock
                  RegWriteEN_In,  //enable signal for register write
                  Mem2RegSEL_In,  //select signal between ALU result and memory output
                  MemWriteEN_In,  //enable signal for memory write
                  Branch_In,      //branch signal
                  ZeroFlag_In,
                  ALUResult_In,
                  WriteData_In,   //data to be written in memory
                  WriteReg_In,    //data to be written in register
                  PC_In,
                  RegWriteEN_Out,
                  Mem2RegSEL_Out,
                  MemWriteEN_Out,
                  Branch_Out,
                  ZeroFlag_Out,
                  ALUResult_Out,
                  WriteData_Out,
                  WriteReg_Out,
                  PC_Out);
    
    input CLOCK, RegWriteEN_In, Mem2RegSEL_In, MemWriteEN_In, Branch_In, ZeroFlag_In;
    input [31:0] ALUResult_In, WriteData_In, WriteReg_In, PC_In;
    output reg RegWriteEN_Out, Mem2RegSEL_Out, MemWriteEN_Out, Branch_Out, ZeroFlag_Out;
    output reg [31:0] ALUResult_Out, WriteData_Out, WriteReg_Out, PC_Out;
    
    always @ (posedge CLOCK) begin
        RegWriteEN_Out = RegWriteEN_In;
        Mem2RegSEL_Out = Mem2RegSEL_In;
        MemWriteEN_Out = MemWriteEN_In;
        Branch_Out     = Branch_In   ;
        ZeroFlag_Out   = ZeroFlag_In;
        ALUResult_Out  = ALUResult_In;
        WriteData_Out  = WriteData_In;
        WriteReg_Out   = WriteReg_In;
        PC_Out         = PC_In  ;
    end
        endmodule
