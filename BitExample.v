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

    
    integer  clk_cnt_tmp = 0;
    reg clk_tmp = 0;
    wire [4:0] bat_ctl;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_tmp <= 1'b0;
        else if (clk_cnt_tmp >= 'd10000000) begin
            clk_tmp <= ~clk_tmp;
            clk_cnt_tmp <= 0;
        end
        else
            clk_cnt_tmp <= clk_cnt_tmp + 1;
    end
    // Instantiate the mips_cpu module
    mips_cpu mips (
        .clk1( clk_tmp),          // Connect your module's clk to mips_cpu's clk
        .clk2(~clk_tmp),
        .bat_ctl(bat_ctl)   // Connect your module's bat_ctl to mips_cpu's bat_ctl
        
        // Connect other ports as needed
        
);

    
    vga_char vga0(    .clk(clk), .rst_n(rst_n), .bat_ctl(bat_ctl), .hsync(hsync), .vsync(vsync),.r(r),.g(g),.b(b));

    endmodule
