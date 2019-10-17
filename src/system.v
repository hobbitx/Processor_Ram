module system (HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,KEY,LEDR,SW);

output [7:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
output [17:0] LEDR;
input [3:0]KEY;
input[17:0] SW;
wire [15:0] dout, q;

wire [15:0] option;
wire [15:0] addr;
wire hit,hit2;
wire w;

assign HEX6 = 8'b1111111111;
assign HEX7 = 8'b1111111111;

//SEG7 hex6(HEX6[7:0], {15'b0,hit2},1);
//SEG7 hex7(HEX7[7:0], {15'b0,hit},1);
//addr


SEG7 hex0(HEX0[7:0], option[3:0],1);
SEG7 hex1(HEX1[7:0], option[7:4],1);
SEG7 hex2(HEX2[7:0], option[11:8],1);
SEG7 hex3(HEX3[7:0], option[15:12],1);
	
SEG7 hex4(HEX4[7:0], addr[3:0],1);
SEG7 hex5(HEX5[7:0], addr[7:4],1);
	
assign LEDR[17] = ~KEY[3];
assign LEDR[0] = hit;
assign LEDR[1] = hit2;

wire [15:0] s1,s2,s3,s4;

wire [15:0] select = SW[17]?(SW[16]?s4:s3):(SW[16]?s2:s1);

assign option = SW[0]?select:q; 

processor proc1 (q, KEY[0], ~KEY[3], dout, addr, w,s1,s2,s3,s4);
cache #(16) mem1(dout,addr[4:0],~KEY[3],w,hit,hit2,q);



endmodule

