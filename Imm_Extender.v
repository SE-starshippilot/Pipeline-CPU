module Imm_Extender(Imm,
                    Imm_SignExt,
                    Imm_ZeroExt);
    input [15:0] Imm;
    output [31:0] Imm_SignExt, Imm_ZeroExt;
    
    assign Imm_SignExt = {{16{Imm[15]}}, Imm};
    assign Imm_ZeroExt = {{16{1'b0}}, Imm};
    
endmodule
