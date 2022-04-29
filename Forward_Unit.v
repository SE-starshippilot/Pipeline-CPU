module Forward_Unit(
    STALL,
    RsAddr_D,
    RtAddr_D,
    RsAddr_E,
    RtAddr_E,
    RegDstAddr_E,
    RegDstAddr_M,
    RegDstAddr_W,
    RegWriteEN_E,
    RegWriteEN_M,
    RegWriteEN_W,

    Fwd1AddrSEL_D,
    Fwd2AddrSEL_D,
    Fwd1AddrSEL_E,
    Fwd2AddrSEL_E
);
    input [4:0] RsAddr_D, RtAddr_D, RsAddr_E, RtAddr_E, RegDstAddr_E, RegDstAddr_M, RegDstAddr_W;
    input STALL, RegWriteEN_E, RegWriteEN_M, RegWriteEN_W;
    output reg [1:0]Fwd1AddrSEL_E, Fwd2AddrSEL_E, Fwd1AddrSEL_D, Fwd2AddrSEL_D;

    always @(*) begin
        if (STALL === 0) begin
            Fwd1AddrSEL_D <= 0;
            Fwd2AddrSEL_D <= 0;
            Fwd1AddrSEL_E <= 0;
            Fwd2AddrSEL_E <= 0;
            //  Control hazard related with Beq/Bne, happens upon instructin decode
            if (RegWriteEN_E == 1 && RegDstAddr_E != 0) begin  
                if(RegDstAddr_E == RsAddr_D) 
                    Fwd1AddrSEL_D <= 1;    //for hazard that attempts to use data from ALU at EX stage
                if(RegDstAddr_E == RtAddr_D) 
                    Fwd2AddrSEL_D <= 1;    //for hazard that attempts to use data from ALU at EX stage
            end
            //  Data hazard related with R type instructions, happens upon execution
            if (RegWriteEN_M == 1 && RegDstAddr_M != 0) begin
                if (RegDstAddr_M == RsAddr_D)       //for hazard that attempts to use data from MEM
                    Fwd1AddrSEL_D <= 2;
                if (RegDstAddr_M == RtAddr_D)       //for hazard that attempts to use data from MEM
                    Fwd2AddrSEL_D <= 2;
                if(RegDstAddr_M == RsAddr_E)            //for hazard that attempts to use data from ALU at MEM stage
                    Fwd1AddrSEL_E <= 1;
                if(RegDstAddr_M == RtAddr_E)            //for hazard that attempts to use data from ALU at MEM stage
                    Fwd2AddrSEL_E <= 1;
            end
            if (RegWriteEN_W == 1 && RegDstAddr_W != 0) begin
                if (RegDstAddr_W ==  RsAddr_E)
                    Fwd1AddrSEL_E <= 2;
                if (RegDstAddr_W == RtAddr_E)
                    Fwd2AddrSEL_E <= 2;
            end
        end
    end
endmodule

module Forward_Unit2(
   RsAddr_D,
   RtAddr_D,
   RegDstAddr_M,
   RegWriteEN_M,
   Fwd1AddrSEL,
   Fwd2AddrSEL
);
    input [4:0] RsAddr_D, RtAddr_D, RegDstAddr_M;
    input RegWriteEN_M;
    output reg Fwd1AddrSEL, Fwd2AddrSEL;

    always @(*) begin
        Fwd1AddrSEL <= 0;
        Fwd2AddrSEL <= 0;
        if (RsAddr_D != 0 && (RsAddr_D == RegDstAddr_M) && RegWriteEN_M) Fwd1AddrSEL <= 1;
        if (RtAddr_D != 0 && (RtAddr_D == RegDstAddr_M) && RegWriteEN_M) Fwd1AddrSEL <= 1;
    end
endmodule