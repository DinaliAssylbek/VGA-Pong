module VGA_top (
    input clk, clr, reset,                 // 50 MHz FPGA signal, clear signal, reset signal
    input [15:0] q_b,                      // Data Coming in from memory

    output wire [7:0] VGA_R, VGA_G, VGA_B, // 8 bits for each RGB channel
    output hSync, vSync,                   // Horizontal and Vertical Sync signal
    output enable, bright, sync,           // Enable Signal (25 MHz clock and VGA clock), bright indicating if on screen, VGA_Sync_N
    output [15:0] addr_b                   // Address to input for the B port in BRAM
);

// VGA timing control variables
wire [9:0] hCount;
wire [9:0] vCount;
wire [1:0] game_state;

// Glyph-based VGA variables
wire [2:0] glyph_column; 
wire [2:0] glyph_row;
wire [5:0] char_index;
wire [2:0] colors;
wire pixel;

// Game state variables
wire [9:0] ball_x;
wire [9:0] ball_y;
wire [9:0] paddle1_y;
wire [9:0] paddle2_y;
wire [6:0] player_1_score;
wire [6:0] player_2_score;

// Decoded player scores
wire [3:0] tens_place_score_1;
wire [3:0] ones_place_score_1;
wire [3:0] tens_place_score_2;
wire [3:0] ones_place_score_2;

// Ball animation variables
wire [9:0] animation_ball_x;
wire [9:0] animation_ball_y;

// VGA timing control
vgaControl control (
    .clk(clk), 
    .clr(clr), 
    .en(enable),
    .hSync(hSync), 
    .vSync(vSync), 
    .bright(bright), 
    .hCount(hCount), 
    .vCount(vCount)
);

// Ball animation for intro screen
ball_animation ba (
    .clk(clk), 
    .reset(reset), 
    .ball_x_pos(animation_ball_x), 
    .ball_y_pos(animation_ball_y)
);

// FSM for reading game data
fsm_read_data fsm (
    .clk(clk), 
    .reset(reset), 
    .q_b(q_b), 
    .addr_b(addr_b), 
    .game_state(game_state), 
    .ball_x(ball_x), 
    .ball_y(ball_y), 
    .paddle1_y(paddle1_y), 
    .paddle2_y(paddle2_y), 
    .player_1_score(player_1_score), 
    .player_2_score(player_2_score)
);

// Decoding player scores
score_decoder sd (
    .binary_score1(player_1_score), 
    .binary_score2(player_2_score), 
    .tens_place_1(tens_place_score_1), 
    .ones_place_1(ones_place_score_1), 
    .tens_place_2(tens_place_score_2), 
    .ones_place_2(ones_place_score_2)
);

// Address generation
addr_gen ag (
    .clk(clk), 
    .reset(reset), 
    .tens_place_score_1(tens_place_score_1), 
    .ones_place_score_1(ones_place_score_1), 
    .game_state(game_state), 
    .tens_place_score_2(tens_place_score_2), 
    .ones_place_score_2(ones_place_score_2), 
    .hCount(hCount), 
    .vCount(vCount), 
    .y_pos1(paddle1_y), 
    .y_pos2(paddle2_y), 
    .ball_x(ball_x), 
    .ball_y(ball_y), 
    .animation_ball_x(animation_ball_x), 
    .animation_ball_y(animation_ball_y), 
    .char_index(char_index), 
    .glyph_column(glyph_column), 
    .glyph_row(glyph_row), 
    .colors(colors)
);

// Glyph ROM
glyph_rom gr (
    .char_index(char_index), 
    .glyph_column(glyph_column), 
    .glyph_row(glyph_row), 
    .pixel(pixel)
);

// Bit generation for RGB output
bitGen bg (
    .pixel(pixel), 
    .bright(bright), 
    .VGA_R(VGA_R), 
    .VGA_G(VGA_G), 
    .VGA_B(VGA_B), 
    .colors(colors)
);

endmodule
