// Data Cache.  
module dmem(
    input         clk,
    input         rst,
    input  [31:0] i_addr,
    input  [31:0]  dataW,
    input          memRW,
    output [31:0] o_data
);

logic [31:0] memory [0:1023];
assign o_data = memory[i_addr];

    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i <= 1023; i = i + 1) begin
                memory[i] <= 32'h0;
            end
        end else if (memRW) begin
            memory[i_addr] <= dataW;
        end
    end    
endmodule
