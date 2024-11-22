module instruction_memory(
    input wire [31:0] addr,
    output reg [31:0] instruction
);
    reg [7:0] mem [0:1023];
    
    initial begin
        $readmemh("instrucciones_verilog.hex", mem);
      	instruction = 32'b0;
    end
    
  always @(addr) begin

        instruction = {
            mem[addr], 
          	mem[addr+1],
          	mem[addr+2],
          	mem[addr+3]    
        };
    end
endmodule