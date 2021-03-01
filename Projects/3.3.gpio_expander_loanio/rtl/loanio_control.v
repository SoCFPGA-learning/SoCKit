module loanio_control (					
			// define input / output parameters of the module
			input  wire			clk,			//clock input
			input  wire 		RESET_KEY,
			output [3:0]    	BOARD_LEDS,
			input  wire [66:0] loan_io_in,		//loan io inputs coming from soc_system block
			output wire [66:0] loan_io_out,		//loan io outputs going to soc_system block
			output wire [66:0] loan_io_oe		//loan io enable outputs going to soc_system block
			);

reg  [26:0] counter;

//enable oe (1) the outputs
//assign loan_io_oe[52:51] = 2'b11;		//I2C1
assign loan_io_oe[52] = 1'b1;			//I2C1 pin 11
assign loan_io_oe[54:53] = 2'b11;		//HPS_LEDS 1,0	
assign loan_io_oe[0] = 1'b1;			//HPS_LTC_GPIO	
assign loan_io_oe[60] = 1'b1;			//SPIM1
assign loan_io_oe[58:57] = 2'b11;		//SPIM1

//disable oe (0) the inputs
assign loan_io_oe[59] = 1'b0;			//SPIM1 MISO signal
assign loan_io_oe[51] = 1'b0;			//I2C1 pin 9 used as Interrupt from mcp23s17

always @ (posedge clk)  		// on positive clock edge
	counter <= counter + 1;		// increment counter
			
//assign to each input/output loanio pin the value required
assign loan_io_out[54] = counter[23] || ~RESET_KEY;			//HPS_LEDS 1	

// Signal HPS_LTC_GPIO is connected to U49 selector circuit through R365 resistor
// HPS_LTC_GPIO = 1 disables SPI and duplicates I2C at pins 4 & 7 at LTC connector
// HPS_LTC_GPIO = 0 enables SPI comms at LTC connector
// HPS_LTC_GPIO has to be selected by HPS GPIO00 / FPGA LOANIO00
// If a zero Resistor were soldered in the place for R362 then selection could be made through LTC connector 

//LTC_Connector -- test outputs --																		LTC_PIN			SIGNAL 		SCHEMATICS		FPGA_PIN		COMMENTS
//assign loan_io_out[51] = counter[24]; //I2C_LTC[0];		1.5Hz 		pin 9		I2C1.SDA		HPS_I2C_SDA		PIN_A25 	(share bus with G-Sensor)			
//assign loan_io_out[52] = counter[23]; //I2C_LTC[1];		3 Hz 		pin 11 		I2C1.SCL		HPS_I2C_CLK		PIN_H23 	(share bus with G-Sensor)
//assign loan_io_out[57] = counter[22]; //SPI_LTC[0];	***6 Hz / 3 Hz 	pin 4		SPIM1.CLK		HPS_SPIM_CLK	PIN_A23		SCK_SCL  selected by GPIO 0 / 1
//assign loan_io_out[58] = counter[21]; //SPI_LTC[1];	***12Hz / 1.5Hz	pin 7		SPIM1.MOSI		HPS_SPIM_MOSI	PIN_C22		MOSI_SDA	selected by GPIO 0 / 1
//assign loan_io_out[59] = counter[20]; //SPI_LTC[2];	***25Hz / 0V	pin 5		SPIM1.MISO		HPS_SPIM_MISO	PIN_B23		MISO selected by GPIO 0 / 1		
//assign loan_io_out[60] = counter[19]; //SPI_LTC[3];	***50Hz / 3.3V	pin 6		SPIM1.SS (CS)	HPS_SPIM_SS		PIN_H20		CSn selected by GPIO 0 / 1

assign loan_io_out[0] = 1'b0;	// HPS_LTC_GPIO = 0 enables SPI 	//	pin 14		HPS_LTC_GPIO	HPS_LTC_GPIO	PIN_F16	
																	//	pin 3,8,12,13 GND
																	//	pin 1		VCC9    9V
																	//	pin 2,10	VCC3P3  3.3V					
												
gpio_spi gpio_spi_0 (
    .CLK_50(clk),
    .RESET_N(RESET_KEY),        	//KEY 0
    // LED output
    .CORE_LED(loan_io_out[53]),     //HPS_LED0
    .BOARD_LEDS(BOARD_LEDS),     	//LEDS 0..3
    //Joystick SELECT Pin   (for selection of buttons to read)
	.JOY_SEL(loan_io_out[52]),		//I2C_LTC[1];				//pin 11 LTC
    // MCP23S17 interface
    .JS_INTA(loan_io_in[51]),     	// Interrupt from mcp23s17  //pin 9 LTC
    .JS_MISO(loan_io_in[59]),
    .JS_MOSI(loan_io_out[58]),
    .JS_CS(loan_io_out[60]),
    .JS_SCK(loan_io_out[57])
);
										

endmodule					
