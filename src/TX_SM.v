`timescale 10ns/1ps
module TX_SM(
input clk,
input reset,
input HOLD_REG_FULL,
input HOLD_REG_EMPTY,
input DATA_WAIT,
output reg [7:0] dataIn,
output reg TX_VALID,
output reg TX_READY);
reg [40:0] data;
reg flag;
integer i;
reg [7:0] SYNC, PID, EOP;

initial begin
  flag = 0;
  dataIn = 0;
  TX_VALID = 0;
  TX_READY = 0;
  data = 40'b0110111101101100011011000110010101101000;
  SYNC = 8'b00101010;
  PID = 8'b01111000;
  EOP = 8'b00010000;
end

initial begin
  #512 $finish;
end

initial begin
  #16 TX_READY = 1;
end

always @ ( posedge clk ) begin
  if (reset) begin
    TX_READY = 0;
  end
  if (TX_READY & (!flag)) begin
    dataIn = SYNC;
    #16
    dataIn = PID;
    #16
    TX_VALID = 1;
    flag = 1;
    dataIn = 0;
  end

  if (TX_VALID) begin
    if (!DATA_WAIT) begin
      dataIn = data[8:0];
      data = data >> 8;

      #16;
      if (data == 0) begin
        TX_VALID = 0;
        dataIn = EOP;
        #16
        TX_READY = 0;
        flag = 0;
        dataIn = 0;
      end
    end
  end
end

endmodule
