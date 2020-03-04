`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2020 03:34:38 PM
// Design Name: 
// Module Name: vga_display
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


module vga_display(
    input [7:0] x_pos,
    input [7:0] y_pos,
    input clk,
    input reset,
    output Hsync,
    output Vsync,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue
    );
    
    wire vga_clk;
    //wire clk_1k;
    
    vga_clk clk2(.clk_in(clk), .clk_out(vga_clk));
    //slowclk_1M clk3(.clk_in(clk), .clk_out(clk_1k));
    
    wire [10:0] x,y;
    wire blank;
    
    
   //debounce du(.clk(clk_1k), .in(up_i),      .out(up),       .reset(reset));
   //debounce dd(.clk(clk_1k), .in(down_i),    .out(down),     .reset(reset));
   //debounce dr(.clk(clk_1k), .in(right_i),   .out(right),    .reset(reset));
   //debounce dl(.clk(clk_1k), .in(left_i),    .out(left),     .reset(reset));

    //vga stuff
    vga_controller_640_60 display(
        .rst(reset), 
        .pixel_clk(vga_clk),
        .HS(Hsync),
        .VS(Vsync),
        .hcount(y),
        .vcount(x),
        .blank(blank)
    );
    
    always @ (blank, y_pos, x_pos, x, y)
    begin
    if (blank) 
        begin
        vgaRed = 4'b0;
        vgaBlue = 4'b0;
        vgaGreen = 4'b0;
        end
    else
        begin
           if ((x >= x_pos * 10'd32) && (((x_pos + 1) * 10'd32) >= x) && (y >= y_pos * 10'd32) && (((y_pos + 1) * 10'd32) >= y))
	           begin
	           vgaRed = 4'b0000;
	           vgaGreen = 4'b0000;
	           vgaBlue = 4'b1111;
	           end
	       else
	          begin
              vgaRed = 4'b0;
              vgaBlue = 4'b0;
              vgaGreen = 4'b0;
              end     
	   end
	end   
endmodule