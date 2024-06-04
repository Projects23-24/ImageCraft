`timescale 1ns / 1ps

module disp_sync(
  input clk, rst,
  output reg v_sync, h_sync, v_disp, h_disp,
  output reg [9:0] v_loc,
  output reg [10:0] h_loc
);
  
  always @(posedge clk) begin    
  
	  if(rst)
	    h_loc <= 11'b00000000001;
	  else if(h_loc >= 11'b10000100000)			
        h_loc <= 11'b0000000001;
      else
        h_loc <= h_loc + 11'b00000000001;
	  //counter for horizontal position.
      
	  if(rst)
		v_loc <= 10'b0000000001;
      else if(h_loc == 11'b10000100000 && v_loc >= 10'b1001110100)			
        v_loc <= 10'b0000000001;
      else if(h_loc == 11'b10000100000)
        v_loc <= v_loc + 10'b0000000001;
      else
        v_loc <= v_loc;
      //counter for vertical position.
	  
	  if(rst)
		h_sync <= 1'b0;
      if(h_loc == 11'b01101001000)
		h_sync <= 1'b1;
      if(h_loc == 11'b1111001000)
		h_sync <= 1'b0;
	  //if block for horizontal sync pulse
	  
	  if(rst)
		v_sync <= 1'b0;
      if(v_loc == 10'b1001011001)
		v_sync <= 1'b1;
      if(v_loc == 10'b1001011101)
		v_sync <= 1'b0;
	  //if block for vertical sync pulse
	  
	  if(rst)
		h_disp <= 1'b1;
      if(h_loc == 11'b01100100000)
		h_disp <= 1'b0;
      if(h_loc == 11'b10000100000)
		h_disp <= 1'b1;
	  
	  if(rst)
		v_disp <= 1'b1;
      if(v_loc == 10'b1001010111)
		v_disp <= 1'b0;
      if(v_loc == 10'b1001110100)
		v_disp <= 1'b1;
		
      end
  
endmodule