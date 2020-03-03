`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2020 02:00:11 PM
// Design Name: 
// Module Name: mcs_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mcs_top(
    input clk_fpga,
    input reset,
    input rx,
    output tx,
    input [7:0] sw,
    output [7:0] LED
    );
    
    microblaze_mcs_0 mcs_0(
        .Clk(clk_fpga),
        .Reset(reset),
        .UART_rxd(rx),
        .UART_txd(tx),
        .GPIO1_tri_i(sw),
        .GPIO1_tri_o(LED)
    );
endmodule
