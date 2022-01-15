`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2021 20:05:47
// Design Name: 
// Module Name: Drone_Cam_Trans_tb
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


module Drone_Cam_Trans_tb();
reg clk;
reg aclk;
reg rstn;
reg HDMIrstn;
initial begin 
clk = 1'b0;
aclk = 1'b0;
rstn = 1'b0;
HDMIrstn = 1'b0;
#100;
rstn = 1'b1;
#2500000;
#300;
HDMIrstn = 1'b1;
end
always #4 clk = ~clk;
always #10 aclk = ~aclk;

reg [31:0]  S_APB_0_paddr    ; // input  [31:0] S_APB_0_paddr      ,
reg         S_APB_0_penable  ; // input         S_APB_0_penable    ,
wire [31:0] S_APB_0_prdata   ;  // output [31:0] S_APB_0_prdata     ,
wire        S_APB_0_pready   ;  // output        S_APB_0_pready     ,
reg         S_APB_0_psel     ; // input         S_APB_0_psel       ,
wire        S_APB_0_pslverr  ;  // output        S_APB_0_pslverr    ,
reg [31:0]  S_APB_0_pwdata   ; // input  [31:0] S_APB_0_pwdata     ,
reg         S_APB_0_pwrite   ; // input         S_APB_0_pwrite     ,

wire        m_axis_video_tready;   // output        s_axis_video_tready, 
wire [31:0] m_axis_video_tdata ;   // input  [23:0] s_axis_video_tdata , 
reg         m_axis_video_tvalid;   // input         s_axis_video_tvalid, 
reg         m_axis_video_tuser ;   // input         s_axis_video_tuser , 
reg         m_axis_video_tlast ;   // input         s_axis_video_tlast , 


TxSyntPic TxSyntPic_inst(
.clk (clk ),
.rstn(rstn),

.SelStat(1'b1),

.s_axis_video_tdata  (32'h00000000)       ,
.s_axis_video_tready (m_axis_video_tready),
.s_axis_video_tvalid (m_axis_video_tvalid),
.s_axis_video_tlast  (m_axis_video_tlast) ,
.s_axis_video_tuser  (m_axis_video_tuser) ,
.m_axis_video_tdata  (m_axis_video_tdata) ,
.m_axis_video_tvalid ()                   ,
.m_axis_video_tready (1'b1)               ,
.m_axis_video_tlast  ()                   ,
.m_axis_video_tuser  ()     
    );
 
initial begin 
m_axis_video_tvalid = 0;   // input         s_axis_video_tvalid, 
m_axis_video_tuser  = 0;   // input         s_axis_video_tuser , 
m_axis_video_tlast  = 0;   // input         s_axis_video_tlast , 
@(posedge rstn);
#100;
repeat (5)begin 
        wrLine(1);
        repeat (479) wrLine(0);
        #4620608;
        @(posedge clk);
    end
#1000000;    
$finish;    
end

wire TxPixelClk ;

 wire [31 : 0] Ms_axis_video_tdata  = m_axis_video_tdata ; //input  wire [23 : 0] s_axis_video_tdata    , 
 wire          Ms_axis_video_tready    ; //output wire s_axis_video_tready            , 
 wire          Ms_axis_video_tvalid = m_axis_video_tvalid ; //input  wire s_axis_video_tvalid            , 
 wire          Ms_axis_video_tlast  = m_axis_video_tlast ; //input  wire s_axis_video_tlast             , 
 wire          Ms_axis_video_tuser  = m_axis_video_tuser ; //input  wire s_axis_video_tuser         ,     

wire HVsync                     ;                        // input HVsync,                      
wire FrameSync;
wire HMemRead                   ;                      // input HMemRead,                    
wire  [23:0] TxHDMIdata_Slant     ;   // output [11:0] HDMIdata             
wire [23 : 0] Out_pData;
wire Out_pHSync;
wire pVDE;


wire TranEn          ;
wire [11:0] TranData ;
wire NextData        ;
wire TranFrame       ; // output TranFrame
wire [15:0] TranAdd  ; //output [15:0] TranAdd,
  
TxMem TxMem_inst(
.clk               (clk),                       // input Cclk,                        
.rstn               (rstn),                      // input rstn,                        

.Bit5(1'b1),
.CheckMath( 1'b1),    //  input      CheckMath;
.SelFrame (2'b01),    //  input [1:0]SelFrame ;
//.Mem_cont           (4'hf),
.s_axis_video_tready(Ms_axis_video_tready),       // output        s_axis_video_tready, 
.s_axis_video_tdata (Ms_axis_video_tdata ),       // input  [23:0] s_axis_video_tdata , 
.s_axis_video_tvalid(Ms_axis_video_tvalid),       // input         s_axis_video_tvalid, 
.s_axis_video_tuser (Ms_axis_video_tuser ),       // input         s_axis_video_tuser , 
.s_axis_video_tlast (Ms_axis_video_tlast ),       // input         s_axis_video_tlast , 

.FrameSync          (FrameSync          ),
.PixelClk           (TxPixelClk           ),       // input Hclk,                        
//.FraimSel           (1'b00               ),

.HVsync             (HVsync             ),       // input HVsync,                      
.HMemRead           (HMemRead           ),       // input HMemRead,         
.pVDE               (pVDE               ),       // output        Out_pVDE  ,
.HDMIdata           (TxHDMIdata_Slant   )        // output [11:0] HDMIdata    

    );

  TxHDMI TxHDMI_inst (
    .clk(TxPixelClk),
    .rstn(HDMIrstn),
    
    .Out_pData(Out_pData),
    .Out_pVSync(HVsync),
    .Out_pHSync(Out_pHSync),
    .Out_pVDE(pVDE),
    .FrameSync(FrameSync),
    .CheckMath( 1'b1),    //  input      CheckMath;
    
    .Mem_Read(HMemRead),
    .Mem_Data(TxHDMIdata_Slant)
  );
  
////////////////////////////// End Of mem test //////////////////////////////
task wr4fix;
begin 
m_axis_video_tvalid = 1'b1;   
repeat (4) @(posedge clk);
#1;
m_axis_video_tvalid = 1'b0;   
repeat (3) @(posedge clk);
#1;
end 
endtask

task wr4fix_frame;
input frame;
begin 
m_axis_video_tvalid = 1'b1;   
m_axis_video_tuser  = 1'b0;
m_axis_video_tlast  = 1'b0;
repeat (2) @(posedge clk);
#1;
 m_axis_video_tlast  = 1'b1;
@(posedge clk);#1;
m_axis_video_tlast  = 1'b0;
if (frame)m_axis_video_tuser  = 1'b1;
@(posedge clk);#1;
m_axis_video_tvalid = 1'b0;   
repeat (3) @(posedge clk);
#1;
m_axis_video_tuser  = 1'b0;
repeat (3) wr4fix;
end 
endtask

task wr16pix;
begin 
repeat (7) @(posedge clk);
#1;
repeat (4) wr4fix;
end 
endtask

task wrLine;
input frame;
begin 
wr4fix_frame(frame);
repeat (39) wr16pix;
repeat (1750) @(posedge clk);
#1;
end
endtask

//////////////////////////////////////////////////
/////////////// Read/write tasks /////////////////
//////////////////////////////////////////////////

task ReadAXI;
input [31:0] addr;
begin 
    S_APB_0_paddr    = 0; // input  [31:0] S_APB_0_paddr      ,
    S_APB_0_penable  = 0; // input         S_APB_0_penable    ,
    S_APB_0_psel     = 0; // input         S_APB_0_psel       ,
    S_APB_0_pwdata   = 0; // input  [31:0] S_APB_0_pwdata     ,
    S_APB_0_pwrite   = 0; // input         S_APB_0_pwrite     ,
    @(posedge aclk);
    S_APB_0_paddr   = addr;
    S_APB_0_psel    = 1'b1;
    @(posedge aclk);
    S_APB_0_penable    = 1'b1;
    while (~S_APB_0_pready) begin
        @(posedge aclk);    
        if (S_APB_0_pready) begin 
                S_APB_0_psel  = 1'b0;
                S_APB_0_penable  = 1'b0;
                end
    end
end 
endtask 


task WriteAXI;
input [31:0] addr;
input [31:0] data;
begin 
    S_APB_0_paddr    = 0; // input  [31:0] S_APB_0_paddr      ,
    S_APB_0_penable  = 0; // input         S_APB_0_penable    ,
    S_APB_0_psel     = 0; // input         S_APB_0_psel       ,
    S_APB_0_pwdata   = 0; // input  [31:0] S_APB_0_pwdata     ,
    S_APB_0_pwrite   = 0; // input         S_APB_0_pwrite     ,


    @(posedge aclk);
    S_APB_0_paddr   = addr;
    S_APB_0_pwdata  = data;
    S_APB_0_pwrite  = 1'b1;
    S_APB_0_psel    = 1'b1;
    @(posedge aclk);
    S_APB_0_penable  = 1'b1;
    while (~S_APB_0_pready) begin
        @(posedge aclk);    
        if (S_APB_0_pready) begin 
                S_APB_0_psel  = 1'b0;
                S_APB_0_penable  = 1'b0;
                end
    end
end 
endtask 

endmodule
