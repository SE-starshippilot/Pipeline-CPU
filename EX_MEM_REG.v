module EX_MEM_REG(CLOCK,
                  RegWriteEN_In,  //enable signal for register write
                  Mem2RegSEL_In,  //select signal between ALU result and memory read
                  MemWriteEN_In,  //enable signal for memory write
                  ALUResult_In,
                  WriteData_In,   //data to be written in memory
                  RegWBAddr_In,   //address register to be written back
                  PCPlus4_In,

                  RegWriteEN_Out,
                  Mem2RegSEL_Out,
                  MemWriteEN_Out,
                  ALUResult_Out,
                  WriteData_Out,
                  RegWBAddr_Out,
                  PCPlus4_Out);
    
    input CLOCK, RegWriteEN_In, MemWriteEN_In;
    input [31:0] ALUResult_In, WriteData_In, PCPlus4_In;
    input [4:0] RegWBAddr_In;
    input [1:0] Mem2RegSEL_In;
    output reg RegWriteEN_Out,  MemWriteEN_Out;
    output reg [31:0] ALUResult_Out, WriteData_Out, PCPlus4_Out;
    output reg [4:0] RegWBAddr_Out;
    output reg [1:0] Mem2RegSEL_Out;
    
    always @ (posedge CLOCK) begin
        RegWriteEN_Out <= RegWriteEN_In;
        Mem2RegSEL_Out <= Mem2RegSEL_In;
        MemWriteEN_Out <= MemWriteEN_In;
        ALUResult_Out  <= ALUResult_In;
        WriteData_Out  <= WriteData_In;
        RegWBAddr_Out  <= RegWBAddr_In;
        PCPlus4_Out    <= PCPlus4_In;
    end
endmodule
