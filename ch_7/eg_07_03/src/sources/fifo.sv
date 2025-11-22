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