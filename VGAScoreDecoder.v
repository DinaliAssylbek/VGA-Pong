module score_decoder(
    input [6:0] binary_score1,      // 7-bit input representing the first binary score
	 input [6:0] binary_score2,	   // 7-bit input representing the second binary score
    output reg [3:0] tens_place_1,  // 4-bit output for the tens place of the first score
    output reg [3:0] ones_place_1,  // 4-bit output for the ones place of the first score
	 output reg [3:0] tens_place_2,  // 4-bit output for the tens place of the second score
	 output reg [3:0] ones_place_2   // 4-bit output for the ones place of the second score
);

    // Always block that executes whenever any input changes
	 always @(*) begin
        tens_place_1 = binary_score1 / 10;   // Compute the tens place of the first score using integer division
        ones_place_1 = binary_score1 % 10;   // Compute the ones place of the first score using the modulo operator
		  tens_place_2 = binary_score2 / 10;   // Compute the tens place of the second score using integer divison
		  ones_place_2 = binary_score2 % 10;   // Compute the ones place of the second score using the module operator
    end

endmodule
