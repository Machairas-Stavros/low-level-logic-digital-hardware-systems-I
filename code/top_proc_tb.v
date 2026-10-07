`timescale 1ns/1ps
`include "top_proc.v"
`include "ram.v"
`include "rom.v"

module mc_tb;
  
  reg clk,rst; wire MemRead,MemWrite;
  wire [31:0] instr, dReadData, WriteBackData,PC,dAddress,dWriteData; 
  
  initial
    begin
      $dumpfile("mult_tb.vcd"); $dumpvars;
      clk = 1'b0;
      rst = 1'b1;
    end
  
  multicycle mc1 (.clk(clk), .rst(rst), .MemRead(MemRead), .MemWrite(MemWrite), .instr(instr), .dReadData(dReadData), .WriteBackData(WriteBackData), .PC(PC), .dWriteData(dWriteData), .dAddress(dAddress));
  
  INSTRUCTION_MEMORY im1 (.clk(clk), .addr(PC[8:0]), .dout(instr));
  
  DATA_MEMORY dm1(.clk(clk), .we(MemWrite & ~MemRead), .addr(dAddress), .din(dWriteData), .dout(dReadData));
  
  always 
    begin
      #10; 
      clk = ~ clk;
    end
 
  initial 
    begin
      
      #20 
      rst = 1'b0;
      
    end 
      
endmodule