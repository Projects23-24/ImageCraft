module memory
    #(parameter IMAGE_WIDTH=4, IMAGE_HEIGHT = 4)
    (
    input clk,
    input r_en,
    input w_en,
    input [$clog2(IMAGE_WIDTH*IMAGE_HEIGHT)-1:0] r_add,
    input [$clog2(IMAGE_WIDTH*IMAGE_HEIGHT)-1:0] w_add,
    input [11:0] w_data,
    
    output reg [11:0] r_data
    );
    
    reg [11:0] mem [0:15];
    
    always@(posedge clk) begin
        if (w_en) begin
            mem[w_add] <= w_data;
        end
        if (r_en) begin
            r_data <= mem[r_add];
        end
    end
endmodule