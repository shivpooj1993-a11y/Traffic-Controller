Smart Traffic Management System

A Verilog-based Smart Traffic Management System for controlling traffic lights at a four-way road intersection using traffic-density information.

Overview

Traditional traffic lights operate using fixed timing regardless of the number of vehicles waiting on each road. This project implements an adaptive traffic-light controller that uses traffic-density inputs to select the road that should receive the green signal.

The system monitors four directions:

North

South

East

West

Each direction has a 2-bit traffic-density input:

Density	Meaning
00	No traffic
01	Low traffic
10	Medium traffic
11	High traffic

The controller compares the traffic levels and gives priority to the direction with the highest traffic density.

Features

Four-way traffic intersection

Adaptive traffic control

Traffic-density based priority

Red, yellow and green traffic signals

Safe all-red transition between directions

Reset functionality

Synthesizable Verilog RTL

Self-checking testbench

Simulation support using Icarus Verilog and GTKWave

System Architecture
                 NORTH
              [Sensor N]
                  |
                  |
                  v
             +---------+
             |         |
WEST         | Traffic |        EAST
[Sensor W] ->| Control |<- [Sensor E]
             |         |
             +---------+
                  ^
                  |
              [Sensor S]
                 SOUTH

Inputs
Signal	Width	Description
clk	1	System clock
reset	1	Active-high reset
traffic_n	2	North traffic density
traffic_s	2	South traffic density
traffic_e	2	East traffic density
traffic_w	2	West traffic density
Outputs
Signal	Description
north_red	North red signal
north_yellow	North yellow signal
north_green	North green signal
south_red	South red signal
south_yellow	South yellow signal
south_green	South green signal
east_red	East red signal
east_yellow	East yellow signal
east_green	East green signal
west_red	West red signal
west_yellow	West yellow signal
west_green	West green signal
Controller States

The controller uses six states:

NS_GREEN
   |
   v
NS_YELLOW
   |
   v
ALL_RED
   |
   v
EW_GREEN
   |
   v
EW_YELLOW
   |
   v
ALL_RED
   |
   +------> Select next direction


North and South operate together because they do not conflict with each other in this simplified four-way intersection model.

East and West operate together for the same reason.

Adaptive Control

At the end of each traffic-light cycle, the controller compares the traffic density.

For the North-South direction:

NS traffic = traffic_n + traffic_s


For the East-West direction:

EW traffic = traffic_e + traffic_w


The direction with the greater traffic demand receives the next green phase.

If both directions have the same demand, the controller alternates between them.

Simulation

The supplied testbench checks:

Reset operation

Heavy North-South traffic

Heavy East-West traffic

Equal traffic

Changing traffic conditions

Yellow transitions

All-red safety state

Running With Icarus Verilog

Install Icarus Verilog and GTKWave.

Compile the design:

iverilog -o traffic_sim src/traffic_controller.v tb/traffic_controller_tb.v


Run the simulation:

vvp traffic_sim


A VCD waveform file named traffic.vcd will be generated.

Open the waveform:

gtkwave traffic.vcd

Expected Simulation

Example console output:

Starting Smart Traffic Management System simulation...

Time=0    NS GREEN
Time=40   NS GREEN
Time=80   NS YELLOW
Time=90   ALL RED
Time=100  EW GREEN
Time=140  EW GREEN
Time=180  EW YELLOW
Time=190  ALL RED

Traffic conditions changed.

Time=200  NS GREEN
...
Simulation completed successfully.


The exact timestamps depend on the clock and timing parameters used in the RTL.

Applications

The concept can be extended to:

Smart city traffic systems

IoT-based traffic monitoring

FPGA traffic controllers

Emergency vehicle priority systems

Intelligent transportation systems

Vehicle-density monitoring

Future Enhancements

Possible improvements include:

Real-time vehicle sensors

Emergency vehicle detection

Pedestrian crossing control

Ambulance priority

Camera-based vehicle counting

IoT/cloud monitoring

Machine-learning-based traffic prediction

FPGA implementation

Tools

Verilog HDL

Icarus Verilog

GTKWave

Git

GitHub

License

This project is intended for educational and academic purposes.