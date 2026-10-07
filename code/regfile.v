module regfile(input wire clk, write, input wire [4:0] readReg1, readReg2, writeReg, input wire [31:0] writeData, output reg [31:0] readData1, readData2);
  parameter reg_length = 32;
  
  reg [reg_length-1:0] reg_array [reg_length-1:0];
  integer i;
  
  initial
    begin
      for (i=0; i<reg_length; i=i+1)
        reg_array[i] = 32'b0;
    end
  
  //basically the writing process when the reading and writing addresses coincide is executed at the next duty cycle.
  
  always @(clk)
    begin
      readData1 = reg_array[readReg1];
      readData2 = reg_array[readReg2];
      
      if(write)
        begin
          if (writeReg==readReg1 || writeReg==readReg2)
            reg_array[writeReg] <= writeData;
          else
            reg_array[writeReg] = writeData;
        end
    end
  
endmodule