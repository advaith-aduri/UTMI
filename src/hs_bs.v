module hs_bs(
  input [7:0] dataIn,
  input clk,
  input TX_VALID,
  input TX_READY,
  output reg DATA_WAIT,
  output HOLD_REG_FULL,
  output reg HOLD_REG_EMPTY,
  output reg dataOut);

  reg [7:0] temp;
  reg [6:0] DW_C;
  integer i;
  reg [5:0] BSV;
  reg temp_bit,flag;

  assign HOLD_REG_FULL = ~(HOLD_REG_EMPTY);


  initial begin
    temp = 0;
    dataOut = 0;
    i = 8;
    DATA_WAIT = 0;
    HOLD_REG_EMPTY = 1;
    BSV = 6'b000000;
    flag = 0;
    DW_C = 7'b1111111;
  end

  always @ (posedge clk) begin

    if (TX_READY) begin
      HOLD_REG_EMPTY = 0;
      if (i == 8) begin
        if (!DATA_WAIT) begin
          temp = dataIn;
        end
        else begin
          temp = 8'b00000000;
          temp[0] = temp_bit;
          flag = 1;
        end
      i = 0;
      end
      BSV = BSV << 1;
      BSV[0] = temp[i];
      if (BSV == 6'b111111) begin
        if (i == 7) begin
          temp_bit = 0;
        end
        else begin
          temp_bit = temp[7];
        end
        DATA_WAIT = 1;
      end
      dataOut = temp[i];
      if (BSV == 6'b111111) begin
        temp = temp << 1;
        temp[i+1] = 0;
      end
      if (DATA_WAIT & flag) begin
        DW_C = DW_C << 1;
        DW_C[0] = dataOut;
        if (DW_C[6:0] == 7'b0000000) begin
          DW_C = 7'b1111111;
          flag = 0;
          DATA_WAIT = 0;
        end
      end
      i = i + 1;
      if (BSV == 6'b111111) begin
      BSV = 6'b000000;
      end
    end
    else begin
      temp = 0;
      dataOut = 0;
      i = 8;
      DATA_WAIT = 0;
      HOLD_REG_EMPTY = 1;
      BSV = 6'b000000;
      flag = 0;
      DW_C = 7'b1111111;
    end
  end
endmodule
