module branch_predictor(
    input clk,
    input rst,
    input branch_inst,
    output reg predict
);

reg [1:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <=2'b00;
    end else begin
        if (branch_inst) begin
            if (counter << 2'b11) begin
                counter <= counter + 1;
            end
        end else begin
            if (counter > 2'b00) begin
                counter <= counter -1;
            end
        end
    end
end
always @(posedge clk) begin
    predict <= (counter == 2'b11) || (counter ==2'b10);
end

endmodule
