`timescale 1ns / 1ns
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:49:42 11/29/2013 
// Design Name: 
// Module Name:    syncs 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module videosyncs (
  input wire clk,        // reloj de 25 MHz (mirar abajo en el "ModeLine")
  output reg hs,         // salida sincronismo horizontal
  output reg vs,         // salida sincronismo vertical
 	output wire [10:0] hc, // salida posicion X actual de pantalla
	output wire [10:0] vc, // salida posicion Y actual de pantalla
  output reg display_enable // hay que poner un color en pantalla (1) o hay que poner negro (0)
  );
	
  // Visita esta URL si pretendes cambiar estos valores para generar otro modo de pantalla. Atrevete!!!
  // https://www.mythtv.org/wiki/Modeline_Database#VESA_ModePool
  // El que he usado aqui es:
  // ModeLine "640x480" 25.18 640 656 752 800 480 490 492 525 -HSync -VSync
  //                      ^
  //                      +---- Frecuencia de reloj de pixel en MHz
  parameter HACTIVE = 640;
  parameter HFRONTPORCH = 656;
  parameter HSYNCPULSE = 752;
	parameter HTOTAL = 800;
  parameter VACTIVE = 480;
  parameter VFRONTPORCH = 490;
  parameter VSYNCPULSE = 492;
  parameter VTOTAL = 525;
  parameter HSYNCPOL = 0;  // 0 = polaridad negativa, 1 = polaridad positiva
  parameter VSYNCPOL = 0;  // 0 = polaridad negativa, 1 = polaridad positiva

  reg [10:0] hcont = 0;
  reg [10:0] vcont = 0;
	
  assign hc = hcont;
  assign vc = vcont;

  always @(posedge clk) begin
      if (hcont == HTOTAL-1) begin
         hcont <= 11'd0;
         if (vcont == VTOTAL-1) begin
            vcont <= 11'd0;
         end
         else begin
            vcont <= vcont + 11'd1;
         end
      end
      else begin
         hcont <= hcont + 11'd1;
      end
  end
   
  always @* begin
    if (hcont>=0 && hcont<HACTIVE && vcont>=0 && vcont<VACTIVE)
      display_enable = 1'b1;
    else
      display_enable = 1'b0;

    if (hcont>=HFRONTPORCH && hcont<HSYNCPULSE)
      hs = HSYNCPOL;
    else
      hs = ~HSYNCPOL;

    if (vcont>=VFRONTPORCH && vcont<VSYNCPULSE)
      vs = VSYNCPOL;
    else
      vs = ~VSYNCPOL;
  end
endmodule   

`default_nettype wire
