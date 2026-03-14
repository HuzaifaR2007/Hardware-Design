module fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 8
) (
    input logic clk,
    input logic rst,
    input logic wr_en,
    input logic rd_en,
    input logic [DATA_WIDTH-1:0] wr_data,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic full,
    output logic empty
);

    logic [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
    logic [$clog2(FIFO_DEPTH)-1:0] wr_ptr;
    logic [$clog2(FIFO_DEPTH)-1:0] rd_ptr;
    logic [$clog2(FIFO_DEPTH):0] count;

    always_ff @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            rd_data <= 0;
        end else if (wr_en && !rd_en && !full) begin
            mem[wr_ptr] <= wr_data;
            if (wr_ptr == FIFO_DEPTH - 1) begin
                wr_ptr <= 0;
            end else begin
                wr_ptr <= wr_ptr + 1;
            end
            count <= count + 1;
        end else if (rd_en && !wr_en && !empty) begin
            rd_data <= mem[rd_ptr];
            if (rd_ptr == FIFO_DEPTH - 1) begin
                rd_ptr <= 0;
            end else begin
                rd_ptr <= rd_ptr + 1;
            end
            count <= count - 1;
        end else if (rd_en && wr_en) begin
            mem[wr_ptr] <= wr_data;
            if (!empty) begin
                rd_data <= mem[rd_ptr];
            end
            if (wr_ptr == FIFO_DEPTH - 1) begin
                wr_ptr <= 0;
            end else begin
                wr_ptr <= wr_ptr + 1;
            end
            if (rd_ptr == FIFO_DEPTH - 1) begin
                rd_ptr <= 0;
            end else begin
                rd_ptr <= rd_ptr + 1;
            end
        end else begin
            
        end
        
    end
    assign full  = (count == FIFO_DEPTH);
    assign empty = (count == 0);

endmodule