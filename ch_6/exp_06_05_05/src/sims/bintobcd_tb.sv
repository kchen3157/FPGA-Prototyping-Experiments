`timescale 1 ns/10 ps


module bintobcd_tb;

    // ********** Parameters **********
    localparam WIDTH = 32; // Be able to handle numbers up to 1E9
    localparam CLK_PERIOD = 10; // 10 ns -> 100 MHz

    // ********** DUT IO **********
    logic i_clk, i_rst;
    logic i_start;
    logic [31:0] i_bin;

    logic o_ready, o_done;
    logic [3:0] o_bcd3, o_bcd2, o_bcd1, o_bcd0;
    logic [3:0] o_bcd6, o_bcd5, o_bcd4;
    logic [3:0] o_dp;

    // ********** DUT Instantiation **********
    bintobcd dut_bintobcd
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
            repeat(2) @(posedge i_clk);
            i_rst = 1'b0;
            repeat(2) @(posedge i_clk);
        end
    endtask

    task automatic start();
        begin
            wait(o_ready === 1'b1);
            @(posedge i_clk);
            i_start = 1'b1;
            @(posedge i_clk);
            i_start = 1'b0;
        end
    endtask

    task automatic set_input(logic [WIDTH-1:0] bin);
        begin
            i_bin = bin;
        end
    endtask

    initial
    begin
        set_input(0);
        reset();

        set_input(32'd9999999);
        start();

        @(posedge o_done);
        set_input(0);
        start();

        @(posedge o_done);
        set_input(32'd6767);
        start();

        @(posedge o_done);
        set_input(32'd7676767);
        start();

        @(posedge o_done);
        repeat(5)
        begin
            real rand_input = $urandom_range(0, 9_999_999.0);
            set_input(rand_input);
            start();
            @(posedge o_done);
        end

        // wait some more
        repeat(3) @(posedge i_clk);

        $stop;
    end


endmodule