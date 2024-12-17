module vgaControl(
    input clk,
	 input clr,
	 output reg en,
    output hSync,
    output vSync,
    output bright,
    output reg [9:0] hCount,
    output reg [9:0] vCount
  );
	 reg [2:0] hEn;
	 // Assign region where we trigger our syncs and brightness
	 assign hSync = (hCount > 96 && hCount < 784);
	 assign vSync = (vCount > 2 && vCount < 511);
	 assign bright = (hCount > 130 && hCount < 784) && (vCount > 25 && vCount < 511);
	 
	 // Slows down the clk in half by using an enable
	 always @(posedge clk or negedge clr) begin
		if (~clr) begin
			en = 0;
		end
		else begin
			en <= ~en;
		end
	 end
	 
	 // Horizontal counter
    always @(posedge clk or negedge clr) begin
		if (~clr) begin
			hCount <= 0;
			hEn <= 0;
		end
		else if (en) begin
			if (hCount == 799) begin
				hCount <= 0;
				hEn <= 1;
			end
			else begin
				hCount <= hCount + 1;
				hEn <= 0;
			end
		 end
	 end
	 
	 // Vertical counter
    always @(posedge clk or negedge clr) begin
      if (~clr) begin
			vCount <= 0;
		end
		else if (en && hEn) begin
			if (vCount == 520)
				vCount <= 0;
			else
				vCount <= vCount + 1;
		end
	end
endmodule