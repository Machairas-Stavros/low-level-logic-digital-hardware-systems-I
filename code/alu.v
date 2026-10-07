module alu (output wire zero, output wire [31:0] result, input wire [31:0] op1, op2, input wire [3:0] alu_op);
  
  parameter[3:0] ALUOP_AND = 4'b0000; //Logic AND
  parameter[3:0] ALUOP_OR = 4'b0001; //Logic OR
  parameter[3:0] ALUOP_ADD = 4'b0010; //Addition
  parameter[3:0] ALUOP_SUB = 4'b0110; //Substraction
  parameter[3:0] ALUOP_SLT = 4'b0111; //Set Less than
  parameter[3:0] ALUOP_SRL = 4'b1000; //Logic Shift Right
  parameter[3:0] ALUOP_SLL = 4'b1001; //Logic Shift Left
  parameter[3:0] ALUOP_SRA = 4'b1010; //Arithmetic Shift Right
  parameter[3:0] ALUOP_XOR = 4'b1101; //Logic XOR
  
  assign result = 
    (alu_op == ALUOP_AND) ? op1 & op2:
    (alu_op == ALUOP_OR) ? op1 | op2:
    (alu_op == ALUOP_ADD) ? op1 + op2:
    (alu_op == ALUOP_SUB) ? op1 - op2:
    (alu_op == ALUOP_SLT) ? ((-op1 < -op2) ? 32'b1 : 32'b0):
    (alu_op == ALUOP_SRL) ? op1 >> op2[4:0]:
    (alu_op == ALUOP_SLL) ? op1 << op2[4:0]:
    (alu_op == ALUOP_SRA) ? -(-op1 >>> op2[4:0]):
    (alu_op == ALUOP_XOR) ? op1 ^ op2:
    32'hxxxxxxxx;
  
  assign zero = (result == 32'b0) ? 1'b1 : 1'b0;
  
endmodule