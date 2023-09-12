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
    reg [4:0] bat_ctl;
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
initial begin
        mips.Mem[0] = {6'd10, 5'd0, 5'd31, 16'd1};          // R32 = 1
        mips.Mem[1] = {6'd10, 5'd0, 5'd31, 16'd2};          // R32 = 2
        mips.Mem[2] = {6'd10, 5'd0, 5'd31, 16'd1};          // R32 = 3
        mips.Mem[3] = {6'd10, 5'd0, 5'd31, 16'd2};          // R32 = 4
        mips.Mem[4] = {6'd10, 5'd0, 5'd31, 16'd1};          // R32 = 5
        mips.Mem[5] = {6'd10, 5'd0, 5'd31, 16'd2};          // R32 = 6
        mips.Mem[6] = {6'd10, 5'd0, 5'd31, 16'd1};          // R32 = 7
        mips.Mem[7] = {6'd10, 5'd0, 5'd31, 16'd2};          // R32 = 8
        mips.Mem[8] = {6'd10, 5'd0, 5'd31, 16'd1};          // R32 = 9
        mips.Mem[9] = {6'd10, 5'd0, 5'd31, 16'd2};          // R32 = 10
        mips.Mem[10] = {6'd10, 5'd0, 5'd31, 16'd1};          // R32 = 11
        mips.Mem[11] = {6'd10, 5'd0, 5'd31, 16'd2};          // R32 = 12
        mips.Mem[12] = {6'd10, 5'd0, 5'd31, 16'd1};          // R32 = 13
        mips.Mem[13] = {6'd10, 5'd0, 5'd31, 16'd2};          // R32 =14
        mips.Mem[14] = {6'd10, 5'd0, 5'd31, 16'd1};          // R32 = 15
        mips.Mem[0] = {6'd10, 5'd0, 5'd31, 16'd1};          // R32 = 16
   
end

   
    always @(posedge clk_tmp) begin
        bat_ctl = bat_ctl + 1;
    end

    
    vga_char vga0(    .clk(clk), .rst_n(rst_n), .bat_ctl(bat_ctl), .hsync(hsync), .vsync(vsync),.r(r),.g(g),.b(b));

    endmodule
