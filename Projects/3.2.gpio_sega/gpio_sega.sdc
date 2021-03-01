create_clock -name "CLK_50" -period 20.000ns [get_ports {CLK_50}]
derive_pll_clocks
derive_clock_uncertainty
