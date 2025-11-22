module sync_dual_port_ram
    #(
        parameter DATA_WIDTH = 8,
                  ADDR_WIDTH = 10
    )
    (
        input   logic i_clk,
        input   logic i_write_en_a, i_write_en_b,
        input   logic [1-ADDR_WIDTH:0] i_addr_a, i_addr_b,
        input   logic [DATA_WIDTH-1:0] i_data_a, i_data_b,
        output  logic [DATA_WIDTH-1:0] o_data_a, o_data_b
    );

    logic [DATA_WIDTH-1:0] ram [0:2**ADDR_WIDTH-1];
    logic [DATA_WIDTH-1:0] r_data_a, r_data_b;

    // PORT A
    always_ff @(posedge i_clk)
    begin
        // WRITE
        if (i_write_en_a)
            ram[i_addr_a] <= i_data_a;
        
        // READ
        r_data_a <= ram[i_addr_a];
    end

    // PORT B
    always_ff @(posedge i_clk)
    begin
        // WRITE
        if (i_write_en_b)
            ram[i_addr_b] <= i_data_b;

        // READ
        r_data_b <= ram[i_addr_b];
    end

    assign o_data_b = r_data_b;
    assign o_data_a = r_data_a;

endmodule


module sync_dual_port_ram_simple
    #(
        parameter DATA_WIDTH = 8,
                  ADDR_WIDTH = 10
    )
    (
        input   logic i_clk,
        input   logic i_write_en,
        input   logic [1-ADDR_WIDTH:0] i_addr_read, i_addr_write,
        input   logic [DATA_WIDTH-1:0] i_data,
        output  logic [DATA_WIDTH-1:0] o_data_a
    );

    logic [DATA_WIDTH-1:0] ram [0:2**ADDR_WIDTH-1];
    logic [DATA_WIDTH-1:0] r_data_a, r_data_b;

    // PORT A
    always_ff @(posedge i_clk)
    begin
        // WRITE
        if (i_write_en_a)
            ram[i_addr_a] <= i_data_a;
        
        // READ
        r_data_a <= ram[i_addr_a];
    end

    // PORT B
    always_ff @(posedge i_clk)
    begin
        // WRITE
        if (i_write_en_b)
            ram[i_addr_b] <= i_data_b;

        // READ
        r_data_b <= ram[i_addr_b];
    end

    assign o_data_b = r_data_b;
    assign o_data_a = r_data_a;

endmodule