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
    clk, rst_n,bat_ctl,
    hsync, vsync, r, g, b   // VGA control
);

    input clk;        // 100MHz
    input rst_n;      // Reset signal (Modified comment)
    input [4:0] bat_ctl; 
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

    reg [111:0] bat;
    reg [127:0] char_line_solid;
    reg [127:0] char_line_fluid;


    always @(posedge clk_vga or negedge rst_n) begin
        if (!rst_n) begin
            bat <= 'd1;
        end
        else begin
            case(bat_ctl)
            5'd0: bat <= 'hF;
            5'd1: bat <= 'hFF;
            5'd2: bat <= 'hFFF;
            5'd3: bat <= 'hFFFF;
            5'd4: bat <= 'hFFFFF;
            5'd5: bat <= 'hFFFFFF;
            5'd6: bat <= 'hFFFFFFF;
            5'd7: bat <= 'hFFFFFFFF;
            5'd8: bat <= 'hFFFFFFFFFF;
            5'd9: bat <= 'hFFFFFFFFFFF;
            5'd10: bat <= 'hFFFFFFFFFFFFFF;
            5'd11: bat <= 'hFFFFFFFFFFFFFFF;
            5'd12: bat <= 'hFFFFFFFFFFFFFFFF;
            5'd13: bat <= 'hFFFFFFFFFFFFFFFFFF;
            5'd14: bat <= 'hFFFFFFFFFFFFFFFFFFF;
            5'd15: bat <= 'hFFFFFFFFFFFFFFFFFFFF;
            5'd16: bat <= 'hFFFFFFFFFFFFFFFFFFFFFF;
            5'd17: bat <= 'hFFFFFFFFFFFFFFFFFFFFFFF;
            5'd18: bat <= 'hFFFFFFFFFFFFFFFFFFFFFFFF;
            5'd19: bat <= 'hFFFFFFFFFFFFFFFFFFFFFFFFFF;
            5'd20: bat <= 'hFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            5'd21: bat <= 'hFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            5'd22: bat <= 'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            5'd23: bat <= 'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            5'd24: bat <= 'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            5'd25: bat <= 'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            5'd26: bat <= 'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            5'd27: bat <= 'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            5'd28: bat <= 'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            endcase
        end
    
    end

    always @(posedge clk_vga or negedge rst_n) begin
        if (!rst_n) begin
            char_line_solid <= 128'h0;
            char_line_fluid <= 128'h0;
        end
        else begin
            char_line_solid <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            char_line_fluid <= {8'hFF, bat, 8'hFF};
        end
    end
    reg[6:0] char_bit;
      always @(posedge clk_vga or negedge rst_n) begin
        // In a 640x480 array, select a location to display the character "FPGA"
        if (!rst_n)
            char_bit <= 7'h7f;
        else if (x_cnt == 10'd400)
            char_bit <= 7'd127;  // Display high bits first, decrement by 1 each time
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
