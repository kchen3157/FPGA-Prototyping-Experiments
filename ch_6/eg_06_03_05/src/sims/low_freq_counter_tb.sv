module low_freq_counter_tb;

    localparam CLOCK_PER = 10;
    localparam SIGNAL_PER = 250000000;

    logic i_clk, i_rst;
    logic i_start, i_signal;
    logic [3:0] o_freq_bcd [3:0];

    low_freq_counter low_freq_counter_uut
        (.*);

    // generate clock
    always
    begin
        i_clk = 1'b1;
        #(CLOCK_PER/2);
        i_clk = 1'b0;
        #(CLOCK_PER/2);
    end

    // generate signal
    always
    begin
        i_signal = 1'b1;
        #(SIGNAL_PER/2);
        i_signal = 1'b0;
        #(SIGNAL_PER/2);
    end

    initial
    begin
        i_start = 1'b0;
        i_rst = 1'b1;
        repeat(3) @(posedge i_clk);
        i_rst = 1'b0;
        @(posedge i_clk);
        i_start = 1'b1;
        @(posedge i_clk);
        i_start = 1'b0;
        repeat(5) @(posedge i_signal);

        $stop;
    end
endmodule
