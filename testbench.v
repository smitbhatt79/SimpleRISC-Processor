`timescale 1ns/1ps

module tb_processor;

    reg clk_sig;
    reg reset_sig;

    // Connecting the processor module
    SimpleRISC_Processor core (
        .clk(clk_sig),
        .rst(reset_sig)
    );

    // Clock: toggles every 5ns (100MHz)
    initial clk_sig = 0;
    always #5 clk_sig = ~clk_sig;

    initial begin
        $display("---------------------------- Begin Simulation --------------------------------------");
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_processor);

        reset_sig = 1;
        #7;
        reset_sig = 0;

        #150;
        $display("---------------------------- End Simulation --------------------------------------");
        $finish;
    end

endmodule
