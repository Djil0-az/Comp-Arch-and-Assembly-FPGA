`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/06 09:12:15
// Design Name: 
// Module Name: BitExample
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



   
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 2018/07/30 21:43:04
    // Design Name: 
    // Module Name: BitComputer_Top
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
    
    //{ input      CLK100MHZ,
        //°´key--d£¬·¢Éù
    //}
    module BitExample(
        input        clk,
        input      rst_n,
 
        //vga
            output wire[3:0] b,
            output wire[3:0] r,
            output wire [3:0] g,
            output wire hsync,
            output wire vsync,//,
        
        inout  [6:0]       EXT_IO);
        
     
        
             
            vga_char vga0(    .clk(clk), .rst_n(rst_n), .hsync(hsync), .vsync(vsync),.r(r),.g(g),.b(b));
                   
           
             
        
   
        
    endmodule


