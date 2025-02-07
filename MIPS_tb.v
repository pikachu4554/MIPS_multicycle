module MIPS_tb;

    // Inputs
    reg clock;
    reg rst;

    // Outputs
    wire [3:0] state;

    // Instantiate the Unit Under Test (UUT)
    MIPS uut (
        .clock(clock), 
        .rst(rst), 
        .state(state)
    );
    always #5 clock =~clock;
    initial begin
        // Initialize Inputs
        clock = 0;
        rst = 1;#1;
        rst = 0;#200 $finish;
        
       
    end 
endmodule   

        
