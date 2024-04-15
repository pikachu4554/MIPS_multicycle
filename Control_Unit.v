
module Control_Unit( 
    clock,
    rst,
    instr_Opcode,
    instr_Function,
    sig_MemtoReg,
    sig_RegDst,
    sig_IorD,
    sig_PCSrc,
    sig_ALUSrcB, 
    sig_ALUSrcA, 
    sig_IRWrite, 
    sig_MemWrite,
    sig_PCWrite,
    sig_Branch,
    sig_RegWrite,
    state,
    alu_Control
    );

    input clock;
    input rst;
    input [5:0] instr_Opcode;
    input [5:0] instr_Function;
    output sig_MemtoReg;
    output sig_RegDst;
    output sig_IorD;
    output sig_PCSrc;
    output [1:0] sig_ALUSrcB;
    output sig_ALUSrcA;
    output sig_IRWrite;
    output sig_MemWrite;
    output sig_PCWrite;
    output sig_Branch;
    output sig_RegWrite;
    
    output reg [3:0] state;
    output reg [2:0] alu_Control;

    parameter STATE_0 = 0;
    parameter STATE_1 = 1;
    parameter STATE_2 = 2;
    parameter STATE_3 = 3;
    parameter STATE_4 = 4;
    parameter STATE_5 = 5;
    parameter STATE_6 = 6;
    parameter STATE_7 = 7;
    parameter STATE_8 = 8;
    parameter STATE_9 = 9;
    parameter STATE_10 = 10;
    parameter STATE_11 = 11;
    parameter STATE_12 = 12;
    parameter STATE_13 = 13;
    parameter STATE_14 = 14;
    
    parameter R_TYPE = 6'b000000; //R_Type  
  
    parameter SUBI = 6'b001000;   //SUBI

    wire [1:0] alu_Op;
    always@(posedge clock) begin
        if (rst) 
            state <= 4'd0;
        else begin
            case(state)
                STATE_0: 
                    state <= 4'd1;
                STATE_1:begin
                    if (instr_Opcode == R_TYPE)
                        state <= 4'd6;
                    else if (instr_Opcode == SUBI)
                        state <= 4'd9;
                    
                    else 
                        state <= 4'd0;
                end                             
                STATE_6: begin
                        state <= 4'd7;
                end     
                STATE_7:
                    state <= 4'd0;
                
                STATE_9:
                    state <= 4'd10;         
                STATE_10:
                    state <= 4'd0;                            
                default : state <= 4'd0;
            endcase 
        end
    end

    assign sig_IorD = 1'b0;
    
    assign sig_ALUSrcA = (rst == 1'b1) ? 1'b0  :(((state == 4'd9)|| (state == 4'd10)||(state == 4'd6)) ? 1'b1 : 1'b0);
    
    assign sig_ALUSrcB = (rst == 1'b1) ? 2'b00 :((state == 4'd0)? 2'b01 : ((state == 4'd1) ? 2'b11 : (((state == 4'd9)||(state == 4'd10)) ? 2'b10 : 2'b00)));
    
    assign alu_Op = (rst == 1'b1) ? 2'b0  :(((state == 4'd6)||(state==4'd7)) ? 2'b10 : (((state == 4'd9)||(state==4'd10))? 2'b01: 2'b00));
    
    assign sig_PCSrc = (rst == 1'b1) ? 1'b0 : 1'b0;
    
    assign sig_IRWrite = (rst == 1'b1) ? 1'b0  :((state  == 4'd0) ? 1'b1 : 1'b0);
    
    assign sig_PCWrite = (rst == 1'b1) ? 1'b0  :((state == 4'd0) ? 1'b1 : 1'b0);
    
    assign sig_Branch = (rst == 1'b1) ? 1'b0  : 1'b0;
    
    assign sig_RegDst = (rst == 1'b1) ? 1'b0  :((state == 4'd7)? 1'b1 : 1'b0);
    
    assign sig_MemtoReg = (rst == 1'b1) ? 1'b0 : 1'b0;
    
    assign sig_RegWrite = (rst == 1'b1) ? 1'b0  :(((state == 4'd7) || (state == 4'd10)) ? 1'b1 : 1'b0);
    
    assign sig_MemWrite = 1'b0;
    
       
    always @(alu_Op or instr_Function) begin
        if (alu_Op ==0)
            alu_Control <= 3'b010;              // add 
        else if (alu_Op == 2'b01 )
            alu_Control <= 3'b110;              // sub          
        
        else if (alu_Op == 2'b10 ) begin
            case (instr_Function)
                6'b100000 : 
                    alu_Control <= 3'b010;  // add
                6'b100010 : 
                    alu_Control <= 3'b110;  // sub 
                6'b100100 : 
                    alu_Control <= 3'b000;  // and 
                6'b100101 : 
                    alu_Control <= 3'b001;  // or
                6'b101010 : 
                    alu_Control <= 3'b111;  // slt
                6'b100110 : 
                    alu_Control <= 3'b101;  // Xor 
                default :   
                    alu_Control <= 3'bxxx;
            endcase                 
        end
        else if (alu_Op == 2'b11 ) begin
            alu_Control <= 3'b001;
            end
        else 
            alu_Control <= 3'bxxx;
    end         
        
endmodule   

  
