`timescale 1ns/1ps

module monocycle_processor_tb();
    reg clk;
    reg rst;
    
    monocycle_processor cpu(
        .clk(clk),
        .rst(rst)
    );

    always begin
        clk = 0;
        #5; 
        clk = 1;
        #5;
    end

    integer file;

    task display_state;
        begin
            $fwrite(file, "Time=%0t ps\n", $time);
            $fwrite(file, "PC=%h\n", cpu.pc_out);
            $fwrite(file, "Instruction=%h\n", cpu.instruction);
            $fwrite(file, "Register File Status:\n");
            for (integer i = 0; i < 32; i = i + 1) begin
              if (cpu.RF.memory[i] != 0) begin
                $fwrite(file, "x%0d=%h\n", i, cpu.RF.memory[i]);
                end
            end
            $fwrite(file, "Memory Status:\n");
            for (integer i = 0; i < 64; i = i + 4) begin
                if (cpu.DM.mem[i/4] != 0) begin
                    $fwrite(file, "mem[%0h]=%h\n", i, cpu.DM.mem[i/4]);
                end
            end
            $fwrite(file, "-------------------------\n");
        end
    endtask
    

    initial begin
        file = $fopen("simulation_results.txt", "w");
        rst = 1;
        $readmemh("instrucciones_verilog.hex", cpu.IM.mem);
        #10;
        rst = 0;

      repeat(67) begin
            @(posedge clk);
            display_state();
        end
        
        $fclose(file);
        $finish;
    end

    initial begin
        $monitor("Time=%0t rst=%b pc=%h inst=%h",
                 $time, rst, cpu.pc_out, cpu.instruction);
    end
    
    initial begin
        $dumpfile("processor_waves.vcd");
        $dumpvars(0, monocycle_processor_tb);
    end
    
endmodule