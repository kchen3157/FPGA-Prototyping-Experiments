// Testbench for 2 Digit BCD to 2 Byte Binary converter
//
// TESTED INPUT: 2 Digit BCD (00->99)
// TESTED OUTPUT: 2 Byte Binary (0x00->0x63)
// 
// SIMULATION TIME: 12.03 us

`timescale 1 ns/10 ps

module bcd2tobin2_tb;

    localparam CLOCK_T = 10; // 10 ns -> 100 MHz

    logic i_clk, i_rst;
    logic i_start;
    logic [3:0] i_bcd1, i_bcd0;

    logic o_ready, o_done;
    logic [7:0] o_bin;


    // Unit Instantiation
    bcd2tobin2 uut_bcd2tobin2
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
        i_bcd1 = 4'h0;
        i_bcd0 = 4'h0;
        @(posedge i_clk);
        i_rst = 1'b0;
        
        // wait some
        repeat(3) @(posedge i_clk);
        
        for (int i = 4'h0; i <= 4'h9; i = i + 1)
        begin
            for (int j = 4'h0; j <= 4'h9; j = j + 1)
            begin
                wait (o_ready == 1'b1);
                i_bcd1 = i;
                i_bcd0 = j;
                @(posedge i_clk);
                i_start = 1'b1;
                @(posedge i_clk);
                i_start = 1'b0;
                wait (o_done == 1'b1);
            end
        end
    
        $stop;
    end
    
    
endmodule