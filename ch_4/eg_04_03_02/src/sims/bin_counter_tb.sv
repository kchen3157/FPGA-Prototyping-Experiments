`timescale 1 ns/10 ps

module bin_counter_tb;

    localparam T = 20;

    logic i_clk, i_resetn;
    logic i_syn_clr, i_load, i_en, i_up;
    logic [2:0] i_d;
    logic o_max_tick, o_min_tick;
    logic [2:0] o_q;

    univ_bin_counter #(.N(3)) uut_univ_bin_counter
        (.clk(i_clk), .resetn(i_resetn), .syn_clr(i_syn_clr),
         .load(i_load), .en(i_en), .up(i_up), .d(i_d),
         .max_tick(o_max_tick), .min_tick(o_min_tick),
         .q(o_q));

    always // T = 20 ns clock
    begin
        i_clk = 1'b1;
        #(T/2);
        i_clk = 1'b0;
        #(T/2);
    end

    initial // reset for first half cycle
    begin
        i_resetn = 1'b0;
        #(T/2);
        i_resetn = 1'b1;
    end

    initial
    begin
        // initial input
        i_syn_clr = 1'b0;
        i_load = 1'b0;
        i_en = 1'b0;
        i_up = 1'b1;
        i_d = 3'b000;
        @(posedge i_resetn); // wait for reset to deassert
        @(negedge i_clk); // wait for one clock

        // test load
        i_load = 1'b1;
        i_d = 3'b011;
        @(negedge i_clk);
        i_load = 1'b0;
        repeat(2) @(negedge i_clk);

        // test syn_clr
        i_syn_clr = 1'b1;
        @(negedge i_clk);
        i_syn_clr = 1'b0;

        // test up count, pause
        i_en = 1'b1;
        i_up = 1'b1;
        repeat(10) @(negedge i_clk);
        i_en = 1'b0;
        repeat(2) @(negedge i_clk);
        i_en = 1'b1;
        repeat(2) @(negedge i_clk);

        // test down count
        i_up = 1'b0;
        repeat(10) @(negedge i_clk);

        // continue until q = 2
        wait(o_q == 3'd2);
        @(negedge i_clk);
        i_up = 1'b1;
        
        // continue until min_tick is 1
        @(negedge i_clk);
        wait(o_min_tick);
        @(negedge i_clk);
        i_up = 1'b0;

        // absolute delay
        #(4*T);
        i_en = 1'b0;
        #(4*T);

        $stop;

    end

endmodule
