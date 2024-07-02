`timescale 1ns / 1ps

module top_module(
input clk,reset,en_blurr,
output v_sync,h_sync,
output [11:0] pixel,
output en_mode_led
    );
   reg [16:0] wr_add; 
   wire clk_40;
   reg [1:0] current_write_line;
   reg [8:0] pointer;
   wire [3:0] doutr,doutg,doutb;
   reg [3:0] dinr,ding,dinb;
   reg [16:0] rd_add;
   reg [3:0] linebuffer1 [0:399];
   reg [3:0] linebuffer2 [0:399];
   reg [3:0] linebuffer3 [0:399];
   reg [3:0] linebuffer4 [0:399];
   reg [8:0] linecounter;
   reg [3:0] linestore1 [0:399];
   reg [3:0] linestore2 [0:399];
   reg [3:0] convolved_pixel;
   wire [3:0] out_pixel;
   reg [3:0] pix1,pix2,pix3,pix4,pix5,pix6,pix7,pix8,pix9;
   reg enable;
   reg en_mode;
   reg change_state;
   initial
   begin
        change_state=0;
        en_mode=0;
        enable=0;
        wr_add=0;
        current_write_line=0;
        pointer=0;
        linecounter=0;
        rd_add=0;
   end
   assign en_mode_led=en_mode;
   always@(posedge clk_40 && en_mode)
   begin
        
        pointer<=pointer+1;
        if(pointer==399)
            begin
                pointer<=0;
                linecounter<=linecounter+1;
                if(linecounter==301)
                    linecounter<=0;
                current_write_line<=current_write_line+1;
            end
   end
   
   always@(posedge clk_40 && en_mode)
   begin
        case(current_write_line)
        0:
        begin
            linebuffer1[pointer]<=doutr;
        end           
        1:
        begin
            linebuffer2[pointer]<=doutr;
        end
        2:
        begin
            linebuffer3[pointer]<=doutr;
        end        
        3:
        begin
            linebuffer4[pointer]<=doutr;
        end        
        endcase
   end
   
   
   always@(posedge clk_40 && en_mode)
   begin
      //  convolved_pixel<=out_pixel;
        linestore1[pointer]<=out_pixel;
        linestore2[pointer]<=linestore1[pointer];
        dinr<=linestore2[pointer];
        rd_add<=pointer+(linecounter-2)*400;
        if(pointer+(linecounter-2)*400<0)
        begin
            rd_add<=0;
            if(linecounter>=2 && linecounter<=300)  // this is the crucial condition
            begin
                enable<=1'b1;
            end
            else
            begin
                if(linecounter==301)
                    begin
                        enable<=1'b0;
                    end
            end
            
        end
   end
   
   
   
   average_pixel a0(
   .p1(pix1),
   .p2(pix2),
   .p3(pix3),
   .p4(pix4),
   .p5(pix5),
   .p6(pix6),
   .p7(pix7),
   .p8(pix8),
   .p9(pix9),
   .o1(out_pixel)
   );
  
   always@(*)
   begin
        case(current_write_line)
        0:
        begin
        pix5=linebuffer3[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1=0;
        else
            pix1=linebuffer2[pointer-1];
        if(pointer-1<0)
            pix4=0;
        else
            pix4=linebuffer3[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7=0;
        else
            pix7=linebuffer4[pointer-1];
        if(linecounter==0) 
            pix2=0;
        else
            pix2=linebuffer2[pointer];
        if(linecounter==299)
            pix8=0;
        else
            pix8=linebuffer4[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3=0;
        else
            pix3=linebuffer2[pointer+1];
        if(pointer+1>400)
            pix6=0;
        else
            pix6=linebuffer3[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9=0;
        else
            pix9=linebuffer4[pointer+1];


            
        end
        1:
        begin
        pix5=linebuffer4[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1=0;
        else
            pix1=linebuffer3[pointer-1];
        if(pointer-1<0)
            pix4=0;
        else
            pix4=linebuffer4[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7=0;
        else
            pix7=linebuffer1[pointer-1];
        if(linecounter==0) 
            pix2=0;
        else
            pix2=linebuffer3[pointer];
        if(linecounter==299)
            pix8=0;
        else
            pix8=linebuffer1[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3=0;
        else
            pix3=linebuffer3[pointer+1];
        if(pointer+1>400)
            pix6=0;
        else
            pix6=linebuffer4[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9=0;
        else
            pix9=linebuffer1[pointer+1];
        end
        2:
        begin
        pix5=linebuffer1[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1=0;
        else
            pix1=linebuffer4[pointer-1];
        if(pointer-1<0)
            pix4=0;
        else
            pix4=linebuffer1[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7=0;
        else
            pix7=linebuffer2[pointer-1];
        if(linecounter==0) 
            pix2=0;
        else
            pix2=linebuffer4[pointer];
        if(linecounter==299)
            pix8=0;
        else
            pix8=linebuffer2[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3=0;
        else
            pix3=linebuffer4[pointer+1];
        if(pointer+1>400)
            pix6=0;
        else
            pix6=linebuffer1[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9=0;
        else
            pix9=linebuffer2[pointer+1];
        end
        3:
        begin
        pix5=linebuffer2[pointer];
        if((pointer-1<0) || (linecounter==0)) 
            pix1=0;
        else
            pix1=linebuffer1[pointer-1];
        if(pointer-1<0)
            pix4=0;
        else
            pix4=linebuffer2[pointer-1];
        if((pointer-1<0) || (linecounter==299)) 
            pix7=0;
        else
            pix7=linebuffer3[pointer-1];
        if(linecounter==0) 
            pix2=0;
        else
            pix2=linebuffer1[pointer];
        if(linecounter==299)
            pix8=0;
        else
            pix8=linebuffer3[pointer];
        if((pointer+1>400) || (linecounter==0)) 
            pix3=0;
        else
            pix3=linebuffer1[pointer+1];
        if(pointer+1>400)
            pix6=0;
        else
            pix6=linebuffer2[pointer+1];
        if((pointer+1>400) || (linecounter==299)) 
            pix9=0;
        else
            pix9=linebuffer3[pointer+1];    
        end
        endcase
   end

   
   /*always@(change_state,linecounter)
   begin
       en_mode=1'b1;
       if(linecounter==301)
            en_mode=1'b0;
   end*/
   always@(*)
   begin
   if(en_blurr)
      //change_state=~change_state;  
      en_mode=1'b1;
   else
      en_mode=1'b0;
   end

blk_mem_gen_0 R_channel (
  .clka(clk_40),    // input wire clka
  .ena(enable),      // input wire ena
  .wea(enable),      // input wire [0 : 0] wea
  .addra(rd_add),  // input wire [16 : 0] addra
  .dina(dinr),    // input wire [3 : 0] dina
  .clkb(clk_40),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(wr_add),  // input wire [16 : 0] addrb
  .doutb(doutr)  // output wire [3 : 0] doutb
);
   
  /* 
blk_mem_gen_5 G_channel (
  .clka(clk_40),    // input wire clka
  .ena(enable),      // input wire ena
  .wea(enable),      // input wire [0 : 0] wea
  .addra(rd_add),  // input wire [16 : 0] addra
  .dina(ding),    // input wire [3 : 0] dina
  .clkb(clk_40),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(wr_add),  // input wire [16 : 0] addrb
  .doutb(doutg)  // output wire [3 : 0] doutb
);

blk_mem_gen_7 B_channel (
  .clka(clk_40),    // input wire clka
  .ena(enable),      // input wire ena
  .wea(enable),      // input wire [0 : 0] wea
  .addra(rd_add),  // input wire [16 : 0] addra
  .dina(dinb),    // input wire [3 : 0] dina
  .clkb(clk_40),    // input wire clkb
  .enb(1'b1),      // input wire enb
  .addrb(wr_add),  // input wire [16 : 0] addrb
  .doutb(doutb)  // output wire [3 : 0] doutb
);*/
  /* blk_mem_gen_0 R_channel (
  .clka(clk_var),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(1'b0),      // input wire [0 : 0] wea
  .addra(wr_add),  // input wire [16 : 0] addra
  .dina(dinr),    // input wire [3 : 0] dina
  .douta(doutr)  // output wire [3 : 0] douta
);


   blk_mem_gen_1 G_channel (
  .clka(clk_var),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(1'b0),      // input wire [0 : 0] wea
  .addra(wr_add),  // input wire [16 : 0] addra
  .dina(),    // input wire [3 : 0] dina
  .douta(doutg)  // output wire [3 : 0] douta
);

blk_mem_gen_3 B_channel (
  .clka(clk_var),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(1'b0),      // input wire [0 : 0] wea
  .addra(wr_add),  // input wire [16 : 0] addra
  .dina(),    // input wire [3 : 0] dina
  .douta(doutb)  // output wire [3 : 0] douta
);
*/
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
wire [10:0] v_loc,h_loc;
disp_sync D0(.clk(clk_40),.rst(reset),.v_sync(v_sync),.h_sync(h_sync),.v_disp(v_disp),.h_disp(h_disp),.h_loc(h_loc),.v_loc(v_loc));

reg [11:0] pixel_reg;
always@(*)
begin
if(v_disp && h_disp)
begin
    
    
    if(h_loc>200 && h_loc<601 && v_loc>150 && v_loc<451)
    begin
      //  read_en=1'b1;
        pixel_reg={doutr,4'b0000,4'b0000};

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
