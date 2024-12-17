module fsm_read_data
(
    input clk,                                      // 50 MHz FPGA clock
    input reset,                                    // Active-high reset
	 input [15:0] q_b,                               // Data coming from memory
	 
	 output reg [15:0] addr_b,								 // Address Output for BRAM
	 output reg [1:0] game_state,                    // Current Game State
	 output reg [9:0] ball_x, ball_y,                // Balls X and Y position
	 output reg [9:0] paddle1_y, paddle2_y,          // Paddle 1 and 2 Y positions
	 output reg [6:0] player_1_score, player_2_score // Player 1 and 2 scores
);

// Memory addresses for reading data
parameter [15:0] game_state_address = 16'h800F;			// Address for game state
parameter [15:0] ball_x_address = 16'h8008;				// Address for ball's X position
parameter [15:0] ball_y_address = 16'h8009;				// Address for ball's Y position
parameter [15:0] paddle1_y_address = 16'h8002;			// Address for Paddle 1 Y position
parameter [15:0] paddle2_y_address = 16'h8004;			// Address for Paddle 2 Y position
parameter [15:0] player_1_score_address = 16'h800D;	// Address for Player 1 score
parameter [15:0] player_2_score_address = 16'h800E;	// Address for Player 2 score

// State definitions
parameter [4:0] IDLE = 5'b00000;      // Initial state
parameter [4:0] READ1 = 5'b00001;     // Read game_state
parameter [4:0] WAIT1 = 5'b01111;     // Wait for game_state to arrive
parameter [4:0] UPDATE1 = 5'b00010;   // Update game_state
parameter [4:0] READ2 = 5'b00011;     // Read ball_x
parameter [4:0] WAIT2 = 5'b10000;     // Wait for ball_x to arrive
parameter [4:0] UPDATE2 = 5'b00100;   // Update ball_x
parameter [4:0] READ3 = 5'b00101;     // Read ball_y
parameter [4:0] WAIT3 = 5'b10001;     // Wait for ball_y to arrive
parameter [4:0] UPDATE3 = 5'b00110;   // Update ball_y
parameter [4:0] READ4 = 5'b00111;     // Read paddle1_y
parameter [4:0] WAIT4 = 5'b10010;     // Wait for paddle1_y to arrive
parameter [4:0] UPDATE4 = 5'b01000;   // Update paddle1_y
parameter [4:0] READ5 = 5'b01001;     // Read paddle2_y
parameter [4:0] WAIT5 = 5'b10011;     // Wait for paddle2_y to arrive
parameter [4:0] UPDATE5 = 5'b01010;   // Update paddle2_y
parameter [4:0] READ6 = 5'b01011;     // Read paddle_1_score
parameter [4:0] WAIT6 = 5'b10100;     // Wait for paddle_1_score to arrive
parameter [4:0] UPDATE6 = 5'b01100;   // Update paddle_1_score
parameter [4:0] READ7 = 5'b01101;     // Read paddle_2_score
parameter [4:0] WAIT7 = 5'b10101;     // Wait for paddle_2_score to arrive
parameter [4:0] UPDATE7 = 5'b01110;   // Update paddle_2_score

reg [4:0] State, NS; // State and next state

// State transitions
always @(negedge clk) begin
    if (!reset) begin
        State <= IDLE;           // Remain in IDLE state
    end else 
        State <= NS;             // Move to the next state
end

// Next state logic
always @(negedge clk) begin
    case (State)
        IDLE: NS <= READ1;         // Transition from IDLE to READ1
		  
		  READ1: NS <= WAIT1;        // Transition from READ1 to WAIT1
		  WAIT1: NS <= UPDATE1;      // Transition from WAIT1 to UPDATE1
		  UPDATE1: NS <= READ2;      // Transition from UPDATE1 to READ2
		  
        READ2: NS <= WAIT2;        // Transition from READ2 to WAIT2
		  WAIT2: NS <= UPDATE2;      // Transition from WAIT2 to UPDATE2
		  UPDATE2: NS <= READ3;      // Transition from UPDATE2 to READ3
		  
        READ3: NS <= WAIT3;        // Transition from READ3 to WAIT3
		  WAIT3: NS <= UPDATE3;      // Transition from WAIT3 to UPDATE3
		  UPDATE3: NS <= READ4;      // Transition from UPDATE3 to READ4
		  
        READ4: NS <= WAIT4;        // Transition from READ4 to WAIT4
		  WAIT4: NS <= UPDATE4;      // Transition from WAIT4 to UPDATE4
		  UPDATE4: NS <= READ5;      // Transition from UPDATE4 to READ5
		  
        READ5: NS <= WAIT5;        // Transition from READ5 to WAIT5
		  WAIT5: NS <= UPDATE5;      // Transition from WAIT5 to UPDATE5
		  UPDATE5: NS <= READ6;      // Transition from UPDATE5 to READ6
		  
		  READ6: NS <= WAIT6;        // Transition from READ6 to WAIT6
		  WAIT6: NS <= UPDATE6;      // Transition from WAIT6 to UPDATE6
		  UPDATE6: NS <= READ7;      // Transition from UPDATE6 to READ7
		  
		  READ7: NS <= WAIT7;        // Transition from READ7 to WAIT7
		  WAIT7: NS <= UPDATE7;      // Transition from WAIT7 to UPDATE7
		  UPDATE7: NS <= IDLE;       // Transition from UPDATE7 to IDLE
		  
        default: NS <= IDLE;       // Default state if none match
    endcase
end

// Output and BRAM control logic
always @ (negedge clk) begin
    case (State)
        IDLE: begin addr_b <= 16'b0; end                      // Reset address in IDLE
		  
		  READ1: begin addr_b <= game_state_address; end        // Set address to game_state
		  UPDATE1: begin game_state <= q_b[1:0]; end            // Update game state with data from memory

        READ2: begin addr_b <= ball_x_address; end            // Set address to ball_x
		  UPDATE2: begin ball_x <= q_b[9:0]; end                // Update ball_x with data from memory
		  
        READ3: begin addr_b <= ball_y_address; end            // Set address to ball_y
		  UPDATE3: begin ball_y <= q_b[9:0]; end                // Update ball_y with data from memory
		  
        READ4: begin addr_b <= paddle1_y_address; end         // Set address to paddle1_y
		  UPDATE4: begin paddle1_y <= q_b[9:0]; end             // Update paddle1_y with data from memory

        READ5: begin addr_b <= paddle2_y_address; end         // Set address to paddle2_y
		  UPDATE5: begin paddle2_y <= q_b[9:0]; end             // Update paddle2_y with data from memory
		  
		  READ6: begin addr_b <= player_1_score_address; end    // Set address to player_1_score
		  UPDATE6: begin player_1_score <= q_b[6:0]; end        // Update paddle_1_score with data from memory
		  
		  READ7: begin addr_b <= player_2_score_address; end    // Set address to player_2_score
		  UPDATE7: begin player_2_score <= q_b[6:0]; end        // Update player_2_score with data from memory
		  
		  default: begin addr_b <= 16'b0; end                   // Default: Reset address
    endcase
	 
end

endmodule