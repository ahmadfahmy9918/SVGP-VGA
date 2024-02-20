LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY vga_driver IS
	PORT (
		CLK : IN STD_LOGIC;
		RST : IN STD_LOGIC;
		BS : IN STD_LOGIC;
		RS : IN STD_LOGIC;
		HSYNC : OUT STD_LOGIC;
		VSYNC : OUT STD_LOGIC;
		DAC_CLK : OUT STD_LOGIC;
		Rout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		Gout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		Bout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		SW0		: in STD_LOGIC;
		SW1		: in STD_LOGIC;
		SW2		: in STD_LOGIC;
		SW3		: in STD_LOGIC
	);
END vga_driver;

ARCHITECTURE Behavioral OF vga_driver IS
	SIGNAL clk25 : STD_LOGIC := '0';
	signal delay : Integer := 0;
	CONSTANT HD : INTEGER := 639; -- Horizontal Display
	CONSTANT HFP : INTEGER := 16; -- Right Border (Front Porch)
	CONSTANT HSP : INTEGER := 96; -- Horizontal Sync Pulse
	CONSTANT HBP : INTEGER := 48; -- Left Border (Back Porch)

	CONSTANT VD : INTEGER := 479; -- Vertical Display
	CONSTANT VFP : INTEGER := 10; -- Right Border (Front Porch)
	CONSTANT VSP : INTEGER := 2; -- Vertical Sync Pulse
	CONSTANT VBP : INTEGER := 33; -- Left Border (Back Porch)

	SIGNAL hPos : INTEGER := 0;
	SIGNAL vPos : INTEGER := 0;

	SIGNAL videoON : STD_LOGIC := '0';
	signal p1, p2 : Integer := 158;
	signal ball_x  : Integer :=312;
	signal ball_y : Integer := 232;
	signal ball_xmove, ball_ymove : Integer := 4;

	-- SIZINGS
	signal buttoncounter : Integer range 0 to 50 :=0;
	signal ballmovespeed : Integer := 4;
	signal playermovespeed : Integer := 3;
	signal paddlewidth : Integer := 50;
	signal score : Integer range -160 to 160 :=0;
	signal score_x : Integer := 312;

