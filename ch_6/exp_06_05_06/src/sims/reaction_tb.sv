// Testbench for Reaction Control Module (reaction)
//

`timescale 1 ns/10 ps

module reaction_tb;

    // ********** Parameters **********
    localparam CLK_FREQ = 100_000_000;
    localparam CLK_PERIOD = 10; // 10 ns -> 100 MHz
    localparam CYCLES_PER_MS = 1_000_000 / CLK_PERIOD;

    // Shorten simulation wait time 
    localparam SIM_UPPER_WAIT_MS = 15;
    localparam SIM_LOWER_WAIT_MS = 2;

    // ********** UUT IO **********
    logic i_clk, i_rst;

    logic i_start, i_clear, i_stop; // user control signals

    logic [13:0] o_display_val; // output to display, in binary (BCD conversion and led mux handled by other modules)
    logic o_display_greeting; // when high, the display module ignores input val and displays "HI"
    logic o_led; // stimulus LED

    // ********** DUT Instantiation **********
    reaction 
        #(.UPPER_WAIT_MS(SIM_UPPER_WAIT_MS), .LOWER_WAIT_MS(SIM_LOWER_WAIT_MS))
        dut_reaction (.*);

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
            i_clear = '0;
            i_stop = '0;
            repeat(2) @(posedge i_clk);
            i_rst = 1'b0;
            repeat(2) @(posedge i_clk);
        end
    endtask

    task automatic wait_ms(input int ms);
        int j;
        for (j = 0; j < ms; j++) begin
            repeat (CYCLES_PER_MS) @(posedge i_clk);
        end
        $display("Info: Waiting %0d ms", ms);
    endtask

    task automatic start();
        begin
            @(posedge i_clk);
            i_start <= 1'b1;
            @(posedge i_clk);
            i_start <= 1'b0;
            $display("Info: Start button pressed");
        end
    endtask

    task automatic stop();
        begin
            @(posedge i_clk);
            i_stop <= 1'b1;
            @(posedge i_clk);
            i_stop <= 1'b0;
            $display("Info: Stop button pressed");
        end
    endtask

    task automatic clear();
        begin
            @(posedge i_clk);
            i_clear <= 1'b1;
            @(posedge i_clk);
            i_clear <= 1'b0;
            $display("Info: Clear button pressed");
        end
    endtask

    initial
    begin
        reset();
        clear();

        if (!o_display_greeting)
        begin
            $error("o_display_greeting not asserted after clear");
        end

        // Check regular reaction
        $display("Info: Start regular reaction test");
        start();
        @(posedge o_led);
        $display("Info: Got LED on");
        wait_ms(2);
        stop();
        $display("Result: display_val = %0d ms", o_display_val);

        // Check premature reaction
        $display("Info: Start premature reaction test");
        start();
        wait_ms(10);
        stop();
        $display("Result: display_val = %0d ms", o_display_val);

        // Check none reaction (> 1000 ms)
        $display("Info: Start none reaction test");
        start();
        @(posedge o_led);
        $display("Info: Got LED on");
        wait_ms(1001);
        stop();
        $display("Result: display_val = %0d ms", o_display_val);
        
        // wait some more
        repeat(3) @(posedge i_clk);

        $stop;
    end
    
    
endmodule