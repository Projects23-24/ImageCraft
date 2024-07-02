`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2024 22:31:23
// Design Name: 
// Module Name: Operation
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


module Operation(
        input clk,enable,
        input [2:0] mode,
        input [3:0] value,threshold,
        input [11:0] inPixel,
        output [11:0] outPixel
    );
    
    reg [11:0] output1;
    
    
    always @(posedge clk)
    begin
        if(enable==1)
        begin
            case(mode)
                3'b000:
                    begin
                        output1[11:8] <= (inPixel[11:8]>(4'b1111 - value))?(4'b1111):(inPixel[11:8]+value);
                        output1[7:4] <= (inPixel[7:4]>(4'b1111 - value))?(4'b1111):(inPixel[7:4]+value);
                        output1[3:0] <= (inPixel[3:0]>(4'b1111 - value))?(4'b1111):(inPixel[3:0]+value);
                    end 
                default:
                begin
                    output1 = inPixel;
                end
            endcase
        end
    end
    
    assign outPixel = output1;
    
endmodule
