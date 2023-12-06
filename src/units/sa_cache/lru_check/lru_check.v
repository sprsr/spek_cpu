module new_line_way 
#( 
    parameter LINE_WIDTH = 533,
    parameter CACHE_LINES = 256,
    parameter LINE_SIZE_BYTES   = 64,
    parameter LRU_BITS = 1,
    parameter VALID_BITS = 1,
    parameter DIRTY_BITS = 1,
    parameter TAG_BITS = 18,
    parameter INDEX_BITS = 8,
    parameter OFFSET_BITS = 6,
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 32,
    parameter WAYS = 4
)
(
    input   [INDEX_BITS-1:0] index,
    input   [LINE_WIDTH - 1 :0] cache [0:(CACHE_LINES - 1)] [0: WAYS - 1],
    output [WAYS - 1: 0]    new_line_way
);

reg [WAYS - 1: 0]    r_new_line_way;
assign new_line_way = r_new_line_way;

always @(*) begin
        for (integer i = 0; i< WAYS; i=i+1) begin
            if (!cache[index][i][LINE_WIDTH - 1]) begin
                r_new_line_way = i;
            end else begin
                r_cache[index][i][LINE_WIDTH - 1] = 1'b0;
            end
        end
end
endmodule
