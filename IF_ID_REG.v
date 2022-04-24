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
        if (RESET !== 1'b1 || ^RESET === 1'bx) begin
            if (STALL !== 1'b1 || ^STALL === 1'bx) begin
                Instruction_Out <=  Instruction_In;
                PCPlus4_Out     <=  PCPlus4_In;
            end
        end else begin
            Instruction_Out <= 32'b0;
            PCPlus4_Out <= PCPlus4_In;
        end
    end
endmodule
