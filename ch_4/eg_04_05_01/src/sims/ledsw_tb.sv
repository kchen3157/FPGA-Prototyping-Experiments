`timescale 1 ns/10 ps

module led_switch_tb

    localparam T = 20; // clock period

    logic i_clk, i_reset;
    logic [7:0] i_sw;
    logic [7:0] o_sseg_n;
    logic [3:0] o_ldsel;

    led_switch uut_led_switch
        (.*);

    always
    begin
        i_clk = 1'b1;
        #(T/2);
        i_clk = 1'b0;
        #(T/2);
    end

    initial
    begin
        i_reset = 1'b1;
        #(T/2);
        i_reset = 1'b0;
    end

    initial
    begin
        i_sw = 8'd0;
        @(negedge i_clk);
        i_sw = 8'd5;
    end


endmodule
