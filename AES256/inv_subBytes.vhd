----------------------------------------------------------------------------------
-- Company: MicroLab - DEI - Politecnico di Milano
-- Engineer: Nacci Alessandro Antonio and Matteo Domenico
-- 
-- Create Date:    11:30:09 05/22/2009 
-- Design Name: 
-- Module Name:    subBytes - Behavioral 
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


entity inv_subBytes is
	PORT(
		clk:			in		std_logic;
		inState:		in		stateMatrix;
		outState:	out	stateMatrix
	);
end inv_subBytes;

architecture Behavioral of inv_subBytes is

	component inv_subElement is
		PORT(
			clk:			in		std_logic;
			inValue:		in		sboxElement_subType;
			outValue:	out	sboxElement_subType
		);
	end component;

begin	

	-- generating subBytes elaboration units


	subByteI	:  FOR i IN 0 TO 3 GENERATE
		subByteJ	:	FOR j IN 0 TO 3 GENERATE
							new_sByte:  inv_subElement PORT MAP (clk, inState(i)(j), outState(i)(j));
						END GENERATE;						
					END GENERATE;

	
end Behavioral;

