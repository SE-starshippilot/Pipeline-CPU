module Jump_CTRL (
    opcode,
    func,               // determine wheter or not to jump
    JSEL                // the selection signal for jumping
);
    parameter J   = 6'b000010;
    parameter JAL = 6'b000011;
    parameter JR  = 6'b001000;
    input [5:0] opcode, func;
    output [1:0] JSEL;

    assign JSEL = (opcode === 6'b0 && func === JR)? 2: (opcode === J || opcode === JAL )? 1:0;
endmodule