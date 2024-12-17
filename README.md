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
###### Description: 
This module generates the addresses for accessing the video memory (VGA frame buffer). It calculates the address to be read based on the current pixel location on the screen.
Function: Ensures that the VGA controller can correctly access the correct memory locations to display the images and text on the screen.
#### 2. VGABallAnimationCalculator.v
Description: This module is responsible for calculating the animation of the ball during the game.
Function: It controls the ball's movement, including speed, direction, and interactions with the paddles and walls.
#### 3. VGABitGen.v
Description: This module generates the bit patterns required for displaying characters or images on the VGA screen.
Function: It works with the glyph ROM to convert the data into the proper bit representation for the VGA display.
#### 4. VGAControl.v
Description: This module acts as the central control unit for the VGA display, coordinating the flow of data to the VGA output based on the current game state.
Function: It manages the different game states (Introduction, Game, Game Over) and triggers the appropriate actions to update the display.
#### 5. VGAGlyphRom.v
Description: This module contains a ROM (Read-Only Memory) with 24 predefined glyphs used by the game.
Function: The glyphs are used to display scores, text, and other graphical elements on the screen. The ROM is specifically designed for this Pong game and will need to be modified for use in other applications.
#### 6. VGAScoreDecoder.v
Description: This module decodes the score data and sends it to the display.
Function: Converts the numerical score into the corresponding glyph to be displayed on the screen, helping to visualize the player's score.
#### 7. VGATop.v
Description: This is the top-level module that instantiates and connects all the other modules in the project.
Function: Coordinates the overall system, connecting the VGA controller, BRAM, and other submodules. It serves as the main control unit for the Pong game.
#### 8. VGAfsm.v
Description: This module contains the finite state machine (FSM) that controls the transitions between the different game states.
Function: It determines when the game should move between the Introduction, Game, and Game Over screens based on user inputs or game events.
