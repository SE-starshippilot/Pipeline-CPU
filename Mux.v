module MUX(in_A, in_B, sel, out);
    input in_A, in_B, sel;
    output out;

    assign out = (sel == 0)? in_A: in_B;
endmodule