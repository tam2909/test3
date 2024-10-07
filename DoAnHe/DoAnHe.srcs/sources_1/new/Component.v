`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2024 03:18:38 PM
// Design Name: 
// Module Name: Component
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Component(

    );
endmodule

module AddSub #(parameter BusWidth = 32)(Y, A, B, Sel);
    input[BusWidth - 1:0] A, B;
    input Sel;
    output[BusWidth - 1:0] Y;
    wire[BusWidth - 1:0] Bin;
    wire Cin;
    
    assign Bin = B ^ {32{Sel}};
    assign Cin = ~Sel;
    
    assign Y = A + Bin + Cin;
endmodule

module Max #(parameter BusWidth = 32) (Y, A, B);
    input[BusWidth - 1:0] A, B;
    output[BusWidth - 1:0] Y;
    wire[BusWidth - 1:0] AfterSub;
    assign AfterSub = A - B;
    assign Y = (AfterSub[BusWidth - 1])?B:A;
endmodule

module Min #(parameter BusWidth = 32) (Y, A, B);
    input[BusWidth - 1:0] A, B;
    output[BusWidth - 1:0] Y;
    wire[BusWidth - 1:0] AfterSub;
    assign AfterSub = A - B;
    assign Y = (AfterSub[BusWidth - 1])?A:B;
endmodule

module MinMax #(parameter BusWidth = 32) (Y, A, B, Sel);
    input[BusWidth - 1:0] A, B;
    input Sel;
    output[BusWidth - 1:0] Y;
    wire[BusWidth - 1:0] AfterSub;
    wire AfterSel;
    assign AfterSub = A - B;    
    assign AfterSel = AfterSub[BusWidth - 1] ^ Sel;
    assign Y = (AfterSel)?B:A;
endmodule

module GxCalculator #(parameter BusWidth = 32) (In0, In2, In3, In5, In6, In8, Out);
    input[BusWidth - 1:0] In0, In2, In3, In5, In6, In8;
    output[BusWidth - 1:0] Out;
    wire[BusWidth - 1:0] AfterSub0, AfterSub1, AfterSub2;
    assign AfterSub0 = In2 - In0;
    assign AfterSub1 = In5 - In3;
    assign AfterSub2 = In8 - In6;
    assign Out = AfterSub0 + AfterSub2 + (AfterSub1<<1);
endmodule

module GyCalculator #(parameter BusWidth = 32) (In0, In1, In2, In6, In7, In8, Out);
    input[BusWidth - 1:0] In0, In1, In2, In6, In7, In8;
    output[BusWidth - 1:0] Out;
    wire[BusWidth - 1:0] AfterSub0, AfterSub1, AfterSub2;
    assign AfterSub0 = In0 - In6;
    assign AfterSub1 = In1 - In7;
    assign AfterSub2 = In2 - In8;
    assign Out = AfterSub0 + AfterSub2 + (AfterSub1<<1);
endmodule

module SobelCalculator #(parameter BusWidth = 32) (In0, In1, In2, In3, In5, In6, In7, In8, Out);
    input[BusWidth - 1:0] In0, In1, In2, In3, In5, In6, In7, In8;
    output[BusWidth - 1:0] Out;
    wire[BusWidth - 1:0] Gx, Gy, MaxG, MinG, AfterSub, AfterAdd;
    GxCalculator #(BusWidth) gx(.Out(Gx), .In0(In0), .In2(In2), .In3(In3), .In5(In5), .In6(In6), .In8(In8));
    GyCalculator #(BusWidth) gy(.Out(Gy), .In0(In0), .In1(In1), .In2(In2), .In6(In6), .In7(In7), .In8(In8));
    
    Max #(BusWidth) max0(.Y(MaxG), .A(Gx), .B(Gy));
    Min #(BusWidth) min(.Y(MinG), .A(Gx), .B(Gy));
    assign AfterSub = MaxG - (MaxG>>3);
    assign AfterAdd = AfterSub + (MinG>>1);
    Max #(BusWidth) max1(.Y(Out), .A(AfterAdd), .B(MaxG));
endmodule  


    
