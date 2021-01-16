`timescale 1ns / 1ns
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:39:58 08/24/2018 
// Design Name: 
// Module Name:    fantasma_rebotando 
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

module fantasma_rebotando (
  input wire clk,     // 25 MHz (a no ser que uses otro ModeLine (ver videosyncs.v)
  output wire [7:0] r,
  output wire [7:0] g,
  output wire [7:0] b,
  output wire hsync,
  output wire vsync
  );

  wire [10:0] hc, vc;     // posicion actual X,Y de la pantalla
  wire display_enable;    // la posicion X,Y anterior es valida
  wire [7:0] rfondo, gfondo, bfondo;  // color de fondo
  wire [10:0] posx, posy; // posicion X,Y de la esquina superior izquierda del sprite

  videosyncs sincronismos (
    .clk(clk),
    .hs(hsync),   // se generan los dos
    .vs(vsync),   // pulsos de sincronismo
    .hc(hc),  // este modulo tambien genera
    .vc(vc),  // los valores X,Y de pantalla
    .display_enable(display_enable)  // los valores X,Y anteriores son validos
    );

  fondo los_cuadraditos (
    .hc(hc),
    .vc(vc),
    .display_enable(display_enable),
    .r(rfondo),  // color de fondo
    .g(gfondo),  // generado por
    .b(bfondo)   // este modulo
    );
    
  sprite el_fantasma (
    .clk(clk),
    .hc(hc),
    .vc(vc),
    .posx(posx),
    .posy(posy),
    .rin(rfondo),  // si no hay que pintar sprite 
    .gin(gfondo),  // entonces se pintara el color
    .bin(bfondo),  // que se ponga como entrada
    .rout(r),  // color de salida, que puede ser
    .gout(g),  // o bien el color de un pixel del sprite
    .bout(b)   // o bien el color de fondo, que proviene de arriba
    );
    
  update actualiza_pos_fantasma (
    .clk(clk),
    .vsync(vsync),  // senal que usaremos para saber cuando toca actualizar la posicion
    .posx(posx),    // posicion X de la esquina superior izquierda del sprite
    .posy(posy)     // posicion Y de la esquina superior izquierda del sprite
    );    

endmodule

`default_nettype wire