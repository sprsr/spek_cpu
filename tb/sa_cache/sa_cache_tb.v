
module sa_cache_tb;

    //reset that pulses once
    reg reset = 0;
    reg clk;
    reg [17:0]  i_tag_in;
    reg [7:0]   i_index_in;
    reg [5:0]   i_offset_in;
    reg [31:0]  dataW_in;
    reg [31:0 ] i_memory_line_in;
    reg i_memory_response_in;
    reg memRW_in;
    reg [31:0] o_data_out;
    reg [31:0] o_line_data;
    reg        cache_miss;
    reg [31:0] evict_data;
    reg [31:0] evict_addr;
    reg        evict
    sa_cache c0 (
        .clk(clk),
        .rst(reset),
        .i_tag(i_tag_in),
        .i_index(i_index_in),
        .i_offset(i_offset_in),
        .dataW(dataW_in),
        .i_memory_line(i_memory_line_in),
        .i_memory_response(i_memory_response_in),
        .memRW(memRW_in),
        .o_data(o_data_out),
        .line_data(o_line_data),
        .cache_miss(cache_miss),
        .o_evict_data(evict_data),
        .o_evict_addr(evict_addr),
        .o_evict(evict)
    );

    initial begin 
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        i_tag_in    <= 0;
        i_index_in  <= 0;
        i_offset_in <= 0;
        #10 begin
        end
    initial begin

        $dumpfile("sa_cache_tb.vcd");
        $dumpvars(0,sa_cache_tb);

        # 10 reset = 1'b1;
        # 12 reset = 1'b0;
        # 200 $finish;
    end

endmodule
