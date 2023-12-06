//Register File 
module register(
    input         clk,
    input         rst,
    input         regWEn,
    input  [31:0] dataD,
    input  [4:0]  addrD,
    input  [4:0]  addrA,
    input  [4:0]  addrB,
    output [31:0] dataA,
    output [31:0] dataB,
    output [31:0] debug [31:0]
);

    reg [31:0] r_memory [31:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin 
            r_memory[0] <= 32'h2;
            r_memory[1] <= 32'h1;
            r_memory[2] <= 32'h2;
            r_memory[3] <= 32'h3;
            r_memory[4] <= 32'h4;
            r_memory[5] <= 32'h5;
            r_memory[6] <= 32'h6;
            r_memory[7] <= 32'h7;
            r_memory[8] <= 32'h8;
            r_memory[9] <= 32'h9;
            r_memory[10] <= 32'h10;
            r_memory[11] <= 32'h11;
            r_memory[12] <= 32'h12;
            r_memory[13] <= 32'h13;
            r_memory[14] <= 32'h14;
            r_memory[15] <= 32'h15;
            r_memory[16] <= 32'h16;
            r_memory[17] <= 32'h17;
            r_memory[18] <= 32'h18;
            r_memory[19] <= 32'h19;
            r_memory[20] <= 32'h20;
            r_memory[21] <= 32'h21;
            r_memory[22] <= 32'h22;
            r_memory[23] <= 32'h23;
            r_memory[24] <= 32'h24;
            r_memory[25] <= 32'h25;
            r_memory[26] <= 32'h26;
            r_memory[27] <= 32'h27;
            r_memory[28] <= 32'h28;
            r_memory[29] <= 32'h29;
            r_memory[30] <= 32'h30;
            r_memory[31] <= 32'h31;

        // Control.v will determine if we need to write back.
        end else if (regWEn) begin
            r_memory[addrD] = dataD;
        end
    end

    assign dataA = r_memory[addrA];
    assign dataB = r_memory[addrB];
    assign debug = r_memory;
endmodule

