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
    input display,
    input rx,
    output tx,
    input [7:0] sw,
    output [3:0] LED,
    output [6:0] seg,
    output [3:0] an,
    output Hsync,
    output Vsync,
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen
    );
    
    
    wire [7:0] x_pos;
    wire [7:0] y_pos;
    wire [7:0] x_coord;
    wire [7:0] y_coord;
    
    wire seg_clk;
    
    microblaze_mcs_0 mcs_0(
        .Clk(clk_fpga),
        .Reset(reset),
        .UART_rxd(rx),
        .UART_txd(tx),
        .GPIO1_tri_i(display),
        .GPIO1_tri_o(x_pos),
        .GPIO2_tri_o(y_pos),
        .GPIO3_tri_o(x_coord),
        .GPIO4_tri_o(y_coord)
    );
    
    vga_display(
        .x_pos(x_pos),
        .y_pos(y_pos),
        .clk(clk_fpga),
        .reset(reset),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue)
    );
    
    slowclock clk0(.clk_in(clk_fpga), .clk_out(seg_clk));
    seven_seg(.in({x_coord, y_coord}), .clk(seg_clk), .seg(seg), .an(an));
    
    
endmodule
