`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module MemOrIO(
    //from controller
    input memRead; // read memory
    input memWrite; // write memory
    input ioRead; // read IO
    input ioWrite; // write IO

    input[31:0] addr_in; // from alu_result in ALU
    output[31:0] addr_out; // address to Data-Memory

    input[31:0] m_rdata; // data read from Data-Memory
    input[15:0] io_rdata; // data read from IO, 16 bits
    output[31:0] r_wdata; // data to Decoder (registers)

    input[31:0] r_rdata; // data read from Decoder(registers)

    output reg[31:0] write_data; // data to memory or I/O（m_wdata, io_wdata）

    output SwitchCtrl; // Switch Chip Select
    output LEDCtrl;
    output TubeCtrl;
);

    assign addr_out = addr_in;
    // The data wirte to register file may be from memory or io. 
    // While the data is from io, it should be the lower 16bit of r_wdata. 
    assign r_wdata = ioRead ? io_rdata : m_rdata;

    // Chip select signal of Led and Switch are all active high;
    assign LEDCtrl = ioWrite  && ; // to be determined  
    assign SwitchCtrl = ioRead;
    assign TubeCtrl = ioWrite && ; // to be determined

    // question: how to decide when to use led, when to use segment tube?
    // use a signal to differentiate bit-wise operation(led) and arithmetic operation(segment tube).

    always @* begin
        if((memWrite==1)||(ioWrite==1))
            //wirte_data could go to either memory or IO. where is it from?
            write_data = r_rdata;
        else
            write_data = 32'hZZZZZZZZ;
    end

endmodule