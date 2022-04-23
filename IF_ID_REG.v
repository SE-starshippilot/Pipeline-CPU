module IF_ID_REG(CLOCK,
                 RESET,
                 Instruction_In,
                 PCPlus4_In,
                 Instruction_Out,
                 PCPlus4_Out);
    input CLOCK, RESET;
    input [31:0] Instruction_In, PCPlus4_In;
    output reg [31:0] Instruction_Out, PCPlus4_Out;
    
    always @(posedge CLOCK) begin
        if (RESET !== 1'b1) begin
            Instruction_Out <= Instruction_In;
            PCPlus4_Out     <= PCPlus4_In;
        end
    end
endmodule
