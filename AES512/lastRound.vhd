----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    05:57:48 06/18/2009 
-- Design Name: 
-- Module Name:    lastRound - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.aPack.ALL;



entity lastRound is
	PORT(
		clk:			in		std_logic;
		rst:			in		std_logic;
		partialKey:	in		partialExpKeyType;
		enable:		in		std_logic;
		inState:		in		stateMatrix;
		ready:		out		std_logic;
		outState:	out	stateMatrix
	);
end lastRound;

architecture Behavioral of lastRound is	


-------------------------------------------------------------------------
-----------------      COMPONENT DECLARATION        ---------------------
-------------------------------------------------------------------------
component subBytes is
	PORT(
		clk:			in		std_logic;
		inState:		in		stateMatrix;
		outState:	out	stateMatrix
	);
end component;	

component shiftRows is
	PORT(
		clk:		in		std_logic;
		input:	in		stateMatrix;
		output:	out	stateMatrix
	);
end component;

component addRoundKey is
	PORT(
		clk:			in		std_logic;
		partialKey:	in		partialExpKeyType;
		inState:		in		stateMatrix;
		outState:	out	stateMatrix
	);
end component;
-------------------------------------------------------------------------
-----------------    END COMPONENT DECLARATION      ---------------------
-------------------------------------------------------------------------
	signal	out0:			stateMatrix;
	signal	out1:			stateMatrix;
	signal 	outTmp:		stateMatrix;
	
	type STATE_TYPE is (RESET, ELABORATING, STANDBY);
   signal CURRENT_STATE, NEXT_STATE: STATE_TYPE;
	
begin

	subBytes_cmp:  		subBytes 		PORT MAP (clk, inState, out0);
	shiftRows_cmp:  		shiftRows 		PORT MAP (clk, out0, out1);
	addRoundKey_cmp:  	addRoundKey 	PORT MAP (clk, partialKey, out1, outTmp);
	
	process (clk, enable)
	begin
		if(clk='1' and clk'EVENT) then			
			if (enable='1') then
				ready <= '1';
				outState <= outTmp;
			else 
				ready <= '0';		
			End if;
		End if;
	end process;
			  
	
end Behavioral;

