module Main_CTRL (opcode,
                  func,
                  RegWriteEN,
                  Mem2RegSEL,
                  MemWriteEN,
                  Branch,
                  ALUCtrl,
                  ALUSrc,
                  RegDst);
input [5:0] opcode, func;
output RegWriteEN, Mem2RegSEL, MemWriteEN, Branch, ALUCtrl, ALUSrc, RegDst;



endmodule //Main_CTRL
