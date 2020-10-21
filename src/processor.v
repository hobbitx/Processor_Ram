module processor (DataIn, Reset, Clock, Dout, Daddress, W,s1,s2,s3,s4);

input [15:0] DataIn;
input Reset, Clock; 
output [15:0] Dout, Daddress;
reg [15:0] storeAddress,loadAddress;
output reg W;
output [15:0] s1,s2,s3,s4;


reg x;
wire [15:0] instruction, dataRFOut1, dataRFOut2, aluOut, DataOutMux, DataOutRegAlu,DataOutPC;

reg [15:0]copy;


reg [15:0] newPC;
reg [15:0] estagio_1;
reg [31:0] estagio_2;
reg [48:0] estagio_3;
reg [48:0] estagio_4;



reg writeEnableRegALU, writeEnableRegisterFile,writeEnableRegisterFile4, incr_pc,isStore,isLoad;
reg writeEnableRegInstruction, writeEnableRegAddress,enable_newPC, writeEnableRegDout;
reg [1:0] controlMux, controlAlu;

reg [2:0] ReadAddressRF1, ReadAddressRF2;

assign s1 = estagio_1;
assign s2 = estagio_2[15:0];
assign s3 = estagio_3[15:0];
assign s4 = estagio_4[15:0];

/*
module PC_reg7 (R, L, incr_pc, Clock, Q);
*/
PC_reg7 PC( newPC,enable_newPC , incr_pc, Clock, DataOutPC);

/*
module registerFile (Read1,Read2,WriteReg,WriteData,RegWrite,Data1,Data2,clock);
input [2:0] Read1,Read2,WriteReg;
input [15:0] WriteData;
input RegWrite, clock;
output [15:0] Data1, Data2;
*/
registerFile rf(ReadAddressRF1, ReadAddressRF2, (writeEnableRegisterFile? ReadAddressRF2: estagio_4[11:9]),
 (writeEnableRegisterFile? estagio_3[31:16] : estagio_4[31:16]), (writeEnableRegisterFile | writeEnableRegisterFile4), dataRFOut1, dataRFOut2, Clock, incr_pc);


/*
module alu (opA, opB, control, result);
input   [1:0] control;
input [15:0]  opA, opB;
output reg [15:0]  result;
*/
alu alu1(dataRFOut1, dataRFOut2, controlAlu,aluOut );


/*
module register16bits(R, Rin, Clock, Q);
parameter n = 16;
input [n-1:0] R;
input Rin, Clock;
output [n-1:0] Q;
*/
register16bits regALU(estagio_4[31:16], writeEnableRegALU, Clock, DataOutRegAlu);	
register16bits RegDout(dataRFOut1, writeEnableRegDout, Clock, Dout);
register16bits_i RegAddress((isLoad?loadAddress:(isStore?storeAddress:DataOutPC)), writeEnableRegAddress, Clock, Daddress);

initial
begin
isLoad = 1'b0;
end
    
