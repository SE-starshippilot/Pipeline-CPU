module Forward_Unit(
    RsAddr,
    RtAddr,
    RegDstAddr_M,
    RegDstAddr_W,
    RegWriteEN_M,
    RegWriteEN_W,
    Fwd1AddrSEL,
    Fwd2AddrSEL
);
    input [4:0] RsAddr, RtAddr, RegDstAddr_M, RegDstAddr_W;
    input RegWriteEN_M, RegWriteEN_W;
    output reg [1:0] Fwd1AddrSEL, Fwd2AddrSEL;

    always @(*) begin
        Fwd1AddrSEL <= 0;
        Fwd2AddrSEL <= 0;
        if(RegWriteEN_M == 1 && RegDstAddr_M != 0) begin
            if(RegDstAddr_M == RsAddr)
                Fwd1AddrSEL <= 1;
            else if(RegDstAddr_M == RtAddr)
                Fwd2AddrSEL <= 1;
        end
        if (RegWriteEN_W == 1 && RegDstAddr_W != 0) begin
            if(RegDstAddr_W == RsAddr)
                Fwd1AddrSEL <= 2;
            else if(RegDstAddr_W == RtAddr)
                Fwd2AddrSEL <= 2;
        end
    end
endmodule