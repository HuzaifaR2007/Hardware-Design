module counter #(

    parameter WIDTH = 4
    ) (
    input logic clk,
    input logic rst,
    input logic load,
    input logic up,
    input logic down,
    input logic [WIDTH-1:0] load_val,
    output logic [WIDTH-1:0] count,
    output logic underflow,
    output logic overflow
);

always_ff @(posedge clk) begin
    overflow <= 0;
    underflow <= 0;

    if (rst) begin
        count <= 0;
    end else if (load) begin
        count <= load_val;
    end else if (up && down) begin
        // nothing happens
    end else if (up) begin
        if (count == {WIDTH{1'b1}}) begin
            overflow <= 1;
            count <= count + 1;
        end else count <= count + 1; 
    end else if (down) begin
        if (count == 0) begin
            underflow <= 1;
            count <= count - 1;
        end else count <= count - 1;
    end
end
endmodule