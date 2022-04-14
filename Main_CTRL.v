module Main_CTRL (input [5:0] opcode,
                  input [4:0] func,
                  output RegWriteD,
                  Mem2RegD,
                  MemWriteD,
                  ALUCtrlD,
                  ALUSrcD,
                  RegDstD);

    always @(opcode, func) begin
        
    end

endmodule //Main_CTRL
