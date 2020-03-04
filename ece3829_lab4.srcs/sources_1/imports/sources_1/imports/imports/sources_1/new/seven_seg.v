`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jeffrey Huang
// 
// Create Date: 01/21/2020 02:34:40 PM
// Design Name: 
// Module Name: seven_seg
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
// Controls the 7 segment displays on the board to display the input from the switches
// First four switches from the right control input A, the next four B and so on, 
// and the inputs correspond to the each seven seg display from left to right. 
// SEL1 and 2 are controlled by the up and center buttons. 
//////////////////////////////////////////////////////////////////////////////////


module seven_seg(
    input [15:0] in,
    input clk,
    output [6:0] seg,
    output [3:0] an);
    
    wire[1:0] counter_out;
    wire[3:0] in_sel;
    
    my_counter m0(clk, counter_out);
    decoder2to4 m1(counter_out, an);
    assign in_sel = (counter_out==2'b00)?in[11:8]:
        (counter_out==2'b01)?in[15:12]:
        (counter_out==2'b10)?in[3:0]:
        in[7:4];
    
    bcd7seg m2(in_sel,seg);
endmodule
