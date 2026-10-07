`include "datapath.v"

module multicycle (input wire clk, rst, input reg [31:0] instr, dReadData, WriteBackData, output reg MemRead, MemWrite, output wire [31:0] PC, dWriteData, dAddress);
  parameter INITIAL_PC = 32'h0040000;
  parameter instr_fetch = 5'b00001,instr_dec = 5'b00010,exec = 5'b00100,mem = 5'b01000,wr_back = 5'b10000;
  
  reg [4:0] current_state,next_state;
  reg [3:0] ALUCtrl;
  reg Branch,PCSrc,ALUSrc,LoadPC,RegWrite,MemToReg;
  wire Zero;
  
  datapath #(INITIAL_PC) pd1(.clk(clk), .rst(rst), .PCSrc(PCSrc), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .MemToReg(MemToReg), .LoadPC(LoadPC), .PC(PC), .instr(instr), .ALUCtrl(ALUCtrl), .Zero(Zero), .dAddress(dAddress), .dReadData(dReadData), .dWriteData(dWriteData), .WriteBackData(WriteBackData));
  
  always @(instr,Zero)
    begin
      if (instr[6:0]==7'b1100011 && instr[14:12]==3'b000)
        Branch = 1'b1;
      else
        Branch = 1'b0;
      PCSrc = Branch & Zero;
    end
  
  always @(instr)
    begin
      if ((instr[6:0]==7'b0000011 && instr[14:12]==3'b010) || (instr[6:0]==7'b0100011 && instr[14:12]==3'b010) || (instr[6:0]==7'b0010011 && (instr[14:12]!=3'b001 && instr[14:12]!=3'b011 && instr[14:12]!=3'b101)))
        ALUSrc = 1'b1;
      else
        ALUSrc = 1'b0;
    end
  
  always @(instr)
    begin
      //SUB Operation (BEQ, SUB)
      if ((instr[6:0]==7'b1100011 && instr[14:12]==3'b000) || (instr[6:0]==7'b0110011 && instr[14:12]==3'b000 && instr[31:25]==7'b0100000))
        ALUCtrl = 4'b0110;
      //ADD Operation (ADD, LW, SW)
      else if (((instr[6:0]==7'b0000011 || instr[6:0]==7'b0100011) && (instr[14:12]==3'b010)) || (instr[6:0]==7'b0010011 && instr[14:12]==3'b000) || (instr[6:0]==7'b0110011 && instr[14:12]==3'b000 && instr[31:25]==7'b0000000))
        ALUCtrl = 4'b0010;
      //AND Operation (AND, ANDI)
      else if ((instr[6:0]==7'b0010011 && instr[14:12]==3'b111) || (instr[6:0]==7'b0110011 && instr[14:12]==3'b111 && instr[31:25]==7'b0000000))
        ALUCtrl = 4'b0000;
      //OR Operation (OR, ORI)
      else if ((instr[6:0]==7'b0010011 && instr[14:12]==3'b110) || (instr[6:0]==7'b0110011 && instr[14:12]==3'b110 && instr[31:25]==7'b0000000))
        ALUCtrl = 4'b0001;
      //XOR Operation (XOR, XORI)
      else if ((instr[6:0]==7'b0010011 && instr[14:12]==3'b100) || (instr[6:0]==7'b0110011 && instr[14:12]==3'b100 && instr[31:25]==7'b0000000))
        ALUCtrl = 4'b1101;
      //SLT Operation (SLT)
      else if ((instr[6:0]==7'b0010011 && instr[14:12]==3'b010) || (instr[6:0]==7'b0110011 && instr[14:12]==3'b010 && instr[31:25]==7'b0000000))
        ALUCtrl = 4'b0111;
      //SRL Operation (SRL, SRLI)
      else if ((instr[6:0]==7'b0010011 && instr[14:12]==3'b101 && instr[31:25]==7'b0000000) || (instr[6:0]==7'b0110011 && instr[14:12]==3'b101 && instr[31:25]==7'b0000000))
        ALUCtrl = 4'b1000;
      //SLL Operation (SLL, SLLI)
      else if ((instr[6:0]==7'b0010011 && instr[14:12]==3'b001 && instr[31:25]==7'b0000000) || (instr[6:0]==7'b0110011 && instr[14:12]==3'b001 && instr[31:25]==7'b0000000))
        ALUCtrl = 4'b1001;
      //SRA Operation (SRA, SRAI)
      else if ((instr[6:0]==7'b0010011 && instr[14:12]==3'b101 && instr[31:25]==7'b0100000) || (instr[6:0]==7'b0110011 && instr[14:12]==3'b101 && instr[31:25]==7'b0100000))
        ALUCtrl = 4'b1010;
    end
  
  always @(posedge clk or posedge rst)
    begin: STATE_MEMORY
      if(rst) 
        begin
          current_state <= instr_fetch;
        end
      else
        begin
          current_state <= next_state;
        end
    end
  
  always @(current_state)
    begin: NEXT_STATE_LOGIC
      case (current_state)
        instr_fetch: next_state = instr_dec;
        instr_dec: next_state = exec;
        exec: 
          begin
            if ((instr[6:0]==7'b0000011 || instr[6:0]==7'b0100011) && instr[14:12]==3'b010)
              next_state = mem;
            else
              next_state = wr_back;
          end
        mem: next_state = wr_back;
        wr_back: next_state = instr_fetch;
        default: next_state = instr_fetch;
      endcase
    end
   
  always @(current_state)
    begin: OUTPUT_LOGIC
      case (current_state)
        instr_fetch:
          begin
            LoadPC = 1'b0;MemRead = 1'b0;MemWrite = 1'b0;MemToReg = 1'b0;RegWrite = 1'b0;
          end
        instr_dec:
          begin
            LoadPC = 1'b0;MemRead = 1'b0;MemWrite = 1'b0;MemToReg = 1'b0;RegWrite = 1'b0;
          end
        exec: 
         begin
           LoadPC = 1'b0;MemToReg = 1'b0;RegWrite = 1'b0;
           if (instr[6:0]==7'b0000011 && instr[14:12]==3'b010)
             begin
               MemRead <= 1'b1;MemWrite <= 1'b0;
             end
           else if (instr[6:0]==7'b0100011 && instr[14:12]==3'b010)
             begin
               MemRead <= 1'b0;MemWrite <= 1'b1;
             end
           else
             begin
               MemRead <= 1'b0;MemWrite <= 1'b0;
             end
         end
       mem:
         begin
           LoadPC = 1'b0;MemRead <= 1'b0;MemWrite <= 1'b0;
           if ((instr[6:0]==7'b0010011 && instr[14:12]!=3'b011) || (instr[6:0]==7'b0110011 && instr[14:12]!=3'b011))
             begin
               MemToReg <= 1'b0;RegWrite <= 1'b1;
             end
           else if (instr[6:0]==7'b0000011 && instr[14:12]==3'b010)
             begin
               MemToReg <= 1'b1;RegWrite <= 1'b1;
             end
           else
             begin
               MemToReg <= 1'b0;RegWrite <= 1'b0;
             end
         end
        wr_back:
          begin
            LoadPC = 1'b1;MemRead = 1'b0;MemWrite = 1'b0;MemToReg <= 1'b0;RegWrite <= 1'b0;
          end
        default:
          begin
            LoadPC = 1'b1;MemRead = 1'b0;MemWrite = 1'b0;MemToReg = 1'b0;RegWrite = 1'b0;
          end
      endcase
    end
  
endmodule