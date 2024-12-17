module bitGen(

    input pixel,            // Input signal indicating whether the current pixel is active
	 input bright,           // Brightness control signal (active-high)
	 input [2:0] colors,     // 3-bit input to specify the color output
	 
	 output reg [7:0] VGA_R, // 8-bit output for the red channel
	 output reg [7:0] VGA_G, // 8-bit output for the green channel
	 output reg [7:0] VGA_B  // 8-bit output for the blue channel
	 
);

	parameter ON = 8'b11111111;  // Full intensity for a color channel
	parameter OFF = 8'b00000000; // No intensity for a color channel
	
    always @(*) begin
		// If brightness is off, all channels are set to OFF (black)
		if (~bright) begin
			VGA_R = OFF;
         VGA_G = OFF;
         VGA_B = OFF;
		end else if (pixel == 1'b1) begin
			// If brightness is on and the pixel is active
			if (colors == 2'b00) begin
				// If the color code is 00, set all channels to ON (white)
				VGA_R = ON;
				VGA_G = ON;
				VGA_B = ON;
			end else if (colors == 2'b01) begin
				// If the color code is 01, set green and blue channels to ON (cyan)
				VGA_R = OFF;
				VGA_G = ON;
				VGA_B = ON;
			end else if (colors == 2'b10) begin
				// If the color code is 10, set only the red channel to ON (red)
				VGA_R = ON;
				VGA_G = OFF;
				VGA_B = OFF;
			end
		end else begin
			// If the pixel is not active, all channels are set to OFF (black)
			VGA_R = OFF;
			VGA_G = OFF;
			VGA_B = OFF;
		end
    end
	 
endmodule