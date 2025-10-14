// Testbench for 4 Byte Binary to 4 Digit BCD converter
//
// TESTED INPUT: 4 Byte Binary (0x0000->0x270F)
// TESTED OUTPUT: 4 Digit BCD (0000->9999)
// 
// SIMULATION TIME: ~1.8 ms

`timescale 1 ns/10 ps

module bin4tobcd4_tb;

    localparam CLOCK_T = 10; // 10 ns -> 100 MHz

    logic i_clk, i_rst;
    logic i_start;
    logic [15:0] i_bin;

    logic o_ready, o_done;
    logic [3:0] o_bcd3, o_bcd2, o_bcd1, o_bcd0;


    // Unit Instantiation
    bin4tobcd4 uut_bin4tobcd4
        (.*);

    always // generate clock
    begin
        i_clk = 1'b1;
        #(CLOCK_T/2);
        i_clk = 1'b0;
        #(CLOCK_T/2);
    end

    initial
    begin
        // first reset
        i_rst = 1'b1;
        i_start = 1'b0;
        i_bin = 16'h0000;
        @(posedge i_clk);
        i_rst = 1'b0;
        
        // wait some
        repeat(3) @(posedge i_clk);
        
        for (int i = 16'h0000; i <= 16'h270F; i = i + 1)
        begin
            wait (o_ready == 1'b1);
            i_bin = i;
            @(posedge i_clk);
            i_start = 1'b1;
            @(posedge i_clk);
            i_start = 1'b0;
            wait (o_done == 1'b1);
        end

        // wait some
        repeat(3) @(posedge i_clk);
    
        $stop;
    end
    
    
endmodule