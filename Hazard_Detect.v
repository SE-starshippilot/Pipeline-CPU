module Hazard_Detect(
                   RsAddr_D,
                   RtAddr_D,
                   RtAddr_E,
                   RegAddr3_E,
                   RegAddr3_M,
                   Beq,
                   Bne,
                   RegWriteEN_E,
                   Mem2RegSEL_E,
                   Mem2RegSEL_M,

                   Stall);
    input [4:0] RsAddr_D, RtAddr_D, RtAddr_E, RegAddr3_E, RegAddr3_M;
    input [1:0] Mem2RegSEL_E, Mem2RegSEL_M;
    input Beq, Bne, RegWriteEN_E;
    output reg Stall;
    initial begin
        Stall <= 0;
    end
    
    always @(*) begin
        Stall <= 0;
        if (
                ((RsAddr_D == RtAddr_E || RtAddr_D == RtAddr_E) && Mem2RegSEL_E != 0 ) ||                           //LW stall: if LW follows instruction that tries to use data from memory
                ((Beq || Bne) && (Mem2RegSEL_M != 0  && (RsAddr_D == RegAddr3_M || RtAddr_D == RegAddr3_M))         //Branch stall: if branch try to get register data from MEM stage
                )
            ) 
        begin 
            Stall <= 1;
        end

    end
    
endmodule
