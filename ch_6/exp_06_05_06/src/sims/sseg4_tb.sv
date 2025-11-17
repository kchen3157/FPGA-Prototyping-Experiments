`timescale 1 ns/10 ps


module sseg4_tb;

    // ********** Parameters **********
    localparam WIDTH = 14; // Be able to handle numbers up to 9999
    localparam CLK_PERIOD = 10; // 10 ns -> 100 MHz

    // ********** DUT IO **********
    logic i_clk, i_rst;
    logic [13:0] i_bin;
    logic i_greeting;

    logic [3:0] o_bcd3, o_bcd2, o_bcd1, o_bcd0;
    logic o_idle;

    // ********** DUT Instantiation **********
    sseg4 dut_sseg4
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
            i_bin = '0;
            i_greeting = 1'b0;
            repeat(2) @(posedge i_clk);
            i_rst = 1'b0;
            repeat(2) @(posedge i_clk);
        end
    endtask

    task automatic set_input(logic [WIDTH-1:0] bin);
        begin
            i_bin = bin;
        end
    endtask

    initial
    begin
        reset();

        for (logic [WIDTH-1:0] i = 0; i <= 14'h270F; i++)
        begin
            set_input(i);
            @(posedge i_clk);
            wait(o_idle === 1'b1);
            @(posedge i_clk);
        end

        repeat(500) @(posedge i_clk);

        $stop;
    end


endmodule