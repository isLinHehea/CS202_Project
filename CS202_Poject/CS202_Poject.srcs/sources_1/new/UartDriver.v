module UartDriver(
    input iFpgaClock, iCpuClock, iCpuReset
    ,input iUartCtrl, iIoRead //�?个来自memorio, �?个来自controller
    ,input iUartFromPc
    ,output reg [15:0] oUartData
);
    wire [7:0] dataReceived;
    always@(negedge iCpuClock or posedge iCpuReset) begin
        if(iCpuReset) begin
            oUartData <= 0;
        end
		else if(iUartCtrl && iIoRead) begin
			oUartData <= {8'h00, dataReceived};
        end
		else begin
            oUartData <= oUartData;
        end
    end
    wire fakeUartToPc;
    //parameter define
    parameter  CLK_FREQ = 100_000000;         //定义系统时钟频率 
    parameter  UART_BPS = 128000;           //定义串口波特率
    uart_manager #(
        .CLK_FREQ ( CLK_FREQ ),
        .UART_BPS ( UART_BPS ))
    u_uart_manager (
        .sys_clk                 ( iFpgaClock              ),
        .sys_rst_n               ( ~iCpuReset            ),
        .uart_rxd                ( iUartFromPc             ),

        .uart_txd                ( fakeUartToPc             ),
        .data_received           ( dataReceived  [7:0] )
    );
endmodule