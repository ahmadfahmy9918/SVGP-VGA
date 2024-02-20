# Simple Video-Game Processor for VGA
## Abstract
The goal of this project was to design a Simple Video-Game Processor for Video Graphics Array (VGA) on a Xilinx Spartan-3E FPGA. The main objectives
could be broken down as follows. First, the goal was to learn about the functionality of the
video-output system as well as the Video Graphic Adaptor (VGA). Secondly, it was important
to learn how to develop and incorporate the gaming logic of the pong game with the
dynamic elements of the game. Finally, it was important to apply the knowledge of the
signals that synchronize the video output (Hsync and Vsync), as well as the signals that
provide what is being seen (Rout, Bout, and Gout). The Hsync and Vsync signals were set by
using a counter. When 800 clock cycles (based on requirements in the lab manual) were
reached, the Hsync would reset and a new line would result. When 525 lines (also based on
requirements in the lab manual) were reached, a new frame would begin. Initially, or when
the game is reset after a goal, the objects are set at specific places in the game. After every
second, the ball moves at a rate of 60 pixels per second, and its horizontal and vertical
movement is changed when it collides with elements of the game (paddle, boundary, etc.).
This is detected when the ball reaches coordinates held by the aforementioned objects in
the game. If the “up” or “down” switches for both paddles were on, the coordinates of the
paddle would be changed by adding the paddle velocity. More specifically, it would move
vertically, based on the direction chosen, at a rate of 60 pixels per second. We were able to
successfully code a VHDL file as well as implement the VGA design. This was verified when
our timing diagrams agreed with the expected results. The output from the game was given
to the VGA to update RGB output signals as expected. The timing diagrams showed that the
HSync and VSync signals produced the appropriate output. Overall, the project was
completed successfully.

## Introduction 
The goal of the project was to create a pong game which is controlled using switches. To
clearly understand how to do such a task one must understand what is required to undergo
it. The project’s overall purpose was to generate video output with the use of
synchronizations signals, output signals, and game logic that creates ball movement, paddle
movement, and detects collisions. Also, to show how the interface interaction is possible
using the software. In this project, the paddles were used to move both up and down using
the switches. Since there are multiple switches, the ones used on either end were selected
as the controls for the paddles. The display of the pong field was a set field which uses the
pixel settings with signals for the Hsync and Vsync for the placement of the pixels. The pixels
change due to the various objects in motion, so the pixels that output these objects, change
every second. The object’s coordinates are used to replace the current pixel value and set it
as the colour associated with the object. The parts of the field use a colour scheme that use
a mix of red, green, and blue signals to represent desired colours for the ball, paddles,
background, etc. The movement throughout the pong field, as well as any changes that
occur when actions take place, is programmed using VHDL.

## Specifications
The behaviour of this system took on a straightforward approach. My partner and I
opted to build the program using a single component. Our initial plan was to use two
components, one for the game engine and another for VGA output. A diagram of this can be
found in the appendix. However, when implementing our design, we found that it creates a
simpler design to integrate the two into a single component.

## Design
[insert fig 1 here

Table I. VGA Horizontal Parameters
| Paramter          | Clock Cycles |
|-------------------|:------------:|
| Complete Line     | 800          |
| Front Porch       | 16           |
| Sync Pulse        | 96           |
| Back Porch        | 48           |
| Active Image Area | 640          |

Table II. VGA Vertical Parameters
| Paramter          | Clock Cycles |
|-------------------|:------------:|
| Complete Line     | 525          |
| Front Porch       | 10           |
| Sync Pulse        | 2            |
| Back Porch        | 33           |
| Active Image Area | 480          |

[insert process diagram here

[insert timing diagrams here

## Results

## Conclusions
This project was a learning opportunity about the process of creating an image using a VGA connection. In addition, I had to learn how to process the image while still keeping track of and handling user inputs. I was then able to successfully handle the ball/paddle movement and check for the possible boundary conditions. The signals demonstrated that the ball was moving in the directions we anticipated. The output from the game process was provided to the VGA process to update RGB signals accordingly. Simulations demonstrated that the HSync and VSync signals produced the correct output. I  observed the appropriate RGB signals being accompanied by the HSync and VSync signals. Overall, the project was completed successfully.
