module IF_ID_REG(CLOCK,
                 RESET,
                 STALL,
                 Instruction_In,
                 PCPlus4_In,
                 Instruction_Out,
                 PCPlus4_Out);
    input CLOCK, RESET, STALL;
    input [31:0] Instruction_In, PCPlus4_In;
    output reg [31:0] Instruction_Out, PCPlus4_Out;
    
    always @(posedge CLOCK) begin
        if (STALL !== 1'b1) begin
            if (RESET !== 1'b1) begin
                Instruction_Out <=  Instruction_In;
                PCPlus4_Out     <=  PCPlus4_In;
            end else begin
                Instruction_Out <= 32'b0;
                PCPlus4_Out     <= PCPlus4_In;
            end
        end 
    end
endmodule
