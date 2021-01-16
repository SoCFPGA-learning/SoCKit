`timescale 1ns / 1ns
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:41:13 08/24/2018 
// Design Name: 
// Module Name:    update 
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
module update (
  input wire clk,
  input wire vsync,
  output reg [10:0] posx,
  output reg [10:0] posy
  );
  
  parameter
    XMAX = 11'd640,
    YMAX = 11'd480,
    TAM  = 11'd16;
    
  initial begin
    posx = 11'd320;  // incialmente, centro de la pantalla
    posy = 11'd240;  // para una pantalla de 640x480, claro.
  end
  
  reg vsync_prev = 1'b0;
  reg dx = 1'b0;  // 0: mover a la derecha. 1: mover a la izquierda
  reg dy = 1'b0;  // 0: mover hacia abajo. 1: mover hacia arriba
  
  always @(posedge clk)
    vsync_prev <= vsync;    
  wire actualizar_ahora = vsync_prev & ~vsync;  // momento en el que vsync pasa de 1 a 0 (flanco de bajada)
  
  always @(posedge clk) begin
    if (actualizar_ahora == 1'b1) begin
      if (posx == XMAX-TAM && dx == 1'b0 || posx == 11'd1 && dx == 1'b1)  // si llegamos al borde izquierdo o derecho, cambiar sentido de movimiento horizontal
        dx <= ~dx;
      if (posy == YMAX-TAM && dy == 1'b0 || posy == 11'd1 && dy == 1'b1)  // si llegamos al borde inferior o superior, cambiar sentido de movimiento vertical
        dy <= ~dy;
      posx <= posx + {{10{dx}}, 1'b1};  // si dx=0, esto hace que se sume 00000000001 a posx. Si dx=1, esto hace que se sume 11111111111 a posx.
      posy <= posy + {{10{dy}}, 1'b1};  // lo mismo, pero con dy y posy
    end
  end
endmodule

`default_nettype wire