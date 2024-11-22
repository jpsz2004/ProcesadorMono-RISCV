module immediate_generator(
  	input wire [24:0] instruction,
    input wire [2:0] ImmSrc,
    output reg [31:0] imm_ext
);
     always @* begin
        case(ImmSrc)
            3'b000: begin
                imm_ext[11:0] = instruction[24:13];
                imm_ext[31:12] = {20{imm_ext[11]}};
            end
            3'b001: begin
                imm_ext[11:0] = {instruction[24:18], instruction[4:0]};
                imm_ext[31:12] = {20{imm_ext[11]}};
            end
            3'b010: begin
                imm_ext[20:0] = {instruction[24:5]};
                imm_ext[31:21] = {10{imm_ext[20]}};
            end
            3'b101: begin
                imm_ext[12:0] = {instruction[24], instruction[0], instruction[23:18], instruction[4:1], 1'b0};
                imm_ext[31:13] = {19{imm_ext[12]}};
            end
            3'b110: begin
                imm_ext[20:0] = {instruction[24], instruction[12:5], instruction[13], instruction[23:14], 1'b0};
                imm_ext[31:21] = {11{imm_ext[20]}};
            end
            default: imm_ext = 32'h0;
        endcase
    end

endmodule
