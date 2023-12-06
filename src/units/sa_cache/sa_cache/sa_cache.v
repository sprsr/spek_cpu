// memory.v
// @sprsr
module SA_Cache 
#(  parameter CACHE_LINES = 256,
    parameter LINE_SIZE_BYTES   = 64,
    parameter LRU_BITS = 1,
    parameter VALID_BITS = 1,
    parameter DIRTY_BITS = 1,
    parameter TAG_BITS = 18,
    parameter INDEX_BITS = 8,
    parameter OFFSET_BITS = 6,
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 32,
    parameter WAYS = 4)

    (
        input                                       clk,
        input                                       rst,
        input  [ADDRESS_WIDTH - 1:0]                i_addr,
        input  [DATA_WIDTH - 1:0]                   dataW,
        input  [LINE_SIZE_BITS -1:0]                i_memory_line,
        input                                       i_memory_response,
        input                                       memRW,
        output reg [DATA_WIDTH - 1:0]                   o_data,
        input  [TAG_BITS -1 : 0]                    i_tag,
        input  [(INDEX_BITS - 1): 0]                i_index,
        input  [(OFFSET_BITS - 1): 0]               i_offset,
        output reg [(LINE_SIZE_BITS -1): 0]         line_data,
        output                                      cache_miss,
        output reg [DATA_WIDTH -1:0]                    o_evict_data,
        output reg [ADDRESS_WIDTH -1:0]                    o_evict_addr,
        output reg                                  o_evict

        //input  [($log2(CACHE_LINES) - 1): 0]     i_index,
        //input  [($log2(LINE_SIZE_BYTES) - 1): 0] i_offset,
    );

    localparam LINE_SIZE_BITS = LINE_SIZE_BYTES * 8;
    localparam LINE_WIDTH = (VALID_BITS + LRU_BITS + DIRTY_BITS + TAG_BITS + (LINE_SIZE_BYTES * 8));

    reg [LINE_WIDTH - 1 : 0]           cache [0:(CACHE_LINES - 1)] [0: WAYS - 1];
    wire [WAYS - 1 : 0]                hit;
    reg [(LINE_SIZE_BYTES * 8) - 1: 0] data [WAYS - 1: 0];
    wire [WAYS - 1 : 0]                mux_sel;
    reg [$clog2(WAYS)-1:0]             way_index;
    reg [$clog2(WAYS):  0]             way_mem_slot;
    reg                                r_cache_miss = 1'b0;


    assign cache_miss = r_cache_miss;


    //Generate comparator for each WAY
    generate
        genvar i;

        for (i = 0; i < WAYS; i= i+1) begin
            Comparator #() u_inst_comparator (
                .i_a(cache[i_index][i][(LINE_WIDTH - VALID_BITS - LRU_BITS - DIRTY_BITS - 1) -: TAG_BITS]),
                .i_b(i_tag),
                .o_y(hit[i])
            );
            AND #() u_inst_and (
                .i_a(hit[i]),
                .i_b(cache[i_index][i][LINE_WIDTH - 1]),
                .o_y(mux_sel[i])
            );
        end
    endgenerate
   /* 
    mux_4x1 #() inst_mux_4x1 (
        .i_data(data),
        .i_sel(mux_sel),
        .o_y(o_data)
    );*/
    one_to_one_mux #() inst_one_to_one_mux (
        .i_data(data),
        .i_sel(mux_sel),
        .o_y(line_data)
    );

    function find_hit(input [WAYS-1:0] hit);
        find_hit = 0;
        for (integer i = 0; i< WAYS; i=i+1) begin
            if (hit[i] == 1'b1) begin
                find_hit = i;
            end
        end
    endfunction

    function [$clog2(WAYS) -1:0] new_line_way (input [INDEX_BITS-1:0] index);
        new_line_way = 1'b0;
        for (integer i = 0; i< (WAYS); i=i+1) begin
            if (!cache[index][i][LINE_WIDTH - 1]) begin
                new_line_way = i;
            end else begin
                cache[index][i][LINE_WIDTH - 1] = 1'b0;
            end
        end
    endfunction 

    initial begin 
        for (integer i = 0; i < WAYS; i= i+1) begin
            data[i] = cache[i_index][i][LINE_SIZE_BITS - 1: 0];
        end
    end


    always @(posedge clk or posedge rst) begin

        if (rst) begin
            o_data <= 32'b0;
            r_cache_miss <= 0;
            way_mem_slot <= 0;
        end else begin
            if (!r_cache_miss) begin
                if (hit != 0) begin
                    // read the cache
                    way_index = find_hit(hit);
                    case (hit)
                        4'b0000: way_index <= 0;
                        4'b0010: way_index <= 1;
                        4'b0100: way_index <= 2;
                        4'b1000: way_index <= 3;
                    endcase
                    case (memRW) 
                        1'b1: begin
                            // Write to Cache
                            cache[i_index][way_index][(8*i_offset) +: DATA_WIDTH] <= dataW;
                            // Set Cache Line As Dirty
                            cache[i_index][way_index][LINE_WIDTH - 2] <= 1'b1;
                            //Maybe Placeholder
                            o_data <= dataW;
                        end
                        1'b0: begin
                            //Read Cache
                            o_data <= cache[i_index][way_index][(8*i_offset) +: DATA_WIDTH];
                        end
                    endcase
                    // set the LRU bit
                    cache[i_index][way_index][LINE_WIDTH - 3] <= 1'b1;
                end else begin
                    r_cache_miss <= 1'b1; 
                end
            end else begin
                if (i_memory_response) begin
                    /*
                    if (!cache[i_index][0][LINE_WIDTH - 1])
                        way_mem_slot = 2'h0;
                    else begin 
                        cache[i_index][0][LINE_WIDTH - 1] = 1'b0;
                        if (!cache[i_index][1][LINE_WIDTH - 1])
                            way_mem_slot = 2'h1;
                        else begin 
                            cache[i_index][1][LINE_WIDTH - 1] = 1'b0;
                            if (!cache[i_index][2][LINE_WIDTH - 1])
                                way_mem_slot = 2'h2;
                            else begin 
                                cache[i_index][2][LINE_WIDTH - 1] = 1'b0;
                                if (!cache[i_index][3][LINE_WIDTH - 1])
                                way_mem_slot = 2'h3;
                                else begin 
                                    cache[i_index][3][LINE_WIDTH - 1] = 1'b0;
                                    if (!cache[i_index][0][LINE_WIDTH - 1])
                                    way_mem_slot = 2'h0;
                                end
                            end
                        end
                    end
                   */ 
                    way_mem_slot = new_line_way(i_index);
                    if (cache[i_index][way_mem_slot][LINE_WIDTH - 1]) begin
                        o_evict_data <= cache[i_index][way_mem_slot][LINE_SIZE_BITS-1:0];
                        o_evict_addr[ADDRESS_WIDTH - 1 -: TAG_BITS] <= i_tag;
                        o_evict_addr[ADDRESS_WIDTH -TAG_BITS - 1 -: INDEX_BITS] <= i_index;
                        o_evict_addr[ADDRESS_WIDTH -TAG_BITS - INDEX_BITS - 1 -: OFFSET_BITS] <= i_offset;
                        o_evict <= 1'b1;
                    end
                    cache[i_index][way_mem_slot][LINE_SIZE_BITS-1:0] <= i_memory_line;
                    cache[i_index][way_mem_slot][LINE_WIDTH - 1] <= 1'b1;
                    cache[i_index][way_mem_slot][LINE_WIDTH - 3] <= 1'b1;
                    r_cache_miss <= 1'b0;
                end
            end
        end
    end


                    endmodule


