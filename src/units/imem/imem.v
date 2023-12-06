// Instruction Cache.  
// Will determine best way to load instructions from Main Memory later. 
// Right now an initial test sequence will be used
module imem(
    input  [31:0] i_addr,
    output [31:0] o_data
);

    reg  [31:0]  r_memory [0:1023];

    initial begin
        /*
        r_memory[1] <= 32'b00000010000001000000001010010011;
        r_memory[2] <= 32'b00000010000001000000001010010011;
        r_memory[3] <= 32'b00000000100000010010000000100011;
        */

        r_memory[0] <= 32'b0;
        r_memory[1] <= 32'b00000000000101011000010110010011;
        r_memory[2] <= 32'b0;
        r_memory[3] <= 32'b0;
        r_memory[4] <= 32'b0;
        r_memory[5] <= 32'b0;
        r_memory[6] <= 32'b0;
        r_memory[7] <= 32'b0;
        r_memory[8] <= 32'b0;
    end

    assign o_data = r_memory[i_addr];

endmodule
