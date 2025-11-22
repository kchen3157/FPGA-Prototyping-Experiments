// Listing 7.1 Register file with explicit decoding and multiplexing logic
module reg_file_explicit
    (
        input   logic i_clk,
        input   logic i_write_en,
        input   logic [1:0] i_write_addr, i_read_addr,
        input   logic [7:0] i_write_data,
        output  logic [7:0] o_write_data
    );

    localparam DATA_WIDTH = 8,
               ADDR_WIDTH = 2;
    
    logic [DATA_WIDTH-1:0] r_array [0:2**ADDR_WIDTH-1];
    logic [2**ADDR_WIDTH-1:0] w_en;

    always_ff @(posedge i_clk)
    begin : register_inst
        if (w_en[0])
            r_array[0] <= i_write_data;
        if (w_en[1])
            r_array[1] <= i_write_data;
        if (w_en[2])
            r_array[2] <= i_write_data;
        if (w_en[3])
            r_array[3] <= i_write_data;
    end

    always_comb
    begin : write_decoder
        if (~i_write_en)
            w_en = 4'b0000;
        else
            case (i_write_addr)
                2'b00: w_en = 4'b0001;
                2'b01: w_en = 4'b0010;
                2'b10: w_en = 4'b0100;
                default: w_en = 4'b1000; // 2'b11
            endcase
    end

    always_comb
    begin : output_mux
        case (i_read_addr)
            2'b00: o_write_data = r_array[0];
            2'b01: o_write_data = r_array[1];
            2'b10: o_write_data = r_array[2];
            default: o_write_data = r_array[3]; // 2'b11
        endcase
    end

endmodule


// Listing 7.2 Register file with dynamic indexing
module reg_file_dyn
    #(
        parameter DATA_WIDTH = 8,
                  ADDR_WIDTH = 2
    )
    (
        input   logic i_clk,
        input   logic i_write_en,
        input   logic [ADDR_WIDTH-1:0] i_write_addr, i_read_addr,
        input   logic [DATA_WIDTH-1:0] i_write_data,
        output  logic [DATA_WIDTH-1:0] o_read_data
    );

    logic [DATA_WIDTH-1:0] r_array [0:2**ADDR_WIDTH-1];

    always_ff @(posedge i_clk)
    begin
        if (i_write_en)
            r_array[i_write_addr] <= i_write_data;
    end

    assign o_read_data = r_array[i_read_addr];
endmodule


// Listing 7.3 Register file two read ports
module reg_file_2_read_port
    #(
        parameter DATA_WIDTH = 8,
                  ADDR_WIDTH = 2
    )
    (
        input   logic i_clk,
        input   logic i_write_en,
        input   logic [ADDR_WIDTH-1:0] i_write_addr, i_read_addr0, i_read_addr1
        input   logic [DATA_WIDTH-1:0] i_write_data,
        output  logic [DATA_WIDTH-1:0] o_read_data0, o_read_data1
    );

    logic [DATA_WIDTH-1:0] r_array [0:2**ADDR_WIDTH-1];

    always_ff @(posedge i_clk)
    begin
        if (i_write_en)
            r_array[i_write_addr] <= i_write_data;
    end

    assign o_read_data0 = r_array[i_read_addr0];
    assign o_read_data1 = r_array[i_read_addr1];
endmodule