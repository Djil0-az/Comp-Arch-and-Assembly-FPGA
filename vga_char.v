`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2016 11:10:38 AM
// Design Name: 
// Module Name: vga_char
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

module vga_char(
    clk, rst_n,
    hsync, vsync, r, g, b   // VGA control
);

    input clk;        // 100MHz
    input rst_n;      // Reset signal (Modified comment)
    output hsync;     // Horizontal sync signal
    output vsync;     // Vertical sync signal
    output[3:0] r;    // Red output signal
    output[3:0] g;    // Green output signal
    output[3:0] b;    // Blue output signal

    reg[9:0] x_cnt;    // Horizontal coordinate
    reg[9:0] y_cnt;    // Vertical coordinate
    reg clk_vga = 0;   // VGA clock
    reg clk_cnt = 0;   // Frequency divider counter

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_vga <= 1'b0;
        else if (clk_cnt == 1) begin
            clk_vga <= ~clk_vga;
            clk_cnt <= 0;
        end
        else
            clk_cnt <= clk_cnt + 1;
    end

    reg valid_yr;    // Row display valid signal
    always @ (posedge clk_vga or negedge rst_n) begin
        if (!rst_n)
            valid_yr <= 1'b0;
        else if (y_cnt == 10'd32)
            valid_yr <= 1'b1;
        else if (y_cnt == 10'd511)
            valid_yr <= 1'b0;
    end

    wire valid_y = valid_yr;

    reg valid_r;
    always @ (posedge clk_vga or negedge rst_n) begin
        if (!rst_n)
            valid_r <= 1'b0;
        else if ((x_cnt == 10'd141) && valid_y)
            valid_r <= 1'b1;
        else if ((x_cnt == 10'd781) && valid_y)
            valid_r <= 1'b0;
    end
    wire valid = valid_r;

    always @ (posedge clk_vga or negedge rst_n) begin
        if (!rst_n)
            x_cnt <= 10'd0;
        else if (x_cnt == 10'd799)
            x_cnt <= 10'd0;
        else
            x_cnt <= x_cnt + 1'b1;
    end

    always @ (posedge clk_vga or negedge rst_n) begin
        if (!rst_n)
            y_cnt <= 10'd0;
        else if (y_cnt == 10'd524)
            y_cnt <= 10'd0;
        else if (x_cnt == 10'd799)
            y_cnt <= y_cnt + 1'b1;
    end

    // VGA synchronization, horizontal and vertical sync signals
    reg hsync_r, vsync_r;
    always @ (posedge clk_vga or negedge rst_n) begin
        if (!rst_n)
            hsync_r <= 1'b1;
        else if (x_cnt == 10'd0)
            hsync_r <= 1'b0;    // Generate hsync signal
        else if (x_cnt == 10'd96)
            hsync_r <= 1'b1;
    end

    always @ (posedge clk_vga or negedge rst_n) begin
        if (!rst_n)
            vsync_r <= 1'b1;
        else if (y_cnt == 10'd0)
            vsync_r <= 1'b0;    // Generate vsync signal
        else if (y_cnt == 10'd2)
            vsync_r <= 1'b1;
    end

    assign hsync = hsync_r;
    assign vsync = vsync_r;

    // Resolution 640x480
    wire[9:0] x_dis;    // Horizontal coordinate display valid area relative coordinate values 0-639
    wire[9:0] y_dis;    // Vertical coordinate display valid area relative coordinate values 0-479

    // Subtract the blanking area, convert to an easy-to-understand 640x480
    assign x_dis = x_cnt - 10'd142;
    assign y_dis = y_cnt - 10'd33;

    reg [27:0] bat;
    reg [127:0] char_line_solid;
    reg [127:0] char_line_fluid;

    always @(posedge clk_vga or negedge rst_n) begin
        if (!rst_n) begin
            char_line_solid <= 128'h0;
            char_line_fluid <= 128'h0;
        end
        else begin
            char_line_solid <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            
           char_line_fluid <= {
            128'hFF,
            bat[0],
            bat[1],
            bat[2],
            bat[3],
            bat[4],
            bat[5],
            bat[6],
            bat[7],
            bat[8],
            bat[9],
            bat[10],
            bat[11],
            bat[12],
            bat[13],
            bat[14],
            bat[15],
            bat[16],
            bat[17],
            bat[18],
            bat[19],
            bat[20],
            bat[21],
            bat[22],
            bat[23],
            bat[24],
            bat[25],
            bat[26],
            bat[27],
            128'hFF
        };
        end
    end
    reg[6:0] char_bit;
    always @(posedge clk_vga or negedge rst_n) begin
        // In a 640x480 array, select a location to display the character "FPGA"
        if (!rst_n)
            char_bit <= 7'h7f;
        else if (x_cnt == 10'd400)
            char_bit <= 7'd128;  // Display high bits first, decrement by 1 each time
        else if (x_cnt > 10'd400 && x_cnt < 10'd528)
            char_bit <= char_bit - 1'b1;
    end

    reg[11:0] vga_rgb;
    always @ (posedge clk_vga) begin
        // Output the signal for each row
        if (!valid)
            vga_rgb <= 12'b0000_0000_0000;
        else if (x_cnt >= 10'd400 && x_cnt < 10'd528) begin
            // =
            case(y_dis)
        10'd200: if(char_line_solid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd201: if(char_line_solid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd202: if(char_line_fluid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd203: if(char_line_fluid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd204: if(char_line_fluid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd205: if(char_line_fluid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd206: if(char_line_fluid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd207: if(char_line_fluid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_00;
        10'd208: if(char_line_fluid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd209: if(char_line_fluid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd210: if(char_line_fluid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd211: if(char_line_fluid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd212: if(char_line_fluid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd213: if(char_line_fluid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd214: if(char_line_solid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        10'd215: if(char_line_solid[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                 else vga_rgb <= 12'b0000_0000_0000;
        default: vga_rgb <= 12'h000;
    endcase
        end
        else
            vga_rgb <= 12'h000;
    end

    // On the Basys3, each color has four control signals, which can be adjusted
    assign r = vga_rgb[11:8];
    assign g = vga_rgb[7:4];
    assign b = vga_rgb[3:0];
endmodule


