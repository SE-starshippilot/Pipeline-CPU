module ID_CTRL_MUX(RESET,
                   RegWriteEN_In,  //enable signal for register write
                   RegSrcSEL_In,   //select signal between ALU result and memory output
                   MemWriteEN_In,  //enable signal for memory write
                   Beq_In,         //beq signal
                   Bne_In,         //bne signal
                   ALUCtrl_In,     //control signal for determine ALU operation
                   ALUSrc_In,      //control signal for determine ALU sources
                   RegDstSEL_In,   //selection signal for determine target register address
                   RegWriteEN_Out,
                   RegDstSEL_Out,
                   MemWriteEN_Out,
                   Beq_Out,
                   Bne_Out,
                   ALUCtrl_Out,
                   ALUSrc_Out,
                   RegDstSEL_Out);
    
    input RESET, RegWriteEN_In, MemWriteEN_In, Beq_In, Bne_In;
    input [1:0] RegDstSEL_In, RegSrcSEL_In;
    input [4:0] ALUCtrl_In, ALUSrc_In;
    
    output reg  RegWriteEN_Out, MemWriteEN_Out, Beq_Out, Bne_Out;
    output reg [1:0] RegDstSEL_Out, RegSrcSEL_Out;
    output reg [4:0] ALUCtrl_Out, ALUSrc_Out;
    
    always @(*) begin
        RegWriteEN_Out = (RESET === 1'b1)? 0:RegWriteEN_In;
        RegDstSEL_Out  = (RESET === 1'b1)? 0:RegDstSEL_In;
        MemWriteEN_Out = (RESET === 1'b1)? 0:MemWriteEN_In;
        Beq_Out        = (RESET === 1'b1)? 0:Beq_In;
        Bne_Out        = (RESET === 1'b1)? 0:Bne_In;
        ALUCtrl_Out    = (RESET === 1'b1)? 0:ALUCtrl_In;
        ALUSrc_Out     = (RESET === 1'b1)? 0:ALUSrc_In;
        RegDstSEL_Out  = (RESET === 1'b1)? 0:RegDstSEL_In;
    end
endmodule
