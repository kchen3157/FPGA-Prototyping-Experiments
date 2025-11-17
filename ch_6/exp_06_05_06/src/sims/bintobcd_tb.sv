`timescale 1 ns/10 ps


module bintobcd_tb;

    // ********** Parameters **********
    localparam WIDTH = 14; // Be able to handle numbers up to 9999
    localparam CLK_PERIOD = 10; // 10 ns -> 100 MHz

    // ********** DUT IO **********
    logic i_clk, i_rst;
    logic i_start;
    logic [13:0] i_bin;

    logic o_ready, o_done;
    logic [3:0] o_bcd3, o_bcd2, o_bcd1, o_bcd0;

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
            @(posedge i_clk);
            i_start = 1'b1;
            @(posedge i_clk);
            i_start = 1'b0;
            @(posedge i_clk);
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

        for (logic [WIDTH-1:0] i = 0; i <= 14'h270F; i++)
        begin
            wait(o_ready === 1'b1);
            set_input(i);
            start();
        end

        $stop;
    end


endmodule