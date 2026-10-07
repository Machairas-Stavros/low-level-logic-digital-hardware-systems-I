`include "calc_enc.v"
`include "alu.v"

module calc(output wire [15:0] led, input wire [15:0] sw,
            input wire clk, btnc, btnl, btnu, btnr, btnd);
  
  reg [15:0] accumulator;
  
  initial
    begin
      accumulator = 16'hxxxx;
    end
  
  wire z0;
  wire [3:0] alu_op0;
  wire [31:0] res0,op1_0,op2_0; 
  
  assign op1_0 = {{16{accumulator[15]}},accumulator};
  assign op2_0 = {{16{sw[15]}},sw};
  
  decoder d1 (.alu_op(alu_op0), .btnl(btnl), .btnr(btnr), .btnc(btnc));
  alu a1 (.zero(z0), .result(res0), .op1(op1_0), .op2(op2_0), .alu_op(alu_op0));
  
  always @(posedge clk or posedge btnu)
    begin
      if(btnu)
        accumulator = 16'b0;
      if(btnd) 
        accumulator = res0[15:0];
  	end
  
  assign led = accumulator;

endmodule