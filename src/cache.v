module cache #(parameter NBits=8) (dataIn,Address,clk,rw,hit,hit2,dataOut);
input [NBits-1:0] dataIn;
input [4:0] Address;
input clk,rw;
output hit,hit2;
output [NBits-1:0] dataOut;


wire [1:0] LRU;
wire hit_v0, hit_v1,LRU_new, rw_v0, rw_v1;
wire [NBits-1:0] output_main_memory;
wire [2:0] index_cache;
wire [1:0] tag_address;
wire [NBits-1:0] data_v0, data_v1;

//cache_way(input [7:0] dataIn, input [2:0] index_cache, input [1:0] tag_address, 
//input clk, input rw_v0, output [7:0] data_v0, output hit_v0);
cache_way way0(dataIn, index_cache, tag_address, clk, rw_v0, data_v0, hit_v0);
cache_way way1(dataIn, index_cache, tag_address, clk, rw_v1, data_v1, hit_v1);

//assign hit = hit_v0 | hit_v1;
assign dataOut =  (hit)?((hit_v0)?(data_v0):(data_v1)):output_main_memory;


mem_block #(3, 2, 8) LRU_mem_v(index_cache, clk, {~LRU_new, LRU_new}, 1'b1, LRU);

assign LRU_new = ~LRU[0]|(~hit_v1&hit_v0);
assign hit = hit_v0;
assign hit2 = hit_v1;
assign rw_v0 =  ~hit_v0 & ~hit_v1 & ~ LRU[0];
assign rw_v1 =  ~hit_v0 & ~hit_v1 & ~ LRU[1];

assign tag_address = Address[4:3];
assign index_cache = Address[2:0];


mem_block #(5, 16, 32) main_memory(Address, clk, dataIn, rw   , output_main_memory);



endmodule

