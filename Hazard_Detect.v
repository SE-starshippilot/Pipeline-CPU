module Hazard_Detect(
                   RsAddr_D,
                   RtAddr_D,
                   RtAddr_E,
                   Mem2RegSEL,
                   Stall_F,
                   Stall_D,
                   Flush_E);
    input [4:0] RsAddr_D, RtAddr_D, RtAddr_E;
    input [1:0] Mem2RegSEL;
    output reg Stall_F, Stall_D, Flush_E;
    initial begin
        Stall_D <= 0;
        Stall_F <= 0;
        Flush_E <= 0;
    end
    
    always @(*) begin
        Stall_D <= 0;
        Stall_F <= 0;
        Flush_E <= 0;
        if ((RsAddr_D == RtAddr_E || RtAddr_D == RtAddr_E) && Mem2RegSEL === 1 ) begin //Only LW can cause stalling
            Stall_D <= 1;
            Stall_F <= 1;
            Flush_E <= 1;
        end
    end
    
endmodule
