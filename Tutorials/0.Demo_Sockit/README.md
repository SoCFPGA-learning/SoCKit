Logic circuit & Simulation
-----

### Features

* Build a digital logic schematic in the block editor
* Simulate in the waveform simulator
* Test with real hardware (4 slides & led)

### Sources of information

* https://www.youtube.com/watch?v=uSGsQjXWnXk
* Sockit telegram Group (credits to Fernando)

### Considerations

This tutorial has been made with this software setup:

* Quartus lite & EDS 17.0

  There shouldn't be any major problem for following this tutorial with other versions of Quartus.

### Block diagram
![](./block-diagram.png)

### IO assignment

* SW0 = A, SW1 = B, SW2 = C, SW3 = D
* LED0 = F
* Pin planner location assignment:

![image-20210106000604643](pin-planner.png)



### Notes 

* Recordad que la parte de generación de cada valor en el waveform simulator se hace forzando un clock a cada variable de entrada , empezando el D por 10 ns, C 20 ns, B 40ns y A 80 ns