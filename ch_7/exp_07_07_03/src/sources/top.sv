module top
    (
        input   logic clk,
        input   logic cpu_resetn,

        input   logic btnl, btnr,
        input   logic [7:0] sw,
        
        output   logic [1:0] led,

        // FMC sseg out
        output  logic [3:0] sseg_dig,
        output  logic sseg_a, sseg_b, sseg_c, sseg_d, sseg_e,
                      sseg_f, sseg_g, sseg_dp,

        // vadj
        (* DONT_TOUCH = "TRUE" *) output  logic [1:0] set_vadj,
        (* DONT_TOUCH = "TRUE" *) output  logic vadj_en
    );

    localparam READ_DATA_WIDTH = 8,
               WRITE_DATA_WIDTH = 16,
               ADDR_WIDTH = 8;

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

    logic [READ_DATA_WIDTH-1:0] w_read_data;
    logic [WRITE_DATA_WIDTH-1:0] w_write_data;
    assign w_write_data = {4'h0, sw[7:4], 4'h0, sw[3:0]};
    fifo
    #(
        .WRITE_DATA_WIDTH(WRITE_DATA_WIDTH), .READ_DATA_WIDTH(READ_DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_fifo
    (
        .i_clk(clk), .i_rst(~cpu_resetn),
        .i_read(w_read), .i_write(w_write),
        .i_write_data(w_write_data),

        .o_full(led[0]), .o_empty(led[1]),
        .o_read_data(w_read_data)
    );

    //********* DISPLAY OUTPUT *********
    // Create nets to connect sseg4 and reaction together
    logic [13:0] w_reaction_val;
    // Create sseg/ldsel nets
    logic [7:0] w_sseg_n;
    assign {sseg_dp, sseg_g, sseg_f, sseg_e,
            sseg_d, sseg_c, sseg_b, sseg_a} = w_sseg_n;

    // Set v_adj to 3.3V
    assign vadj_en = 1'b1;
    assign set_vadj = 2'b11;

    sseg4 u_sseg4
    (
        .i_clk(clk), .i_rst(~cpu_resetn),
        .i_bin({6'h00, w_read_data}),
        .i_greeting(1'b0),               // When asserted, display "HI"

        .o_sseg_n(w_sseg_n),
        .o_ldsel(sseg_dig),
        .o_idle()                    // For siulation usage
    );

endmodule
