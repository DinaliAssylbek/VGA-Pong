module addr_gen(
    input clk, reset,                                   // 50 MHz FPGA clock and reset signal
    input [9:0] hCount, vCount,                         // Current horizontal and vertical pixel coordinates from the VGA controller
    input [1:0] game_state,                             // Current state of the game (e.g., idle, play, end, etc.)
    input [9:0] y_pos1, y_pos2,                         // Vertical positions of Paddle 1 and Paddle 2
    input [9:0] animation_ball_x, animation_ball_y,     // Coordinates for the animated ball during intro or non-gameplay states
    input [9:0] ball_x, ball_y,                         // Coordinates for the ball during gameplay
    input [3:0] tens_place_score_1, ones_place_score_1, // Tens and ones digit of Player 1's score
    input [3:0] tens_place_score_2, ones_place_score_2, // Tens and ones digit of Player 2's score

    output reg [5:0] char_index,                        // Index of the character glyph to be displayed
    output [2:0] glyph_column,                          // Current column of the character glyph being drawn (for addressing ROM)
    output [2:0] glyph_row,                             // Current row of the character glyph being drawn (for addressing ROM)
    output reg [2:0] colors                             // Color output for the pixel being rendered (based on game elements)
);

	 parameter PADDLE_WIDTH = 10;   // Paddle Width Parameter
    parameter PADDLE_HEIGHT = 75;  // Paddle Height Parameter
	 parameter BALL_SIZE = 10;      // Ball Size Parameter

    // Grid column and row (pixel position on the screen)
    wire [6:0] grid_column = hCount[9:3]; // Adjust grid column to match the display's resolution
    wire [5:0] grid_row = vCount[8:3];    // Adjust grid row to match the display's resolution

    assign glyph_column = hCount[2:0]; // Mapping hCount to column
    assign glyph_row = vCount[2:0];    // Mapping vCount to row

    always @(posedge clk) begin
		
		  // If reset, black out the whole screen
		  if (!reset) begin
				char_index <= 31;
		  end else if ((hCount >= 150 && hCount < 150 + PADDLE_WIDTH) && (vCount >= (game_state == 2'b00 ? animation_ball_y : y_pos1) && vCount < (game_state == 2'b00 ? animation_ball_y : y_pos1) + PADDLE_HEIGHT)) begin // Paddle 1 Position
				char_index <= 10;
				colors <= 1;
		  end else if ((hCount >= 735 && hCount < 735 + PADDLE_WIDTH) && (vCount >= (game_state == 2'b00 ? animation_ball_y : y_pos2) && vCount < (game_state == 2'b00 ? animation_ball_y : y_pos2) + PADDLE_HEIGHT)) begin // Paddle 2 Position
				char_index <= 10;
				colors <= 2;
		  end else if ((hCount >= (game_state == 2'b00 ? animation_ball_x : ball_x) && hCount < (game_state == 2'b00 ? animation_ball_x : ball_x) + BALL_SIZE) && (vCount >= (game_state == 2'b00 ? animation_ball_y : ball_y) && vCount < (game_state == 2'b00 ? animation_ball_y : ball_y) + BALL_SIZE)) begin // Ball Position
				char_index <= 10;
				colors <= 0;
		  
		  // Player 1 Score
		  end else if (grid_row == 6 && grid_column == 24) begin char_index <= 3; colors <= 0; // S
		  end else if (grid_row == 6 && grid_column == 25) begin char_index <= 10;colors <= 0; // C
		  end else if (grid_row == 6 && grid_column == 26) begin char_index <= 6; colors <= 0; // O
		  end else if (grid_row == 6 && grid_column == 27) begin char_index <= 1; colors <= 0; // R
		  end else if (grid_row == 6 && grid_column == 28) begin char_index <= 2; colors <= 0; // E
		  end else if (grid_row == 6 && grid_column == 29) begin char_index <= 12;colors <= 0; // :
		  
		  end else if (grid_row == 6 && grid_column == 31) begin char_index <= 13 + ones_place_score_1; colors <= 0; // Player 1 Score
		  end else if (grid_row == 6 && grid_column == 30) begin char_index <= 13 + tens_place_score_1; colors <= 0; // Player 1 Score
		  
		  // Player 2 Score
		  end else if (grid_row == 6 && grid_column == 80) begin char_index <= 3; colors <= 0;  // S
		  end else if (grid_row == 6 && grid_column == 81) begin char_index <= 10; colors <= 0; // C
		  end else if (grid_row == 6 && grid_column == 82) begin char_index <= 6; colors <= 0;  // O
		  end else if (grid_row == 6 && grid_column == 83) begin char_index <= 1; colors <= 0;  // R
		  end else if (grid_row == 6 && grid_column == 84) begin char_index <= 2; colors <= 0;  // E
		  end else if (grid_row == 6 && grid_column == 85) begin char_index <= 12; colors <= 0; // :
		  
		  end else if (grid_row == 6 && grid_column == 87) begin char_index <= 13 + ones_place_score_2; colors <= 0; // Player 2 Score
		  end else if (grid_row == 6 && grid_column == 86) begin char_index <= 13 + tens_place_score_2; colors <= 0; // Player 2 Score
		  
		  // Pong Intro Screen
		  end else if (game_state == 2'b00) begin
				colors <= 0;
	
			  // Bit Busters  
			  if (grid_row == 30 && grid_column == 50) begin char_index <= 7;           // B
			  end else if (grid_row == 30 && grid_column == 51) begin char_index <= 9;  // I
			  end else if (grid_row == 30 && grid_column == 52) begin char_index <= 5;  // T
			  end else if (grid_row == 30 && grid_column == 54) begin char_index <= 7;  // B
			  end else if (grid_row == 30 && grid_column == 55) begin char_index <= 8;  // U
			  end else if (grid_row == 30 && grid_column == 56) begin char_index <= 3;  // S
			  end else if (grid_row == 30 && grid_column == 57) begin char_index <= 5;  // T
			  end else if (grid_row == 30 && grid_column == 58) begin char_index <= 2;  // E
			  end else if (grid_row == 30 && grid_column == 59) begin char_index <= 1;  // R
			  end else if (grid_row == 30 && grid_column == 60) begin char_index <= 3;  // S
			  
			  // P1: Press A To Start
			  end else if (grid_row == 40 && grid_column == 44) begin char_index <= 0;  // P
			  end else if (grid_row == 40 && grid_column == 45) begin char_index <= 14; // 1
			  end else if (grid_row == 40 && grid_column == 46) begin char_index <= 12; // :
			  end else if (grid_row == 40 && grid_column == 48) begin char_index <= 0;  // P
			  end else if (grid_row == 40 && grid_column == 49) begin char_index <= 1;  // R
			  end else if (grid_row == 40 && grid_column == 50) begin char_index <= 2;  // E
			  end else if (grid_row == 40 && grid_column == 51) begin char_index <= 3;  // S
			  end else if (grid_row == 40 && grid_column == 52) begin char_index <= 3;  // S
			  end else if (grid_row == 40 && grid_column == 54) begin char_index <= 4;  // A
			  end else if (grid_row == 40 && grid_column == 56) begin char_index <= 5;  // T
			  end else if (grid_row == 40 && grid_column == 57) begin char_index <= 6;  // O
			  end else if (grid_row == 40 && grid_column == 59) begin char_index <= 3;  // S
			  end else if (grid_row == 40 && grid_column == 60) begin char_index <= 5;  // T
			  end else if (grid_row == 40 && grid_column == 61) begin char_index <= 4;  // A
			  end else if (grid_row == 40 && grid_column == 62) begin char_index <= 1;  // R
			  end else if (grid_row == 40 && grid_column == 63) begin char_index <= 5;  // T
			  
			  // PONG Headline
			  end else if (grid_row == 28 && grid_column == 46) begin char_index <= 30;
			  end else if (grid_row == 28 && grid_column == 52) begin char_index <= 30;
			  end else if (grid_row == 28 && grid_column == 53) begin char_index <= 30;
			  end else if (grid_row == 28 && grid_column == 56) begin char_index <= 30;
			  end else if (grid_row == 28 && grid_column == 59) begin char_index <= 30;
			  end else if (grid_row == 28 && grid_column == 62) begin char_index <= 30;
			  end else if (grid_row == 28 && grid_column == 63) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 46) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 51) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 54) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 56) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 58) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 59) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 61) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 64) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 46) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 47) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 48) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 51) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 54) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 56) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 59) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 61) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 63) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 64) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 46) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 49) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 51) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 54) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 56) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 59) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 61) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 46) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 49) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 51) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 54) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 56) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 59) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 61) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 64) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 46) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 47) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 48) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 52) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 53) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 56) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 59) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 62) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 63) begin char_index <= 30;
			  end else begin char_index <= 31; 
		  end

		  
		  // If game is over
		  end else if (game_state == 2'b10) begin
		  colors <= 0;
			  if (grid_row == 40 && grid_column == 48) begin char_index <= 0;          // P
			  end else if (grid_row == 40 && grid_column == 49) begin char_index <= 1; // R
			  end else if (grid_row == 40 && grid_column == 50) begin char_index <= 2; // E
			  end else if (grid_row == 40 && grid_column == 51) begin char_index <= 3; // S
			  end else if (grid_row == 40 && grid_column == 52) begin char_index <= 3; // S
			  
			  end else if (grid_row == 40 && grid_column == 54) begin char_index <= 3; // S
			  end else if (grid_row == 40 && grid_column == 55) begin char_index <= 5; // T
			  end else if (grid_row == 40 && grid_column == 56) begin char_index <= 4; // A
			  end else if (grid_row == 40 && grid_column == 57) begin char_index <= 1; // R
			  end else if (grid_row == 40 && grid_column == 58) begin char_index <= 5; // T
			  
			  end else if (grid_row == 40 && grid_column == 60) begin char_index <= 5; // T
			  end else if (grid_row == 40 && grid_column == 61) begin char_index <= 6; // O
			  
			  end else if (grid_row == 40 && grid_column == 63) begin char_index <= 1; // R
			  end else if (grid_row == 40 && grid_column == 64) begin char_index <= 2; // E
			  end else if (grid_row == 40 && grid_column == 65) begin char_index <= 3; // S
			  end else if (grid_row == 40 && grid_column == 66) begin char_index <= 5; // T
			  end else if (grid_row == 40 && grid_column == 67) begin char_index <= 4; // A
			  end else if (grid_row == 40 && grid_column == 68) begin char_index <= 1; // R
			  end else if (grid_row == 40 && grid_column == 69) begin char_index <= 5; // T
			  
			  // G
			  end else if (grid_row == 28 && grid_column == 48) begin char_index <= 30;
			  end else if (grid_row == 28 && grid_column == 49) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 47) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 50) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 47) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 49) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 50) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 47) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 47) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 50) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 48) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 49) begin char_index <= 30;
			  
			  // A
			  end else if (grid_row == 28 && grid_column == 52) begin char_index <= 30;
			  end else if (grid_row == 28 && grid_column == 55) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 52) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 55) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 52) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 53) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 54) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 55) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 52) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 55) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 52) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 55) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 53) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 54) begin char_index <= 30;
			  
			  // M
			  end else if (grid_row == 28 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 28 && grid_column == 61) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 61) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 61) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 59) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 61) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 58) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 60) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 61) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 61) begin char_index <= 30;
			  
			  // E
			  end else if (grid_row == 28 && grid_column == 63) begin char_index <= 30;
			  end else if (grid_row == 28 && grid_column == 64) begin char_index <= 30;
			  end else if (grid_row == 28 && grid_column == 65) begin char_index <= 30;
			  end else if (grid_row == 28 && grid_column == 66) begin char_index <= 30;
			  end else if (grid_row == 27 && grid_column == 63) begin char_index <= 30;
			  end else if (grid_row == 26 && grid_column == 63) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 63) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 64) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 65) begin char_index <= 30;
			  end else if (grid_row == 25 && grid_column == 66) begin char_index <= 30;
			  end else if (grid_row == 24 && grid_column == 63) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 63) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 64) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 65) begin char_index <= 30;
			  end else if (grid_row == 23 && grid_column == 66) begin char_index <= 30;
			  
			  // O
			  end else if (grid_row == 35 && grid_column == 48) begin char_index <= 30;
			  end else if (grid_row == 35 && grid_column == 49) begin char_index <= 30;
			  end else if (grid_row == 34 && grid_column == 47) begin char_index <= 30;
			  end else if (grid_row == 34 && grid_column == 50) begin char_index <= 30;
			  end else if (grid_row == 33 && grid_column == 47) begin char_index <= 30;
			  end else if (grid_row == 33 && grid_column == 50) begin char_index <= 30;
			  end else if (grid_row == 32 && grid_column == 47) begin char_index <= 30;
			  end else if (grid_row == 32 && grid_column == 50) begin char_index <= 30;
			  end else if (grid_row == 31 && grid_column == 47) begin char_index <= 30;
			  end else if (grid_row == 31 && grid_column == 50) begin char_index <= 30;
			  end else if (grid_row == 30 && grid_column == 48) begin char_index <= 30;
			  end else if (grid_row == 30 && grid_column == 49) begin char_index <= 30;
			  
			  //V
			  end else if (grid_row == 35 && grid_column == 53) begin char_index <= 30;
			  end else if (grid_row == 35 && grid_column == 54) begin char_index <= 30;
			  end else if (grid_row == 34 && grid_column == 52) begin char_index <= 30;
			  end else if (grid_row == 34 && grid_column == 55) begin char_index <= 30;
			  end else if (grid_row == 33 && grid_column == 52) begin char_index <= 30;
			  end else if (grid_row == 33 && grid_column == 55) begin char_index <= 30;
			  end else if (grid_row == 32 && grid_column == 52) begin char_index <= 30;
			  end else if (grid_row == 32 && grid_column == 55) begin char_index <= 30;
			  end else if (grid_row == 31 && grid_column == 52) begin char_index <= 30;
			  end else if (grid_row == 31 && grid_column == 55) begin char_index <= 30;
			  end else if (grid_row == 30 && grid_column == 52) begin char_index <= 30;
			  end else if (grid_row == 30 && grid_column == 55) begin char_index <= 30;
			  
			  // E
			  end else if (grid_row == 35 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 35 && grid_column == 58) begin char_index <= 30;
			  end else if (grid_row == 35 && grid_column == 59) begin char_index <= 30;
			  end else if (grid_row == 35 && grid_column == 60) begin char_index <= 30;
			  end else if (grid_row == 34 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 33 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 32 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 32 && grid_column == 58) begin char_index <= 30;
			  end else if (grid_row == 32 && grid_column == 59) begin char_index <= 30;
			  end else if (grid_row == 32 && grid_column == 60) begin char_index <= 30;
			  end else if (grid_row == 31 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 30 && grid_column == 57) begin char_index <= 30;
			  end else if (grid_row == 30 && grid_column == 58) begin char_index <= 30;
			  end else if (grid_row == 30 && grid_column == 59) begin char_index <= 30;
			  end else if (grid_row == 30 && grid_column == 60) begin char_index <= 30;
			  
			  // R
			  end else if (grid_row == 35 && grid_column == 62) begin char_index <= 30;
			  end else if (grid_row == 35 && grid_column == 65) begin char_index <= 30;
			  end else if (grid_row == 34 && grid_column == 62) begin char_index <= 30;
			  end else if (grid_row == 34 && grid_column == 65) begin char_index <= 30;
			  end else if (grid_row == 33 && grid_column == 62) begin char_index <= 30;
			  end else if (grid_row == 33 && grid_column == 65) begin char_index <= 30;
			  end else if (grid_row == 32 && grid_column == 62) begin char_index <= 30;
			  end else if (grid_row == 32 && grid_column == 63) begin char_index <= 30;
			  end else if (grid_row == 32 && grid_column == 64) begin char_index <= 30;
			  end else if (grid_row == 31 && grid_column == 62) begin char_index <= 30;
			  end else if (grid_row == 31 && grid_column == 65) begin char_index <= 30;
			  end else if (grid_row == 30 && grid_column == 62) begin char_index <= 30;
			  end else if (grid_row == 30 && grid_column == 63) begin char_index <= 30;
			  end else if (grid_row == 30 && grid_column == 64) begin char_index <= 30;
			  end else begin char_index <= 31; end
			  
			end else begin
				char_index <= 31;
				colors <= 0;
			end
		  end

endmodule
