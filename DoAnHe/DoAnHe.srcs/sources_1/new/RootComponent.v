`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2024 09:43:23 AM
// Design Name: 
// Module Name: RootComponent
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



function automatic integer log2;
        input integer value;
        integer results;
        begin
            results = 0;
            while (value > 0) begin
                value = value >> 1;
                results = results + 1;
            end
            log2 = results;
        end
endfunction

module Image #(parameter ImageWidth = 1024, parameter ImageHeight = 1024, parameter BusWidth = 32) (Out0, Out1, Out2, Out3, Out5, Out6, Out7, Out8, Addr0x, Addr0y, Addr1x, Addr1y, Addr2x, Addr2y, Addr3x, Addr3y, Addr5x, Addr5y, Addr6x, Addr6y, Addr7x, Addr7y, Addr8x, Addr8y);
    localparam WidthContainerSize = log2(ImageWidth);
    localparam HeightContainerSize = log2(ImageHeight);
    
    output[BusWidth - 1:0] Out0, Out1, Out2, Out3, Out5, Out6, Out7, Out8;
    input[WidthContainerSize - 1:0] Addr0x, Addr1x, Addr2x, Addr3x, Addr5x, Addr6x, Addr7x, Addr8x;
    input[HeightContainerSize - 1:0] Addr0y, Addr1y, Addr2y, Addr3y, Addr5y, Addr6y, Addr7y, Addr8y;
    
    reg[BusWidth - 1:0] Image[ImageHeight - 1:0][ImageWidth - 1:0]; //Image[y][x]
    assign Out0 = Image[Addr0y][Addr0x];
    assign Out1 = Image[Addr1y][Addr1x];
    assign Out2 = Image[Addr2y][Addr2x];
    assign Out3 = Image[Addr3y][Addr3x];
    assign Out5 = Image[Addr5y][Addr5x];
    assign Out6 = Image[Addr6y][Addr6x];
    assign Out7 = Image[Addr7y][Addr7x];
    assign Out8 = Image[Addr8y][Addr8x];
endmodule

module ImageReader #(parameter ImageWidth = 32, parameter ImageHeight = 32, parameter BusWidth = 32) (Out0, Out1, Out2, Out3, Out5, Out6, Out7, Out8, Clk, Rst);
    output[8*BusWidth - 1:0] Out0, Out1, Out2, Out3, Out5, Out6, Out7, Out8;
    input Clk, Rst;
    localparam WidthContainerSize = log2(ImageWidth);
    localparam HeightContainerSize = log2(ImageHeight);
    
    reg[WidthContainerSize - 1:0] Addr0x, Addr1x, Addr2x, Addr3x, Addr5x, Addr6x, Addr7x, Addr8x;
    reg[HeightContainerSize - 1:0] Addr0y, Addr1y, Addr2y, Addr3y, Addr5y, Addr6y, Addr7y, Addr8y;
    //x direction
    always @(posedge Rst or posedge Clk) begin
        if(Rst) begin
            Addr0x <= 0;
            Addr1x <= 1;
            Addr2x <= 2;
            Addr3x <= 0;
            Addr5x <= 2;
            Addr6x <= 0;
            Addr7x <= 1;
            Addr8x <= 2;
        end
        else if(Addr2x == ImageWidth) begin
            Addr0x <= 0;
            Addr1x <= 1;
            Addr2x <= 2;
            Addr3x <= 0;
            Addr5x <= 2;
            Addr6x <= 0;
            Addr7x <= 1;
            Addr8x <= 2;
         end
         else begin
            Addr0x <= Addr0x + 1;
            Addr1x <= Addr1x + 1;
            Addr2x <= Addr2x + 1;
            Addr3x <= Addr3x + 1;
            Addr5x <= Addr5x + 1;
            Addr6x <= Addr6x + 1;
            Addr7x <= Addr7x + 1;
            Addr8x <= Addr8x + 1;
         end
     end
     //y direction
     always @(posedge Rst or posedge Clk) begin
        if(Rst) begin
            Addr0y <= 0;
            Addr1y <= 0;
            Addr2y <= 0;
            Addr3y <= 1;
            Addr5y <= 1;
            Addr6y <= 2;
            Addr7y <= 2;
            Addr8y <= 2;
        end
        else if(Addr2x == ImageWidth) begin
            if(Addr6y == ImageHeight) begin
                Addr0y <= 0;
                Addr1y <= 0;
                Addr2y <= 0;
                Addr3y <= 1;
                Addr5y <= 1;
                Addr6y <= 2;
                Addr7y <= 2;
                Addr8y <= 2;
            end
            else begin
                Addr0y <= Addr0y + 1;
                Addr1y <= Addr1y + 1;
                Addr2y <= Addr2y + 1;
                Addr3y <= Addr3y + 1;
                Addr5y <= Addr5y + 1;
                Addr6y <= Addr6y + 1;
                Addr7y <= Addr7y + 1;
                Addr8y <= Addr8y + 1;
            end
         end
         else begin
            Addr0y <= Addr0y;
            Addr1y <= Addr1y;
            Addr2y <= Addr2y;
            Addr3y <= Addr3y;
            Addr5y <= Addr5y;
            Addr6y <= Addr6y;
            Addr7y <= Addr7y;
            Addr8y <= Addr8y;
        end
     end
     
     Image #(ImageWidth, ImageHeight, BusWidth) image(.Out0(Out0), .Out1(Out1), .Out2(Out2), .Out3(Out3), .Out5(Out5), .Out6(Out6), .Out7(Out7), .Out8(Out8), .Addr0x(Addr0x), .Addr0y(Addr0y), .Addr1x(Addr1x), .Addr1y(Addr1y), .Addr2x(Addr2x), .Addr2y(Addr2y), .Addr3x(Addr3x), .Addr3y(Addr3y), .Addr5x(Addr5x), .Addr5y(Addr5y), .Addr6x(Addr6x), .Addr6y(Addr6y), .Addr7x(Addr7x), .Addr7y(Addr7y), .Addr8x(Addr8x), .Addr8y(Addr8y));
endmodule
