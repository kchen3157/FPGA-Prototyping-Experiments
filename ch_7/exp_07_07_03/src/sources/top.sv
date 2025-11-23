module top
    (
        input   logic clk,
        input   logic cpu_resetn,

        input   logic btnl, btnr,
        input   logic [7:0] sw,
        
        output   logic [1:0] led,

        // FMC sseg out
        output  logic fmc_clk0_m2c_n, fmc_clk1_m2c_n,
        output  logic fmc_la_2n, fmc_la_2p, fmc_la_3p, fmc_la_4p,
                      fmc_la_5n, fmc_la_8n, fmc_la_8p, fmc_la_9n,
                      fmc_la_9p, fmc_la_12p,

        // vadj
        (* DONT_TOUCH = "TRUE" *) output  logic [1:0] set_vadj,
        (* DONT_TOUCH = "TRUE" *) output  logic vadj_en
    );

    localparam DATA_WIDTH = 8,
               ADDR_WIDTH = 4;

    logic w_read, w_write;
    rise_edge_det u_rise_edge_det_read
        (
            .i_clk(clk), .i_rst(~cpu_resetn),
            .i_signal(btnr),
            .o_edge(w_read)
        );
    rise_edge_det u_rise_edge_det_write
        (
            .i_clk(clk), .i_rst(~cpu_resetn),
            .i_signal(btnl),
            .o_edge(w_write)
        );

    logic [DATA_WIDTH-1:0] w_read_data;
    fifo
    #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(4)
    ) u_fifo
    (
        .i_clk(clk), .i_rst(~cpu_resetn),
        .i_read(w_read), .i_write(w_write),
        .i_write_data(sw),

        .o_full(led[0]), .o_empty(led[1]),
        .o_read_data(w_read_data)
    );

    //********* DISPLAY OUTPUT *********
    // Create nets to connect sseg4 and reaction together
    logic [13:0] w_reaction_val;
    // Create sseg/ldsel nets
    logic [7:0] w_sseg_n;
    logic [3:0] w_ldsel;
    assign {fmc_la_5n, fmc_la_8p, fmc_la_12p, fmc_clk0_m2c_n,
            fmc_la_8n, fmc_la_9p, fmc_la_3p, fmc_la_9n} = w_sseg_n;
    assign  {fmc_la_2p, fmc_la_2n, fmc_la_4p, fmc_clk1_m2c_n} = w_ldsel;

    // Set v_adj to 3.3V
    assign vadj_en = 1'b1;
    assign set_vadj = 2'b11;

    sseg4 u_sseg4
    (
        .i_clk(clk), .i_rst(~cpu_resetn),
        .i_bin({6'h00, w_read_data}),
        .i_greeting(1'b0),               // When asserted, display "HI"

        .o_sseg_n(w_sseg_n),
        .o_ldsel(w_ldsel),
        .o_idle()                    // For siulation usage
    );

endmodule
