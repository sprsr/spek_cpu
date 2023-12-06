module imem_tb;

    reg [31:0] r_addr;
    reg [31:0] r_data;
    
    imem c0 (
        .i_addr(r_addr),
        .o_data(r_data)
    );

    initial begin

        $dumpfile("imem_tb.vcd");
        $dumpvars(0,imem_tb);

        # 10 r_addr = 0;
        # 20 r_addr = 1;
        # 30 $finish;
    end

endmodule
