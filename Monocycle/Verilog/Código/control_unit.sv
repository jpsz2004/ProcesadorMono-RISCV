module control_unit(
    input wire [6:0] OpCode,
  	input wire [2:0] funct3,
  	input wire [6:0] funct7,
    output reg [4:0] BrOp,
    output reg [2:0] DMCtrl,
    output reg DMWr,
    output reg [3:0] ALUOp,
    output reg ALUASrc,
    output reg ALUBSrc,
    output reg RUWr,
    output reg [1:0] RUDataWrSrc,
    output reg [2:0] ImmSrc
);

    always @(*) begin
    RUWr = 1'b0;
    ALUOp = 4'h0;
    ImmSrc = 3'h0;
    ALUASrc = 1'h0;
    ALUBSrc = 1'h0;
    DMWr = 1'h0;
    DMCtrl = 3'h0;
    BrOp = 5'h0;
    RUDataWrSrc = 2'h0;

    case (OpCode)
        7'b0110011: begin // R-Type instruction
   
          	if (funct7 == 7'b0000001 && funct3 == 3'b000) begin
          		ALUOp = 4'b1001; // Código para multiplicación entera
        	end 
          	else begin
            	ALUOp = {funct7[5], funct3[2:0]};
        	end
  
            RUWr = 1'b1;
            ALUASrc = 1'b0;
            ALUBSrc = 1'b0;
            ImmSrc = 3'bxxx;
            BrOp = 5'b00xxx;
            DMWr = 1'b0;
            DMCtrl = 3'bxxx;
            RUDataWrSrc = 2'b00;
        end
        7'b0010011: begin // I-Type instruction
            ALUOp = {1'b0, funct3};
            RUWr = 1'b1;
            ALUASrc = 1'b0;
            ALUBSrc = 1'b1;
            ImmSrc = 3'b000;
            BrOp = 5'b00xxx;
            DMWr = 1'b0;
            DMCtrl = 3'bxxx;
            RUDataWrSrc = 2'b00;
        end
        7'b0000011: begin // Load I-Type instruction
            ALUOp = 4'b0000;
            RUWr = 1'b1;
            ALUASrc = 1'b0;
            ALUBSrc = 1'b1;
            ImmSrc = 3'b000;
            BrOp = 5'b00xxx;
            DMWr = 1'b0;
            DMCtrl = funct3[2:0];
            RUDataWrSrc = 2'b01;
        end
        7'b0100011: begin // Store S-Type instruction
            ALUOp = 4'b0000;
            RUWr = 1'b0;
            ALUASrc = 1'b0;
            ALUBSrc = 1'b1;
            ImmSrc = 3'b001;
            BrOp = 5'b00xxx;
            DMWr = 1'b1;
            DMCtrl = funct3[2:0];
            RUDataWrSrc = 2'bxx;
        end
        7'b1100011: begin // Branch SB-Type instruction
            ALUOp = 4'b0000;
            RUWr = 1'b0;
            ALUASrc = 1'b1;
            ALUBSrc = 1'b1;
            ImmSrc = 3'b101;
            BrOp = {2'b01, funct3};
            DMWr = 1'b0;
            DMCtrl = 3'bxxx;
            RUDataWrSrc = 2'bxx;
        end
        7'b1101111: begin // Jal J-Type instruction
            ALUOp = 4'b0000;
            RUWr = 1'b1;
            ALUASrc = 1'b1;
            ALUBSrc = 1'b1;
            ImmSrc = 3'b110;
            BrOp = 5'b1xxxx;
            DMWr = 1'b0;
            DMCtrl = 3'bxxx;
            RUDataWrSrc = 2'b10;
        end
        7'b1100111: begin // Jalr I-Type instruction
            ALUOp = 4'b0000;
            RUWr = 1'b1;
            ALUASrc = 1'b0;
            ALUBSrc = 1'b1;
            ImmSrc = 3'b000;
            BrOp = 5'b1xxxx;
            DMWr = 1'b0;
            DMCtrl = 3'bxxx;
            RUDataWrSrc = 2'b10;
        end
        7'b0110111: begin // Lui U-Type instruction
            ALUOp = 4'b0000;
            RUWr = 1'b1;
            ALUASrc = 1'bx;
            ALUBSrc = 1'b1;
            ImmSrc = 3'b010;
            BrOp = 5'b00xxx;
            DMWr = 1'b0;
            DMCtrl = 3'bxxx;
            RUDataWrSrc = 2'b00;
        end
        7'b0010111: begin // Auipc U-Type instruction
            ALUOp = 4'b0000;
            RUWr = 1'b1;
            ALUASrc = 1'b1;
            ALUBSrc = 1'b1;
            ImmSrc = 3'b010;
            BrOp = 5'b00xxx;
            DMWr = 1'b0;
            DMCtrl = 3'bxxx;
            RUDataWrSrc = 2'b00;
        end
    endcase
end


endmodule
