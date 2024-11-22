module branch_unit (
    input wire [4:0] BrOp, 
    input wire [31:0] A,
    input wire [31:0] B, 
    output reg NextPCSrc  
);
   always @(*) begin
        if (BrOp[4] == 1'b1) begin
            NextPCSrc = 1'b1;
        end else begin
            if(BrOp[4:3] == 2'b0) begin
                NextPCSrc = 1'b0;
            end else begin
                case (BrOp)
                    5'b01000: NextPCSrc = (A == B);
                    5'b01001: NextPCSrc = (A != B);
                    5'b01100: NextPCSrc = ($signed(A) < $signed(B));
                    5'b01101: NextPCSrc = ($signed(A) >= $signed(B));
                    5'b01110: NextPCSrc = (A < B);
                    5'b01111: NextPCSrc = (A >= B);
                    default: NextPCSrc = 0;
                endcase
            end
        end
    end

endmodule
