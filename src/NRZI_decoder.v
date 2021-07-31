module NRZI_decoder(
    input NRZI_in,
    input clk,
    input reset,
    output reg data_out);
    reg NRZI_in_d;
    wire transition;
    
    initial begin
        data_out = 0;
    end
    always @ (posedge clk) begin
        if (reset) begin
            NRZI_in_d = 0;
        end  
        else begin
            NRZI_in_d <= NRZI_in;
        end
    end
    
    assign transition = NRZI_in ^ NRZI_in_d;
    
    always @ (posedge clk) begin
        if (reset) begin
            data_out = 0;
        end
        else if (transition) begin
            data_out = 1;
        end
        else begin
            data_out = 0;
        end
    end
    
endmodule