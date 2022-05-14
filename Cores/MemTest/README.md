# MemTest - Utility to test SDRAM daughter board - SOCKIT PORT

Memtest by Somhic ported from Neptuno https://github.com/neptuno-fpga/MemTest_Mister, which was ported from Multicore 2, which was already ported from original Memory tester for MiSTer (https://github.com/MiSTer-devel/MemTest_MiSTer).

**Features:**

* VGA video output 

**Additional hardware**:

- SDRAM module for testing. 
- PS/2 Keyboard connected to GPIO 

**STATUS**:

- 22/04/22 Sockit Port. **Only does the test at fixed 120 MHz frecuency**
- Does not work with 128 MB memory modules. 

**Compiling:**

* Load project  in /synth/sockit/memtest_sockit.qpf
* sof file already included in /synth/sockit/output_files/

**Pinout connections:**

See qsf file

## Memtest screen:

![MemTest screen](memtest.png)

 1. Auto mode indicator (animated)
 2. Test time passed in minutes
 3. Current memory module frequency in MHz
 4. Memory module size:
    * 0 - no memory board
    * 1 - 32 MB
    * 2 - 64 MB
    * 3 - 128 MB
 5. Number of of passed test cycles (each cycle is 32 MB)
 6. Number of failed tests.

## Controls (keyboard)
* Up - increase frequency   ~~(KEY0 BUTTON)~~

* Down - decrease frequency ~~(KEY1 BUTTON)~~

* ESC - reset the test

* A - auto mode, detecting the maximum frequency for module being tested. Test starts from maximum frequency. With every error frequency will be decreased. [~~SW1 SWITCH~~]
  
  

Test is passed if amount of errors is 0. For quick test let it run for 10 minutes in auto mode. If you want to be sure, let it run for 1-2 hours.

Board should pass at least 130 MHz clock test. Any higher clock will assure the higher quality of the board.