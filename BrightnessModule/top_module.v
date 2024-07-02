`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2024 23:33:56
// Design Name: 
// Module Name: top_module
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


module top_module(
input clk,reset,
input active,
output h_sync,v_sync,
output [11:0] pixel
    );
    reg enable;
    wire clk_40;
    reg [17:0] wr_add;
    wire [3:0] doutr,doutg,doutb;
    reg [3:0] dinr,ding,dinb;
    reg [17:0] rd_add;
    reg [17:0] change_addr;
    reg [17:0] total_counter;
    wire [10:0] v_loc,h_loc;
    initial
    begin
        total_counter=0;
        enable=0;
    end 
    always@(posedge clk_40)
    begin
        if(active && total_counter<=119999 && h_loc>200 && h_loc<601 && v_loc>150 && v_loc<451)
        begin
            total_counter<=total_counter+1;
            enable<=1;
            /*dinr<=doutr+4'b0001;
            if(doutr==4'b1111)
                dinr<=4'b1111;
            ding<=doutg+4'b0001;
            if(doutg==4'b1111)
                ding<=4'b1111;
            dinb<=doutb+4'b0001;
            if(doutb==4'b1111)
                dinb<=4'b1111;*/
             dinr<=~doutr;
             ding<=~doutg;
             dinb<=~doutb;
        end
        else
        begin
            enable<=0;
        end
    end
    always@(*)
    begin
        change_addr=wr_add-1;
        if(wr_add==0)
            change_addr=0;
        
    end
blk_mem_gen_0 R_channel (
  .clka(clk_40),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(enable),      // input wire [0 : 0] wea
  .addra(chsnge_addr),  // input wire [16 : 0] addra
  .dina(dinr),    // input wire [3 : 0] dina
  .clkb(clk_40),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(wr_add),  // input wire [16 : 0] addrb
  .doutb(doutr)  // output wire [3 : 0] doutb
);
   
   
blk_mem_gen_1 G_channel (
  .clka(clk_40),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(enable),      // input wire [0 : 0] wea
  .addra(change_addr),  // input wire [16 : 0] addra
  .dina(ding),    // input wire [3 : 0] dina
  .clkb(clk_40),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(wr_add),  // input wire [16 : 0] addrb
  .doutb(doutg)  // output wire [3 : 0] doutb
);

blk_mem_gen_2 B_channel (
  .clka(clk_40),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(enable),      // input wire [0 : 0] wea
  .addra(change_addr),  // input wire [16 : 0] addra
  .dina(dinb),    // input wire [3 : 0] dina
  .clkb(clk_40),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(wr_add),  // input wire [16 : 0] addrb
  .doutb(doutb)  // output wire [3 : 0] doutb
); 
 
    
      clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk_40),     // output clk_out1
    // Status and control signals
    .reset(reset), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
);

//////////MATTTTT CHHHHUNNNNNAAAAAAA////////////
wire v_disp,h_disp;

disp_sync D0(.clk(clk_40),.rst(reset),.v_sync(v_sync),.h_sync(h_sync),.v_disp(v_disp),.h_disp(h_disp),.h_loc(h_loc),.v_loc(v_loc));

reg [11:0] pixel_reg;
always@(*)
begin
if(v_disp && h_disp)
begin
    
    
    if(h_loc>200 && h_loc<601 && v_loc>150 && v_loc<451)
    begin
      //  read_en=1'b1;
        pixel_reg={doutr,doutg,doutb};

    end
    else
        pixel_reg={4'b0000,4'b0000,4'b0000};
        
end

end

always@(posedge clk_40)
begin
        
        
        
            if(h_loc>200 && h_loc<601 && v_loc>150 && v_loc<451)
            begin
                wr_add<=wr_add+1;
            if(wr_add==119999)
                wr_add<=0;
            end
            if(h_loc>600 && v_loc>450)
                wr_add<=0;
        
     
       

end

assign pixel=pixel_reg;
endmodule