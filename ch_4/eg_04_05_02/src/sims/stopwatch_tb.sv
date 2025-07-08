`timescale 1 ns/10 ps

module stopwatch_tb;

    localparam CLOCK_T = 10; // 10 ns -> 100 MHz

    logic i_clk;
    logic i_go, i_clr;
    logic [3:0] o_s2, o_s1, o_s0;

    stopwatch_cascade #(.DVSR(2)) u_stopwatch_cascade
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
        i_go = 1'b0;
        i_clr = 1'b1;
        
        // wait some
        repeat(3) @(posedge i_clk);
        
        // start counting
        i_clr = 1'b0;
        i_go = 1'b1;

        wait(o_s2 == 4'h1);
        $stop;
    end
    
    
endmodule