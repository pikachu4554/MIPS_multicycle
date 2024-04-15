module Memory(
    clock,
    sig_MemWrite, 
    adr, 
    wd, 
    rd 
    );

    input clock;
    input sig_MemWrite; 
 
    
    input [31:0] adr; 
    input [31:0] wd ; 
    output reg [31:0] rd; 

    parameter DATA_WIDTH = 50;
    reg [7:0] ram [0:DATA_WIDTH-1];
    
    initial begin 
        {ram[0],ram[1],ram[2],ram[3]}=32'b000000_00010_00011_00001_00000_101010;
        {ram[4],ram[5],ram[6],ram[7]}=32'b001000_00100_00101_00000000_00001000;
    end
    always @(posedge clock) begin
        if(sig_MemWrite == 0)
            rd = {ram[adr],ram[adr+1],ram[adr+2],ram[adr+3]};
        else
            ram[adr] = wd;
    end
        
endmodule
