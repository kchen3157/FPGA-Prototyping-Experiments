module top
    (
        input   logic clk,
        input   logic cpu_resetn,
        output  logic [7:0] led
    );

    logic [25:0] r_clk_count; // 100 MHz / 2^26 ~= 1.49 Hz
    logic clk_slow = r_clk_count[25];
    always @(posedge clk)
    begin
        r_clk_count <= r_clk_count + 1;
    end

    free_run_bin_counter u_free_run_bin_counter
        (.clk(clk_slow), .resetn(cpu_resetn), .max_tick(), .q(led));


endmodule
