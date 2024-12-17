# VGA Pong Project for CS 3710
This project is part of a larger Pong game implemented in Verilog for the CS 3710 class at the University of Utah. The project utilizes VGA communication to display the game on a screen. It operates on a 25 Hz clock and includes animations for the ball and paddles, with multiple game states and a custom-built font for the display.

## Overview
The design consists of several Verilog modules that communicate with each other to display the Pong game on a VGA screen. The system uses a 25 Hz clock and supports three main game states:

1. Introduction Screen
2. Game Screen
3. Game Over Screen
   
The display is controlled via the VGA interface, and the game data (such as ball and paddle positions, scores, and game state) is stored in Block RAM (BRAM). The game's glyph ROM contains a set of 24 glyphs specifically designed for this Pong game.

## File Descriptions:
#### 1. VGAAddressGen.v
Description: This module generates the index for accessing the glyph. It calculates the address to be read based on the current pixel location on the screen.
#### 2. VGABallAnimationCalculator.v
Description: This module is responsible for calculating the animation of the ball during the introduction screen of the game.
#### 3. VGABitGen.v
Description: This module generates the bit patterns required for displaying characters or images on the VGA screen.
#### 4. VGAControl.v
Description: This module acts as the central control unit for the VGA display, calculating the horizontal and vertical pixel placements as well as the horizontal and vertical synchronizations.
#### 5. VGAGlyphRom.v
Description: This module contains a ROM (Read-Only Memory) with 24 predefined glyphs used by the game.
#### 6. VGAScoreDecoder.v
Description: This module decodes the score data and sends it to the display.
#### 7. VGATop.v
Description: This is the top-level module that instantiates and connects all the other modules in the project.
#### 8. VGAfsm.v
Description: This module contains the finite state machine (FSM) that controls the signals sent to memory to continously retrieve game information such as scores, paddle positions, and ball position from memory. 
