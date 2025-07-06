module top
    (
        input   logic clk,
        input   logic cpu_resetn,
        input   logic [7:0] sw,
        input   logic btnu, btnc, btnd,
        output  logic [7:0] led
    );

    logic [25:0] r_clk_count; // 100 MHz / 2^26 ~= 1.49 Hz
    logic clk_slow = r_clk_count[25];
    always @(posedge clk)
    begin
        r_clk_count <= r_clk_count + 1;
    end

    univ_bin_counter u_univ_bin_counter
        (.clk(clk_slow), .resetn(cpu_resetn), .syn_clr(btnc),
         .load(btnu), .en(1'b1), .up(~btnd), .d(sw), .max_tick(),
         .min_tick(), .q(led));


endmodule
