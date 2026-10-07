`include "regfile.v"
`include "alu.v"

module datapath #(parameter INITIAL_PC = 32'h00400000)(input wire clk, rst, PCSrc, ALUSrc, RegWrite, MemToReg, LoadPC, input wire [31:0] WriteBackData, input reg [31:0] instr, input wire [3:0] ALUCtrl, output wire Zero, output wire [31:0] dAddress, dWriteData, output reg [31:0] PC, dReadData);

  reg [31:0] branch_offset,imm;
  reg [11:0] imm_temp;
  wire [31:0] readData1, res_alu, op2_alu;
  
  regfile rf1 (.clk(clk), .write(RegWrite), .readReg1(instr[19:15]), .readReg2(instr[24:20]), .writeReg(instr[11:7]), .readData1(readData1), .readData2(dWriteData), .writeData(WriteBackData));
  
  assign op2_alu = ALUSrc ? imm : dWriteData;
      
  alu a1 (.zero(Zero), .result(res_alu), .op1(readData1), .op2(op2_alu), .alu_op(ALUCtrl));
  
  assign dAddress = res_alu;
  
  assign WriteBackData = MemToReg ? dReadData : res_alu;
  
  always @(posedge clk or posedge rst)
    begin
      if (rst)
        PC = INITIAL_PC;
      else if(LoadPC)
        begin
          if(PCSrc)
            PC <= PC+branch_offset;
          else
            PC <= PC+32'b0100;
        end
    end
  
  always @(instr)
    begin
      if ((instr[6:0]==7'b0010011 && (instr[14:12]==3'b000 || instr[14:12]==3'b010 || instr[14:12]==3'b100 || instr[14:12]==3'b110 || instr[14:12]==3'b111)) || (instr[6:0]==7'b0000011 && instr[14:12]==3'b010))
        begin
          imm_temp = instr[31:20];
          imm = {{20{imm_temp[11]}},imm_temp};
        end
      else if (instr[6:0]==7'b0100011 && instr[14:12]==3'b010)
        begin
          imm_temp = {instr[31:25],instr[11:7]};
          imm = {{20{imm_temp[11]}},imm_temp};
        end
      else if (instr[6:0]==7'b1100011 && instr[14:12]==3'b000)
        begin
          imm_temp = {instr[31],instr[7],instr[30:25],instr[11:8]};
          imm = {{20{imm_temp[11]}},imm_temp};
          branch_offset = imm<<1;
        end
    end
 
endmodule