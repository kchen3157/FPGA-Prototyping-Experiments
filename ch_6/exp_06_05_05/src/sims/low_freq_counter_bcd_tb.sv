// Testbench for Low Frequency Counter
//
// 
//! Testing the whole frame of input takes a while
//! SIMULATION TIME: 

`timescale 1 ns/10 ps

module low_freq_counter_bcd_tb;

    // ********** Parameters **********
    localparam CLK_FREQ = 100_000_000;
    localparam CLK_PERIOD = 10; // 10 ns -> 100 MHz

    // ********** UUT IO **********
    logic i_clk, i_rst;
    logic i_start, i_signal;

    logic [3:0] o_freq_bcd3;
    logic [3:0] o_freq_bcd2;
    logic [3:0] o_freq_bcd1;
    logic [3:0] o_freq_bcd0;
    logic [3:0] o_freq_dp;

    logic o_ready, o_done;

    // ********** DUT Instantiation **********
    low_freq_counter_bcd dut_low_freq_counter_bcd
        (.*);

    // ********** Clockgen **********
    initial i_clk = 1'b0;
    always 
    begin
        #(CLK_PERIOD/2);
        i_clk = ~i_clk;
    end

    // ********** Testbench Tasks **********
    task automatic reset();
        begin
            i_rst = 1'b1;
            i_start = 1'b0;
            i_signal = 1'b0;
            repeat(2) @(posedge i_clk);
            i_rst = 1'b0;
            repeat(2) @(posedge i_clk);
        end
    endtask

    task automatic start_measurement();
        begin
            wait(o_ready === 1'b1);
            @(posedge i_clk);
            i_start = 1'b1;
            @(posedge i_clk);
            i_start = 1'b0;
        end
    endtask

    task automatic generate_signal(real period_us);
        real period_ns;
        begin
            period_ns = period_us * 1000.0;

            @(posedge i_clk);
            i_signal = 1'b1;
            @(posedge i_clk);
            i_signal = 1'b0;

            #(period_ns - CLK_PERIOD);

            @(posedge i_clk);
            i_signal = 1'b1;
            @(posedge i_clk);
            i_signal = 1'b0;
        end
    endtask

    task automatic verify
        (
            real    period_us
        );
        int diff;
        begin
            @(posedge o_done);

            $display("div_tb: Ran %0f period, should be %0f frequency, got %0d%0d%0d%0d with decimal %0d",
               period_us, (1_000_000_000/period_us), o_freq_bcd3, o_freq_bcd2, o_freq_bcd1, o_freq_bcd0, o_freq_dp);

            wait(o_ready === 1'b1);
        end
    endtask

    initial
    begin
        reset();

        // start_measurement();
        // generate_signal(0.67);
        // verify(0.67, 1'b1, 1'b0); // Underflow

        start_measurement();
        generate_signal(1);
        verify(1);

        start_measurement();
        generate_signal(1.67);
        verify(1);

        start_measurement();
        generate_signal(6767.67);
        verify(6767.67);
    
        start_measurement();
        generate_signal(676767.67);
        verify(676767.67);

        start_measurement();
        generate_signal(999_999.0);
        verify(999_999.0);

        // start_measurement();
        // generate_signal(1_000_000.0);
        // verify(1_000_000.0, 1'b0, 1'b1); // Overflow

        repeat(5)
        begin
            real random_period_us = $urandom_range(1.0, 999_999.0);
            start_measurement();
            generate_signal(random_period_us);
            verify(random_period_us);
        end

        // wait some more
        repeat(3) @(posedge i_clk);

        $stop;
    end
    
    
endmodule