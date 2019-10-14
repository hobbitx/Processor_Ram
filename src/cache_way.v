module cache_way(input [15:0] dataIn, input [2:0] index_cache, input [1:0] tag_address, input clk, input rw_v0, output [15:0] data_v0, output hit_v0);


wire [19:0] q_v0, dataIn_v0;
wire valid_v0, comparator_v0;
wire [1:0] tag_data_v0;

//mem_cache (input [2:0] address, input clock, input [12:0] data, input wren, output [12:0] q);
mem_block #(3, 20, 8) cache_v0(index_cache, clk, dataIn_v0, rw_v0, q_v0);

assign comparator_v0 = &(~(tag_address ^ tag_data_v0));
assign hit_v0 = comparator_v0 & valid_v0;

assign valid_v0 = q_v0[19];
assign dirty_v0 = q_v0[18];
assign tag_data_v0 = q_v0[17:16];
assign data_v0 = q_v0[15:0];

//assign dataIn_v0 = {valid, dirty, tag_address, dataIn};
assign dataIn_v0 = {1'b1, 1'b1, tag_address, dataIn};


endmodule

