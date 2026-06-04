`timescale 1ns/1ps

module debounce_tb;

    reg clk;
    reg reset;
    reg sw;
    wire clean_sw;

    // DUT
    debouncer #(
        .max_count(5)
    ) dut (
        .clk(clk),
        .reset(reset),
        .sw(sw),
        .clean_sw(clean_sw)
    );

    // Clock generation (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin

        // Initial conditions
        reset = 1;
        sw  = 0;

        #20;
        reset = 0;

        // ==========================
        // Simulate button press bounce
        // ==========================

        #20;
        sw = 1;
        #10;
        sw = 0;
        #10;
        sw = 1;
        #10;
        sw = 0;
        #10;
        sw = 1;

        // Now keep it stable
        #100;

        // ==========================
        // Simulate button release bounce
        // ==========================

        sw = 0;
        #10;
        sw = 1;
        #10;
        sw = 0;
        #10;
        sw = 1;
        #10;
        sw = 0;

        // Keep stable
        #100;

        $finish;
    end

    // Monitor signals
    initial begin
        $monitor(
            "Time=%0t  sw=%b  clean_sw=%b",
            $time, sw, clean_sw
        );
    end

endmodule