BEGIN
	clk_div : PROCESS (CLK, RST)
	BEGIN
		IF (CLK'EVENT AND CLK = '1') THEN
			clk25 <= NOT clk25;
			DAC_CLK <= clk25;
		END IF;
	END PROCESS;

 

	Horizontal_position_counter : PROCESS (clk25, RST)
	BEGIN
		IF (RST = '1') THEN
			hPos <= 0;
		ELSIF (clk25'EVENT AND clk25 = '1') THEN
			IF (hPos = (HD + HFP + HSP + HBP)) THEN
				hPos <= 0;
			ELSE
				hPos <= hPos + 1;
			END IF;
		END IF;
	END PROCESS;
	
	horizontal_synchrnozation : PROCESS (clk25, RST, hPos)
	BEGIN
		IF (RST = '1') THEN
			HSYNC <= '0';
		ELSIF (CLK'EVENT AND CLK = '1') THEN
			IF ((hPos <= (HD + HFP)) OR (hPos > HD + HFP + HSP)) THEN
				HSYNC <= '1';
			ELSE
				HSYNC <= '0';
			END IF;
		END IF;
	END PROCESS;

	Vertical_position_counter : PROCESS (clk25, RST, hPos)
	BEGIN
		IF (RST = '1') THEN
			vPos <= 0;
		ELSIF (clk25'EVENT AND clk25 = '1') THEN
			IF (hPos = (HD + HFP + HSP + HBP)) THEN
				IF (vPos = (VD + VFP + VSP + VBP)) THEN
					vPos <= 0;
				ELSE
					vPos <= vPos + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;


	vertical_synchrnozation : PROCESS (clk25, RST, vPos)
	BEGIN
		IF (RST = '1') THEN
			VSYNC <= '0';
		ELSIF (CLK'EVENT AND CLK = '1') THEN
			IF ((vPos <= (VD + VFP)) OR (vPos > VD + VFP + VSP)) THEN
				VSYNC <= '1';
			ELSE
				VSYNC <= '0';
			END IF;
		END IF;
	END PROCESS;

	video_on : PROCESS (clk25, RST, hPos, vPos)
	BEGIN
		IF (RST = '1') THEN
			videoOn <= '0';
		ELSIF (CLK'EVENT AND CLK = '1') THEN
			IF (hPos <= HD AND vPos <= VD) THEN
				videoOn <= '1';
			ELSE
				videoOn <= '0';
			END IF;
		END IF;
	END PROCESS;

	draw : PROCESS (clk25, RST, hPos, vPos, videoOn)
	BEGIN
		IF (RST = '1') THEN
			ROut <= "00000000";
			GOut <= "11111111";
			BOut <= "00000000";
		ELSIF (CLK'EVENT AND CLK = '1') THEN
			IF (videoOn = '1') THEN

				--Horizontal Border UP AND DOWN
				IF ((hPos >= 25 AND hPos <= 615 AND ((vPos >= 34 AND vPos <= 45) OR (vPos >= 435 AND vPos <= 446)))) THEN
					ROut <= "11111111";
					GOut <= "11111111";
					BOut <= "11111111";
					--RIGHT BORDER UP
				ELSIF ((hPos >= 605 AND hPos <= 615) AND vPos >= 45 AND vPos <= 180) THEN
					ROut <= "11111111";
					GOut <= "11111111";
					BOut <= "11111111";
					-- LEFT BORDER UP
				ELSIF ((hPos >= 25 AND hPos <= 35) AND (vPos >= (45) AND vPos <= 180)) THEN
					ROut <= "11111111";
					GOut <= "11111111";
					BOut <= "11111111";
					-- RIGHT BORDER DOWN
				ELSIF ((hPos >= 605 AND hPos <= 615) AND vPos >= 290 AND vPos <= 446) THEN
					ROut <= "11111111";
					GOut <= "11111111";
					BOut <= "11111111";
				
					-- LEFT BORDER DOWN
				ELSIF ((hPos >= 25 AND hPos <= 35) AND (vPos >= 290 AND vPos <= 446)) THEN
					ROut <= "11111111";
					GOut <= "11111111";
					BOut <= "11111111";
					-- Create Lines Down the middle 
				ELSIF ((hPos > 316 AND hPos < 324) AND vPos >= 37 AND vPos < 448) AND (((vPos - 35) MOD 64) > 32) THEN
					ROUT <= "00101010";
					GOUT <= "00100000";
					BOUT <= "00101010";
				ELSIF (hPos >= 0 AND hPos <= 640 AND vPos >= 0 AND vPos <= 480) THEN
					ROUT <= "00000000"; 
					GOUT <= "01010101";
					BOUT <= "00000000";
				ELSE
					ROut <= "00000000";
					GOut <= "00000000";
					BOut <= "00000000";
				END IF;
				--(Blue paddle)
				if(hPos > 40 AND hPos <=55 AND vPos> p1 AND vPos<= p1 + paddlewidth) THEN
					ROUT <= "00000000";
					GOUT <= "00000000";
					BOUT <= "10101101";
					
				-- (Pink Paddle)
				elsif(hPos > 581 AND hPos <=595 AND vPos> p2 AND vPos<= p2 + paddlewidth) THEN
					ROUT <= "10101101";
					GOUT <= "00000000";
					BOUT <= "10101111";
			
					
				elsif(hPos > ball_x AND hPos <= ball_x+16 AND vPos>ball_y AND vPos<=(ball_y+16)) THEN
						if(ball_x <= 12 OR ball_x+16 >= 628) THEN
						--Ball turn red when in goal
							ROUT <= "10101101";
							GOUT <= "00000000";
							BOUT <= "00000000";
							if(delay = 6000) THEN
								ball_x <= 312;
								delay <= 0;
								ball_xmove <= -ball_xmove;
								ball_ymove <= -ball_ymove;
							else
								delay <= delay + 1;
							end if;
						else
							ROUT <= "10101101";
							GOUT <= "10101101";
							BOUT <= "00000000";
						end if;
				
				
				END IF;

				if(hPos = 639 AND vPos = 479)THEN
						
						-- BALL BOUNCE
							-- Parameters for wall
						if(ball_x <= 36 OR ball_x+16 >= 605) THEN
							if(ball_y > 180 AND ball_y < 290) THEN

							else
								if(ball_x <= 36) THEN
									ball_xmove <= ballmovespeed;
								else
									ball_xmove <= -ballmovespeed;
								end if;
							end if;
						end if;
						
							-- Bottom part of net
						if(ball_y <= 36) THEN
							ball_ymove <= ballmovespeed;
						end if;
						--Top part 
						if(ball_y+16 >= 435) THEN
							ball_ymove <= -ballmovespeed;
						end if;
						
							--Player1
						if((ball_x <= 60 AND ball_x+16 >=44) AND (ball_y+16 > p1 AND ball_y < p1+paddlewidth)) THEN
							ball_xmove <= ballmovespeed;
						end if;
						
						 -- Player2
						if((ball_x<=597 AND ball_x+16 >= 581) AND(ball_y+16 > p2 AND ball_y < p2+paddlewidth)) THEN
							ball_xmove <= -ballmovespeed;
						end if;
						
						-- move player 1
						if (SW1 = '1') then		
							if (SW0 = '1' AND p1 >= 43) then 
								p1 <= p1 - playermovespeed;
							elsif (SW0 = '0' AND p1 + paddlewidth <= 440) then  
								p1 <= p1 + playermovespeed;
							end if;
						end if;
						
						-- Move Player 2
						if (SW3 = '1') then		
							if (SW2 = '1' AND p2 >= 43) then 
								p2 <= p2 - playermovespeed;
							elsif (SW2 = '0' AND p2 + paddlewidth <= 440) then  
								p2 <= p2 + playermovespeed;
							end if;
						end if;
						
						-- Move Ball
						if(NOT(ball_x <= 10 OR ball_x+16 >= 630)) THEN
							ball_x <= ball_x + ball_xmove;
							ball_y <= ball_y + ball_ymove;
						end if;
						
				
				END IF;
 
			ELSE
				ROut <= "00000000";
				GOut <= "00000000";
				BOut <= "00000000";
			END IF;
		END IF;
	END PROCESS;

END Behavioral;