module fifo_ctrl
    #(
        parameter ADDR_WIDTH = 4
    )
    (
        input   logic   i_clk, i_rst,
        input   logic   i_read, i_write,

        output  logic   o_empty, o_full,
        output  logic   [ADDR_WIDTH-1:0] o_read_addr, o_write_addr
    );


    logic [ADDR_WIDTH-1:0] r_read_ptr, w_read_ptr_next, w_read_ptr_succ;
    logic [ADDR_WIDTH-1:0] r_write_ptr, w_write_ptr_next, w_write_ptr_succ;
    logic r_full, w_full_next;
    logic r_empty, w_empty_next;


    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_read_ptr <= '0;
            r_write_ptr <= '0;
            r_full <= 1'b0;
            r_empty <= 1'b1;
        end
        else
        begin
            r_read_ptr <= w_read_ptr_next;
            r_write_ptr <= w_write_ptr_next;
            r_full <= w_full_next;
            r_empty <= w_empty_next;
        end
    end

    always_comb
    begin
        w_write_ptr_succ = r_write_ptr + 1;
        w_read_ptr_succ = r_read_ptr + 1;

        w_write_ptr_next = r_write_ptr;
        w_read_ptr_next = r_read_ptr;
        w_full_next = r_full;
        w_empty_next = r_empty;

        unique case ({i_write, i_read})
        2'b01: // read
            if (~r_empty)
            begin
                w_read_ptr_next = w_read_ptr_succ;
                w_full_next = 1'b0;
                if (w_read_ptr_succ == r_write_ptr)
                    w_empty_next = 1'b1;
            end
        2'b10: // write
            if (~r_full)
            begin
                w_write_ptr_next = w_write_ptr_succ;
                w_empty_next = 1'b0;
                if (w_write_ptr_succ == r_read_ptr)
                    w_full_next = 1'b1;
            end
        2'b11: // write and read
        begin
            w_read_ptr_next = w_read_ptr_succ;
            w_write_ptr_next = w_write_ptr_succ;
        end
        default: ; // do nothing
        endcase
    end 

    assign o_read_addr = r_read_ptr;
    assign o_write_addr = r_write_ptr;
    assign o_full = r_full;
    assign o_empty = r_empty;

endmodule

module reg_file
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

module fifo
    #(
        parameter DATA_WIDTH = 8,
                  ADDR_WIDTH = 4
    )
    (
        input   logic i_clk, i_rst,
        input   logic i_read, i_write,
        input   logic [DATA_WIDTH-1:0] i_write_data,

        output  logic o_full, o_empty,
        output  logic [DATA_WIDTH-1:0] o_read_data        
    );


    logic [ADDR_WIDTH-1:0] w_write_addr, w_read_addr;
    logic w_write_en, w_full;

    assign w_write_en = i_write & ~w_full;
    assign o_full = w_full;

    fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH))
        (
            .i_clk(i_clk), .i_rst(i_rst),
            .i_read(i_read), .i_write(i_write),
            .o_empty(o_empty), .o_full(w_full),
            .o_read_addr(w_read_addr), .o_write_addr(w_write_addr)
        );    
    
    reg_file #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH))
        (
            .i_clk(i_clk),
            .i_write_en(w_write_en),
            .i_write_addr(w_write_addr), .i_read_addr(w_read_addr),
            .i_write_data(i_write_data),
            .o_read_data(o_read_data)
        );

endmodule