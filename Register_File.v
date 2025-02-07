module Register_File(
    clock,
    a1,
    a2,
    a3,
    wd3,
    sig_RegWrite,
    rd1,
    rd2
    );

    input clock;
    input [4:0] a1;
    input [4:0] a2;
    input [4:0] a3;
    input [31:0] wd3;
    input sig_RegWrite;
    output  [31:0] rd1;
    output  [31:0] rd2;

    reg [31:0] reg_File  [0:31];
    integer i;
    initial begin
        reg_File[0]=0;
        reg_File[1]=2;
        reg_File[2]=32'h778DE;
        reg_File[3]=32'h16FDA;
        reg_File[4]=32'h898F;
        for(i=5;i<31;i=i+1)
        begin
        reg_File[i]=0;
        end
                
    end
    
    assign rd1 = reg_File[a1];
    assign rd2 = reg_File[a2];

    always @(posedge clock) begin
        if (sig_RegWrite == 1)
            reg_File[a3] <= wd3;
    end
    
endmodule
