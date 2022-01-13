`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/12/2022 04:23:27 PM
// Design Name: 
// Module Name: PicTest_Top
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


module PicTest_Top(
// Zync signals
inout [14:0] DDR_addr,
inout [2:0] DDR_ba,
inout  DDR_cas_n,
inout  DDR_ck_n,
inout  DDR_ck_p,
inout  DDR_cke,
inout  DDR_cs_n,
inout [3:0] DDR_dm,
inout [31:0] DDR_dq,
inout [3:0] DDR_dqs_n,
inout [3:0] DDR_dqs_p,
inout  DDR_odt,
inout  DDR_ras_n,
inout  DDR_reset_n,
inout  DDR_we_n,
inout  FIXED_IO_ddr_vrn,
inout  FIXED_IO_ddr_vrp,
inout [53:0] FIXED_IO_mio,
inout  FIXED_IO_ps_clk,
inout  FIXED_IO_ps_porb,
inout  FIXED_IO_ps_srstb,

// MIPI Signal 
input  dphy_clk_lp_n,
input  dphy_clk_lp_p,
input [1:0] dphy_data_hs_n,
input [1:0] dphy_data_hs_p,
input [1:0] dphy_data_lp_n,
input [1:0] dphy_data_lp_p,
input  dphy_hs_clock_clk_n,
input  dphy_hs_clock_clk_p,

output [0:0] cam_gpio_tri_io,
inout cam_iic_scl_io,
inout cam_iic_sda_io,

  output      hdmi_tx_clk_n   ,
  output      hdmi_tx_clk_p   ,
  output [2:0]hdmi_tx_data_n  ,
  output [2:0]hdmi_tx_data_p  ,
  input       sysclk       ,
  input  [3:0] sw,
  input  [3:0] btn,
  output [3:0] led, //[0] }]; #IO_L23P_T3_35 Sch=led[0]  
  output led5_b,    // }]; #IO_L20P_T3_13 Sch=led5_b
  output led5_g,    // }]; #IO_L19P_T3_13 Sch=led5_g
  output led5_r,    // }]; #IO_L18N_T2_13 Sch=led5_r
  output led6_b,    // }]; #IO_L8P_T1_AD10P_35 Sch=led6_b
  output led6_g,    // }]; #IO_L6N_T0_VREF_35 Sch=led6_g
  output led6_r    // }]; #IO_L18P_T2_34 Sch=led6_r
    );

wire Ex_rstn = ~btn[0];    
wire Bit5 = sw[0];

wire GPIO_0;          //  output GPIO_0;
wire sccb_clk_0;      //  output sccb_clk_0;
wire sccb_clk_en_0;   //  output sccb_clk_en_0;
wire sccb_data_en_0;  //  output sccb_data_en_0;
wire sccb_data_out_0; //  output sccb_data_out_0;
wire sccb_data_in_0      ;           //  input sccb_data_in_0;

PicTesst_BD PicTesst_BD_inst
(
.DDR_addr(DDR_addr),		//inout [14:0] DDR_addr
.DDR_ba(DDR_ba),        //inout [2:0] DDR_ba
.DDR_cas_n(DDR_cas_n),        //inout  DDR_cas_n
.DDR_ck_n(DDR_ck_n),        //inout  DDR_ck_n
.DDR_ck_p(DDR_ck_p),        //inout  DDR_ck_p
.DDR_cke(DDR_cke),        //inout  DDR_cke
.DDR_cs_n(DDR_cs_n),        //inout  DDR_cs_n
.DDR_dm(DDR_dm),        //inout [3:0] DDR_dm
.DDR_dq(DDR_dq),        //inout [31:0] DDR_dq
.DDR_dqs_n(DDR_dqs_n),        //inout [3:0] DDR_dqs_n
.DDR_dqs_p(DDR_dqs_p),        //inout [3:0] DDR_dqs_p
.DDR_odt(DDR_odt),        //inout  DDR_odt
.DDR_ras_n(DDR_ras_n),        //inout  DDR_ras_n
.DDR_reset_n(DDR_reset_n),        //inout  DDR_reset_n
.DDR_we_n(DDR_we_n),        //inout  DDR_we_n
.FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),        //inout  FIXED_IO_ddr_vrn
.FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),        //inout  FIXED_IO_ddr_vrp
.FIXED_IO_mio(FIXED_IO_mio),        //inout [53:0] FIXED_IO_mio
.FIXED_IO_ps_clk(FIXED_IO_ps_clk),        //inout  FIXED_IO_ps_clk
.FIXED_IO_ps_porb(FIXED_IO_ps_porb),        //inout  FIXED_IO_ps_porb
.FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),        //inout  FIXED_IO_ps_srstb

.sys_clock      (sysclk),
.ext_reset_in   (Ex_rstn), 

// Cammera outputs
.dphy_clk_lp_n(dphy_clk_lp_n),        //input  dphy_clk_lp_n
.dphy_clk_lp_p(dphy_clk_lp_p),        //input  dphy_clk_lp_p
.dphy_data_hs_n(dphy_data_hs_n),        //input [1:0] dphy_data_hs_n
.dphy_data_hs_p(dphy_data_hs_p),        //input [1:0] dphy_data_hs_p
.dphy_data_lp_n(dphy_data_lp_n),        //input [1:0] dphy_data_lp_n
.dphy_data_lp_p(dphy_data_lp_p),        //input [1:0] dphy_data_lp_p
.dphy_hs_clock_clk_n(dphy_hs_clock_clk_n),        //input  dphy_hs_clock_clk_n
.dphy_hs_clock_clk_p(dphy_hs_clock_clk_p),        //input  dphy_hs_clock_clk_p
// Cammera SCCB
.GPIO_0         (GPIO_0         ),    //  output GPIO_0;
.sccb_clk_0     (sccb_clk_0     ),    //  output sccb_clk_0;
.sccb_clk_en_0  (sccb_clk_en_0  ),    //  output sccb_clk_en_0;
.sccb_data_en_0 (sccb_data_en_0 ),    //  output sccb_data_en_0;
.sccb_data_in_0 (sccb_data_in_0 ),    //  input sccb_data_in_0;
.sccb_data_out_0(sccb_data_out_0),    //  output sccb_data_out_0;

.Bit5(Bit5), // input Bit5

.TMDS_Clk_n_0 (hdmi_tx_clk_n ),   //   output TMDS_Clk_n_0;
.TMDS_Clk_p_0 (hdmi_tx_clk_p ),   //   output TMDS_Clk_p_0;
.TMDS_Data_n_0(hdmi_tx_data_n),   //   output [2:0]TMDS_Data_n_0;
.TMDS_Data_p_0(hdmi_tx_data_p)   //   output [2:0]TMDS_Data_p_0;

);

assign cam_gpio_tri_io = GPIO_0; 
assign cam_iic_scl_io  = (sccb_clk_en_0) ? sccb_clk_0 : 1'b1;
assign cam_iic_sda_io = (~sccb_data_en_0) ? sccb_data_out_0 : 1'bz;
assign sccb_data_in_0 = cam_iic_sda_io;
    
endmodule
