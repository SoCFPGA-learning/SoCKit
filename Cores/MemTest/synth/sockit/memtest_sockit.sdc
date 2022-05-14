derive_pll_clocks
derive_clock_uncertainty

create_clock -name clk_50 -period 14.5 [get_ports {clock_50_i}]

# set_clock_groups -exclusive -group [get_clocks { *|vpll|vpll_inst|altera_pll_i|*[*].*|divclk}]

set sysclk pll|altpll_component|auto_generated|pll1|clk[0] 
create_generated_clock -name sdram_clk -source $sysclk -invert [get_ports {SDRAM_CLK}]


# Name the SDRAM-related variables
set RAM_CLK SDRAM_CLK
set RAM_OUT {SDRAM_DQ* SDRAM_A* SDRAM_BA* SDRAM_nRAS SDRAM_nCAS SDRAM_nWE SDRAM_DQM* SDRAM_nCS SDRAM_CKE}
set RAM_IN {SDRAM_D*}


# Input delays
set_input_delay -clock sdram_clk -max 6.4 [get_ports ${RAM_IN}]
set_input_delay -clock sdram_clk -min 3.2 [get_ports ${RAM_IN}]

# Output delays
set_output_delay -clock sdram_clk -max 1.5 [get_ports ${RAM_OUT}]
set_output_delay -clock sdram_clk -min -0.8 [get_ports ${RAM_OUT}]

# Multicycle
set_multicycle_path -from sdram_clk -to [get_clocks $sysclk] -setup 2
