`timescale 10ns/1ps
module RX_SM(
  input SH_DATA_IN,
  input SH_DATA_WAIT,
  output reg RX_ACTIVE,
  output reg RX_VALID,
  output reg RX_DATA,
  input [7:0] SH_DATA_OUT,
  output reg [7:0] SIE_DATA);

reg clk_1, clk_8;
reg [7:0] SYNC, PID, EOP;
integer i;

initial begin
  SYNC = 8'b00101010;
  PID = 8'b01111000;
  EOP = 8'b00010000;
end

initial begin
  clk_1 = 1;
  clk_8 = 0;
  clk_8 = 1;
  i = 0;
  RX_ACTIVE = 0;
  RX_VALID = 0;
  RX_DATA = 0;
  SIE_DATA = 0;
end

always #1 clk_1 = ~clk_1;
always #8 clk_8 = ~clk_8;


initial begin
  #8 RX_ACTIVE = 1;
end
always @ ( posedge clk_1 ) begin
  if (RX_ACTIVE) begin
    if (RX_VALID) begin
      if (SH_DATA_OUT == EOP) begin
        RX_VALID = 0;
        RX_DATA = 0;
        SIE_DATA = 0;
        #16;
      end
      else if (SH_DATA_OUT == PID) begin
        RX_DATA = 1;
        #16;
      end
      else begin
        if (SH_DATA_WAIT | (!RX_VALID)) begin
          RX_DATA = 0;
        end
        else begin
          RX_DATA = 1;
        end

        if (RX_DATA) begin
          SIE_DATA = SH_DATA_OUT;
          #16;
        end
        else begin
          SIE_DATA = 0;
        end
      end
    end
    if (SH_DATA_OUT == SYNC) begin
      RX_VALID = 1;
      #16;
    end
  end
  else begin
    SIE_DATA = 0;
  end
end

endmodule
