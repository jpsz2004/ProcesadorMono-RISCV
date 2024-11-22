module data_memory(
  	input wire clk,
    input wire DMWr,            
    input wire [2:0] DMCtrl,
    input wire [31:0] addr,  
    input wire [31:0] DataWr,
    output reg [31:0] DataRd 
);
  reg [31:0] mem [1023:0];
  
  	initial begin
    	DataRd = 32'h0;
    end
  
     always @(*) begin
        case (DMCtrl)
            3'b000: DataRd <= {{24{mem[addr[11:2]][7]}}, mem[addr[11:2]][7:0]};    // Byte
            3'b001: DataRd <= {{16{mem[addr[11:2]][15]}}, mem[addr[11:2]][15:0]};  // Halfword
            3'b010: DataRd <= mem[addr[11:2]];                               // Word
            3'b100: DataRd <= {24'b0, mem[addr[11:2]][7:0]};                 // Byte Unsigned
            3'b101: DataRd <= {16'b0, mem[addr[11:2]][15:0]};                // Halfword Unsigned
        endcase
        
    end

    always_ff @(posedge clk) begin
        if(DMWr) begin
            case (DMCtrl)
                3'b000: mem[addr[11:2]] <= {{24{DataWr[7]}}, DataWr[7:0]};    // Byte
                3'b001: mem[addr[11:2]] <= {{16{DataWr[15]}}, DataWr[15:0]};  // Halfword
                3'b010: mem[addr[11:2]] <= DataWr;                               // Word
                3'b100: mem[addr[11:2]] <= {24'b0, DataWr[7:0]};                 // Byte Unsigned
                3'b101: mem[addr[11:2]] <= {16'b0, DataWr[15:0]};                // Halfword Unsigned
            endcase
        end
    end

endmodule
