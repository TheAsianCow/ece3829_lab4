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
    
    
    wire [10:0] x_pos;
    wire [10:0] y_pos;
    wire [15:0] coord;
    
    wire seg_clk;
    wire deb_clk;
    wire mcs_clk;
    wire vga_clk;
    
    wire lock;
    
    reg display_i,pressed;
    
    clk_wiz_0 mmcm(
        .clk_in1(clk_fpga),
        .reset(reset),
        .clk_100M(mcs_clk),
        .clk_vga(vga_clk),
        .locked(lock)
    );
    
    microblaze_mcs_0 mcs_0(
        .Clk(mcs_clk),
        .Reset(reset),
        .UART_rxd(rx),
        .UART_txd(tx),
        .GPIO1_tri_i(display_i),
        .GPIO1_tri_o(x_pos),
        .GPIO2_tri_o(y_pos),
        .GPIO3_tri_o(coord),
        .GPIO4_tri_o(LED)
    );
    
    vga_display(
        .x_pos(x_pos),
        .y_pos(y_pos),
        .clk(vga_clk),
        .reset(reset),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue)
    );
    
    slowclock clk0(.clk_in(clk_fpga), .clk_out(seg_clk));
    seven_seg(.in(coord), .clk(seg_clk), .seg(seg), .an(an));
    
    debounce_clk clk1(.clk_in(clk_fpga), .clk_out(deb_clk));
    
    always@(posedge deb_clk)begin
        if(display && !pressed)begin
            display_i <= 1;
            pressed <= 1;
        end
        else if(pressed)begin
            display_i <= 0;
            pressed <= 0;
        end
        else pressed <= pressed;
    end
    
endmodule
