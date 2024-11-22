`include "ALU.sv"
`include "register_file.sv"
`include "data_memory.sv"
`include "instruction_memory.sv"
`include "PC.sv"
`include "control_unit.sv"
`include "immediate_generator.sv"
`include "branch_unit.sv"

module monocycle_processor (
    input wire clk,
    input wire rst
);

    wire [31:0] pc_out, pc_in, instruction, imm_ext;
    wire [31:0] RU_rs1, RU_rs2, ALURes, DataRd, DataWr;
    wire [4:0] rs1, rs2, rd;
    wire [2:0] funct3;
    wire [6:0] opcode, funct7;
    wire [4:0] BrOp;       
  	wire [3:0] ALUOp;
    wire DMWr, ALUASrc, ALUBSrc, RUWr;
    wire [1:0] RUDataWrSrc;
    wire [2:0] DMCtrl;
    wire [2:0] ImmSrc;
    wire NextPCSrc;
  

    pc PC (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    instruction_memory IM (
        .addr(pc_out),
        .instruction(instruction)
    );

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd = instruction[11:7];

    control_unit CU (
        .OpCode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .BrOp(BrOp),
        .DMCtrl(DMCtrl),
        .DMWr(DMWr),
        .ALUOp(ALUOp),
        .ALUASrc(ALUASrc),
        .ALUBSrc(ALUBSrc),
        .RUWr(RUWr),
        .RUDataWrSrc(RUDataWrSrc),
        .ImmSrc(ImmSrc)   
    );

    immediate_generator ImmGen (
      	.instruction(instruction[31:7]),
        .ImmSrc(ImmSrc),       
        .imm_ext(imm_ext)
    );
  
    // MUX para seleccionar ALU source A
    wire [31:0] ALUA = (ALUASrc) ? pc_out : RU_rs1;

    // MUX para seleccionar ALU source B
    wire [31:0] ALUB = (ALUBSrc) ? imm_ext : RU_rs2;

    ALU ALU (
        .A(ALUA),
        .B(ALUB),
        .ALUOp(ALUOp),         
        .ALURes(ALURes)
    );

    data_memory DM (
      	.clk(clk),
        .DMWr(DMWr),
        .DMCtrl(DMCtrl),
        .addr(ALURes),
        .DataWr(RU_rs2),
        .DataRd(DataRd)
    );
    
    branch_unit br_unit (
        .BrOp(BrOp),        
        .A(RU_rs1),
        .B(RU_rs2),
      	.NextPCSrc(NextPCSrc)
    );
  


    // Lógica para calcular el siguiente valor de PC
  	assign pc_in = (NextPCSrc) ? ALURes : pc_out + 4;

    // Lógica para seleccionar el valor de escritura en el registro
    assign DataWr = (RUDataWrSrc == 2'b00) ? ALURes :
                    (RUDataWrSrc == 2'b01) ? DataRd :
                    (RUDataWrSrc == 2'b10) ? (pc_out + 4) : 32'b0;
  
    register_file RF (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .RUWr(RUWr),
        .DataWr(DataWr),
        .RU_rs1(RU_rs1),
        .RU_rs2(RU_rs2)
    );

endmodule
