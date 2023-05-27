`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Decoder(input clk,                 // CPU clock
               input rst,                 // Reset
               input[31:0] Instruction,   // Instruction, from IFetch
               input[31:0] mem_data,      // Memory data, from MemOrIO
               input[31:0] ALU_result,    // ALU result, from Executer
               input Jal,                 // Jal
               input RegWrite,
               input MemtoReg,
               input RegDST,
               input[31:0] link_addr,     // From iFetch, pc + 4 for Jal
               output[31:0] read_data_1,
               output[31:0] read_data_2,
               output[31:0] Sign_extend); // 32-bit signed immediate
    
    
    reg[31:0] register[0:31]; // 32 registers

    reg[4:0] write_register_address;
    reg[31:0] write_data;
    
    wire[4:0] rs;
    wire[4:0] rt;
    wire[4:0] rd;
    wire[15:0] immediate;
    wire[5:0] opcode;
    wire sign;
    
    assign opcode    = Instruction[31:26];
    assign rs        = Instruction[25:21];
    assign rt        = Instruction[20:16];
    assign rd        = Instruction[15:11];
    assign immediate = Instruction[15:0];
    assign sign        = Instruction[15];
    
    assign Sign_extend = (6'b001100 == opcode || 6'b001101 == opcode || 6'b001110 == opcode|| 6'b001011 == opcode)?{{16{1'b0}},immediate}:{{16{sign}},immediate};
    assign read_data_1 = register[rs];
    assign read_data_2 = register[rt];
        
    always @* begin
        if (RegWrite == 1)begin
            if (1'b1 == Jal)begin
                write_register_address = 5'b11111;
            end
            else if (1'b1 == RegDST)begin
                write_register_address = rd;
            end
            else begin
                write_register_address = rt;
            end
        end
    end
        
    always @* begin
        if (6'b000011 == opcode && 1'b1 == Jal) begin
            write_data = link_addr;
        end
        else if (1'b1 == MemtoReg) begin
            write_data = mem_data;
        end
        else begin
            write_data = ALU_result;
        end
    end
    
    integer i;
    always @(posedge clk) begin
        if (rst == 1'b1) begin
            for(i = 0; i <= 31 && i != 29; i = i + 1) begin
                register[i] <= 32'h0000_0000;
            end
            register[29] <= 32'h0000_FFFF;
        end
        else begin
            if ((RegWrite || Jal) && write_register_address != 0) begin
                register[write_register_address] <= write_data;
            end
        end
    end
endmodule
