module Ifetc32 (Instruction,
                branch_base_addr,
                Addr_result,
                Read_data_1,
                Branch,
                nBranch,
                Jmp,
                Jal,
                Jr,
                Zero,
                clock,
                reset,
                link_addr);
    output[31:0] Instruction;			// the instruction fetched from this module
    output[31:0] branch_base_addr;      // (pc+4) to ALU which is used by branch type instruction
    output reg[31:0] link_addr;             // (pc+4) to Decoder which is used by jal instruction
    
    input[31:0]  Addr_result;           // the calculated address from ALU
    input[31:0]  Read_data_1;           // the address of instruction used by jr instruction
    input        Branch;                // while Branch is 1,it means current instruction is beq
    input        nBranch;               // while nBranch is 1,it means current instruction is bnq
    input        Jmp;                   // while Jmp 1, it means current instruction is jump
    input        Jal;                   // while Jal is 1, it means current instruction is jal
    input        Jr;                    // while Jr is 1, it means current instruction is jr
    input        Zero;                  // while Zero is 1, it means the ALUresult is zero
    input        clock,reset;           // Clock and reset (Synchronous reset signal, high level is effective, when reset = 1, PC value is 0)
    
    reg[31:0] PC, Next_PC;
    
    always @* begin
        if (((Branch == 1) && (Zero == 1)) || ((nBranch == 1) && (Zero == 0))) // beq, bne
            Next_PC = Addr_result;
        else if (Jr == 1)
            Next_PC = Read_data_1;
        else
            Next_PC = PC + 4;
    end
    
    
    always @(negedge clock or posedge reset) begin
        if (reset == 1) begin
            PC        <= 32'h0000_0000;
            link_addr <= 2'h0000_0000;
        end
        else begin
            if (Jal == 1)
                link_addr <= PC+4;
                if ((Jmp == 1) || (Jal == 1))
                    Next_PC = {PC[31:28], Instruction[25:0], 2'b00};
                else
                    PC <= Next_PC;
                end
                end
                assign fetch_addr       = PC[15:2];
                assign branch_base_addr = PC + 4;
            
endmodule
