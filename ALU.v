module ALU(ctrl,
           selected_A,
           selected_B,
           result,
           zero_flag
           );
    
    input [4:0] ctrl;
    input signed [31:0] selected_A, selected_B;
    output reg[31:0] result;
    output reg zero_flag;
    
    always @(ctrl, selected_A, selected_B) begin
        case (ctrl)
            0: result       = selected_A + selected_B;
            1: result       = selected_A - selected_B;
            2: result       = selected_A & selected_B;
            3: result       = selected_A | selected_B;
            4: result       = selected_A ^ selected_B;
            5: result       = ~(selected_A | selected_B);
            6: result       = selected_A < selected_B;
            7: result       = selected_A << selected_B;
            8: result       = selected_A >> selected_B;
            9: result       = selected_A >>> selected_B;
            default: result = 32'bx;
        endcase
        zero_flag = (ctrl == 1 && result == 0)? 1:0;
    end
    
endmodule
