module Reg_file(input rst,input [4:0]inAddr1,input [4:0]inAddr2,input [4:0]outAddr,output [31:0]inVal1,output [31:0]inVal2,input [31:0]outVal);

    reg [31:0]reg_file[31:0];
    wire [4:0] inAddr1,inAddr2,outAddr;
    wire [31:0] inVal1,inVal2,outVal;
    wire rst;
    integer j;

    genvar i;
    generate
        for(i=0;i<32;i=i+1)
        begin
            TriArr T1(reg_file[i],~|(i^inAddr1),inVal1);
            TriArr T2(reg_file[i],~|(i^inAddr2),inVal2);
        end
    endgenerate

    //in this case Always Block is inevitable as we need to assign a value to a reg
    always @(outVal or outAddr) 
    begin
        reg_file[outAddr] <= outVal;
    end

    always @(rst) 
    begin
        for(j=0;j<32;j=j+1)
        begin
            reg_file[j] <= 32'b0;
        end
    end

endmodule

module top;
    reg [4:0] inAddr1,inAddr2,outAddr;
    wire [31:0] inVal1,inVal2;
    reg [31:0]outVal;
    reg rst;

    Reg_file RF(rst,inAddr1,inAddr2,outAddr,inVal1,inVal2,outVal);

    initial 
    begin
        //Load Values into r0,r1
        #0 rst = 1;inAddr1 = 5'b0;inAddr2 = 5'b1;
        #10 rst=0;outAddr = 5'b0;outVal = 32'd567;
        #10 outAddr = 5'b1;outVal = 32'd5237;
        //Update value in r0
        #10 outVal = 32'd69342;outAddr = 32'b0;
    end

    initial
    begin
        $monitor($time, "ALU Input1=%d ALU Input2=%d ALU output=%d\n",inVal1,inVal2,outVal);
   end

endmodule
