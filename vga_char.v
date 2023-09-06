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
				clk,rst_n,		
				hsync,vsync,r,g,b	// VGA控制
			);

    input clk;	    // 100MHz
    input rst_n;	//复位信号 修改注释
    output hsync;	      //行同步信号
    output vsync;	      //场同步信号
    output[3:0] r;    //红色输出信号
    output[3:0] g;     //绿色输出信号
    output[3:0] b;      //蓝色输出信号

    reg[9:0] x_cnt;		//行坐标
    reg[9:0] y_cnt;		//列坐标
    reg clk_vga=0;    //vga时钟
    reg clk_cnt=0;     //分频计数

    always @(posedge clk or negedge rst_n)begin 
        if(!rst_n)  
            clk_vga <= 1'b0;
	    else if(clk_cnt==1)begin
	       clk_vga <= ~clk_vga;
	       clk_cnt<=0; 
        end
        else
            clk_cnt <= clk_cnt+1;
     end


        reg valid_yr;	//行显示有效信号
      always @ (posedge clk_vga or negedge rst_n)begin //480行
          if(!rst_n) valid_yr <= 1'b0;
          else if(y_cnt == 10'd32) valid_yr <= 1'b1;
          else if(y_cnt == 10'd511) valid_yr <= 1'b0;    
       end

      wire valid_y = valid_yr;

      reg valid_r;    
      always @ (posedge clk_vga or negedge rst_n)begin //640列
          if(!rst_n) valid_r <= 1'b0;
          else if((x_cnt == 10'd141) && valid_y) valid_r <= 1'b1;
          else if((x_cnt == 10'd781) && valid_y) valid_r <= 1'b0;
      end
      wire valid = valid_r;    

    always @ (posedge clk_vga or negedge rst_n)begin
        if(!rst_n) x_cnt <= 10'd0;
        else if(x_cnt == 10'd799) x_cnt <= 10'd0;
        else x_cnt <= x_cnt+1'b1;
     end

    always @ (posedge clk_vga or negedge rst_n)begin
        if(!rst_n) y_cnt <= 10'd0;
        else if(y_cnt == 10'd524) y_cnt <= 10'd0;
        else if(x_cnt == 10'd799) y_cnt <= y_cnt+1'b1;
     end

	// VGA场同步,行同步信号
    reg hsync_r,vsync_r;	

    always @ (posedge clk_vga or negedge rst_n)begin
        if(!rst_n) hsync_r <= 1'b1;								
        else if(x_cnt == 10'd0) hsync_r <= 1'b0;	//产生hsync信号
        else if(x_cnt == 10'd96) hsync_r <= 1'b1;
    end

    always @ (posedge clk_vga or negedge rst_n)begin
        if(!rst_n) vsync_r <= 1'b1;							
        else if(y_cnt == 10'd0) vsync_r <= 1'b0;	//产生vsync信号
        else if(y_cnt == 10'd2) vsync_r <= 1'b1;
     end

    assign hsync = hsync_r;
    assign vsync = vsync_r;
    //分辨率640*480
    wire[9:0] x_dis;		//横坐标显示有效区域相对坐标值0-639
    wire[9:0] y_dis;		//竖坐标显示有效区域相对坐标值0-479

//减去消隐区，转换成易于理解的640*480
assign x_dis = x_cnt - 10'd142;
assign y_dis = y_cnt - 10'd33;

reg [27:0] bat;
reg [127:0] char_line_solid;
reg [127:0] char_line_fluid;

always@(posedge clk_vga or negedge rst_n) begin
	if (!rst_n) begin
		char_line_solid <= 128'h0;
		char_line_fluid <= 128'h0;
	end
	else begin
		char_line_solid <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
		char_line_fluid <= 128'h{
			FF,
			F{bat[0]},
			F{bat[1]}, 
			F{bat[2]}, 
			F{bat[3]}, 
			F{bat[4]}, 
			F{bat[5]}, 
			F{bat[6]}, 
			F{bat[7]}, 
			F{bat[8]}, 
			F{bat[9]}, 
			F{bat[10]}, 
			F{bat[11]}, 
			F{bat[12]}, 
			F{bat[13]}, 
			F{bat[14]}, 
			F{bat[15]}, 
			F{bat[16]}, 
			F{bat[17]}, 
			F{bat[18]}, 
			F{bat[19]}, 
			F{bat[20]}, 
			F{bat[21]}, 
			F{bat[22]}, 
			F{bat[23]}, 
			F{bat[24]}, 
			F{bat[25]}, 
			F{bat[26]}, 
			F{bat[27]}, 
			FF
		};
	end
end
reg[6:0] char_bit;	
    always @(posedge clk_vga or negedge rst_n) //在640*480阵列中选取位置显示字符"FPGA"
        if(!rst_n) char_bit <= 7'h7f;
        else if(x_cnt == 10'd400) char_bit <= 7'd128;	//先显示高位，yi次递减
        else if(x_cnt > 10'd400 && x_cnt < 10'd528) char_bit <= char_bit-1'b1;

    reg[11:0] vga_rgb;
    always @ (posedge clk_vga) begin//输出每一行的信号，
        if(!valid) vga_rgb <= 12'b0000_0000_0000;
        else if(x_cnt >= 10'd400 && x_cnt < 10'd528) begin//=
            case(y_dis)
                10'd200: if(char_line00[char_bit]) vga_rgb <= 12'b1111_1111_1111;														//白色字体，可自行设定
                         else vga_rgb <= 12'b0000_0000_0000;	
                10'd201: if(char_line01[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                           else vga_rgb <= 12'b0000_0000_0000;   
                10'd202: if(char_line02[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;   
                10'd203: if(char_line03[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;    
                10'd204: if(char_line04[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;   
                10'd205: if(char_line05[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;  
                10'd206: if(char_line06[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                           else vga_rgb <= 12'b0000_0000_0000;  
                10'd207: if(char_line07[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_00;	
                10'd208: if(char_line08[char_bit])vga_rgb <=12'b1111_1111_1111;
                           else vga_rgb <= 12'b0000_0000_0000;   
                10'd209: if(char_line09[char_bit]) vga_rgb <=12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;
                10'd210: if(char_line0a[char_bit]) vga_rgb <=12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;  			
                10'd211: if(char_line0b[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;   			
                10'd212: if(char_line0c[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    
                10'd213: if(char_line0d[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    
                10'd214: if(char_line0e[char_bit]) vga_rgb <=12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    
                10'd215: if(char_line0f[char_bit]) vga_rgb <=12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;                            
                10'd216: if(char_line10[char_bit]) vga_rgb <= 12'b1111_1111_1111;	
                      else vga_rgb <= 12'b0000_0000_0000;    
                10'd217: if(char_line11[char_bit]) vga_rgb <=12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;   
                10'd218: if(char_line11[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    	
                10'd219: if(char_line13[char_bit])vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    	
                10'd220: if(char_line14[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                        else vga_rgb <= 12'b0000_0000_0000;   
                10'd221: if(char_line15[char_bit])vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;   	
                10'd222: if(char_line16[char_bit])vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    
                10'd223: if(char_line17[char_bit]) vga_rgb <=12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;    	
                10'd224: if(char_line18[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;    
                10'd225: if(char_line19[char_bit])vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;    
                10'd226: if(char_line1a[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;    			
                10'd227: if(char_line1b[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                          else vga_rgb <= 12'b0000_0000_0000;    		
                10'd228: if(char_line1c[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    	
                10'd229: if(char_line1d[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                        else vga_rgb <= 12'b0000_0000_0000;    	
                10'd230: if(char_line1e[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;   
                10'd231: if(char_line1f[char_bit]) vga_rgb <= 12'b1111_1111_1111;
                         else vga_rgb <= 12'b0000_0000_0000;    			   
            default: vga_rgb <= 12'h000;
            endcase
        end
        else vga_rgb <= 12'h000; 
    end  
    //basys3上单个颜色有四位控制信号，可以自行选择控制位数
    assign r = vga_rgb[11:8];
    assign g = vga_rgb[7:4];
    assign b = vga_rgb[3:0];
endmodule

