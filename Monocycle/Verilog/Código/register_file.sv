module register_file(
    input wire clk,
  	input wire [4:0] rs1,   
  	input wire [4:0] rs2, 
  	input wire [4:0] rd,   
    input wire RUWr,
  	input wire [31:0] DataWr,
  	output wire [31:0] RU_rs1,
  	output wire [31:0] RU_rs2
);
    
  	reg [31:0] memory [31:0];
    
    initial begin
      for (int i=0; i<32; i=i+1) begin
            memory[i] = 32'h0;
        end
      memory[1] = 32'h0068;
      memory[2] = 32'd1024;
    end
    
    always @(posedge clk) begin
      if (RUWr == 1'b1 && rd != 5'b00000)
        begin
          memory[rd] <= DataWr;
        end
    end
    
  	assign RU_rs1 = memory[rs1];
  	assign RU_rs2 = memory[rs2];
    
endmodule