always @(posedge Clock)
	begin
		estagio_4 = {aluOut,estagio_3[15:0]};
		if(isLoad)
			begin
				estagio_4 = {DataIn,estagio_3[15:0]};
			end	
	
	if(Daddress == 16'b0001)
			begin
				estagio_3 = {DataIn,estagio_2[15:0]};
			end
			else
			begin
				estagio_3 = {copy,estagio_2[15:0]};
			end
			begin 
				estagio_2 = {estagio_1};
			end
			if(estagio_2[15:12] == 4'b1111 || estagio_4[15:12] == 4'b1101)
				begin
					estagio_1 = {16'bZ};
				end
			else
				begin
					estagio_1 = {DataIn};
				end	
	end
always @(estagio_1)
begin
	
  incr_pc  <= 1'b1;
  if(isLoad)
		begin
			incr_pc  <= 1'b0;
		end	
	writeEnableRegAddress <= 1'b1;
end


/// estagio 2
always @(estagio_2)
begin
 case(estagio_2[15:12])
    4'b1101:  // load
    begin
      controlMux <= 2'b01;  
      ReadAddressRF1 = estagio_2[8:6];
      ReadAddressRF2 = estagio_2[5:3];
    end     
    4'b1100:  // store
    begin
      ReadAddressRF1 <= estagio_2[11:9];
      ReadAddressRF2 <= estagio_2[8:6];   
      controlMux <= 2'b00;  // seleciona o endereco da memoria onde o dado sera escrito  (00 ou 01)
    end     
    4'b1011:  // conditional copy
    begin
      ReadAddressRF1 <= estagio_2[8:6];
      ReadAddressRF2 <= estagio_2[5:3];
    end
    4'b1111:  // copy input
    begin 
      controlMux <= 2'b0;
		copy <= DataIn;
      ReadAddressRF2 <= estagio_2[11:9];
      ReadAddressRF1 <= estagio_2[8:6];
    end     
    4'b1110:  // copy
    begin
      ReadAddressRF1 <= estagio_2[8:6];
      ReadAddressRF2 <= estagio_2[5:3];      
    end
    4'b00xx: // ULA
    begin
      controlMux <= 2'b11;
      ReadAddressRF1 <= estagio_2[8:6];
      ReadAddressRF2 <= estagio_2[5:3];
    end 
  
endcase
end
always @(estagio_3)
begin 
writeEnableRegisterFile = 1'b0;  
isLoad = 1'b0;
 casex(estagio_3[15:12])
	4'b1011:  // conditional copy
    begin
      writeEnableRegisterFile = 1'b0;
    end  	
    4'b1101:  // load
    begin
      writeEnableRegisterFile = 1'b0;
		isLoad = 1'b1;
		loadAddress = dataRFOut1;
      writeEnableRegDout <=1'b0;
    end     
    4'b1100:  // store
    begin
		writeEnableRegisterFile = 1'b0;
      writeEnableRegDout <=1'b1;
    end     
    4'b00xx: //ULA
    begin
	 controlAlu <= estagio_3[13:12];
	 writeEnableRegisterFile <= 1'b0;
    end     
    4'b1111:  // copy input
    begin
		writeEnableRegisterFile = 1'b1;
      writeEnableRegDout <=1'b0;
    end     
    4'b1110:  // copy
    begin
		writeEnableRegisterFile = 1'b0;
      writeEnableRegDout <=1'b0;
    end
endcase
end

always @(estagio_4)
begin   
 casex(estagio_4[15:12])
  
    4'b1101:  // load
    begin
		storeAddress = 16'bZ;
		isStore <= 1'b0;
      writeEnableRegisterFile4 <= 1'b1;
    end     
    4'b1100:  // store
    begin
      storeAddress = dataRFOut2;
      isStore <= 1'b1;
		writeEnableRegisterFile4 <= 1'b0;
    end     
    4'b1011:  // conditional copy
    begin
     storeAddress <= 16'bZ;
     isStore <= 1'b0;
      if(estagio_4[31:16]==16'b0)
        begin
          writeEnableRegisterFile4 <= 1'b1;
        end
      else
        begin
          writeEnableRegisterFile4 <= 1'b0;
        end
    end     
   
    4'b00xx: //ULA
    begin
		storeAddress = 16'bZ;
		isStore <= 1'b0;
		writeEnableRegisterFile4 <= 1'b1;
    end     
    4'b1111:  // copy input
    begin		
		writeEnableRegisterFile4 <= 1'b0;
		storeAddress = 16'bZ;
		isStore <= 1'b0;
    end     

    4'b1110:  // copy
    begin
		storeAddress = 16'bZ;
		isStore <= 1'b0;
		writeEnableRegisterFile4 <= 1'b1;
    end
endcase


if(estagio_4[15:12]==4'b1100) //store
		 begin
			W <= 1'b1;
		 end
    else
		 begin
			W <= 1'b0;
		 end
end
endmodule

module PC_reg7 (R, L, incr_pc, Clock, Q);
	input [15:0] R;
	input L, incr_pc, Clock;
	output reg [15:0] Q;

	initial
		begin
			Q <= 16'b0;
		end

	always @(posedge Clock)
		if (L)
			Q <= R;
		else
			if (Q>32)
					Q = 0;
		else 
			if (incr_pc)
				Q <= Q + 1'b1;
endmodule 

module registerFile (Read1,Read2,WriteReg,WriteData,RegWrite,Data1,Data2,clock, incr_pc);
	input [2:0] Read1,Read2,WriteReg;
	input [15:0] WriteData;
	input RegWrite, clock, incr_pc;
	output [15:0] Data1, Data2;
	wire [15:0] register [7:0];
	wire [7:0] decOut;     
	decoder dec1(WriteReg, decOut);

	register16bits register1(WriteData, decOut[0]& RegWrite , clock, register[0]);
	register16bits register2(WriteData, decOut[1]& RegWrite , clock, register[1]);
	register16bits register3(WriteData, decOut[2]& RegWrite , clock, register[2]);
	register16bits register4(WriteData, decOut[3]& RegWrite , clock, register[3]);
	register16bits register5(WriteData, decOut[4]& RegWrite , clock, register[4]);
	register16bits register6(WriteData, decOut[5]& RegWrite , clock, register[5]);
	register16bits register7(WriteData, decOut[6]& RegWrite , clock, register[6]);

	assign Data1 = register[Read1];
	assign Data2 = register[Read2];
endmodule

module decoder #(parameter N = 3) (input [N-1:0] DataIn, output reg [(1<<N)-1:0] DataOut);
    always @ (DataIn)
     begin
       DataOut <= 1 << DataIn;
     end
endmodule


module mux4_1_16bits (A, B, C, D, Control, DataOut);

input [15:0] A, B, C, D;
input [1:0] Control;
output reg [15:0] DataOut;


always @(A, B, C, D, Control)
begin
  case (Control)
   2'b00: DataOut <= A;
   2'b01: DataOut <= B;
   2'b10: DataOut <= C;
   2'b11: DataOut <= D;
  endcase
end
endmodule



module register16bits(R, Rin, Clock, Q);
parameter n = 16;
input [n-1:0] R;
input Rin, Clock;
output [n-1:0] Q;
reg [n-1:0] Q;

/*
initial 
begin
  Q <= 16'b0;
end
*/

always @(posedge Clock)
if (Rin)
 Q <= R;

endmodule

module register16bits_i(R, Rin, Clock, Q);
parameter n = 16;
input [n-1:0] R;
input Rin, Clock;
output [n-1:0] Q;

reg [n-1:0] Q;

initial 
begin
  Q <= 16'b0;
end


always @(Clock)
if (Rin)
 Q <= R;

endmodule

module alu (opA, opB, control, result);

input   [1:0] control;
input [15:0]  opA, opB;
output reg [15:0]  result;


always @(opA, opB, control )
 case (control)
	  2'b00: 		result <= opA + opB;
	  2'b01: 		result <= opA | opB;
	  2'b10: 		result <= opA & opB;	  	  
	  2'b11: 		result <= ~(opA);
	  endcase
endmodule