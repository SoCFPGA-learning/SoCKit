`timescale 1ns / 1ns
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:41 08/24/2018 
// Design Name: 
// Module Name:    sprite 
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

module sprite (
  input wire clk,
  input wire [10:0] hc,   // posicion X de pantalla
  input wire [10:0] vc,   // posicion Y de pantalla
  input wire [10:0] posx, // posicion X inicial del sprite
  input wire [10:0] posy, // posicion Y inicial del sprite
  input wire [7:0] rin,   // color de pantalla
  input wire [7:0] gin,   // proveniente del
  input wire [7:0] bin,   // modulo anterior (el fondo, por ejemplo)
  output reg [7:0] rout,  // color de pantalla
  output reg [7:0] gout,  // actualizado
  output reg [7:0] bout   // segun haya que pintar o no el sprite
  );

  localparam
    TRANSPARENTE = 24'h00FF00,  // en nuestro sprite el verde es "transparente"
    TAM          = 11'd16;      // tamano en pixeles tanto horizontal como vertical, del sprite

  reg [23:0] spr[0:255];   // memoria que guarda el sprite (16x16 posiciones de 24 bits cada posicion)
  initial begin
    $readmemh ("datos_sprite.hex", spr);  // inicializamos esa memoria desde un fichero con datos hexadecimales
  end
  
  wire [3:0] spr_x = hc - posx; // posicion X dentro de la matriz del sprite, en funcion de la posicion X actual de pantalla y posicion inicial X del sprite
  wire [3:0] spr_y = vc - posy; // posicion Y dentro de la matriz del sprite, en funcion de la posicion Y actual de pantalla y posicion inicial Y del sprite
  
  reg [23:0] color;  // color del pixel actual del sprite
  
  always @(posedge clk) begin
    color <= spr[{spr_y,spr_x}];  // leemos el color del pixel y lo guardamos (la posicion del pixel podria ser completamente erronea aqui)
    if (hc >= posx && hc < (posx + TAM) && vc >= posy && vc < (posy + TAM) && color != TRANSPARENTE) begin  // si la posicion actual de pantalla esta dentro de los margenes del sprite, y el color leido del sprite no es el transparente....
      rout <= color[23:16];  // en ese caso, el color de salida
      gout <= color[15:8];   // es el color del pixel del sprite
      bout <= color[7:0];    // que hemos leido
    end
    else begin
      rout <= rin;           // si no toca pintar el sprite
      gout <= gin;           // o bien el color que hemos leido es el transparente
      bout <= bin;           // entonces pasamos a la salida el color que nos dieron a la entrada
    end  
  end  
endmodule

`default_nettype wire