module ball_animation (
    input clk,               // Clock signal
    input reset,             // Reset signal
    output reg [9:0] ball_x_pos,  // Ball X position
    output reg [9:0] ball_y_pos   // Ball Y position
);

    // Parameters
    parameter MAX_X = 725;   // Maximum X coordinate (screen width)
    parameter MAX_Y = 500;   // Maximum Y coordinate (screen height)
    parameter STEP = 1;       // Ball movement step size

    // Internal signals for ball direction (0 = left/up, 1 = right/down)
    reg direction_x;            // Direction: 0 = moving left, 1 = moving right
    reg direction_y;            // Direction: 0 = moving up, 1 = moving down

    // Counter for clock division (to slow down the movement)
    reg [23:0] counter;       // 24-bit counter for clock division

    // Initial conditions
    initial begin
        ball_x_pos = 110;     // Initial X position of the ball
        ball_y_pos = 200;     // Initial Y position of the ball
        direction_x = 1;      // Start moving to the right
        direction_y = 1;      // Start moving down
        counter = 0;          // Initialize counter
    end

    always @(posedge clk) begin
        if (reset == 0) begin
            // Reset positions and direction on reset
            ball_x_pos <= 110;
            ball_y_pos <= 200;
            direction_x <= 1;  // Start moving to the right
            direction_y <= 1;  // Start moving down
            counter <= 0;      // Reset counter
        end else begin
            // Increment the counter to control movement speed
            counter <= counter + 1;

            // Slow down the animation by updating positions only at intervals
            if (counter == 24'd500000) begin  // Adjust for desired speed
                counter <= 0;

                // Update ball X position based on the horizontal direction
                if (direction_x == 1) begin
                    // Ball moving to the right
                    if (ball_x_pos < MAX_X) begin  // Ensure it doesn't go off the screen
                        ball_x_pos <= ball_x_pos + STEP;
                    end else begin
                        // Change direction to left when it hits the right edge
                        direction_x <= 0;
                    end
                end else begin
                    // Ball moving to the left
                    if (ball_x_pos > 160) begin  // Ensure it doesn't go off the screen
                        ball_x_pos <= ball_x_pos - STEP;
                    end else begin
                        // Change direction to right when it hits the left edge
                        direction_x <= 1;
                    end
                end

                // Update ball Y position based on the vertical direction
                if (direction_y == 1) begin
                    // Ball moving down
                    if (ball_y_pos < MAX_Y) begin  // Ensure it doesn't go off the screen
                        ball_y_pos <= ball_y_pos + STEP;
                    end else begin
                        // Change direction to up when it hits the bottom edge
                        direction_y <= 0;
                    end
                end else begin
                    // Ball moving up
                    if (ball_y_pos > 25) begin  // Ensure it doesn't go off the screen
                        ball_y_pos <= ball_y_pos - STEP;
                    end else begin
                        // Change direction to down when it hits the top edge
                        direction_y <= 1;
                    end
                end
            end
        end
    end
endmodule
