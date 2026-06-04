`timescale 1ns/1ps

module debouncer #(
    parameter max_count = 100000 // ~ 10ms  (Assuming 10 Mhz Clk)
)(
    input clk,
    input reset,
    input sw,
    output reg clean_sw
);

reg sync1,sync2;  // Synchronizer Flip Flops

always @(posedge clk) begin
sync1 <= sw;
sync2 <= sync1;
end

reg [16:0] counter;

initial begin
    clean_sw = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        clean_sw <= 1'b0;
        counter <= 17'b0;
    end
    
    else begin
        if (sync2 == clean_sw) begin
           counter <= 17'b0;
        end
        
        else begin
            counter <= counter + 1;
            if (counter == max_count) begin
                clean_sw <= sync2;
                counter <= 17'b0;
            end
        end
    end
end

endmodule
         