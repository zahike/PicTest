`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/12/2022 01:25:52 PM
// Design Name: 
// Module Name: TxMem
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


module TxMem(
input clk,
input rstn,

input Bit5,

output        s_axis_video_tready,
input  [31:0] s_axis_video_tdata ,
input         s_axis_video_tvalid,
input         s_axis_video_tuser ,
input         s_axis_video_tlast ,

output PixelClk,

input HVsync  ,
input HMemRead,
input pVDE    ,
output [23:0] HDMIdata

    );

assign s_axis_video_tready = 1'b1;   

reg Del_Last;
always @(posedge clk or negedge rstn)
    if (!rstn) Del_Last <= 1'b0;
     else Del_Last <= s_axis_video_tlast;
reg Del_Valid;
always @(posedge clk or negedge rstn)
    if (!rstn) Del_Valid <= 1'b0;
     else Del_Valid <= s_axis_video_tvalid;
reg [14:0] DelData;
always @(posedge clk or negedge rstn)
    if (!rstn) DelData <= 15'h0000;
     else if (s_axis_video_tvalid && Bit5) DelData <= {s_axis_video_tdata[29:25],s_axis_video_tdata[19:15],s_axis_video_tdata[9:5]};     
     else if (s_axis_video_tvalid) DelData <= {s_axis_video_tdata[29:26],1'b0,s_axis_video_tdata[19:16],1'b0,s_axis_video_tdata[9:6],1'b0};     

reg [19:0] CWadd;       // Camera write address
always @(posedge clk or negedge rstn)
    if (!rstn) CWadd <= 20'h00000;
     else if (s_axis_video_tvalid && s_axis_video_tuser && s_axis_video_tready) CWadd <= 20'h00000;
     else if (Del_Valid) CWadd <= CWadd + 1;

wire WriteMem = (CWadd < 256000) ? Del_Valid : 1'b0;
reg [14:0] Mem [0:255999]; // 95ff
always @(posedge clk)
    if (WriteMem) Mem[CWadd] <= DelData;
///////////////////////////  End Of data write to Memory  ///////////////////////////  

//////////////// Pixel Clock generator //////////////// 
reg [2:0] Cnt_Div_Clk;
always @(posedge clk or negedge rstn)
    if (!rstn) Cnt_Div_Clk <= 3'b000;
     else if (Cnt_Div_Clk == 3'b100) Cnt_Div_Clk <= 3'b000;
     else Cnt_Div_Clk <= Cnt_Div_Clk + 1;
reg Reg_Div_Clk;
always @(posedge clk or negedge rstn)
    if (!rstn) Reg_Div_Clk <= 1'b0;
     else if (Cnt_Div_Clk == 3'b000)  Reg_Div_Clk <= 1'b1;
     else if (Cnt_Div_Clk == 3'b010)  Reg_Div_Clk <= 1'b0;

   BUFG BUFG_inst (
      .O(PixelClk), // 1-bit output: Clock output
      .I(Reg_Div_Clk)  // 1-bit input: Clock input
   );
    
//////////////// End Of Pixel Clock generator //////////////// 

reg [19:0] HRadd;
always @(posedge clk or negedge rstn)
    if (!rstn) HRadd <= 20'h00000;
     else if (!HVsync) HRadd <= 20'h00000;
     else if ((Cnt_Div_Clk == 3'b011) && HMemRead) HRadd <= HRadd + 1;
     
reg [14:0] Reg_Mem;
always @(posedge clk)
    Reg_Mem <=  Mem[HRadd];

reg [23:0] RGB4Pix;
always @(posedge clk or negedge rstn)
    if (!rstn) RGB4Pix <= 24'h000000;
     else if (Cnt_Div_Clk == 3'b000) RGB4Pix <= {Reg_Mem[14:10],3'h0,Reg_Mem[9:5],3'h0,Reg_Mem[4:0],3'h0};

assign  HDMIdata = (HRadd < 255999) ? RGB4Pix : 24'h000000;
  
    
endmodule
