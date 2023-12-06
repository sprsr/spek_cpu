module pc_tb;

    //reset that pulses once
    reg reset = 0;
    reg clk;
    reg sel_pc = 0;
    reg [31:0] in_alu = 32'h00008000;
    reg [31:0] in_pc_nxt;
    reg [31:0] pc;
    
    PC c0 (
        .clk(clk),
        .rst(reset),
        .sel_pc(sel_pc),
        .in_pc(in_pc_nxt),
        .in_alu(in_alu),
        .pc_nxt(in_pc_nxt),
        .pc(pc)
    );

    initial begin 
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin

        $dumpfile("pc_tb.vcd");
        $dumpvars(0,pc_tb);

        # 10 reset = 1'b1;
        # 12 reset = 1'b0;
        # 50 sel_pc = 1'b0; 
        # 200 $finish;
    end

endmodule
