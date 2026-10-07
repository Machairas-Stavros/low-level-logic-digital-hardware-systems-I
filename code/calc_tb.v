`timescale 1ns/1ps
`include "calc.v"

module tb;
  
  reg clk,btnl,btnr,btnu,btnd,btnc;
  reg [15:0] sw; 
  wire [15:0] led, prev;
  
  initial
    begin
      $dumpfile("calc_tb.vcd"); $dumpvars;
      clk = 1'b0;
      btnu = 1'b1;
      btnd = 1'b0;
      btnr = 1'b0;
      btnl = 1'b0;
      btnc = 1'b0;
      sw = 16'bxxxxxxxxxxxxxxxx;
    end
  
   calc c1 (
    .led(led), .sw(sw), .clk(clk), .btnl(btnl), .btnr(btnr), 
     .btnu(btnu), .btnd(btnd), .btnc(btnc));
  
  assign  #20 prev = led;
  
  always 
    begin
      #10; 
      clk = ~ clk;
    end
 
  initial 
    begin
      
      #20;
      sw = 16'h1234;
      btnu = 1'b0;
      btnl = 1'b0;
      btnc = 1'b1;
      btnr = 1'b1;
      btnd = 1'b1;
      
      #20;
      sw = 16'h0ff0;
      btnl = 1'b0;
      btnc = 1'b1;
      btnr = 1'b0;
      
      #20;
      sw = 16'h324f;
      btnl = 1'b0;
      btnc = 1'b0;
      btnr = 1'b0;

      #20;
      sw = 16'h2d31;
      btnl = 1'b0;
      btnc = 1'b0;
      btnr = 1'b1;

      #20;
      sw = 16'hffff;
      btnl = 1'b1;
      btnc = 1'b0;
      btnr = 1'b0;
      
      #20;
      sw = 16'h7346;
      btnl = 1'b1;
      btnc = 1'b0;
      btnr = 1'b1;
      
      #20;
      sw = 16'h0004;
      btnl = 1'b1;
      btnc = 1'b1;
      btnr = 1'b0;
      
      #20;
      sw = 16'h0004;
      btnl = 1'b1;
      btnc = 1'b1;
      btnr = 1'b1;
      
      #20;
      sw = 16'hffff;
      btnl = 1'b1;
      btnc = 1'b0;
      btnr = 1'b1;
      
      #20
      $finish;
      
    end 
      
endmodule