`timescale 1ns / 1ps

module vga_num_ram_module (input clk,              // 100MHz system clock
                           input [3:0] data,       // Six bits of data
                           output reg [7:0] col0,  // First column data
                           output reg [7:0] col1,  // Second column data
                           output reg [7:0] col2,  // Third column data
                           output reg [7:0] col3,  // Fourth column data
                           output reg [7:0] col4,  // Fifth column data
                           output reg [7:0] col5,  // Sixth column data
                           output reg [7:0] col6); // Seventh column data
    always @(posedge clk) begin
        case (data)
            4'b0000: // "0"
            begin
                col0 <= 8'b0000_0000;
                col1 <= 8'b0011_1110;
                col2 <= 8'b0101_0001;
                col3 <= 8'b0100_1001;
                col4 <= 8'b0100_0101;
                col5 <= 8'b0011_1110;
                col6 <= 8'b0000_0000;
            end
            4'b0001: // "1"
            begin
                col0 <= 8'b0000_0000;
                col1 <= 8'b0000_0000;
                col2 <= 8'b0100_0010;
                col3 <= 8'b0111_1111;
                col4 <= 8'b0100_0000;
                col5 <= 8'b0000_0000;
                col6 <= 8'b0000_0000;
            end
            4'b0010: // "2"
            begin
                col0 <= 8'b0000_0000;
                col1 <= 8'b0100_0010;
                col2 <= 8'b0110_0001;
                col3 <= 8'b0101_0001;
                col4 <= 8'b0100_1001;
                col5 <= 8'b0100_0110;
                col6 <= 8'b0000_0000;
            end
            4'b0011: // "3"
            begin
                col0 <= 8'b0000_0000;
                col1 <= 8'b0010_0010;
                col2 <= 8'b0100_0001;
                col3 <= 8'b0100_1001;
                col4 <= 8'b0100_1001;
                col5 <= 8'b0011_0110;
                col6 <= 8'b0000_0000;
            end
            4'b0100: // "4"
            begin
                col0 <= 8'b0000_0000;
                col1 <= 8'b0001_1000;
                col2 <= 8'b0001_0100;
                col3 <= 8'b0001_0010;
                col4 <= 8'b0111_1111;
                col5 <= 8'b0001_0000;
                col6 <= 8'b0000_0000;
            end
            4'b0101: // "5"
            begin
                col0 <= 8'b0000_0000;
                col1 <= 8'b0010_0111;
                col2 <= 8'b0100_0101;
                col3 <= 8'b0100_0101;
                col4 <= 8'b0100_0101;
                col5 <= 8'b0011_1001;
                col6 <= 8'b0000_0000;
            end
            4'b0110: // "6"
            begin
                col0 <= 8'b0000_0000;
                col1 <= 8'b0011_1110;
                col2 <= 8'b0100_1001;
                col3 <= 8'b0100_1001;
                col4 <= 8'b0100_1001;
                col5 <= 8'b0011_0010;
                col6 <= 8'b0000_0000;
            end
            4'b0111: // "7"
            begin
                col0 <= 8'b0000_0000;
                col1 <= 8'b0110_0001;
                col2 <= 8'b0001_0001;
                col3 <= 8'b0000_1001;
                col4 <= 8'b0000_0101;
                col5 <= 8'b0000_0011;
                col6 <= 8'b0000_0000;
            end
            4'b1000: // "8"
            begin
                col0 <= 8'b0000_0000;
                col1 <= 8'b0011_0110;
                col2 <= 8'b0100_1001;
                col3 <= 8'b0100_1001;
                col4 <= 8'b0100_1001;
                col5 <= 8'b0011_0110;
                col6 <= 8'b0000_0000;
            end
            4'b1001: // "9"
            begin
                col0 <= 8'b0000_0000;
                col1 <= 8'b0010_0110;
                col2 <= 8'b0100_1001;
                col3 <= 8'b0100_1001;
                col4 <= 8'b0100_1001;
                col5 <= 8'b0011_1110;
                col6 <= 8'b0000_0000;
            end
            4'b1111: // "-"
            begin
                col0 <= 8'b0000_0000;
                col1 <= 8'b0000_1000;
                col2 <= 8'b0000_1000;
                col3 <= 8'b0000_1000;
                col4 <= 8'b0000_1000;
                col5 <= 8'b0000_1000;
                col6 <= 8'b0000_0000;
            end
            default: // ""
            begin
                col0 <= 8'b0000_0000;
                col1 <= 8'b0000_0000;
                col2 <= 8'b0000_0000;
                col3 <= 8'b0000_0000;
                col4 <= 8'b0000_0000;
                col5 <= 8'b0000_0000;
                col6 <= 8'b0000_0000;
            end
        endcase
    end
endmodule
