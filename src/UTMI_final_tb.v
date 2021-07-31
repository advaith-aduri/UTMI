`timescale 10ns / 1ps
module UTMI_final_tb;
reg clk, clk_8;
// TX Connections
wire TX_DATA_WAIT, HOLD_REG_EMPTY, HOLD_REG_FULL, TX_READY, TX_VALID, HS_DATA_OUT, NRZI_ENCODER_DATA_OUT;
wire [7:0] HS_DATA_IN;
// RX Connections
wire NRZI_DECODER_DATA_OUT, RX_DATA_WAIT, RX_ACTIVE, RX_DATA, RX_VALID;
wire [7:0] SH_DATA_OUT, SIE_DATA;
//Initializing clock
initial begin
    clk = 1;
end
always #1 clk = ~clk;

// Module Connections
TX_SM U1(.DATA_WAIT(TX_DATA_WAIT), .HOLD_REG_EMPTY(HOLD_REG_EMPTY), .HOLD_REG_FULL(HOLD_REG_FULL), .TX_READY(TX_READY), .TX_VALID(TX_VALID), .dataIn(HS_DATA_IN), .clk(clk));
hs_bs U2(.TX_READY(TX_READY), .TX_VALID(TX_VALID), .clk(clk), .dataIn(HS_DATA_IN), .dataOut(HS_DATA_OUT), .HOLD_REG_EMPTY(HOLD_REG_EMPTY), .HOLD_REG_FULL(HOLD_REG_FULL), .DATA_WAIT(TX_DATA_WAIT));
NRZI_encoder U3(.clk(clk), .data_in(HS_DATA_OUT), .NRZI_out(NRZI_ENCODER_DATA_OUT));
NRZI_decoder U4(.NRZI_in(NRZI_ENCODER_DATA_OUT), .clk(clk), .data_out(NRZI_DECODER_DATA_OUT));
sh_bus U5(.clk(clk), .dataIn(NRZI_DECODER_DATA_OUT), .dataOut(SH_DATA_OUT), .DATA_WAIT(RX_DATA_WAIT));
RX_SM U6(.SH_DATA_IN(NRZI_DECODER_DATA_OUT), .SH_DATA_WAIT(RX_DATA_WAIT), .SH_DATA_OUT(SH_DATA_OUT), .RX_ACTIVE(RX_ACTIVE), .RX_VALID(RX_VALID), .RX_DATA(RX_DATA), .SIE_DATA(SIE_DATA));

// Testing
initial begin
  $dumpfile("UTMI_final_tb.vcd");
  $dumpvars(2,UTMI_final_tb);
  #512 $finish;
end
endmodule
