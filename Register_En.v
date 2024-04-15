module Register_En( 
   input clock,
    input rst,
    input [31:0] in,
    input enable,
    output reg [31:0] out
    );
 
    always@(posedge clock or posedge rst) begin
        
        if(rst) out<=0; 
        else begin
            if(enable) out<=in;
        end
    end
endmodule
