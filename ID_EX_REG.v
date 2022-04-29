module ID_EX_REG(CLOCK,
                 RESET,
                 RegWriteEN_In,  //enable signal for register write
                 Mem2RegSEL_In,  //select signal between ALU result and memory output
                 MemWriteEN_In,  //enable signal for memory write
                 Beq_In,         //beq signal
                 Bne_In,         //bne signal
                 ALUCtrl_In,     //control signal for determine ALU operation
                 ALUSrc_In,      //control signal for determine ALU sources
                 RegDstSEL_In,   //selection signal for determine target register address
                 RegData1_In,
                 RegData2_In,
                 RSAddr_In,
                 RTAddr_In,
                 RDAddr_In,
                 Shamt_In,
                 Imm_In,
                 PCAddr_In,
                 RegWriteEN_Out,
                 Mem2RegSEL_Out,
                 MemWriteEN_Out,
                 Beq_Out,
                 Bne_Out,
                 ALUCtrl_Out,
                 ALUSrc_Out,
                 RegDstSEL_Out,
                 RegData1_Out,
                 RegData2_Out,
                 RSAddr_Out,
                 RTAddr_Out,
                 RDAddr_Out,
                 Shamt_Out,
                 Imm_Out,
                 PCAddr_Out);
    
    input CLOCK, RESET,RegWriteEN_In, MemWriteEN_In, Beq_In, Bne_In; 
    input [31:0] RegData1_In, RegData2_In, PCAddr_In;
    input [15:0] Imm_In;
    input [4:0] RSAddr_In, RTAddr_In, RDAddr_In, Shamt_In, ALUCtrl_In, ALUSrc_In;
    input [1:0]  Mem2RegSEL_In, RegDstSEL_In;
    output reg RegWriteEN_Out, MemWriteEN_Out, Beq_Out, Bne_Out;
    output reg [31:0] RegData1_Out, RegData2_Out, PCAddr_Out;
    output reg [15:0] Imm_Out;
    output reg [4:0] RSAddr_Out, RTAddr_Out, RDAddr_Out, Shamt_Out, ALUCtrl_Out, ALUSrc_Out;
    output reg [1:0] Mem2RegSEL_Out, RegDstSEL_Out;
 
    always @(posedge CLOCK) begin
        if (RESET === 1'b1) begin
            RegWriteEN_Out <= 0;
            Mem2RegSEL_Out <= 0;
            MemWriteEN_Out <= 0;
            Beq_Out        <= 0;
            Bne_Out        <= 0;
            ALUCtrl_Out    <= 0;
            ALUSrc_Out     <= 0;
            RegDstSEL_Out  <= 0;
        end else begin
            RegWriteEN_Out <= RegWriteEN_In;
            Mem2RegSEL_Out <= Mem2RegSEL_In;
            MemWriteEN_Out <= MemWriteEN_In;
            Beq_Out        <= Beq_In;
            Bne_Out        <= Bne_In;
            ALUCtrl_Out    <= ALUCtrl_In;
            ALUSrc_Out     <= ALUSrc_In;
            RegDstSEL_Out  <= RegDstSEL_In;
        end
        RegData1_Out   <= RegData1_In;
        RegData2_Out   <= RegData2_In;
        Shamt_Out      <= Shamt_In;
        RSAddr_Out     <= RSAddr_In;
        RTAddr_Out     <= RTAddr_In;
        RDAddr_Out     <= RDAddr_In;
        Imm_Out        <= Imm_In;
        PCAddr_Out     <= PCAddr_In;
    end
endmodule
