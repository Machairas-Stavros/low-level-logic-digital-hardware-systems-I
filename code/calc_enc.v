module decoder(output wire [3:0] alu_op, input wire btnl, btnr, btnc);
    
  assign alu_op[0] = (~btnr & btnl) | ((btnl ^ btnc) & btnr);
  assign alu_op[1] = (btnr & btnl) | (~btnl & ~btnc);
  assign alu_op[2] = ((btnr & btnl) | (btnr ^ btnl)) & ~btnc;
  assign alu_op[3] = ((~btnr & btnc) | (btnr ~^ btnc)) & btnl;
  
endmodule