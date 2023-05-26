`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module segs(input clk,
            input rst,
            input kickOff,
            input IOWrite,
            input SEGCtrl,
            input[1:0] segaddr,
            input[15:0] segwdata,
            output reg[7:0] an,
            output reg[7:0] seg0,
            output reg[7:0] seg1);
    
    parameter cnt        = 5_000;
    reg[18:0] divclk_cnt = 0;
    reg divclk           = 0;
    reg[3:0] disp_dat    = 0;
    reg[2:0] disp_bit    = 0;
    reg [3:0] num0, num1, num2, num3, num4;
    reg SEG;
    reg Sign;
    reg[15:0] data;
    
    always@(posedge clk)begin
        if (divclk_cnt == cnt)
        begin
            divclk     <= ~divclk;
            divclk_cnt <= 0;
        end
        else
        begin
            divclk_cnt <= divclk_cnt + 1'b1;
        end
    end

    always@(posedge clk or posedge rst) begin
        if (rst) begin
            SEG <= 1'b0;
        end
        else if (SEGCtrl && IOWrite) begin
            if (segaddr == 2'b00) begin
                SEG  <= 1'b1;
                Sign <= 1'b0;
            end
            else if (segaddr == 2'b10) begin
                SEG  <= 1'b1;
                Sign <= 1'b1;
            end
            else
                SEG <= SEG;
        end
        else begin
            SEG <= SEG;
        end
    end
    
    always@(posedge divclk) begin
        if (SEG == 1'b0) begin
            if (kickOff == 1'b0) begin
                if (disp_bit > 7) begin
                    disp_bit <= 0;
                end
                else begin
                    disp_bit <= disp_bit + 1'b1;
                    case (disp_bit)
                        3'b000 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00000001;//显示第一个数码管，低电平有效
                        end
                        3'b001 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00000010;//显示第二个数码管，低电平有效
                        end
                        3'b010 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00000100;//显示第三个数码管，低电平有效
                        end
                        3'b011 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00001000;//显示第四个数码管，低电平有效
                        end
                        3'b100 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00010000;//显示第五个数码管，低电平有效
                        end
                        3'b101 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00100000;//显示第六个数码管，低电平有效
                        end
                        3'b110 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b01000000;//显示第七个数码管，低电平有效
                        end
                        3'b111 :
                        begin
                            disp_dat <= 4'h1;
                            an       <= 8'b10000000;//显示第八个数码管，低电平有效
                        end
                        default:
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00000000;
                        end
                    endcase
                end
            end
            else begin
                if (disp_bit > 7) begin
                    disp_bit <= 0;
                end
                else begin
                    disp_bit <= disp_bit + 1'b1;
                    case (disp_bit)
                        3'b000 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00000001;//显示第一个数码管，低电平有效
                        end
                        3'b001 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00000010;//显示第二个数码管，低电平有效
                        end
                        3'b010 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00000100;//显示第三个数码管，低电平有效
                        end
                        3'b011 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00001000;//显示第四个数码管，低电平有效
                        end
                        3'b100 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00010000;//显示第五个数码管，低电平有效
                        end
                        3'b101 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00100000;//显示第六个数码管，低电平有效
                        end
                        3'b110 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b01000000;//显示第七个数码管，低电平有效
                        end
                        3'b111 :
                        begin
                            disp_dat <= 4'h2;
                            an       <= 8'b10000000;//显示第八个数码管，低电平有效
                        end
                        default:
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00000000;
                        end
                    endcase
                end
            end
        end
        else begin
            data <= (Sign == 1'b0) ? segwdata : ~segwdata + 1;
            
            num4 <= data[15:0] / 1_0_000 % 10;
            num3 <= data[15:0] / 1_000 % 10;
            num2 <= data[15:0] / 1_00 % 10;
            num1 <= data[15:0] / 1_0 % 10;
            num0 <= data[15:0] / 1 % 10;
            
            if (Sign == 1'b0) begin
                if (disp_bit > 7) begin
                    disp_bit <= 0;
                end
                else begin
                    disp_bit <= disp_bit + 1'b1;
                    case (disp_bit)
                        3'b000 :
                        begin
                            disp_dat <= num0;
                            an       <= 8'b00000001;//显示第一个数码管，低电平有效
                        end
                        3'b001 :
                        begin
                            disp_dat <= num1;
                            an       <= 8'b00000010;//显示第二个数码管，低电平有效
                        end
                        3'b010 :
                        begin
                            disp_dat <= num2;
                            an       <= 8'b00000100;//显示第三个数码管，低电平有效
                        end
                        3'b011 :
                        begin
                            disp_dat <= num3;
                            an       <= 8'b00001000;//显示第四个数码管，低电平有效
                        end
                        3'b100 :
                        begin
                            disp_dat <= num4;
                            an       <= 8'b00010000;//显示第五个数码管，低电平有效
                        end
                        3'b101 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00100000;//显示第六个数码管，低电平有效
                        end
                        3'b110 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b01000000;//显示第七个数码管，低电平有效
                        end
                        3'b111 :
                        begin
                            disp_dat <= 4'h2;
                            an       <= 8'b10000000;//显示第八个数码管，低电平有效
                        end
                        default:
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00000000;
                        end
                    endcase
                end
            end
            else begin
                if (disp_bit > 7) begin
                    disp_bit <= 0;
                end
                else begin
                    disp_bit <= disp_bit + 1'b1;
                    case (disp_bit)
                        3'b000 :
                        begin
                            disp_dat <= num0;
                            an       <= 8'b00000001;//显示第一个数码管，低电平有效
                        end
                        3'b001 :
                        begin
                            disp_dat <= num1;
                            an       <= 8'b00000010;//显示第二个数码管，低电平有效
                        end
                        3'b010 :
                        begin
                            disp_dat <= num2;
                            an       <= 8'b00000100;//显示第三个数码管，低电平有效
                        end
                        3'b011 :
                        begin
                            disp_dat <= num3;
                            an       <= 8'b00001000;//显示第四个数码管，低电平有效
                        end
                        3'b100 :
                        begin
                            disp_dat <= num4;
                            an       <= 8'b00010000;//显示第五个数码管，低电平有效
                        end
                        3'b101 :
                        begin
                            disp_dat <= 4'hf;
                            an       <= 8'b00100000;//显示第六个数码管，低电平有效
                        end
                        3'b110 :
                        begin
                            disp_dat <= 0;
                            an       <= 8'b01000000;//显示第七个数码管，低电平有效
                        end
                        3'b111 :
                        begin
                            disp_dat <= 4'h2;
                            an       <= 8'b10000000;//显示第八个数码管，低电平有效
                        end
                        default:
                        begin
                            disp_dat <= 0;
                            an       <= 8'b00000000;
                        end
                    endcase
                end
            end
        end
    end
    
    always@(disp_dat)
    begin
        if (an > 8'b00001000) begin
            case (disp_dat)
                //显示0—F
                4'h0 : seg0 = 8'hfc;
                4'h1 : seg0 = 8'h60;
                4'h2 : seg0 = 8'hda;
                4'h3 : seg0 = 8'hf2;
                4'h4 : seg0 = 8'h66;
                4'h5 : seg0 = 8'hb6;
                4'h6 : seg0 = 8'hbe;
                4'h7 : seg0 = 8'he0;
                4'h8 : seg0 = 8'hfe;
                4'h9 : seg0 = 8'hf6;
                4'ha : seg0 = 8'hee;
                4'hb : seg0 = 8'h3e;
                4'hc : seg0 = 8'h9c;
                4'hd : seg0 = 8'h7a;
                4'he : seg0 = 8'h9e;
                4'hf : seg0 = 8'h8e;
            endcase
        end
        else begin
            case (disp_dat)
                //显示0-F
                4'h0 : seg1 = 8'hfc;
                4'h1 : seg1 = 8'h60;
                4'h2 : seg1 = 8'hda;
                4'h3 : seg1 = 8'hf2;
                4'h4 : seg1 = 8'h66;
                4'h5 : seg1 = 8'hb6;
                4'h6 : seg1 = 8'hbe;
                4'h7 : seg1 = 8'he0;
                4'h8 : seg1 = 8'hfe;
                4'h9 : seg1 = 8'hf6;
                4'ha : seg1 = 8'hee;
                4'hb : seg1 = 8'h3e;
                4'hc : seg1 = 8'h9c;
                4'hd : seg1 = 8'h7a;
                4'he : seg1 = 8'h9e;
                4'hf : seg1 = 8'hff;
            endcase
        end
    end
endmodule
