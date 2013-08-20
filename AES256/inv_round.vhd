----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    11:47:13 05/29/2009 
-- Design Name: 
-- Module Name:    round - Behavioral 
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


entity inv_round is
	PORT(
		clk:			in		std_logic;
		rst:			in		std_logic;
		partialKey:	in		partialExpKeyType;
		enable:		in		std_logic;
		inState:		in		stateMatrix;
		ready:		out	std_logic;
		outState:	out	stateMatrix
	);
end inv_round;

architecture Behavioral of inv_round is	



-------------------------------------------------------------------------
-----------------      COMPONENT DECLARATION        ---------------------
-------------------------------------------------------------------------
component inv_subBytes is
	PORT(
		clk:			in		std_logic;
		inState:		in		stateMatrix;
		outState:	out	stateMatrix
	);
end component;	

component inv_shiftRows is
	PORT(
		clk:		in		std_logic;
		input:	in		stateMatrix;
		output:	out	stateMatrix
	);
end component;

component inv_mixColumn is
	PORT(
		clk:			in		std_logic;
		inState:		in		stateMatrix;
		outState:	out	stateMatrix
	);
end component;

component inv_addRoundKey is
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

	
	type STATE_TYPE is (RESET, ELABORATING, STANDBY);
   signal CURRENT_STATE, NEXT_STATE: STATE_TYPE;
	
	signal	out0:			stateMatrix;
	signal	out1:			stateMatrix;
	signal	out2:			stateMatrix;
	signal 	outTmp:		stateMatrix;

	
begin

	inv_shiftRows_cmp:  		inv_shiftRows 				PORT MAP (clk, inState, out0);
	inv_subBytes_cmp:  		inv_subBytes 				PORT MAP (clk, out0, out1);
	inv_addRoundKey_cmp:  	inv_addRoundKey 			PORT MAP (clk, partialKey, out1, out2);
	inv_mixColumn_cmp:  		inv_mixColumn 				PORT MAP (clk, out2, outTmp);


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

