`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module IFetch(input clk, rst,
              input[31:0] Addr_result,        // 来自执行单元, 算出的跳转地�???
              input[31:0] read_data_1,        // from decoder, used by jr
              input Branch,
              input nBranch,
              input Jmp,
              input Jal,
              input Jr,
              input Zero,                     //来自执行单元
              input [31:0] Instruction,
              output [31:0] branch_base_addr, // (pc+4) to ALU, for branch use
              output reg [31:0] link_addr,    // pc+4, to Decoder, for jal use
              output [13:0] fetch_addr
              );
    
    reg [31:0] PC, Next_PC;    
    assign fetch_addr = PC[15:2];

    always @* begin
        if ((Branch == 1'b1 && Zero == 1'b1)||(nBranch == 1'b1 && Zero == 1'b0)) // beq, bne
        begin
            Next_PC = Addr_result;
        end
        else if (Jr == 1'b1)
            Next_PC = read_data_1;
        else
            Next_PC = PC + 4;
    end
    
    always @(negedge clk) begin
        if (rst == 1) begin
            PC <= 32'h0000_0000;
        end
        else begin
            if (Jal == 1)
                link_addr <= PC + 4;
            if ((Jmp == 1) || (Jal == 1))
                PC = {PC[31:28], Instruction[25:0], 2'b00};
            else
                PC <= Next_PC;
        end
    end

    assign branch_base_addr = PC + 4;

endmodule
