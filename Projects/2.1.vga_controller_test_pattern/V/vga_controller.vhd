--------------------------------------------------------------------------------
--
--   FileName:         vga_controller.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--   Version 1.1 03/07/2018 Scott Larson
--     Corrected two minor "off-by-one" errors
--
--   https://www.digikey.com/eewiki/pages/viewpage.action?pageId=15925278
--    
--------------------------------------------------------------------------------
-- Set PLLs to produce a 25.175 MHz pixel clock, as required by the 640x480 @60Hz VGA mode.
--------------------------------------------------------------------------------

--
--//http://tinyvga.com/vga-timing/640x480@60Hz
--//Screen refresh rate	60 Hz
--//Vertical refresh	31.46875 kHz
--//Pixel freq.	25.175 MHz
--//Horizontal timing (line)
--//Polarity of horizontal sync pulse is negative.
--//Scanline part	Pixels	Time [µs]
--//Visible area	640	25.422045680238
--//Front porch	16	0.63555114200596
--//Sync pulse	96	3.8133068520357
--//Back porch	48	1.9066534260179
--//Whole line	800	31.777557100298

--//Vertical timing (frame)
--//Polarity of vertical sync pulse is negative.
--//Frame part	Lines	Time [ms]
--//Visible area	480	15.253227408143
--//Front porch	10	0.31777557100298
--//Sync pulse	2	0.063555114200596
--//Back porch	33	1.0486593843098
--//Whole frame	525	16.683217477656


LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY vga_controller IS
	GENERIC(
		h_pulse 	:	INTEGER := 96;    	--horizontal sync pulse width in pixels
		h_bp	 	:	INTEGER := 48;		--horizontal back porch width in pixels
		h_pixels	:	INTEGER := 640-1;		--horizontal display width in pixels
		h_fp	 	:	INTEGER := 16;		--horizontal front porch width in pixels
		h_pol		:	STD_LOGIC := '0';	--horizontal sync pulse polarity (1 = positive, 0 = negative)
		v_pulse 	:	INTEGER := 2;		--vertical sync pulse width in rows
		v_bp	 	:	INTEGER := 33;		--vertical back porch width in rows
		v_pixels	:	INTEGER := 480-1;		--vertical display width in rows
		v_fp	 	:	INTEGER := 10;		--vertical front porch width in rows
		v_pol		:	STD_LOGIC := '0');	--vertical sync pulse polarity (1 = positive, 0 = negative)
	PORT(
		pixel_clk	:	IN	STD_LOGIC;	--pixel clock at frequency of VGA mode being used
		reset_n		:	IN	STD_LOGIC;	--active low asycnchronous reset
		disp_ena	:	OUT	STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
		column		:	OUT	INTEGER;	--horizontal pixel coordinate
		row			:	OUT	INTEGER;	--vertical pixel coordinate
		VGA_BLANK_n	:	OUT	STD_LOGIC;	--direct blacking output to DAC
		VGA_SYNC_n	:	OUT	STD_LOGIC;  --sync-on-green output to DAC
		VGA_HS		:	OUT	STD_LOGIC;	--horiztonal sync pulse
		VGA_VS		:	OUT	STD_LOGIC;	--vertical sync pulse
		VGA_CLK		:	OUT STD_LOGIC);	--clock output to Video DAC
END vga_controller;

ARCHITECTURE behavior OF vga_controller IS
	CONSTANT	h_period	:	INTEGER := h_pulse + h_bp + h_pixels + h_fp;  --total number of pixel clocks in a row
	CONSTANT	v_period	:	INTEGER := v_pulse + v_bp + v_pixels + v_fp;  --total number of rows in column
BEGIN

	VGA_BLANK_n <= '1';  --no direct blanking
	VGA_SYNC_n <= '0';   --no sync on green
	VGA_CLK <= pixel_clk; 
	
	PROCESS(pixel_clk, reset_n)
		VARIABLE h_count	:	INTEGER RANGE 0 TO h_period - 1 := 0;  --horizontal counter (counts the columns)
		VARIABLE v_count	:	INTEGER RANGE 0 TO v_period - 1 := 0;  --vertical counter (counts the rows)
	BEGIN
	
		IF(reset_n = '0') THEN		--reset asserted
			h_count := 0;				--reset horizontal counter
			v_count := 0;				--reset vertical counter
			VGA_HS <= NOT h_pol;		--deassert horizontal sync
			VGA_VS <= NOT v_pol;		--deassert vertical sync
			disp_ena <= '0';			--disable display
			column <= 0;				--reset column pixel coordinate
			row <= 0;					--reset row pixel coordinate
			
		ELSIF(pixel_clk'EVENT AND pixel_clk = '1') THEN

			--counters
			IF(h_count < h_period - 1) THEN		--horizontal counter (pixels)
				h_count := h_count + 1;
			ELSE
				h_count := 0;
				IF(v_count < v_period - 1) THEN	--veritcal counter (rows)
					v_count := v_count + 1;
				ELSE
					v_count := 0;
				END IF;
			END IF;

			--horizontal sync signal
			IF(h_count < h_pixels + h_fp OR h_count >= h_pixels + h_fp + h_pulse) THEN
				VGA_HS <= NOT h_pol;		--deassert horiztonal sync pulse
			ELSE
				VGA_HS <= h_pol;			--assert horiztonal sync pulse
			END IF;
			
			--vertical sync signal
			IF(v_count < v_pixels + v_fp OR v_count >= v_pixels + v_fp + v_pulse) THEN
				VGA_VS <= NOT v_pol;		--deassert vertical sync pulse
			ELSE
				VGA_VS <= v_pol;			--assert vertical sync pulse
			END IF;
			
			--set pixel coordinates
			IF(h_count < h_pixels) THEN  	--horiztonal display time
				column <= h_count;			--set horiztonal pixel coordinate
			END IF;
			IF(v_count < v_pixels) THEN		--vertical display time
				row <= v_count;				--set vertical pixel coordinate
			END IF;

			--set display enable output
			IF(h_count < h_pixels AND v_count < v_pixels) THEN  	--display time
				disp_ena <= '1';											 	--enable display
			ELSE																	--blanking time
				disp_ena <= '0';												--disable display
			END IF;

		END IF;
	END PROCESS;

END behavior;