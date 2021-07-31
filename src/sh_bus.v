module sh_bus(
  input clk,
  input dataIn,
  output reg [7:0] dataOut,
  output reg DATA_WAIT);
  integer i, j;
  reg [7:0] temp;
  reg [5:0] BUS;
  reg flag;

  initial begin
    temp = 0;
    BUS = 0;
    dataOut = 0;
    i = 0;
    j = 0;
    DATA_WAIT = 0;
    flag = 0;
  end

  always @ (posedge clk) begin
    if (i == 8) begin
      if (DATA_WAIT) begin
        dataOut = 0;
        for (i = j; i < 7; i = i + 1) begin
          temp[i] = temp[i + 1];
        end
        temp[7] = dataIn;
        flag = 1;
        j = 0;
      end
      else begin
      dataOut[7:0] = temp[7:0];
      end
      i = 0;
    end
    if (flag) begin
      i = i + 1;
      if (i == 8) begin
        flag = 0;
        DATA_WAIT = 0;
      end
    end
    else begin
      BUS = BUS << 1;
      BUS[0] = dataIn;
      if (BUS == 6'b111111) begin
        temp[i] = dataIn;
        DATA_WAIT = 1;
        i = i + 1;
        j = i;
      end
      else begin
        temp[i] = dataIn;
        i = i + 1;
      end
    end
  end
endmodule
