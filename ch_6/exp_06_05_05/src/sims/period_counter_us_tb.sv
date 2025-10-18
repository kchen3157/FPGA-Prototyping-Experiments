// Testbench for Microsecond Period Counter
//
// TESTED INPUT(i_gen_amt_bcd): 
// TESTED OUTPUT(o_final_bcd): 
// 
//! Testing the whole frame of input takes a while
//! SIMULATION TIME: 

`timescale 1 ns/10 ps

module period_counter_us_tb;

    // ********** Parameters **********
    localparam CLK_FREQ = 100_000_000;
    localparam CLK_PERIOD = 10; // 10 ns -> 100 MHz
    localparam POLL_FREQ = 1_000_000; // 1 us period


    // ********** UUT IO **********
    logic i_clk, i_rst;
    logic i_start;
    logic i_signal;

    logic o_ready, o_done;
    logic o_overflow, o_underflow;
    logic [$clog2(POLL_FREQ)-1:0] o_period;

    // ********** UUT Instantiation **********
    period_counter_us 
        #(
            .CLK_FREQ(CLK_FREQ),
            .POLL_FREQ(POLL_FREQ)
        ) uut_period_counter_us
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

    task automatic verify_measurement
        (
            real    exp_period_us,
            bit     exp_underflow,
            bit     exp_overflow
        );
        begin
            @(posedge o_done);

            $display("Ran %0f got %0d underflow %0b overflow %0b",
               exp_period_us, o_period, o_underflow, o_overflow);
            
            assert(o_underflow === exp_underflow)
                else $error("Mismatch on o_underflow: expected %0b got %0b",
                            exp_underflow, o_underflow);
            assert(o_overflow === exp_overflow)
                else $error("Mismatch on o_overflow: expected %0b got %0b",
                            exp_overflow, o_overflow);
            
            if (!exp_overflow && !exp_underflow)
            begin
                int diff = (int'(exp_period_us) - o_period);
                if (diff < 0)
                begin
                    diff = -diff;
                end
                assert(diff <= 1)
                    else $error("Mismatch on o_period: expected %0f got %0d", exp_period_us, o_period);
            end

            wait(o_ready === 1'b1);
        end
    endtask

    initial
    begin
        reset();

        start_measurement();
        generate_signal(0.67);
        verify_measurement(0.67, 1'b1, 1'b0); // Underflow

        start_measurement();
        generate_signal(1);
        verify_measurement(1, 1'b0, 1'b0);

        start_measurement();
        generate_signal(1.67);
        verify_measurement(1.67, 1'b0, 1'b0);

        start_measurement();
        generate_signal(6767.67);
        verify_measurement(6767.67, 1'b0, 1'b0);
    
        start_measurement();
        generate_signal(676767.67);
        verify_measurement(676767.67, 1'b0, 1'b0);

        start_measurement();
        generate_signal(999_999.0);
        verify_measurement(999_999.0, 1'b0, 1'b0);

        start_measurement();
        generate_signal(1_000_000.0);
        verify_measurement(1_000_000.0, 1'b0, 1'b1); // Overflow

        repeat(5)
        begin
            real random_period_us = $urandom_range(1.0, 999_999.0);
            start_measurement();
            generate_signal(random_period_us);
            verify_measurement(random_period_us, 1'b0, 1'b0);
        end

        // wait some more
        repeat(3) @(posedge i_clk);

        $stop;
    end
    
    
endmodule