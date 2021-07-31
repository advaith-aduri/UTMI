module NRZI_encoder(
    input data_in,
    input clk,
    input reset,
    output reg NRZI_out);

    initial begin
        NRZI_out = 0;
    end
    always @ (posedge clk) begin
        if (data_in & (~reset)) begin
            NRZI_out = ~NRZI_out;
        end
    end
endmodule
