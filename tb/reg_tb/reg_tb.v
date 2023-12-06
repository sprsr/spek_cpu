module reg_tb;

    //reset that pulses once
    reg reset = 0;
    reg clk;
    reg r_regWEn;
    reg [31:0] r_dataD;
    reg [4:0]  r_addrD;
    reg [4:0]  r_addrA;
    reg [4:0]  r_addrB;
    reg [31:0] r_dataA;
    reg [31:0] r_dataB;
    
    register reg_0 (
        .clk(clk),
        .rst(reset),
        .regWEn(r_regWEn),
        .dataD(r_dataD),
        .addrD(r_addrD),
        .addrA(r_addrA),
        .addrB(r_addrB),
        .dataA(r_dataA),
        .dataB(r_dataB)
    );

    initial begin 
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin

        $dumpfile("reg_tb.vcd");
        $dumpvars(0,reg_tb);

        # 0  reset = 1'b1;
        # 10 reset = 1'b0;

        # 10 begin
            r_addrA <= 5'd7;
            r_addrB <= 5'd19;
            r_regWEn<= 1'b0;
        end
        # 10 begin
            r_addrA <= 5'd8;
            r_addrB <= 5'd11;
            r_regWEn<= 1'b0;
        end
        # 10 begin
            r_dataD <= 32'h8;
            r_addrD <= 5'd4;
            r_addrA <= 5'd7;
            r_addrB <= 5'd11;
            r_regWEn<= 1'b1;
        end
        # 10 begin
            r_dataD <= 32'h8;
            r_addrD <= 5'd4;
            r_addrA <= 5'd4;
            r_addrB <= 5'd11;
            r_regWEn<= 1'b0;
        end
        # 200 $finish;
    end

endmodule
